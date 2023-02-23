extends Area2D

@export
var SPEED:int = 300

func set_speed(new_speed):
	SPEED = new_speed

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	var direction = Vector2.RIGHT.rotated(rotation)
	global_position += SPEED * direction * delta

func destroy():
	# TODO: add SFX and death VFX
	queue_free()

func _on_area_entered(_area):
	destroy()

func _on_body_entered(_body):
	destroy()

func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()
