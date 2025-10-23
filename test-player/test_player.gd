extends RigidBody2D

@export_group("Nodes")
@export var Center : Node2D

@export_group("Input")
@export var input_left := "move_left"
@export var input_right := "move_right"
@export var input_jump := "move_jump"

@export_group("Player Movement")
@export var base_torque := 12000.0
@export var jump_height := 1200.0
@export var jump_length := 600.0
@export var input_direction_pull := 0.5

@export_group("Gravity")
@export var gravity_strength := 980.0
@export var gravity_direction := Vector2.DOWN

@export_group("Player Abilities")
@export var frozen := false
@export var can_move := true
@export var can_jump := true

var input_direction : float
var current_torque : float

var corners = []

func _ready():
	for child in Center.get_children():
		if child is Node2D:
			corners.append(child)

func _physics_process(_delta: float) -> void:
	if not can_move:
		return

	input_direction = Input.get_axis(input_left, input_right)
	current_torque = lerp(current_torque, input_direction * base_torque, input_direction_pull)
	apply_torque(current_torque)

	if not can_jump:
		return
	
	if Input.is_action_just_pressed(input_jump):
		jump()
		
	angular_velocity = clamp(angular_velocity, -PI, PI)

func _integrate_forces(state):
	pass


func jump() -> void:
	var highest_corner_position = Vector2(Center.global_position.x, Center.global_position.y - 32)
	
	for corner in corners:
		if abs(corner.global_position.y - (Center.global_position.y - 32)) < 1.0:
			pass
		elif corner.global_position.y < highest_corner_position.y:
			highest_corner_position = corner.global_position
	
	var direction_to_corner = (highest_corner_position - Center.global_position).normalized()

	linear_velocity.x = direction_to_corner.x * jump_length
	linear_velocity.y = direction_to_corner.y * jump_height

	
	
