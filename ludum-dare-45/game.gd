extends Node2D

var window_size
var game_state

signal game_over_sig

export (PackedScene) var rocket

var death_type = 0

# Called when the node enters the scene tree for the first time.
func _ready():

	window_size = OS.get_window_size()
	game_state = get_node("/root/game_state")
	
	$rocket_timer.start()
	$mine_timer.wait_time = game_state.MINE_SPEED
	$mine_timer.start()
	death_type = 0
	
func _process(delta):
	pass

func _on_rocket_timer_timeout():
	earth_launch()
	$rocket_timer.wait_time = game_state.TRANSIT_TIME
	$rocket_timer.start()
	$earth_timer.start()
	
func earth_launch():
	
	var r = rocket.instance()
	r.from_earth = true
	connect("game_over_sig", r, "game_over")
	$space.add_child(r)

	var anim_player_pos = AnimationPlayer.new()
	add_child(anim_player_pos)
	
	r.anim_pos_path = str(get_path_to(anim_player_pos))
	
	var anim_pos = Animation.new()
	anim_pos.add_track(0)
	anim_pos.set_length(game_state.TRANSIT_TIME)
	anim_pos.track_set_interpolation_type(0, Animation.INTERPOLATION_CUBIC)
	anim_pos.track_set_path(0, str(get_path_to(r)) + ":position")
	anim_pos.track_insert_key(0, 0, Vector2(15, 45))
	anim_pos.track_insert_key(0, game_state.TRANSIT_TIME / 2, Vector2(50, 25))
	anim_pos.track_insert_key(0, game_state.TRANSIT_TIME, Vector2(105, 15))
	anim_player_pos.add_animation("rocket_pos", anim_pos)
	
	var anim_player_rot = AnimationPlayer.new()
	add_child(anim_player_rot)
	
	r.anim_rot_path = str(get_path_to(anim_player_rot))
	
	var anim_rot = Animation.new()
	anim_rot.add_track(0)
	anim_rot.set_length(game_state.TRANSIT_TIME)
	anim_rot.track_set_path(0, str(get_path_to(r)) + ":rotation")
	anim_rot.track_insert_key(0, 0, 0.8)
	anim_rot.track_insert_key(0, game_state.TRANSIT_TIME, 1.6)
	anim_player_rot.add_animation("rocket_rot", anim_rot)

	anim_player_rot.play("rocket_rot")
	anim_player_pos.play("rocket_pos")
	r.show()
	
	var n = [game_state.request_worker, game_state.request_engineer, game_state.request_scientist]

	var sum_n = game_state.request_worker + game_state.request_engineer + game_state.request_scientist
	print(sum_n)
	if sum_n == 0:
		n[randi() % 3] = 1
		n[randi() % 3] = 1
		n[randi() % 3] = 1
		sum_n = n[0] + n[1] + n[2]

	# Very bad
	if sum_n == 3 or $rocket_timer.wait_time == 1:
		r.num_workers = 1
		r.num_engineers = 1
		r.num_scientists = 1
	elif sum_n == 1:
		r.num_workers = n[0] * 3
		r.num_engineers = n[1] * 3
		r.num_scientists = n[2] * 3
	elif sum_n == 2:
		var ra = randi() % 2
		if n[0] == 0:
			r.num_workers = 0
			r.num_engineers = 1 + ra
			r.num_scientists = 1 + (ra ^ 1)
		elif n[1] == 0:
			r.num_workers = 1 + ra
			r.num_engineers = 0
			r.num_scientists = 1 + (ra ^ 1)
		elif n[2] == 0:
			r.num_workers = 1 + ra
			r.num_engineers = 1 + (ra ^ 1)
			r.num_scientists = 0

	r.num_civilians = game_state.civ_load
	

func lunar_launch():
	var r = rocket.instance()
	
	r.from_earth = false
	connect("game_over_sig", r, "game_over")
	$space.add_child(r)

	var anim_player_pos = AnimationPlayer.new()
	add_child(anim_player_pos)
	
	r.anim_pos_path = str(get_path_to(anim_player_pos))
	
	var anim_pos = Animation.new()
	anim_pos.add_track(0)
	anim_pos.set_length(game_state.TRANSIT_TIME)
	anim_pos.track_set_interpolation_type(0, Animation.INTERPOLATION_CUBIC)
	anim_pos.track_set_path(0, str(get_path_to(r)) + ":position")
	anim_pos.track_insert_key(0, 0, Vector2(105, 25))
	anim_pos.track_insert_key(0, game_state.TRANSIT_TIME / 1.8, Vector2(50, 60))
	anim_pos.track_insert_key(0, game_state.TRANSIT_TIME, Vector2(15, 65))
	anim_player_pos.add_animation("rocket_pos", anim_pos)
	
	var anim_player_rot = AnimationPlayer.new()
	add_child(anim_player_rot)
	
	r.anim_rot_path = str(get_path_to(anim_player_rot))
	
	var anim_rot = Animation.new()
	anim_rot.add_track(0)
	anim_rot.set_length(game_state.TRANSIT_TIME)
	anim_rot.track_set_path(0, str(get_path_to(r)) + ":rotation")
	anim_rot.track_insert_key(0, 0, 3.9)
	anim_rot.track_insert_key(0, game_state.TRANSIT_TIME, 4.8)
	anim_player_rot.add_animation("rocket_rot", anim_rot)

	anim_player_rot.play("rocket_rot")
	anim_player_pos.play("rocket_pos")
	r.show()
	
	r.num_resources = game_state.PAYLOAD

func load_housing():
	$space.hide()
	$launch_site.hide()
	$mine.hide()
	$housing.show()
	
func load_launch():
	$space.hide()
	$housing.hide()
	$mine.hide()
	$launch_site.show()
	
func load_mine():
	$space.hide()
	$housing.hide()
	$launch_site.hide()
	$mine.show()
	
func game_over():
	
	game_state.has_played = 1
	$earth_timer.stop()
	$rocket_timer.stop()
	$mine_timer.stop()
	$hud.get_node("MarginContainer/HBoxContainer2/housing_btn").disabled = true
	$hud.get_node("MarginContainer/HBoxContainer2/launch_btn").disabled = true
	$hud.get_node("MarginContainer/HBoxContainer2/mine_btn").disabled = true
	
	$housing.hide()
	$launch_site.hide()
	$mine.hide()
	$space.show()
	emit_signal("game_over_sig")
	$hud.get_node("anim").play("fade")
	
	if death_type == 0:
		get_node("MarginContainer/VBoxContainer/Label").text = "COLONY\nOVERPOPULATED"
	else:
		get_node("MarginContainer/VBoxContainer/Label").text = "EARTH PERISHED"
	
	$MarginContainer.show()
	$MarginContainer/VBoxContainer/HBoxContainer/Label3.text = str(game_state.population)
	$anim.play("fade")

func _on_mine_timer_timeout():
	game_state.resources += game_state.MINE_RATE * game_state.num_scientist

func _on_earth_timer_timeout():
	game_state.earth_resources -= game_state.DEATH_RATE

	if game_state.earth_resources <= 0:
		death_type = 1
		game_over()
		
func show_rocket_stats(payload):
	$stats.show()
	$stats/Label.text = str(payload[0])
	$stats/Label2.text = str(payload[1])
	$stats/Label3.text = str(payload[2])
	$stats/Label4.text = str(payload[3])
	
func hide_rocket_stats():
	$stats.hide()
	
func _on_TextureButton_pressed():
	get_node("/root//audio").play()
	game_state.reset()
	get_tree().reload_current_scene()
