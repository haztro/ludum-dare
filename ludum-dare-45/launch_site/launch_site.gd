extends Node2D

var game_state

var max_rockets

var e_normal = preload("res://launch_site/engineer1.png")
var e_hover = preload("res://launch_site/engineer_hover.png")
var e_pressed = preload("res://launch_site/engineer_pressed.png")

var ea_normal = preload("res://launch_site/engineer_add.png")
var ea_hover = preload("res://launch_site/engineer_add_hover.png")
var ea_pressed = preload("res://launch_site/engineer_add_pressed.png")

var launch_flag = 0
var time_to_launch

var mute_flag = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	game_state = get_node("/root//game_state")
	time_to_launch = game_state.MAX_LAUNCH_TIME

func _input(event):
	if event.is_action_pressed("mute"):
		mute_flag ^= 1
		if mute_flag:
			get_node("/root//music").stop()
		else:
			get_node("/root//music").play()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	if launch_flag:
		time_to_launch -= game_state.num_engineer * game_state.LAUNCH_RATE * delta
	
	if time_to_launch <= 0:
		launch_rocket()
	
	$launch_hud/VBoxContainer/launch_progress.value = 100 - 100 * time_to_launch / game_state.MAX_LAUNCH_TIME
	$launch_hud/VBoxContainer/HBoxContainer2/Label.text = str(game_state.num_engineer)

func _on_launch_btn_pressed():
	get_node("/root//audio").play()
	if !launch_flag:
		if game_state.resources >= game_state.LAUNCH_COST:
			if game_state.num_engineer > 0:
				game_state.resources -= game_state.LAUNCH_COST
				launch_flag = 1
				time_to_launch = game_state.MAX_LAUNCH_TIME
			else:
				$launch_hud/VBoxContainer/HBoxContainer2/anim.play("fade")
		else:
			get_parent().get_node("hud/MarginContainer/HBoxContainer/anim3").play("fade")

func launch_rocket():
	launch_flag = 0
	time_to_launch = game_state.MAX_LAUNCH_TIME
	get_parent().lunar_launch()

func _on_back_btn_pressed():
	get_node("/root//audio").play()
	hide()
	get_parent().get_node("space").show()

func _on_request_btn_pressed():
	get_node("/root//audio").play()
	game_state.request_engineer ^= 1
	if game_state.request_engineer == 1:
		$launch_hud/VBoxContainer/HBoxContainer/request_btn.texture_normal = ea_normal
		$launch_hud/VBoxContainer/HBoxContainer/request_btn.texture_hover = ea_hover
		$launch_hud/VBoxContainer/HBoxContainer/request_btn.texture_pressed = ea_pressed
	else:
		$launch_hud/VBoxContainer/HBoxContainer/request_btn.texture_normal = e_normal
		$launch_hud/VBoxContainer/HBoxContainer/request_btn.texture_hover = e_hover
		$launch_hud/VBoxContainer/HBoxContainer/request_btn.texture_pressed = e_pressed

