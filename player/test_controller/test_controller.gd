extends CharacterBody2D

@export_group("Input")
@export var input_left := "move_left"
@export var input_right := "move_right"
@export var input_jump := "move_jump"

@export_group("Player Movement")
@export var base_speed := 8000.0
@export var jump_height := -350.0
@export var gravity_amount := 600.0
@export var rotation_speed := 3.0

@export_group("Player Abilities")
@export var frozen := false
@export var can_move := true
@export var can_jump := true

var direction : float
var recent_direction : float


func _physics_process(delta: float) -> void:
	if frozen:
		return
	
	if not is_on_floor():
		velocity.y += gravity_amount * delta
	
	if not can_jump:
		return
	
	if Input.is_action_just_pressed(input_jump) and is_on_floor():
		velocity.y = jump_height

	if not can_move:
		return

	direction = Input.get_axis(input_left, input_right)
	
	if direction != 0.0:
		velocity.x = direction * base_speed * delta
		self.rotate(direction * rotation_speed * delta)
		recent_direction = direction
	else:
		velocity.x = lerp(0.0, velocity.x, 0.95)
		if abs(int(self.rotation_degrees) % 90) > 0.1:
			self.rotate(recent_direction * rotation_speed * delta * 0.5)
		

	move_and_slide()
