extends RigidBody2D

@export var base_torque_force := 12000.0

var input_direction : float

var current_torque_force : float

func _ready():
	pass

func _physics_process(_delta: float) -> void:
	input_direction = Input.get_axis("left", "right")
	current_torque_force = lerp(current_torque_force, input_direction * base_torque_force, 0.5)
	
	apply_torque(current_torque_force)
		
	angular_velocity = clamp(angular_velocity, -PI, PI)
