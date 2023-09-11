extends TextureButton

export (PackedScene) var item
export (String, MULTILINE) var info
export (int) var price
export (String) var myname

var player
var stats
var audio

# Called when the node enters the scene tree for the first time.
func _ready():
	stats = get_node("/root/Stats")
	audio = get_node("/root/AudioManager")
	# Lol
	player = get_parent().get_parent().get_parent().get_parent().get_parent().get_parent().get_parent().get_node("Player")
	


func _on_ShopItem_mouse_entered():
	var shop = get_parent().get_parent().get_parent().get_node("stats").get_node("Label")
	shop.text = info


func _on_ShopItem_pressed():
	if player.get_parent().get_node("shop").get_node("ShopUI").get_node("CanvasModulate").color == Color(1,1,1,1):
		if stats.gold >= price:
			if myname == "robe":
				player.get_node("body").texture = texture_normal
				player.MAX_SPEED = 200
				player.ACCEL = 20
				stats.gold -= price
				audio.play("buy")
			elif myname == "potion":
				player.equipl(item.instance())
				stats.gold -= price
				audio.play("buy")
			elif myname == "armour":
				player.get_node("body").texture = texture_normal
				player.MAX_SPEED = 120
				player.equip_armour()
				stats.gold -= price
				audio.play("buy")
			elif myname == "helm":
				player.get_node("head").texture = texture_normal
				player.equip_helm()
				stats.gold -= price
				audio.play("buy")
			else:
				var it = item.instance()
				if player.equipped.name != it.name:
					player.equip(item.instance())
					stats.gold -= price
					audio.play("buy")
		else:
			audio.play("error")
		
