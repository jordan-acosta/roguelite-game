extends CharacterBody2D

var max_health: int = 100
var current_health: int = 100
var damage: int = 20
var move_speed: float = 80.0
var attack_cooldown: float = 1.0
var attack_timer: float = 0.0

signal defeated
signal health_changed(current: int, maximum: int)

func _ready():
	# Scale health based on level
	var config = GameState.get_current_config()
	max_health = config.boss_health
	current_health = max_health
	add_to_group("boss")
	emit_signal("health_changed", current_health, max_health)

func _physics_process(delta):
	# Update attack cooldown
	attack_timer -= delta

	# Move toward player
	var player = get_tree().get_first_node_in_group("player")
	if player:
		var direction = (player.position - position).normalized()
		velocity = direction * move_speed
		move_and_slide()

		# Deal damage on collision with player
		if attack_timer <= 0:
			for i in get_slide_collision_count():
				var collision = get_slide_collision(i)
				if collision.get_collider() == player:
					player.take_damage(damage)
					attack_timer = attack_cooldown

func take_damage(amount: int):
	current_health -= amount
	emit_signal("health_changed", current_health, max_health)
	flash_hit()
	if current_health <= 0:
		die()

func flash_hit():
	var color_rect = $ColorRect
	if color_rect:
		var original_color = color_rect.color
		color_rect.color = Color(1, 1, 1)  # Flash white
		await get_tree().create_timer(0.1).timeout
		if is_instance_valid(self) and color_rect:
			color_rect.color = original_color

func die():
	emit_signal("defeated")
	queue_free()
