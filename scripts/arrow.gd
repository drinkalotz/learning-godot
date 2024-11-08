extends RigidBody2D

var speed = 400

func _integrate_forces(state):
	if linear_velocity.length() > 0:
		rotation = linear_velocity.angle()

func _on_arrow_area_shape_entered(area_rid: RID, area: Area2D, area_shape_index: int, local_shape_index: int) -> void:
	var enemy = area.get_parent()
	if enemy is Enemy:
		enemy.is_dying = true
		linear_velocity = Vector2.ZERO
		set_deferred("freeze", true)
		queue_free()
