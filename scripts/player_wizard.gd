extends CharacterBody2D

class_name PlayerWizard

@onready var spell: Area2D = $spell
@onready var _animated_sprite = $AnimatedSprite2D
@onready var spell_collider: CollisionShape2D = $spell/spell_collider


const SPEED = 250.0
const JUMP_VELOCITY = -400.0
var is_dead = false
var is_attacking = false
var look_at = Vector2.RIGHT

func _ready():
	_animated_sprite.animation_finished.connect(_on_animation_done)
	_animated_sprite.animation_changed.connect(_on_animation_changed)

func _physics_process(delta: float) -> void:
	var direction := Input.get_axis("ui_left", "ui_right") 

	if is_dead:
		if not is_on_floor():
			_animated_sprite.play("death")  
			velocity += get_gravity() * delta
		else:
			velocity = Vector2.ZERO
		
		move_and_slide() 
		return
	if not is_on_floor():
		velocity += get_gravity() * delta

	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		if not is_attacking: 
			_animated_sprite.play('jump')

	if Input.is_action_just_pressed("ui_attack") and not is_attacking:		
		_animated_sprite.play('attack1') 
		spell_collider.disabled = false
		is_attacking = true
	
	if direction:
		velocity.x = direction * SPEED
		if is_on_floor():
			if not is_attacking:
				_animated_sprite.play('run')
			_animated_sprite.flip_h = direction < 0
		else:
			if velocity.y != 0:
				if not is_attacking:
					_animated_sprite.play('jump')
				_animated_sprite.flip_h = direction < 0
			else:
				if not is_attacking:
					_animated_sprite.play('idle')
				_animated_sprite.flip_h = direction < 0
			
		
		

	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		if not is_attacking:
			_animated_sprite.play('idle')
			
	if not is_on_floor():
		if velocity.y < 0 and not is_attacking:
			_animated_sprite.play("jump") 
		elif velocity.y > 0 and not is_attacking:
			_animated_sprite.play("jump") 
		elif not is_attacking: 
			_animated_sprite.play('idle')
	if _animated_sprite.flip_h:
		spell_collider.position.x = -30  
	else:
		spell_collider.position.x = 30
	move_and_slide()

func die() -> void:
	is_dead = true  
	_animated_sprite.play("death")  


func _on_area_2d_area_shape_entered(_area_rid: RID, _area: Area2D, _area_shape_index: int, _local_shape_index: int) -> void:
	die()

func _on_animation_done():
	print(_animated_sprite.animation)
	if _animated_sprite.animation == "attack1":
		is_attacking = false
		spell_collider.disabled = true

		
func _on_animation_changed():
	if _animated_sprite.animation == "attack1":
		pass
		

	


func _on_spell_area_shape_entered(area_rid: RID, area: Area2D, area_shape_index: int, local_shape_index: int) -> void:
	var enemy = area.get_parent()
	if enemy is Enemy:
		enemy.is_dying = true
