extends CanvasLayer

# Virtual joystick for mobile devices
var touch_index = -1
var joystick_center = Vector2.ZERO
var current_direction = Vector2.ZERO
var joystick_radius = 80

@onready var joystick_base = $JoystickBase
@onready var joystick_tip = $JoystickBase/JoystickTip

func _ready():
	# Add to group so player can find us
	add_to_group("touch_controls")

	# Check if running on mobile/web
	if OS.has_feature("web") or OS.has_feature("mobile"):
		show()
	else:
		hide()

	joystick_center = joystick_base.position + joystick_base.size / 2

func _input(event):
	if not visible:
		return

	# Handle touch input
	if event is InputEventScreenTouch:
		if event.pressed:
			# Check if touch is in joystick area
			var touch_pos = event.position
			var dist = touch_pos.distance_to(joystick_center)

			if dist < joystick_radius * 2:
				touch_index = event.index
		else:
			if event.index == touch_index:
				touch_index = -1
				current_direction = Vector2.ZERO
				joystick_tip.position = Vector2.ZERO

	elif event is InputEventScreenDrag:
		if event.index == touch_index:
			var drag_pos = event.position - joystick_center
			var distance = drag_pos.length()

			if distance > joystick_radius:
				drag_pos = drag_pos.normalized() * joystick_radius

			joystick_tip.position = drag_pos
			current_direction = drag_pos.normalized()

func get_direction() -> Vector2:
	return current_direction
