extends RigidBody2D

@export_group("Nodes")
@export var Center : Node2D

@export_group("Input")
@export var input_left := "move_left"
@export var input_right := "move_right"
@export var input_jump := "move_jump"

@export_group("Player Movement")
@export var base_torque := 6000.0
@export var jump_height := 600.0
@export var jump_length := 400.0

@export_group("Player Properties")
@export var frozen := false
@export var can_move := true
@export var can_jump := true
var on_ground := false

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
	
	if on_ground_check() && linear_velocity.y > 0:
		can_jump = true

	input_direction = Input.get_axis("left", "right")
	if input_direction:
		current_torque = lerp(current_torque, input_direction * base_torque, 0.25)
	else:
		#torque goes to 0 when player doesn't input so that t
		current_torque = 0
	apply_torque(current_torque)
	
	if Input.is_action_just_pressed("jump") && can_jump:
		can_jump = false
		jump()
	
	angular_velocity = clamp(angular_velocity, -PI/1.5, PI/1.5)
	
func on_ground_check() -> bool:
	var ray_count := 0
	for corner in corners:
		for ray in corner.get_children():
			var target = ray.get_collider()
			if !target:
				continue
			if target.is_in_group("ground"):
				ray_count += 1
	
	if ray_count >= 2:
		return true
		
	return false

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

	
	
