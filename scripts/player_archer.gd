extends CharacterBody2D

class_name PlayerArcher

@onready var _animated_sprite = $AnimatedSprite2D
@onready var bow: Area2D = $bow
@onready var bow_collider: CollisionShape2D = $bow/bow_collider
@onready var arrow_scene = preload("res://scenes/arrow.tscn")  


const SPEED = 250.0
const JUMP_VELOCITY = -400.0
var is_dead = false
var is_attacking = false
var is_shooting = false
var look_at = Vector2.RIGHT

func _ready():
	_animated_sprite.animation_finished.connect(_on_animation_done)
	_animated_sprite.animation_changed.connect(_on_animation_changed)

func _physics_process(delta: float) -> void:
	
	var direction := Input.get_axis("ui_left", "ui_right") 
	if Input.is_action_just_pressed('ui_archer_shoot') and not is_attacking and not is_shooting and is_on_floor():
		_animated_sprite.play("attack_bow")
		is_shooting = true
		
	if is_shooting:
		
		velocity = Vector2.ZERO
		move_and_slide()
		return

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

	if Input.is_action_just_pressed("ui_attack") and not is_attacking and not is_shooting:		
		_animated_sprite.play('attack1') 
		bow_collider.disabled = false
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
		bow_collider.position.x = -30  
	else:
		bow_collider.position.x = 30
	move_and_slide()

func die() -> void:
	is_dead = true  
	_animated_sprite.play("death")  


func _on_animation_done():
	if _animated_sprite.animation == "attack1":
		is_attacking = false
		bow_collider.disabled = true
	elif _animated_sprite.animation == "attack_bow":
		fire_arrow()
		is_shooting = false

		
func _on_animation_changed():
	if _animated_sprite.animation == "attack1":
		pass
		


func _on_bow_area_shape_entered(area_rid: RID, area: Area2D, area_shape_index: int, local_shape_index: int) -> void:
	var enemy = area.get_parent()
	print(enemy.name)
	if enemy is Enemy:
		enemy.is_dying = true


func _on_area_2d_area_shape_entered(area_rid: RID, area: Area2D, area_shape_index: int, local_shape_index: int) -> void:
	die()
func fire_arrow() -> void:
	var arrow_instance = arrow_scene.instantiate() as RigidBody2D
	
	var arrow_offset = Vector2(40, 0) if not _animated_sprite.flip_h else Vector2(-40, 0)
	arrow_instance.global_position = global_position + arrow_offset

	
	var direction = Vector2(1, 0) if not _animated_sprite.flip_h else Vector2(-1, 0)
	arrow_instance.linear_velocity = direction * 1000  

	get_parent().add_child(arrow_instance)
	
