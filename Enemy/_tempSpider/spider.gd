extends CharacterBody2D

var knockback = Vector2.ZERO
var kb_friction:float = 1000

@export
var FRICTION:float = 2000
@export
var ACCELERATION:float = 4000
@export
var CHASE_MAX_SPEED:float = 2000
@export
var WANDER_MAX_SPEED:float = 1000

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

func _physics_process(delta):
	velocity = knockback.move_toward(Vector2.ZERO, kb_friction * delta)
	knockback = velocity
	# move_and_slide()

	match state:
		IDLE:
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
			seek_player()
			
			var wander_direction = global_position.direction_to(wanderController.target_position)
			last_direction = wander_direction
			
			if wanderController.get_time_left() == 0 || (global_position - wanderController.target_position).length() <= wanderController.wander_leniency:
				state = IDLE
				wanderController.start_timer(1)
				
			else:
				
				animationTree.set("parameters/Walk/blend_position", wander_direction)
				animationState.travel("Walk")
				
				velocity = velocity.move_toward(wander_direction * WANDER_MAX_SPEED, ACCELERATION * delta)
		
			
		CHASE:
			var player = playerDetectionZone.player
			
			if player != null:
				var player_direction = global_position.direction_to(player.global_position)
				last_direction = player_direction
				
				animationTree.set("parameters/Walk/blend_position", player_direction)
				animationState.travel("Walk")
				
				velocity = velocity.move_toward(player_direction * CHASE_MAX_SPEED, ACCELERATION * delta)
				
			else:
				state = IDLE
	
	sprite.flip_h = velocity.x < 0 || last_direction.x < 0
	move_and_slide()
	

func seek_player():
	if playerDetectionZone.can_see_player():
		state = CHASE
	

func _on_hurtbox_area_entered(_area):
	knockback = Vector2.RIGHT * 300
	# queue_free()
 
