extends Area2D

var earth1 = preload("res://art/earth.png")
var earth2 = preload("res://art/earth1.png")
var earth3 = preload("res://art/earth2.png")
var earth4 = preload("res://art/earth3.png")
var earth5 = preload("res://art/earth4.png")
var earth6 = preload("res://art/earth5.png")
var earth7 = preload("res://art/earth6.png")

var game_state

# Called when the node enters the scene tree for the first time.
func _ready():
	game_state = get_node("/root//game_state")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if game_state.earth_resources > 86:
		$Sprite.texture = earth1
	
	elif game_state.earth_resources > 72:
		$Sprite.texture = earth2
		
	elif game_state.earth_resources > 58:
		$Sprite.texture = earth3
		
	elif game_state.earth_resources > 44:
		$Sprite.texture = earth4
		
	elif game_state.earth_resources > 30:
		$Sprite.texture = earth5
		
	elif game_state.earth_resources > 16:
		$Sprite.texture = earth6
		
	else:
		$Sprite.texture = earth7
		
