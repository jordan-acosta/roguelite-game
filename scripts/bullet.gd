extends Area2D

var speed: float = 300.0
var damage: int = 10
var direction: Vector2 = Vector2.RIGHT

func _ready():
	body_entered.connect(_on_body_entered)

func _physics_process(delta):
	position += direction * speed * delta

	# Destroy if too far from origin (5000 pixels)
	if position.length() > 5000:
		queue_free()

func _on_body_entered(body):
	if body.is_in_group("boss"):
		body.take_damage(damage)
		queue_free()
