extends Node

# Level progression
var current_level: int = 1
const MAX_LEVELS: int = 3

# Level configuration - scales difficulty
var level_configs = {
	1: {"num_rooms": 5, "boss_health": 50},
	2: {"num_rooms": 7, "boss_health": 75},
	3: {"num_rooms": 10, "boss_health": 100}
}

func get_current_config() -> Dictionary:
	return level_configs[current_level]

func advance_level() -> bool:
	"""Returns true if game continues, false if victory"""
	if current_level >= MAX_LEVELS:
		return false
	current_level += 1
	return true

func reset_game():
	current_level = 1

func is_final_level() -> bool:
	return current_level >= MAX_LEVELS
