extends Node2D

@onready var dungeon = $DungeonGenerator
@onready var player = $Player

func _ready():
	# Wait for dungeon to generate
	await get_tree().create_timer(0.1).timeout

	# Position player at spawn point
	if dungeon:
		player.position = dungeon.get_spawn_position()

	# Add player to group for UI to find
	player.add_to_group("player")

func _input(event):
	# Press R to regenerate dungeon (useful for testing)
	if event.is_action_pressed("ui_accept"):  # Space or Enter
		restart_game()

func restart_game():
	get_tree().reload_current_scene()
