extends CharacterBody2D

@export
var damage = 1

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
@onready
var attackController = $AttackController

enum {
	MOVE,
	DASH
	
}

var state = MOVE
var is_attacking:bool = false
var is_dashing:bool = false
var input_vector:Vector2 = Vector2.ZERO


func _ready():
	stats.no_health.connect(_on_player_no_health)
	# print("Player health = " + str(stats.health))

func _on_player_no_health():
	queue_free()

func process_input():
	input_vector = Vector2.ZERO
	input_vector.x = Input.get_action_strength("right") - Input.get_action_strength("left")
	input_vector.y = Input.get_action_strength("down") - Input.get_action_strength("up")
	input_vector = input_vector.normalized()
	
	is_attacking = Input.is_action_pressed("attack")
	is_dashing = Input.is_action_just_pressed("dash")


func move_state(delta):
	if input_vector != Vector2.ZERO:
		if not $FootstepSFX.is_playing():
			$FootstepSFX.play(0)
			
		velocity = velocity.move_toward(input_vector * speed, acceleration * delta) 
	
	else:
		$FootstepSFX.stop()
		velocity = velocity.move_toward(Vector2.ZERO, friction * delta) 
	
	move_and_slide()
	

func attack():
	attackController.set_target(get_global_mouse_position())
	# attackController.knockback_vector = input_vector
	
	if attackController.attackDone:
		attackController.burst_attack(1, 350, 0, 0.07, 0)
	

func process_animations():
	if input_vector == Vector2.ZERO:
		if is_attacking:
			animationState.travel("IdleAttack")
			# print("IdleAttack")
		
		else:
			animationState.travel("Idle")
			# print("Idle")
	
	else:
		if is_attacking:
			animationTree.set("parameters/Attack/blend_position", input_vector)
			animationState.travel("Attack")
			# print("Attack")
		
		else:
			animationTree.set("parameters/Run/blend_position", input_vector)
			animationState.travel("Run")
			# print("Run")
	

func _physics_process(delta):
	process_input()
	process_animations()
	
	if is_dashing:
		state = DASH
	
	match state:
		MOVE:
			if is_attacking:
				attack()
				
			move_state(delta)
			
		DASH:
			pass

	

func _on_hurtbox_area_entered(area):
	print("hit")
	stats.health -= damage
	hurtbox.start_invincibility(1)
	print("Player health = " + str(stats.health))
	
