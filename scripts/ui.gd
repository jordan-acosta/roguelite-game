extends CanvasLayer

@onready var health_label = $Panel/MarginContainer/VBoxContainer/HealthLabel

func _ready():
	# Connect to player's health signal
	var player = get_tree().get_first_node_in_group("player")
	if player:
		player.health_changed.connect(_on_player_health_changed)
		# Initialize display
		_on_player_health_changed(player.current_health, player.max_health)

func _on_player_health_changed(current, maximum):
	health_label.text = "Health: %d / %d" % [current, maximum]
