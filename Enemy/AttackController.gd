extends Node2D

@export
var EnemyBullet:PackedScene = preload("res://Projectiles/_tempBullet/EnemyBullet.tscn")
@onready
var bulletTimer = $Timer
@export
var attackDone:bool = true
@export
var target:Vector2 = Vector2.ZERO

func set_target(new_target):
	# set attack target
	target = new_target
	

func spawn_bullet(speed):
	# spawn bullet aimed towards target with a given speed
	
	var bullet = EnemyBullet.instantiate()
	bullet.set_speed(speed)
	get_tree().current_scene.add_child(bullet)
	bullet.global_position = self.global_position
	
	var bullet_rotation = self.global_position.direction_to(target).angle()
	bullet.rotation = bullet_rotation
	

"""
Attack Framework
To make a new attack, simply use the spawn_bullet() function(s)
The more flexibility with parameters the better

NOTE: you MUST set the target before checking if an attack is done and before calling the attack function
Otherwise, pre-delay will cause the attack to target the old position

TODO: expand with more attack patterns and bullet types
"""

func burst_attack(no_bullets:int, bullet_speed:int, pre_delay:float, time_between_shots:float, post_delay:float):
	# burst attack
	# waits for pre_delay, fires no_bullets every time_between_shots seconds, waits for post_delay
	attackDone = false
	
	bulletTimer.start(pre_delay)
	await bulletTimer.timeout
	
	for i in no_bullets:
		spawn_bullet(bullet_speed)
		bulletTimer.start(time_between_shots)
		await bulletTimer.timeout
		
	bulletTimer.start(post_delay)
	await bulletTimer.timeout
	attackDone = true
