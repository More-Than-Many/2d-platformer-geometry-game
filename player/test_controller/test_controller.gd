extends CharacterBody2D

@export_group("Input")
@export var input_left := "move_left"
@export var input_right := "move_right"
@export var input_jump := "move_jump"

@export_group("Player Movement")
@export var base_speed := 300.0
@export var jump_height := 10.0
@export var gravity_amount := 10.0


func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += gravity_amount * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = jump_height

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()
