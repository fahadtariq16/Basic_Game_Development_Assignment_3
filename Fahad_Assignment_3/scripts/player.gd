extends CharacterBody2D

const SPEED = 130.0
const JUMP_VELOCITY = -300.0
const MAX_JUMPS = 2   # allow double jump
@onready var animatedSprite = $AnimatedSprite2D
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
	if Input.is_action_just_pressed("jump") and jumps_left > 0:
		velocity.y = JUMP_VELOCITY
		jumps_left -= 1

	# Handle horizontal movement
	var direction := Input.get_axis("move_left", "move_right")
	if direction > 0:
		animatedSprite.flip_h = false
	elif direction < 0:
		animatedSprite.flip_h = true
		
	if is_on_floor():
		if direction == 0:
			animatedSprite.play("idle")
		else:
			animatedSprite.play("run")
	else:
		animatedSprite.play("jump")
		 
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	# Move the player
	move_and_slide()
