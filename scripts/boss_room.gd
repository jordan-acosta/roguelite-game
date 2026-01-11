extends Node2D

const BulletScript = preload("res://scripts/bullet.gd")

@onready var boss = $Boss
@onready var player = $Player
@onready var boss_health_label = $BossUI/Panel/BossHealthLabel

var fire_cooldown: float = 0.0
const FIRE_RATE: float = 0.1

func _ready():
	# Setup player
	player.add_to_group("player")
	player.position = Vector2(400, 500)

	# Connect boss signals
	boss.defeated.connect(_on_boss_defeated)
	boss.health_changed.connect(_on_boss_health_changed)

	# Initialize boss health display
	_on_boss_health_changed(boss.current_health, boss.max_health)

func _on_boss_defeated():
	# Determine next scene
	if GameState.advance_level():
		# More levels to go - return to dungeon
		get_tree().change_scene_to_file("res://scenes/main.tscn")
	else:
		# Victory!
		get_tree().change_scene_to_file("res://scenes/victory.tscn")

func _on_boss_health_changed(current: int, maximum: int):
	if boss_health_label:
		boss_health_label.text = "Boss: %d / %d" % [current, maximum]

func _process(delta):
	if fire_cooldown > 0:
		fire_cooldown -= delta

	# Check fire directions (WASD) - continuous fire while held
	var fire_dir = Vector2.ZERO
	if Input.is_action_pressed("fire_right"):
		fire_dir.x += 1
	if Input.is_action_pressed("fire_left"):
		fire_dir.x -= 1
	if Input.is_action_pressed("fire_down"):
		fire_dir.y += 1
	if Input.is_action_pressed("fire_up"):
		fire_dir.y -= 1

	if fire_dir != Vector2.ZERO and fire_cooldown <= 0:
		fire_bullet(fire_dir.normalized())

func fire_bullet(direction: Vector2):
	if not player or fire_cooldown > 0:
		return

	fire_cooldown = FIRE_RATE

	# Create bullet
	var bullet = Area2D.new()
	bullet.name = "Bullet"
	bullet.position = player.position

	# Visual (red square)
	var visual = ColorRect.new()
	visual.size = Vector2(16, 16)
	visual.position = Vector2(-8, -8)
	visual.color = Color(1, 0, 0)  # Red
	visual.z_index = 100
	bullet.add_child(visual)

	# Collision
	var collision = CollisionShape2D.new()
	var shape = RectangleShape2D.new()
	shape.size = Vector2(16, 16)
	collision.shape = shape
	bullet.add_child(collision)

	# Fire in specified direction
	bullet.set_script(BulletScript)
	add_child(bullet)
	bullet.direction = direction
	bullet.damage = player.damage
