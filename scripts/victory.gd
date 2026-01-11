extends CanvasLayer

@onready var restart_button = $CenterContainer/VBoxContainer/RestartButton

func _ready():
	restart_button.pressed.connect(_on_restart_pressed)

func _on_restart_pressed():
	GameState.reset_game()
	get_tree().change_scene_to_file("res://scenes/main.tscn")
