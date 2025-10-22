extends RigidBody2D

@export var base_torque_force := 12000.0
@export var jump_height := 1200.0

@export_group("Nodes"
@export var CornerHolder : Node

@export_group("Input")
@export var input_left := "move_left"
@export var input_right := "move_right"
@export var input_jump := "move_jump"

@export_group("Player Movement")
@export var base_torque := 12000.0
@export var jump_height := 1200.0

@export_group("Player Abilities")
@export var frozen := false
@export var can_move := true
@export var can_jump := true

var direction : float
var recent_direction : float

var corners = []

var input_direction : float

var current_torque_force : float

func _ready():
	for child in CornerHolder.get_children():
		if child is Node2D:
			corners.append(child)

func _physics_process(_delta: float) -> void:
	if not can_move:
		return

	input_direction = Input.get_axis("left", "right")
	current_torque_force = lerp(current_torque_force, input_direction * base_torque_force, 0.5) #Upon further inspection this may be a bad way of doing this, will try a different method of lerping
	
	apply_torque(current_torque_force)

	if not can_jump:
		return
	
	if Input.is_action_just_pressed("jump"):
		jump()
		
	angular_velocity = clamp(angular_velocity, -PI, PI)


func jump() -> void:
	var highest_corner_position = $CornerHolder/Center.global_position
	print(highest_corner_position)
	for corner in corners:
		if corner.global_position.y == (highest_corner_position.y - 32.0):
			highest_corner_position = $CornerHolder/Center.global_position
			highest_corner_position.y -= 32.0
		elif corner.global_position.y < highest_corner_position.y:
			highest_corner_position = corner.global_position
	
	jump_towards(highest_corner_position)
	print(highest_corner_position)

func jump_towards(point):
	var direction_to_point = (point - self.global_position).normalized()
	linear_velocity.y += direction_to_point.y * jump_height
	print(direction_to_point)
	linear_velocity.x += direction_to_point.x
	
	
