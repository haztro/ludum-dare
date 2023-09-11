extends Knight

const fist = preload("res://Fist.tscn")

var stats = null
var hud = null
var obtained_armour = 0
var obtained_helm = 0
var mouse_down = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	stats = get_node("/root/Stats")
	hud = get_parent().get_node("Gui")
	hud.update_player_bar(health)
	
func hit(weapon_hit, knockback=1):
	.hit(weapon_hit, 1)
	hud.update_player_bar(health)

func equip_armour():
	if obtained_armour == 0:
		max_health += 100
		obtained_armour = 1
		hud.update_player_bar(health)
		hud.update_max(max_health)
		
func equip_helm():
	if obtained_helm == 0:
		max_health += 50
		obtained_helm = 1
		hud.update_player_bar(health)
		hud.update_max(max_health)

func equip_fist():
	equip(fist.instance())

func get_input():

	direction = Vector2(0, 0)
	hud.update_player_bar(health)
	
	if Input.is_key_pressed(KEY_D):
		direction.x += 1
	if Input.is_key_pressed(KEY_A):
		direction.x -= 1
	if Input.is_key_pressed(KEY_S):
		direction.y += 1
	if Input.is_key_pressed(KEY_W):
		direction.y -= 1

	direction = direction.normalized()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if stats.input_ready:
		get_input()

	var screen_scale = (get_viewport().size / get_viewport_rect().size)
	var mouse_pos = get_viewport().get_mouse_position() * screen_scale
	var scaled_pos = get_global_transform_with_canvas().origin * screen_scale
	var dir = (mouse_pos - scaled_pos).normalized()

	body_dest_angle = dir.angle() + PI/2.0
	
	rotate_head(0.3)
	rotate_body(0.4)
	
	if Input.is_mouse_button_pressed(1):
		attack()


func _input(event):
	
	if stats.input_ready:
		if event is InputEventMouseButton:
			if (event.pressed and event.button_index == BUTTON_RIGHT):
				attackl()
				#pass

			

