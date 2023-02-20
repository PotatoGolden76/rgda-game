extends CharacterBody2D


@export
var speed:float = 185
@export
var friction:float = 25
@export
var acceleration:float = 35
@onready
var animationPlayer:AnimationPlayer = $AnimationPlayer
@onready
var animationTree:AnimationTree = $AnimationTree
@onready
var animationState = animationTree.get("parameters/playback")


func _physics_process(_delta):
	var input_vector = Vector2.ZERO
	input_vector.x = Input.get_action_strength("right") - Input.get_action_strength("left")
	input_vector.y = Input.get_action_strength("down") - Input.get_action_strength("up")
	input_vector = input_vector.normalized()
	
	if input_vector != Vector2.ZERO:
		if not $FootstepSFX.is_playing():
			$FootstepSFX.play(0)
		
		animationTree.set("parameters/Run/blend_position", input_vector)
		animationState.travel("Run")
		velocity = velocity.move_toward(input_vector * speed, acceleration) 
	
	else:
		$FootstepSFX.stop()
		animationState.travel("Idle")
		velocity = velocity.move_toward(Vector2.ZERO, friction) 
	
	move_and_slide()
