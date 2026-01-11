extends Area2D

signal player_entered_exit

var triggered = false

func _ready():
	body_entered.connect(_on_body_entered)

func _on_body_entered(body):
	if triggered:
		return
	if body.is_in_group("player"):
		triggered = true
		emit_signal("player_entered_exit")
