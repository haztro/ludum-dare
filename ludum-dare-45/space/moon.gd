extends Area2D

var game_state

# Called when the node enters the scene tree for the first time.
func _ready():
	game_state = get_node("/root/game_state")

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
