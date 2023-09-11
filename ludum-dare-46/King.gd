extends Knight


var player
var hud = null

# Called when the node enters the scene tree for the first time.
func _ready():
	hud = get_parent().get_node("Gui")
	player = get_parent().get_node("Player")
	hud.update_king_bar(health)
	add_collision_exception_with(get_parent().get_node("WorldMap").get_node("throne").get_node("object"))

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	$head.rotation = lerp_angle($head.rotation, (position - player.position).angle() - PI/2, 0.05)
	
func hit(weapon_hit, knockback=0):
	.hit(weapon_hit, 0)
	hud.update_king_bar(health)
