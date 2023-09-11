extends Sprite


var wielder
var audio

# Called when the node enters the scene tree for the first time.
func _ready():
	audio = get_node("/root/AudioManager")
	wielder = get_parent().get_parent()

func attack():
	audio.play("health")
	wielder.add_health(50)
	queue_free()

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
