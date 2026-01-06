extends CharacterBody2D

# Player stats
var max_health = 100
var current_health = 100
var speed = 200.0
var damage = 10

# Shooting
var shoot_timer = 0.0
var shoot_cooldown = 0.5
var bullet_scene = preload("res://scenes/bullet.tscn")

# Movement
func _physics_process(delta):
	# Get input direction
	var direction = Vector2.ZERO

	# Check for touch controls first
	var touch_controls = get_tree().get_first_node_in_group("touch_controls")
	if touch_controls:
		direction = touch_controls.get_direction()

	# Keyboard input (overrides touch if both are used)
	if Input.is_action_pressed("move_right"):
		direction.x += 1
	if Input.is_action_pressed("move_left"):
		direction.x -= 1
	if Input.is_action_pressed("move_down"):
		direction.y += 1
	if Input.is_action_pressed("move_up"):
		direction.y -= 1

	# Normalize diagonal movement
	if direction.length() > 0:
		direction = direction.normalized()

	# Apply movement
	velocity = direction * speed
	move_and_slide()

	# Handle shooting
	if touch_controls:
		var shoot_dir = touch_controls.get_shoot_direction()
		if shoot_dir.length() > 0 and shoot_timer <= 0:
			spawn_bullet(shoot_dir)
			shoot_timer = shoot_cooldown

	# Update shoot timer
	if shoot_timer > 0:
		shoot_timer -= delta

# Spawn bullet
func spawn_bullet(direction: Vector2):
	var bullet = bullet_scene.instantiate()
	bullet.position = position
	bullet.direction = direction
	get_parent().add_child(bullet)

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
