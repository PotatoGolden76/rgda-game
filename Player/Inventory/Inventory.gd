extends Node

@export var data = {}

func _ready():
	# TODO: Serialisation, saving, etc.
	pass 
	
func has_item(id):
	return data.has(id)
	
func add_item(id):
	if has_item(id):
		data[id]+=1
	else:
		data[id]=1
	
func remove_item(id):
	pass
	
func _to_string():
	return data._to_string()
