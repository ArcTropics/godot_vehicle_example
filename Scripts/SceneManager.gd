extends Spatial

class_name SceneManager

func _ready():
#	Set the mouse mode to captured on game start
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _process(delta):
#	Alternate mouse mode from captured to visible each time "ESC" is pressed
	if (Input.is_action_just_pressed("ui_cancel")):
		if (Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED):
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		else:
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

	if (Input.is_action_just_pressed("restart")):
		get_tree().reload_current_scene()
