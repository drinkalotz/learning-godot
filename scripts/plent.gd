extends Enemy
class_name Plent
@onready var ray_cast_right: RayCast2D = $ray_cast_right
@onready var ray_cast_left: RayCast2D = $ray_cast_left
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var plent_killzone_shape: CollisionShape2D = $plent_killzone/plent_killzone_shape

func _ready():
	animated_sprite_2d.animation_finished.connect(_on_animation_done)

func _process(delta: float) -> void:
	if is_dying:
		die()
		return
	if ray_cast_right.is_colliding():
		direction = -1
		animated_sprite_2d.flip_h = true
	if ray_cast_left.is_colliding():
		direction = 1
		animated_sprite_2d.flip_h = false

		
	position.x += direction * speed * delta
	
func die():
	plent_killzone_shape.disabled = true
	animated_sprite_2d.play("die")

func _on_animation_done():
	if animated_sprite_2d.animation == 'die':
		queue_free()
