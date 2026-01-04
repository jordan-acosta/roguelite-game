extends CharacterBody2D

# Player stats
var max_health = 100
var current_health = 100
var speed = 200.0
var damage = 10

# Movement
func _physics_process(delta):
	# Get input direction
	var direction = Vector2.ZERO

	if Input.is_action_pressed("move_right"):
		direction.x += 1
	if Input.is_action_pressed("move_left"):
		direction.x -= 1
	if Input.is_action_pressed("move_down"):
		direction.y += 1
	if Input.is_action_pressed("move_up"):
		direction.y -= 1

	# Normalize diagonal movement
	direction = direction.normalized()

	# Apply movement
	velocity = direction * speed
	move_and_slide()

# Take damage
func take_damage(amount):
	current_health -= amount
	if current_health <= 0:
		die()
	# Emit signal for UI update
	emit_signal("health_changed", current_health, max_health)

# Heal player
func heal(amount):
	current_health = min(current_health + amount, max_health)
	emit_signal("health_changed", current_health, max_health)

# Player death
func die():
	print("Player died! Game Over")
	# In a real game, this would trigger game over screen
	get_tree().reload_current_scene()

# Signals
signal health_changed(current, maximum)
