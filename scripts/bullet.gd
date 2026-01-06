extends Area2D

# Bullet properties
var speed = 400.0
var direction = Vector2.ZERO
var damage = 10
var lifetime = 5.0  # Bullet will auto-destroy after 5 seconds
var time_alive = 0.0

func _ready():
	# Connect collision signal
	body_entered.connect(_on_body_entered)

func _physics_process(delta):
	# Move bullet in direction
	position += direction * speed * delta

	# Track lifetime
	time_alive += delta
	if time_alive >= lifetime:
		queue_free()

func _on_body_entered(body):
	# Check if hit a wall
	if body is StaticBody2D:
		queue_free()
		return

	# Check if hit an enemy (to be implemented later)
	if body.has_method("take_damage"):
		body.take_damage(damage)
		queue_free()

# Auto-cleanup if bullet goes too far off screen
func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()
