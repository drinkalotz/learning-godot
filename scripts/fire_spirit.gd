extends Enemy
class_name FireSpirit
@onready var ray_cast_right: RayCast2D = $ray_cast_right
@onready var ray_cast_left: RayCast2D = $ray_cast_left
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var fire_spirit_killzone_shape: CollisionShape2D = $fire_spirit_killzone/fire_spirit_killzone_shape

func _ready():
	animated_sprite_2d.animation_finished.connect(_on_animation_done)
	if direction == 1:
		animated_sprite_2d.flip_h = false
		animated_sprite_2d.offset.x = -1
	else:
		animated_sprite_2d.flip_h = true
		animated_sprite_2d.offset.x = 3

func _process(delta: float) -> void:
	if is_dying:
		die()
		return
	if ray_cast_right.is_colliding():
		direction = -1
		animated_sprite_2d.flip_h = true
		animated_sprite_2d.offset.x = 3
	if ray_cast_left.is_colliding():
		direction = 1
		animated_sprite_2d.flip_h = false
		animated_sprite_2d.offset.x = -1


		
	position.x += direction * speed * delta
	
func die():
	animated_sprite_2d.play("die")
	fire_spirit_killzone_shape.disabled = true


func _on_animation_done():
	if animated_sprite_2d.animation == 'die':
		queue_free()
