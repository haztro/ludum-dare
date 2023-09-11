extends Sprite
class_name MyObject


# Called when the node enters the scene tree for the first time.
func _ready():
	var new_shape = RectangleShape2D.new()
	new_shape.set_extents(texture.get_size() / 2.0)
	$object/CollisionShape2D.set_shape(new_shape)

func show_shop():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
