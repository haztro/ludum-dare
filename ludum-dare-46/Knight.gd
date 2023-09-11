extends KinematicBody2D
class_name Knight

signal dead(knight)

var direction = Vector2(0, 0)
var ACCEL = 15
var MAX_SPEED = 100
var motion = Vector2(0, 0)
var destination = Vector2(0, 0)
var id = 0

var hit_dir = Vector2(0, 0)
var hit_cooling_down = 0

var health = 100
var max_health = 100
var equipped = null 

var body_dest_angle = 0
var body_current_angle = 0
var head_dest_angle = 0
var head_current_angle = 0

var audio = null

# Called when the node enters the scene tree for the first time.
func _ready():
	audio = get_node("/root/AudioManager")
	print(audio)

func init(new_id, start_pos, new_health, speed):
	id = new_id
	position = start_pos
	health = new_health
	MAX_SPEED = speed

func equip(item):
	for c in $right_hand.get_children():
		$right_hand.remove_child(c)
		equipped = null
		
	equipped = item
	$right_hand.add_child(equipped)
	
func equipl(item):
	for c in $left_hand.get_children():
		$left_hand.remove_child(c)
		equipped = null
		
	equipped = item
	$left_hand.add_child(equipped)

func get_equipped():
	return equipped

func hit(weapon_hit, knockback=1):
	$anim.play("hit")
	audio.play("hit")
	$hit_cooldown.start()
	hit_cooling_down = 1
	
	if remove_health(weapon_hit.damage):
		emit_signal("dead", self)
	
	if knockback:
		hit_dir = (position - weapon_hit.wielder.position).normalized() * 200
	
func attack():
	for c in $right_hand.get_children():
		c.attack()

func attackl():
	for c in $left_hand.get_children():
		c.attack()

func add_health(amount):
	health += amount
	if health >= max_health:
		health = max_health
	
func remove_health(amount):
	health -= amount
	if health <= 0:
		return 1
	return 0

func _on_hit_cooldown_timeout():
	hit_cooling_down = 0

func _physics_process(delta):
	
	if hit_cooling_down:
		direction = Vector2(0, 0)
		
	if direction == Vector2(0, 0):
		apply_friction(ACCEL)
	else:
		apply_movement(direction * ACCEL)
	
	if hit_dir != Vector2(0, 0):
		motion += hit_dir
		motion = motion.clamped(MAX_SPEED*4)
		hit_dir = Vector2(0, 0)
	
	motion = move_and_slide(motion)

func apply_friction(amount):
	if motion.length() > amount:
		motion -= motion.normalized() * amount
	else:
		motion = Vector2(0, 0)

func apply_movement(acceleration):
	motion += acceleration
	motion = motion.clamped(MAX_SPEED)
	
func rotate_head(weight):
	$head.rotation = lerp_angle(head_current_angle, body_dest_angle-rotation+PI, weight)
	head_current_angle = $head.rotation
	
func rotate_body(weight):
	rotation = lerp_angle(body_current_angle, body_dest_angle, weight)
	body_current_angle = rotation



