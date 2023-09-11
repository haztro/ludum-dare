extends Area2D


var stats = null
var audio = null
var value = 10
var has_yield = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	stats = get_node("/root/Stats")
	audio = get_node("/root/AudioManager")

func _on_Coin_body_entered(body):
	if body.name == "Player" and not has_yield:
		audio.play("coin")
		stats.gold += value
		has_yield = 1
		queue_free()
		#get_parent().remove_child(self)
