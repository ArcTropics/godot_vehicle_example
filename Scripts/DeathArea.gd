extends Area

func _on_DeathArea_body_entered(body):
	if body.is_in_group("Player"):
		get_tree().reload_current_scene()
