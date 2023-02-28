extends Node

@export
var maxHealth = 5
var health = maxHealth: set = set_health
@export
var meleeDamage = 3

signal no_health

func set_health(value):
	health = value
	
	if health <= 0:
		emit_signal("no_health")
