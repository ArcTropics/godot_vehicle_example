extends Spatial

export(NodePath) var _target_path
export(float) var arm_length = 5

onready var target = get_node(_target_path)
onready var spring_arm = get_node("SpringArm")
onready var camera = get_node("SpringArm/Camera")

var new_position : Vector3

func _ready():
	global_transform = target.global_transform
	transform.origin.y += 2
#	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	
func _process(delta):
	if Input.is_action_just_pressed("ui_cancel"):
#		if Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
#			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
#		else:
#			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
#		get_tree().quit()
		get_tree().reload_current_scene()

#	SET CAMERA POSITION RELATIVE TO CAR
	global_transform = target.global_transform
	global_rotate(Vector3.UP, target.rotation.y)
#	rotate_object_local(Vector3.UP, target.rotation.y)
	rotation =  Vector3(0, deg2rad(180), 0)	# To make the spring arm rotate 180
	transform.origin.y += 1
	transform.origin.z -= 6
#	rotate_object_local(Vector3.RIGHT, -deg2rad(15))
	
func _physics_process(delta):
	spring_arm.spring_length = lerp(spring_arm.spring_length, arm_length, .01)

	
#	

#func _unhandled_input(event):
#	if (event is InputEventMouseButton) and event.pressed:
#		self.transform.origin = target.transform.origin

