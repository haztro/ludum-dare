extends Node2D

var game_state

var s_normal = preload("res://mine/scientist1.png")
var s_hover = preload("res://mine/scientist_hover.png")
var s_pressed = preload("res://mine/scientist_pressed.png")

var sa_normal = preload("res://mine/scientist_add.png")
var sa_hover = preload("res://mine/scientist_add_hover.png")
var sa_pressed = preload("res://mine/scientist_add_pressed.png")

# Called when the node enters the scene tree for the first time.
func _ready():
	game_state = get_node("/root//game_state")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
		$mine_hud/VBoxContainer/HBoxContainer2/Label.text = str(game_state.num_scientist)

func _on_back_btn_pressed():
	get_node("/root//audio").play()
	hide()
	get_parent().get_node("space").show()

func _on_request_btn_pressed():
	get_node("/root//audio").play()
	game_state.request_scientist ^= 1
	if game_state.request_scientist == 1:
		$mine_hud/VBoxContainer/HBoxContainer/request_btn.texture_normal = sa_normal
		$mine_hud/VBoxContainer/HBoxContainer/request_btn.texture_hover = sa_hover
		$mine_hud/VBoxContainer/HBoxContainer/request_btn.texture_pressed = sa_pressed
	else:
		$mine_hud/VBoxContainer/HBoxContainer/request_btn.texture_normal = s_normal
		$mine_hud/VBoxContainer/HBoxContainer/request_btn.texture_hover = s_hover
		$mine_hud/VBoxContainer/HBoxContainer/request_btn.texture_pressed = s_pressed
