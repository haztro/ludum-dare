extends MyObject

var player
var key_pressed = 0
var stats = null

# Called when the node enters the scene tree for the first time.
func _ready():
	stats = get_node("/root/Stats")
	player = get_parent().get_node("Player")
	
func _process(delta):
	
#	if key_pressed:
#		print("HERE")
#		$ShopUI.set_layer(2)
#	else:
#		$ShopUI.set_layer(0)
		
	if (position - player.position).length() < 40:
		if Input.is_key_pressed(KEY_E) and not key_pressed:
			key_pressed = 1
			show_shop()
		if not Input.is_key_pressed(KEY_E) and key_pressed:
			key_pressed = 0
			hide_shop()
		$Label.visible = 1
	else:
		$Label.visible = 0
		hide_shop()

func show_shop():
	if not $fade.is_active():
		#$ShopUI/TextureRect.visible = 1
		$ShopUI/MarginContainer.show()
		var mod = $ShopUI.get_node("CanvasModulate")
		$fade.interpolate_property(mod, "color", mod.color, Color(1,1,1,1), 0.1, 1, 0)
		$fade.start()
		yield($fade, "tween_completed")

	
func hide_shop():
	var mod = $ShopUI.get_node("CanvasModulate")
	$fade.interpolate_property(mod, "color", mod.color, Color(1,1,1,0), 0.1, 1, 0)
	$fade.start()
	yield($fade, "tween_completed")
	#$ShopUI/TextureRect.visible = 0

	
