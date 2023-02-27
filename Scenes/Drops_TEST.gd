extends Node2D
# DELETE THIS SOMETIME, THIS IS TESTING ONLY

@export var s1 : PackedScene = preload("res://Items/DroppedItem.tscn")
@export var item : Array
# Called when the node enters the scene tree for the first time.
func _ready():
	item = ItemRegistry.items.keys()
	pass # Replace with function body.


# Called every physics frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("mouse_click"):
		var obj = s1.instantiate()
		add_child(obj)
		obj.init(item.pick_random())
