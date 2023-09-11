extends Node2D

var game_state

var max_houses

var w_normal = preload("res://housing/worker1.png")
var w_hover = preload("res://housing/worker_hover.png")
var w_pressed = preload("res://housing/worker_pressed.png")

var wa_normal = preload("res://housing/worker_add.png")
var wa_hover = preload("res://housing/worker_add_hover.png")
var wa_pressed = preload("res://housing/worker_add_pressed.png")

# Called when the node enters the scene tree for the first time.
func _ready():
	game_state = get_node("/root//game_state")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	max_houses = floor(game_state.num_worker / 3) + 1
	$housing_hud/VBoxContainer/HBoxContainer2/Label.text = str(game_state.num_worker)
	
func _on_build_house_btn_pressed():
	get_node("/root//audio").play()
	if game_state.resources >= game_state.HOUSE_COST:
		if game_state.num_houses < max_houses:
			game_state.resources -= game_state.HOUSE_COST
			game_state.num_houses += 1
		else:
	 		$housing_hud/VBoxContainer/HBoxContainer2/anim.play("fade")
	else:
		get_parent().get_node("hud/MarginContainer/HBoxContainer/anim3").play("fade")
			
func _on_back_btn_pressed():
	get_node("/root//audio").play()
	hide()
	get_parent().get_node("space").show()

func _on_request_btn_pressed():
	get_node("/root//audio").play()
	game_state.request_worker ^= 1
	if game_state.request_worker == 1:
		$housing_hud/VBoxContainer/HBoxContainer/request_btn.texture_normal = wa_normal
		$housing_hud/VBoxContainer/HBoxContainer/request_btn.texture_hover = wa_hover
		$housing_hud/VBoxContainer/HBoxContainer/request_btn.texture_pressed = wa_pressed
	else:
		$housing_hud/VBoxContainer/HBoxContainer/request_btn.texture_normal = w_normal
		$housing_hud/VBoxContainer/HBoxContainer/request_btn.texture_hover = w_hover
		$housing_hud/VBoxContainer/HBoxContainer/request_btn.texture_pressed = w_pressed
