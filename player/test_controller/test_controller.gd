extends CharacterBody2D

@export_group("Input")
@export var input_left := "move_left"
@export var input_right := "move_right"
@export var input_jump := "move_jump"

@export_group("Player Movement")
@export var base_speed := 8000.0
@export var jump_height := -350.0
@export var gravity_amount := 600.0

@export_group("Player Abilities")
@export var frozen := false
@export var can_move := true
@export var can_jump := true

var direction : float


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
	
	if direction:
		velocity.x = direction * base_speed * delta
	else:
		velocity.x = 0
		

	move_and_slide()
