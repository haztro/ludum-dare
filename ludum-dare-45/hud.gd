extends CanvasLayer

var game
var game_state

# Called when the node enters the scene tree for the first time.
func _ready():
	game = get_parent()
	game_state = get_node("/root//game_state")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	$MarginContainer/HBoxContainer/res_lbl.text = str(game_state.resources)
	$MarginContainer/HBoxContainer/pop_lbl.text = str(game_state.population) + "/" + str(game_state.num_houses * game_state.HOUSE_CAP)


func _on_housing_btn_pressed():
	game.load_housing()
	get_node("/root//audio").play()


func _on_launch_btn_pressed():
	game.load_launch()
	get_node("/root//audio").play()


func _on_mine_btn_pressed():
	game.load_mine()
	get_node("/root//audio").play()
	

