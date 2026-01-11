extends Node2D

# Grid-based dungeon generation
var cell_size = 32  # Match player character size
var grid_width = 120  # Cells (3840 pixels)
var grid_height = 80  # Cells (2560 pixels)
var map = []  # 2D array: 0 = floor, 1 = wall

# Colors
var background_color = Color(1, 1, 1)  # White background
var wall_color = Color(0.5, 0.5, 0.5)  # Gray walls
var floor_color = Color(0.9, 0.9, 0.9)  # Light gray floor

# Room generation settings
var min_room_size = 5
var max_room_size = 15
var num_rooms = 20

var rooms = []

func _ready():
	generate_dungeon()
	create_exit_trigger()

func generate_dungeon():
	# Clear existing
	for child in get_children():
		child.queue_free()
	rooms.clear()

	# Create white background
	var background = ColorRect.new()
	background.position = Vector2(0, 0)
	background.size = Vector2(grid_width * cell_size, grid_height * cell_size)
	background.color = background_color
	background.z_index = -100
	add_child(background)

	# Initialize map with all walls
	map = []
	for y in range(grid_height):
		var row = []
		for x in range(grid_width):
			row.append(1)  # 1 = wall
		map.append(row)

	# Get room count from level config
	var config = GameState.get_current_config()
	var room_count = config.num_rooms

	# Generate rooms in a horizontal line (left to right)
	var current_x = 2  # Start near left edge
	var corridor_length = 3  # Gap between rooms

	for i in range(room_count):
		var room_w = randi() % (max_room_size - min_room_size) + min_room_size
		var room_h = randi() % (max_room_size - min_room_size) + min_room_size

		# Center room vertically with some random variation
		var room_y = (grid_height / 2) - (room_h / 2) + (randi() % 5 - 2)
		room_y = clamp(room_y, 2, grid_height - room_h - 2)

		var new_room = {"x": current_x, "y": room_y, "w": room_w, "h": room_h}
		carve_room(new_room)

		# Connect to previous room with straight horizontal corridor
		if rooms.size() > 0:
			carve_horizontal_corridor(rooms[-1], new_room)

		rooms.append(new_room)

		# Move x position for next room
		current_x += room_w + corridor_length

	# Render the map
	render_map()

func carve_room(room):
	for y in range(room["y"], room["y"] + room["h"]):
		for x in range(room["x"], room["x"] + room["w"]):
			map[y][x] = 0  # 0 = floor

func carve_horizontal_corridor(room1, room2):
	# Straight horizontal corridor between rooms
	var y1 = room1["y"] + room1["h"] / 2
	var y2 = room2["y"] + room2["h"] / 2
	var x1 = room1["x"] + room1["w"]  # Right edge of room1
	var x2 = room2["x"]  # Left edge of room2

	# Horizontal segment from room1
	for x in range(x1, x2 + 1):
		for dy in range(2):  # 2 cells wide
			var cy = y1 + dy
			if cy >= 0 and cy < grid_height and x >= 0 and x < grid_width:
				map[cy][x] = 0

	# Vertical segment to connect different heights
	if y1 != y2:
		var min_y = min(y1, y2)
		var max_y = max(y1, y2)
		for y in range(min_y, max_y + 2):  # +2 for corridor width
			for dx in range(2):
				var cx = x2 + dx
				if y >= 0 and y < grid_height and cx >= 0 and cx < grid_width:
					map[y][cx] = 0

func render_map():
	# Render only wall cells as gray squares with collision
	for y in range(grid_height):
		for x in range(grid_width):
			if map[y][x] == 1:  # Wall
				create_wall_tile(x, y)

func create_wall_tile(grid_x, grid_y):
	var wall = StaticBody2D.new()
	wall.position = Vector2(grid_x * cell_size, grid_y * cell_size)
	add_child(wall)

	# Visual - gray square
	var visual = ColorRect.new()
	visual.size = Vector2(cell_size, cell_size)
	visual.color = wall_color
	wall.add_child(visual)

	# Collision
	var collision = CollisionShape2D.new()
	var shape = RectangleShape2D.new()
	shape.size = Vector2(cell_size, cell_size)
	collision.shape = shape
	collision.position = Vector2(cell_size / 2, cell_size / 2)
	wall.add_child(collision)

func get_spawn_position():
	# Spawn in center of first room
	if rooms.size() > 0:
		var room = rooms[0]
		return Vector2(
			(room["x"] + room["w"] / 2) * cell_size,
			(room["y"] + room["h"] / 2) * cell_size
		)
	return Vector2(cell_size * 10, cell_size * 10)

func create_exit_trigger() -> Area2D:
	"""Creates an Area2D trigger in the center of the last room"""
	if rooms.size() == 0:
		return null

	var last_room = rooms[-1]
	var trigger = Area2D.new()
	trigger.name = "ExitTrigger"

	# Position at center of last room
	trigger.position = Vector2(
		(last_room["x"] + last_room["w"] / 2) * cell_size,
		(last_room["y"] + last_room["h"] / 2) * cell_size
	)

	# Add collision shape (3x3 cell trigger area)
	var collision = CollisionShape2D.new()
	var shape = RectangleShape2D.new()
	shape.size = Vector2(cell_size * 3, cell_size * 3)
	collision.shape = shape
	trigger.add_child(collision)

	# Add visual indicator (purple portal)
	var visual = ColorRect.new()
	visual.size = Vector2(cell_size * 3, cell_size * 3)
	visual.position = Vector2(-cell_size * 1.5, -cell_size * 1.5)
	visual.color = Color(0.5, 0, 0.8, 0.5)  # Purple, semi-transparent
	trigger.add_child(visual)

	# Attach script
	trigger.set_script(load("res://scripts/exit_trigger.gd"))

	add_child(trigger)
	return trigger
