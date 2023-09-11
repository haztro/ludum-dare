extends CanvasLayer

var stats = null
var audio = null

# Called when the node enters the scene tree for the first time.
func _ready():
	stats = get_node("/root/Stats")
	audio = get_node("/root/AudioManager")
	
func _process(delta):
	$MarginContainer/VBoxContainer/HBoxContainer2/Label.text = str(stats.gold)

func update_king_bar(health):
	$MarginContainer/VBoxContainer/HBoxContainer/king_bar.value = health

func update_player_bar(health):
	$MarginContainer/VBoxContainer/HBoxContainer2/player_bar.value = health
	
func update_max(val):
	$MarginContainer/VBoxContainer/HBoxContainer2/player_bar.max_value = val
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func show_gui():
	$fade.interpolate_property($MarginContainer, "modulate", Color(1,1,1,0), Color(1,1,1,1), 0.3, 1, 0)
	$fade.start()

func _on_TextureButton_pressed():
	audio.play("click")
	get_parent().start_game()
	$TextureButton.disabled = 1
	$fade.interpolate_property($TextureButton, "modulate", Color(1,1,1,1), Color(1,1,1,0), 0.3, 1, 0)
	$fade.start()
	yield($fade, "tween_completed")
	
	
