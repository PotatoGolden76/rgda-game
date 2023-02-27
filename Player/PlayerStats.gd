extends Node2D

@export
var maxHealth:int = 3
@onready
var health:int = maxHealth: set = set_health, get = get_health

signal no_health

func set_health(value):
	health = value
	
	if health <= 0:
		emit_signal("no_health")

func get_health():
	return health
