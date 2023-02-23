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
	target = new_target
	

func spawn_bullet():
	var bullet = EnemyBullet.instantiate()
	get_tree().current_scene.add_child(bullet)
	bullet.global_position = self.global_position
	
	var bullet_rotation = self.global_position.direction_to(target).angle()
	bullet.rotation = bullet_rotation
	


func burst_attack(no_bullets:int, pre_delay:float, time_between_shots:float, post_delay:float):
	attackDone = false
	
	bulletTimer.start(pre_delay)
	await bulletTimer.timeout
	
	for i in no_bullets:
		spawn_bullet()
		bulletTimer.start(time_between_shots)
		await bulletTimer.timeout
		
	bulletTimer.start(post_delay)
	await bulletTimer.timeout
	attackDone = true
