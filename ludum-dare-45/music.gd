extends AudioStreamPlayer


# Called when the node enters the scene tree for the first time.
func _ready():
	stream = load("res://art/music.wav")
	stream.loop_mode = 1
	stream.loop_end = 44100 * 91.19
	play()

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
