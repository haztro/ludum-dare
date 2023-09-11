extends Area2D

var wielder
var has_attacked = 0
var victim = null
var anim_player

export (int) var damage = 50
var hit_range = 32
export (float) var speed = 0
var has_cooled = 1
var audio = null

# Called when the node enters the scene tree for the first time.
func _ready():
	audio = get_node("/root/AudioManager")	
	# Hand of owner..
	wielder = get_parent().get_parent()
	$cooldown.wait_time = speed
	configure_animation()
	hit_range = $Sprite.texture.get_size().y + 10

func configure_animation():
	anim_player = AnimationPlayer.new()
	anim_player.connect("animation_finished", self, "_on_anim_animation_finished")
	var anim = Animation.new()
	var track = anim.add_track(Animation.TYPE_VALUE)
	
	anim.track_set_path(track, ".:position")
	anim.track_insert_key(track, 0, Vector2(0, 0))
	anim.track_insert_key(track, speed/3.0, Vector2(0, 4))
	anim.track_insert_key(track, 2*speed/3.0, Vector2(0, -8))
	anim.track_insert_key(track, 2*speed/3.0 + 0.01, Vector2(0, -8))
	anim.track_insert_key(track, speed, Vector2(0, 0))
	anim.length = speed
	anim_player.add_animation("swing", anim)
	add_child(anim_player)

func attack():
	if has_cooled:
		anim_player.play("swing")
		audio.play("swing")
		$cooldown.start()
		has_cooled = 0

func _on_anim_animation_finished(anim_name):
	has_attacked = 0

func _process(delta):
	if position.y < -4.5:
		if victim != null and not has_attacked:
			victim.hit(self)
			has_attacked = 1

func _on_MeleeWeapon_body_entered(body):
	if body.name != wielder.name and body.name != "object" and not body is TileMap:
		victim = body

func _on_MeleeWeapon_body_exited(body):
	if body.name != wielder.name:
		victim = null

func _on_cooldown_timeout():
	has_cooled = 1
