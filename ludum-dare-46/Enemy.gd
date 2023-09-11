extends Knight

var player
var king

var direction_vec = Vector2(0, 0)

# Called when the node enters the scene tree for the first time.
func _ready():
	player = get_parent().get_node("Player")
	king = get_parent().get_node("King")
	destination = king.position

func think():
	direction_vec = (destination - position).normalized()
	direction = direction_vec
	
	var dist_to_player = (player.position - position).length() 
	var dist_to_target = (destination - position).length()
	
	if dist_to_player <= 60:
		destination = player.position
	else:
		destination = king.position
	
	if dist_to_target <= get_equipped().hit_range:
		direction = Vector2(0, 0)
		attack()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	think()
	
	rotate_head(0.05)
	rotate_body(0.1)
	
	body_dest_angle = direction_vec.angle() + PI/2
	
	for i in get_slide_count():
		var collision = get_slide_collision(i)
		if rand_range(0, 1) > 0.5:
			direction = (direction + collision.normal.rotated(PI/2)).normalized()
		else:
			direction = (direction + collision.normal.rotated(-PI/2)).normalized()
			
