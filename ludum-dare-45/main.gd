extends Node

var game_state

# Called when the node enters the scene tree for the first time.
func _ready():
	game_state = get_node("/root/game_state")
	
	if game_state.has_played == 0:
		get_tree().paused = true
		$intro/anim.play("fade")
	else:
		start()

func start():
	$intro.hide()
	get_tree().paused = false
	$game.show()
	$game.get_node("hud/anim2").play("fade")

func _on_anim_animation_finished(anim_name):
	start()
