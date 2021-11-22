extends VehicleBody

# Declaring Exported Variables
export(float) var horsepower : float = 200		# The horsepower of the engine
export var acceleration : float = 1				# how quickly vehicle accelerates

export var steer_angle = 45						# the steering angle at rest
export var steer_speed = 3						# how fast the steering wheel moves
export var steer_min_angle = 3					# minimum angle at high speed
export var steer_multiplier = 45				# multiplier for low-high speed steer angle

export var brake_power = 5
export var brake_speed = 2

export var rear_wheel_friction = 1.0
export var front_wheel_friction = 1.0

export var handbrake_friction = 0.6
export var handbrake_power = 0.4

var car_speed : float = 0
var previous_frame_pos : Vector3 = Vector3()
var current_frame_pos : Vector3 = Vector3()

onready var fwl = get_node("VehicleWheel_BL")
onready var fwr = get_node("VehicleWheel_BR")


func _ready():
	steer_angle = deg2rad(steer_angle)

func _physics_process(delta):
	
#	While driving you need to have lesser angle in steering the faster the car is going.
#	This is not a real word situation but while playing games the user might use the keyboard where
#	input values are either -1, 0 or 1 and nothing in between, or the sensitivity of the controller
#	is not good enough where steering at high speeds can be problematic, leading to undesired results.
#	For this, it makes sense to reduce the steer angle at high speeds and inclease it at lower speeds.
	
#	modify steer_angle. I use this simple formula. Remember, that now steer_angle is in radians
#	I am using abs(engine_force) + 1 is to avoid division by zero in case engine_force is zero.
	var _steer_angle = (steer_angle * steer_multiplier/ (abs(engine_force) + 1))
	_steer_angle = clamp(_steer_angle, deg2rad(steer_min_angle), steer_angle)
	
	var throttle_input = -Input.get_action_strength("move_back") + Input.get_action_strength("move_forward")
	engine_force = lerp(engine_force, throttle_input * horsepower, acceleration * delta)
	
	var steer_input = -Input.get_action_strength("steer_right") + Input.get_action_strength("steer_left")
	steering = lerp_angle(steering, steer_input * _steer_angle, steer_speed * delta)
	
	var brake_input = Input.get_action_strength("brake")
	var handbrake_input = Input.get_action_strength("handbrake")
	var handbrake_total = handbrake_input * handbrake_power
	brake = lerp(brake, (brake_input + handbrake_total) * brake_power, brake_speed * delta)

#	The brake functionality of the Vehicle Node was stopping the vehicle but not bringing the
#	engine_force down to 0 which was leading to the car to move forward when the brakes were released.
#	I am manually reducing the engine force when brakes are pressed to make sure that there is no
#	engine force when the vehicle comes to a stop
	if brake_input > 0.1 and engine_force > 0:
		engine_force -= horsepower * delta
		
#	Ideally the handbrakes should stop the rear wheels. I tried that logic but it didn't do anything,
#	except bring the vehicle to a stop ust like regular brakes. To simulate handbrake, I am reducing
#	the friction on only rear wheels, causing the vehicle to skid and drag in the rear. I am then
#	putting the friction values back to 1 when handbrake is released. This logic is able
#	to create an expected handbrake effect to some extent. It is not perfect, but still works.
	if handbrake_input > 0.1:
		fwl.wheel_friction_slip = handbrake_friction
		fwr.wheel_friction_slip = handbrake_friction
	else:
		fwl.wheel_friction_slip = rear_wheel_friction
		fwr.wheel_friction_slip = rear_wheel_friction

