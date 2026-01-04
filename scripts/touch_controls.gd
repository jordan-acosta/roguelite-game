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

	# Always show for now (we'll hide on desktop later)
	show()

	# Calculate joystick center from ColorRect offsets
	var base_width = joystick_base.offset_right - joystick_base.offset_left
	var base_height = joystick_base.offset_bottom - joystick_base.offset_top
	joystick_center = Vector2(joystick_base.offset_left + base_width / 2,
	                           joystick_base.offset_top + base_height / 2)

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
			# Touch released - reset joystick
			if event.index == touch_index:
				touch_index = -1
				current_direction = Vector2.ZERO
				# Reset joystick tip to center of base
				var base_width = joystick_base.offset_right - joystick_base.offset_left
				var base_height = joystick_base.offset_bottom - joystick_base.offset_top
				joystick_tip.offset_left = (base_width - 80) / 2
				joystick_tip.offset_top = (base_height - 80) / 2
				joystick_tip.offset_right = joystick_tip.offset_left + 80
				joystick_tip.offset_bottom = joystick_tip.offset_top + 80

	elif event is InputEventScreenDrag:
		if event.index == touch_index:
			var drag_pos = event.position - joystick_center
			var distance = drag_pos.length()

			if distance > joystick_radius:
				drag_pos = drag_pos.normalized() * joystick_radius

			# Update joystick tip position
			var base_width = joystick_base.offset_right - joystick_base.offset_left
			var base_height = joystick_base.offset_bottom - joystick_base.offset_top
			var center_offset = Vector2((base_width - 80) / 2, (base_height - 80) / 2)

			joystick_tip.offset_left = center_offset.x + drag_pos.x
			joystick_tip.offset_top = center_offset.y + drag_pos.y
			joystick_tip.offset_right = joystick_tip.offset_left + 80
			joystick_tip.offset_bottom = joystick_tip.offset_top + 80

			current_direction = drag_pos.normalized()

func get_direction() -> Vector2:
	return current_direction
