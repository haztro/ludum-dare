extends Node

var hit = load("res://assets/sounds/hit.wav")
var swing = load("res://assets/sounds/swing.wav")
var error = load("res://assets/sounds/error.wav")
var death = load("res://assets/sounds/death.wav")
var coin = load("res://assets/sounds/coin.wav")
var click = load("res://assets/sounds/click.wav")
var health = load("res://assets/sounds/health.wav")
var buy = load("res://assets/sounds/buy.wav")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

func play(name, fade_in=0):
	
	var streamPlayer = AudioStreamPlayer.new()
	streamPlayer.connect('finished', streamPlayer, 'queue_free')
	streamPlayer.name = name
	add_child(streamPlayer)

	if name == "hit":
		streamPlayer.stream = hit
	elif name == "swing":
		streamPlayer.stream = swing
		streamPlayer.volume_db = -20
	elif name == "death":
		streamPlayer.stream = death
	elif name == "coin":
		streamPlayer.stream = coin
	elif name == "click":
		streamPlayer.stream = click
	elif name == "buy":
		streamPlayer.stream = buy
	elif name == "error":
		streamPlayer.stream = error
	elif name == "health":
		streamPlayer.stream = health

#	elif name == "select":
#		streamPlayer.stream = select
#	elif name == "error":
#		streamPlayer.stream = error
		
	if fade_in == 0:
		streamPlayer.play()

func is_playing(name):
	
	for sp in get_children():
		if sp.get_name() == name:
			return true 
	
	return false
	
func toggle_play(name):
	
	if is_playing(name):
		stop(name)
	else:
		play(name)
				
	print(get_children().size())
	
func stop(name):
	
	for sp in get_children():
		if sp.get_name() == name:
			sp.stop()
			sp.queue_free()
			
func stop_all():
	for sp in get_children():
		if sp.name != "music":
		#sp.stop()
			sp.queue_free()
			
func fade_in(name, duration, mute=0):
	
	play(name, 1)
	
	for sp in get_children():
		if sp.get_name() == name:
			var tween = Tween.new()
			tween.connect('tween_completed', self, "remove_tween1")
			tween.name = sp.name + "tween"
			sp.volume_db = -80
			add_child(tween)
			tween.interpolate_property(sp, "volume_db", -80, 0, 
				duration, 1, Tween.EASE_IN, 0)
			tween.start()
			if mute == 0:
				sp.play()

func fade_out(name, duration, mute=0):
	for sp in get_children():
		if sp.get_name() == name:
			var tween = Tween.new()
			if mute == 0:
				tween.connect('tween_completed', self, "remove_tween")
			else:
				tween.connect('tween_completed', self, "remove_tween1")
			tween.name = sp.name + "tween"
			add_child(tween)
			tween.interpolate_property(sp, "volume_db", 0, -80, 
				duration, 1, Tween.EASE_IN, 0)
			tween.start()

func remove_tween(object, key):
	for c in get_children():
		if c.name == object.name + "tween":
			c.queue_free()
			object.queue_free()
			remove_child(c)
			remove_child(object)
			
			
func remove_tween1(object, key):
	for c in get_children():
		if c.name == object.name + "tween":
			c.queue_free()
			remove_child(c)

