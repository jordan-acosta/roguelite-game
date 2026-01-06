extends CanvasLayer

# Virtual joysticks for mobile devices
var move_touch_index = -1
var shoot_touch_index = -1
var move_joystick_center = Vector2.ZERO
var shoot_joystick_center = Vector2.ZERO
var current_move_direction = Vector2.ZERO
var current_shoot_direction = Vector2.ZERO
var joystick_radius = 80

@onready var joystick_base = $JoystickBase
@onready var joystick_tip = $JoystickBase/JoystickTip
@onready var shoot_joystick_base = $ShootJoystickBase
@onready var shoot_joystick_tip = $ShootJoystickBase/ShootJoystickTip

func _ready():
	# Add to group so player can find us
	add_to_group("touch_controls")

	# Always show for now (we'll hide on desktop later)
	show()

	# Position joysticks at bottom corners of viewport
	var viewport_size = get_viewport().get_visible_rect().size
	var joystick_size = 200  # Size of the joystick base
	var margin = 80  # Margin from edges

	# Position move joystick at bottom-right
	joystick_base.offset_left = viewport_size.x - joystick_size - margin
	joystick_base.offset_top = viewport_size.y - joystick_size - margin
	joystick_base.offset_right = viewport_size.x - margin
	joystick_base.offset_bottom = viewport_size.y - margin

	# Position shoot joystick at bottom-left
	shoot_joystick_base.offset_left = margin
	shoot_joystick_base.offset_top = viewport_size.y - joystick_size - margin
	shoot_joystick_base.offset_right = margin + joystick_size
	shoot_joystick_base.offset_bottom = viewport_size.y - margin

	# Calculate joystick centers
	var base_width = joystick_base.offset_right - joystick_base.offset_left
	var base_height = joystick_base.offset_bottom - joystick_base.offset_top
	move_joystick_center = Vector2(joystick_base.offset_left + base_width / 2,
	                                joystick_base.offset_top + base_height / 2)

	shoot_joystick_center = Vector2(shoot_joystick_base.offset_left + base_width / 2,
	                                 shoot_joystick_base.offset_top + base_height / 2)

func _input(event):
	if not visible:
		return

	# Handle touch input
	if event is InputEventScreenTouch:
		if event.pressed:
			var touch_pos = event.position

			# Check move joystick
			var move_dist = touch_pos.distance_to(move_joystick_center)
			if move_dist < joystick_radius * 2:
				move_touch_index = event.index

			# Check shoot joystick
			var shoot_dist = touch_pos.distance_to(shoot_joystick_center)
			if shoot_dist < joystick_radius * 2:
				shoot_touch_index = event.index
		else:
			# Touch released
			if event.index == move_touch_index:
				move_touch_index = -1
				current_move_direction = Vector2.ZERO
				reset_joystick(joystick_tip)

			if event.index == shoot_touch_index:
				shoot_touch_index = -1
				current_shoot_direction = Vector2.ZERO
				reset_joystick(shoot_joystick_tip)

	elif event is InputEventScreenDrag:
		# Handle move joystick drag
		if event.index == move_touch_index:
			var drag_pos = event.position - move_joystick_center
			var distance = drag_pos.length()
			if distance > joystick_radius:
				drag_pos = drag_pos.normalized() * joystick_radius

			update_joystick_tip(joystick_tip, drag_pos)
			current_move_direction = drag_pos.normalized()

		# Handle shoot joystick drag
		if event.index == shoot_touch_index:
			var drag_pos = event.position - shoot_joystick_center
			var distance = drag_pos.length()
			if distance > joystick_radius:
				drag_pos = drag_pos.normalized() * joystick_radius

			update_joystick_tip(shoot_joystick_tip, drag_pos)
			current_shoot_direction = drag_pos.normalized()

func reset_joystick(tip: ColorRect):
	var base_width = 200
	var base_height = 200
	tip.offset_left = (base_width - 80) / 2
	tip.offset_top = (base_height - 80) / 2
	tip.offset_right = tip.offset_left + 80
	tip.offset_bottom = tip.offset_top + 80

func update_joystick_tip(tip: ColorRect, drag_pos: Vector2):
	var base_width = 200
	var base_height = 200
	var center_offset = Vector2((base_width - 80) / 2, (base_height - 80) / 2)

	tip.offset_left = center_offset.x + drag_pos.x
	tip.offset_top = center_offset.y + drag_pos.y
	tip.offset_right = tip.offset_left + 80
	tip.offset_bottom = tip.offset_top + 80

func get_direction() -> Vector2:
	return current_move_direction

func get_shoot_direction() -> Vector2:
	return current_shoot_direction
