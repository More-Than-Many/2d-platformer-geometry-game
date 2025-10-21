extends RigidBody2D

@export var torque_force = 8000

func _ready():
	print(torque_force)

func _physics_process(_delta: float) -> void:
	if Input.is_action_pressed("left"):
		apply_torque(-torque_force)
	
	if Input.is_action_pressed("right"):
		apply_torque(torque_force)
		
	angular_velocity = clamp(angular_velocity, -PI, PI)
