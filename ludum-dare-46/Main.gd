extends Node2D

const enemy = preload("res://Enemy.tscn")
const dagger = preload("res://Dagger.tscn")
const sword = preload("res://IronSword.tscn")
const halberd = preload("res://Halberd.tscn")
const fist = preload("res://Fist.tscn")
const coin = preload("res://Coin.tscn")

var enemies = {}
var enemy_id = 0
var stats = null
var hud = null

var enemy_health = 50
var level = 0
var wave_ongoing = 0
var level0weps = [dagger]
var level3weps = [dagger, sword]
var level5weps = [dagger, sword, halberd]
var level8weps = [dagger, sword, halberd, halberd]

var audio
# Called when the node enters the scene tree for the first time.
func _ready():
	audio = get_node("/root/AudioManager")
	get_tree().paused = 0
	stats = get_node("/root/Stats")
	$Player.connect("dead", self, "game_over")
	$King.connect("dead", self, "game_over")
	
	var sword1 = dagger.instance()
	$Player.equip(sword1)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func spawn_enemies():
	for i in range(3):
		add_enemy(Vector2(i, 15*16))
	
func choose_weapon():
	if level <= 2:
		return dagger.instance()
	elif level < 5:
		return level3weps[floor(rand_range(0,2))].instance()
	elif level < 9:
		return level5weps[floor(rand_range(0,3))].instance()
	elif level >= 9:
		return level8weps[floor(rand_range(0,4))].instance()
	return sword.instance()
		
	
func add_enemy(pos):
	enemies[enemy_id] = enemy.instance()
	enemies[enemy_id].init(enemy_id, pos, 100, 40)
	enemies[enemy_id].connect("dead", self, "handle_death")
	enemies[enemy_id].equip(choose_weapon())
	enemies[enemy_id].health = enemy_health
	add_child(enemies[enemy_id])
	enemy_id += 1	

func game_over(entity):
	stats.input_ready = 0
	stats.gold = 0
	get_tree().paused = 1
	audio.play("death")
	$Gui/MarginContainer.modulate = Color(1, 1, 1, 0)
	$cam_tween.interpolate_property($CanvasModulate, "color", Color(1, 1, 1, 1), Color(0, 0, 0, 1), 2, 1, 0)
	$cam_tween.start()
	yield($cam_tween, "tween_completed")
	yield(get_tree().create_timer(1), "timeout")
#	$King.queue_free()
#	$shop.queue_free()
#	queue_free()
	get_tree().reload_current_scene()

func drop_coin(entity):
	var new_coin = coin.instance()
	new_coin.value = floor(rand_range(5, 15))
	new_coin.position = entity.position
	$WorldMap.add_child(new_coin)	

func handle_death(entity):
	audio.play("death")
	drop_coin(entity)
	entity.queue_free()
	remove_child(entity)

func start_game():
	$cam_tween.interpolate_property($Camera2D, "position", $Camera2D.position, Vector2(0, 110), 2, 1, 2)
	$cam_tween.start()
	yield($cam_tween, "tween_completed")

	$WorldMap/door/anim.play("door_open")
	spawn_enemies()
	yield($WorldMap/door/anim, "animation_finished")

	$cam_tween.interpolate_property($Camera2D, "position", $Camera2D.position, $Player.position, 0.5, 1, 2)
	$cam_tween.start()
	yield($cam_tween, "tween_completed")
	
	$Gui.show_gui()
	$Camera2D.current = 0
	$Player/Camera2D.current = 1
	stats.input_ready = 1
	$enemy_spawn.start()
	$wave_timer.start()

func _on_enemy_spawn_timeout():
	if wave_ongoing and level > 0:
		for i in range(floor(rand_range(1, min(level, 4)))):
			add_enemy(Vector2(i, 16*16))
	$enemy_spawn.start()

func _on_TextureButton_pressed():
	$Gui.hud_start()
	
func _on_wave_timer_timeout():
	print("BREAK START")
	wave_ongoing = 0
	$wave_break.start()

func _on_wave_break_timeout():
	print("WAVE START")
	level += 1
	wave_ongoing = 1
	print(level)
	$wave_timer.start()
	$enemy_spawn.start()
