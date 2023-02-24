extends Node2D

@onready
var start_position = global_position
@onready
var target_position = global_position
@export
var wander_threshold:int = 64;
@onready
var timer = $Timer
@export
var wander_leniency:float = 0.5;

func update_target_position():
	# generate a new random wander position within a threshold
	var target_vector = Vector2.ZERO
	
	while(target_vector.length() < 32): 
		target_vector = Vector2(randi_range(-wander_threshold, wander_threshold), randi_range(-wander_threshold, wander_threshold))
	
	target_position = start_position + target_vector

func _on_timer_timeout():
	update_target_position()

func get_time_left():
	return timer.time_left
	
func start_timer(duration):
	timer.start(duration)
