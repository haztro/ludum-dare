extends Area2D

var num_workers
var num_engineers
var num_scientists
var num_civilians
var num_resources

var from_earth

var anim_pos_path
var anim_rot_path

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func game_over():
	$anim.play("fade")


func _on_rocket_area_entered(area):
	if area.name == "moon" and from_earth == true:
		var temp = game_state.population + num_workers + num_engineers + num_scientists + num_civilians
		
		if temp > game_state.num_houses * game_state.HOUSE_CAP:
			get_parent().get_parent().game_over()
		
		game_state.population = temp
		game_state.num_worker += num_workers
		game_state.num_engineer += num_engineers
		game_state.num_scientist += num_scientists
		game_state.num_civilian += num_civilians
		
		get_parent().get_parent().get_node(anim_pos_path).queue_free()
		get_parent().get_parent().get_node(anim_rot_path).queue_free()
		queue_free()
		
	elif area.name == "earth" and from_earth == false:
		game_state.earth_resources = min(100, game_state.earth_resources + num_resources * game_state.CONV)
		get_parent().get_parent().get_node(anim_pos_path).queue_free()
		get_parent().get_parent().get_node(anim_rot_path).queue_free()
		queue_free()


func _on_rocket_mouse_entered():
	get_parent().get_parent().show_rocket_stats([num_workers, num_engineers, num_scientists, num_civilians])

func _on_rocket_mouse_exited():
	get_parent().get_parent().hide_rocket_stats()
