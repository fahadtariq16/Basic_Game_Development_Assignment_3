extends CharacterBody2D

const SPEED = 130.0
const JUMP_VELOCITY = -300.0
const MAX_JUMPS = 2   # allow double jump

var jumps_left = MAX_JUMPS

var score: int = 0

signal score_changed(new_score)   # signal to update UI

func add_score(amount: int) -> void:
	score += amount
	emit_signal("score_changed", score)


func _physics_process(delta: float) -> void:
	# Add gravity
	if not is_on_floor():
		velocity += get_gravity() * delta
	else:
		# Reset jumps when player touches the ground
		jumps_left = MAX_JUMPS

	# Handle jump
	if Input.is_action_just_pressed("ui_accept") and jumps_left > 0:
		velocity.y = JUMP_VELOCITY
		jumps_left -= 1

	# Handle horizontal movement
	var direction := Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	# Move the player
	move_and_slide()
