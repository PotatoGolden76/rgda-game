extends CharacterBody2D

var knockback = Vector2.ZERO
var kb_friction:float = 1000

@export
var FRICTION:float = 2000
@export
var ACCELERATION:float = 4000
@export
var MAX_SPEED:float = 2000

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

func _physics_process(delta):
	velocity = knockback.move_toward(Vector2.ZERO, kb_friction * delta)
	knockback = velocity
	move_and_slide()

	match state:
		IDLE:
			if(velocity != Vector2.ZERO):
				last_direction = velocity.normalized()
			
			velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
			
			seek_player()
		
		WANDER:
			pass
		
		CHASE:
			var player = playerDetectionZone.player
			
			if player != null:
				var player_direction = (player.global_position - global_position).normalized()
				last_direction = player_direction
				
				animationTree.set("parameters/Walk/blend_position", player_direction)
				animationState.travel("Walk")
				
				velocity = velocity.move_toward(player_direction * MAX_SPEED, ACCELERATION * delta)
				
			else:
				state = IDLE
				
				animationTree.set("parameters/Idle/blend_position", last_direction)
				animationState.travel("Idle")
	
	sprite.flip_h = velocity.x < 0 || last_direction.x < 0
	move_and_slide()
	

func seek_player():
	if playerDetectionZone.can_see_player():
		state = CHASE
	

func _on_hurtbox_area_entered(area):
	knockback = Vector2.RIGHT * 300
	# queue_free()
 
