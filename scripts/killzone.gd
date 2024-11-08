extends Area2D
@onready var timer: Timer = $Timer
var is_dying = false



func _on_body_entered(body: Node2D) -> void:
	if is_dying:
		return
	if body.name == 'PlayerSwordsman' or body.name == 'PlayerWizard' or body.name == 'PlayerArcher':
		is_dying = true
		print("Umro si")
		timer.start()


func _on_timer_timeout() -> void:
	get_tree().reload_current_scene()
	is_dying = false
