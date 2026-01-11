extends CanvasLayer

@onready var health_label = $Panel/MarginContainer/VBoxContainer/HealthLabel
@onready var level_label = $Panel/MarginContainer/VBoxContainer/LevelLabel

func _ready():
	# Connect to player's health signal
	var player = get_tree().get_first_node_in_group("player")
	if player:
		player.health_changed.connect(_on_player_health_changed)
		# Initialize display
		_on_player_health_changed(player.current_health, player.max_health)

	# Update level display
	if level_label and GameState:
		level_label.text = "Level: %d / %d" % [GameState.current_level, GameState.MAX_LEVELS]

func _on_player_health_changed(current, maximum):
	health_label.text = "Health: %d / %d" % [current, maximum]
