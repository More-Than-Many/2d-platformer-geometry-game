extends RigidBody2D

@export var base_torque_force := 12000.0
@export var jump_height := 1.5

@export var CornerHolder : Node

var corners = []

var input_direction : float

var current_torque_force : float

func _ready():
	for child in CornerHolder.get_children():
		if child is Node2D:
			corners.append(child)

func _physics_process(_delta: float) -> void:
	input_direction = Input.get_axis("left", "right")
	current_torque_force = lerp(current_torque_force, input_direction * base_torque_force, 0.5) #Upon further inspection this may be a bad way of doing this, will try a different method of lerping
	
	apply_torque(current_torque_force)
	
	if Input.is_action_just_pressed("jump"):
		jump()
		
	angular_velocity = clamp(angular_velocity, -PI, PI)

func jump() -> void:
	var highest_corner = corners[0]
	for corner in corners:
		if corner.global_position.y < highest_corner.global_position.y:
			highest_corner = corner
	
	jump_towards(highest_corner.global_position.y)

func jump_towards(point):
	var direction_to_point = (point - self.global_position.y)
	linear_velocity.y += direction_to_point * jump_height
	
	
