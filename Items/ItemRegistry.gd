extends Node

@export var items = {}

var path = "res://Items/Resources/"

func _ready():
	var dir = DirAccess.open(path)
	if dir:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		while file_name != "":
			print("Found Item: " + file_name)
			var item : Item = load(path + "/" + file_name)
			items[item.name] = item
			file_name = dir.get_next()
	else:
		print("Unable to access items folder")

func get_item(name):
	return items[name]
