extends CharacterBody2D


@export
var speed:float = 200
@export
var friction:float = 2500
@export
var acceleration:float = 3000
@onready
var animationPlayer:AnimationPlayer = $AnimationPlayer
@onready
var animationTree:AnimationTree = $AnimationTree
@onready
var animationState = animationTree.get("parameters/playback")
@onready
var stats = $PlayerStats
@onready
var hurtbox = $Hurtbox

func _ready():
	stats.no_health.connect(_on_player_no_health)
	print("Player health = " + str(stats.health))

func _on_player_no_health():
	queue_free()

func _physics_process(delta):
	# input + physics logic
	
	var input_vector = Vector2.ZERO
	input_vector.x = Input.get_action_strength("right") - Input.get_action_strength("left")
	input_vector.y = Input.get_action_strength("down") - Input.get_action_strength("up")
	input_vector = input_vector.normalized()
	
	if input_vector != Vector2.ZERO:
		if not $FootstepSFX.is_playing():
			$FootstepSFX.play(0)
		
		animationTree.set("parameters/Run/blend_position", input_vector)
		animationState.travel("Run")
		velocity = velocity.move_toward(input_vector * speed, acceleration * delta) 
	
	else:
		$FootstepSFX.stop()
		animationState.travel("Idle")
		velocity = velocity.move_toward(Vector2.ZERO, friction * delta) 
	
	move_and_slide()
	


func _on_hurtbox_area_entered(area):
	stats.health -= area.damage
	hurtbox.start_invincibility(1)
	print("Player health = " + str(stats.health))
	
