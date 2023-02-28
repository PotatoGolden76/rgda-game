extends CharacterBody2D

var knockback = Vector2.ZERO
var kb_friction:float = 1000

@export
var FRICTION:float = 2000
@export
var CHASE_ACCELERATION:float = 6000
@export
var WANDER_ACCELERATION:float = 3000
@export
var CHASE_MAX_SPEED:float = 4000
@export
var WANDER_MAX_SPEED:float = 1000

@export
var melee_damage:int = 2
@export
var bullet_damage:int = 1

enum {
	IDLE, 
	WANDER,
	CHASE
}

var state = IDLE
var last_direction = Vector2.ZERO
@onready
var sprite:Sprite2D = $Sprite
@onready
var animationPlayer:AnimationPlayer = $AnimationPlayer
@onready
var animationTree:AnimationTree = $AnimationTree
@onready
var animationState = animationTree.get("parameters/playback")
@onready
var playerDetectionZone = $PlayerDetectionZone
@onready
var wanderController = $WanderController
@onready
var attackController = $AttackController
@onready
var stats = $Stats

func _physics_process(delta):
	# TODO: refactor knockback logic when a proper player attack system is implemented
	velocity = knockback.move_toward(Vector2.ZERO, kb_friction * delta)
	knockback = velocity
	
	# attack state machine
	match state:
		IDLE:
			# idle state
			# stop moving, check if player is in range, start wander after a second
			
			animationTree.set("parameters/Idle/blend_position", last_direction)
			animationState.travel("Idle")
				
			if(velocity != Vector2.ZERO):
				last_direction = velocity.normalized()
			
			velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
			seek_player()
			
			if wanderController.get_time_left() == 0:
				state = WANDER
				wanderController.start_timer(1)
		
		WANDER:
			# wander state
			# check if player is in range
			# start wandering to a random position generated by the wanderController
			# stop wandering after a second, go back to idle
			
			seek_player()
			
			var wander_direction = global_position.direction_to(wanderController.target_position)
			last_direction = wander_direction
			
			# check if wander timer has finished OR enemy has reached the random wander position (up to a small difference)
			if wanderController.get_time_left() == 0 || (global_position - wanderController.target_position).length() <= wanderController.wander_leniency:
				state = IDLE
				wanderController.start_timer(1)
				
			else:
				animationTree.set("parameters/Walk/blend_position", wander_direction)
				animationState.travel("Walk")
				
				velocity = velocity.move_toward(wander_direction * WANDER_MAX_SPEED, WANDER_ACCELERATION * delta)
		
			
		CHASE:
			# chase state
			# get player position, move towards player
			# setup attack pattern
			
			var player = playerDetectionZone.player
			
			if player != null:
				var player_direction = global_position.direction_to(player.global_position)
				last_direction = player_direction
				
				animationTree.set("parameters/Walk/blend_position", player_direction)
				animationState.travel("Walk")
				
				velocity = velocity.move_toward(player_direction * CHASE_MAX_SPEED, CHASE_ACCELERATION * delta)
				
				attackController.set_target(player.global_position)
				
				if attackController.attackDone:
					attackController.burst_attack(3, 300, 1, 0.1, 0)
				
			else:
				state = IDLE
	
	sprite.flip_h = velocity.x < 0 || last_direction.x < 0
	move_and_slide()
	

func seek_player():
	# check if player is in the playerDetectionZone
	if playerDetectionZone.can_see_player():
		state = CHASE
	

func _on_hurtbox_area_entered(area):
	stats.health -= area.damage
	knockback = area.knockback_vector * 100
	
	
func _on_stats_no_health():
	queue_free()
