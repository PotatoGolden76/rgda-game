extends Area2D

@export var resource : Resource

func _ready():
	pass # Replace with function body.

func init(name):
	resource = ItemRegistry.get_item(name)	
	$Sprite.texture = resource.texture
	$Label.text = resource.name
	$Label.hide()
	#REMOVE THIS
	position = get_global_mouse_position()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_mouse_entered():
	print("Hovering " + resource.name)
	$Label.show()


func _on_mouse_exited():
	$Label.hide()

func _on_body_shape_entered(body_rid, body, body_shape_index, local_shape_index):
	if body.name == "Player":
		Inventory.add_item(resource.name)
		queue_free()
