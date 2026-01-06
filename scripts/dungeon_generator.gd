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

	# Generate rooms
	for i in range(num_rooms):
		var room_w = randi() % (max_room_size - min_room_size) + min_room_size
		var room_h = randi() % (max_room_size - min_room_size) + min_room_size
		var room_x = randi() % (grid_width - room_w - 2) + 1
		var room_y = randi() % (grid_height - room_h - 2) + 1

		var new_room = {"x": room_x, "y": room_y, "w": room_w, "h": room_h}

		# Check if room overlaps with existing rooms
		var overlaps = false
		for room in rooms:
			if rooms_overlap(new_room, room):
				overlaps = true
				break

		if not overlaps:
			carve_room(new_room)

			# Connect to previous room with corridor
			if rooms.size() > 0:
				var prev_room = rooms[rooms.size() - 1]
				carve_corridor(prev_room, new_room)

			rooms.append(new_room)

	# Render the map
	render_map()

func rooms_overlap(room1, room2):
	return not (room1["x"] + room1["w"] < room2["x"] or
				room1["x"] > room2["x"] + room2["w"] or
				room1["y"] + room1["h"] < room2["y"] or
				room1["y"] > room2["y"] + room2["h"])

func carve_room(room):
	for y in range(room["y"], room["y"] + room["h"]):
		for x in range(room["x"], room["x"] + room["w"]):
			map[y][x] = 0  # 0 = floor

func carve_corridor(room1, room2):
	# Get centers
	var x1 = room1["x"] + room1["w"] / 2
	var y1 = room1["y"] + room1["h"] / 2
	var x2 = room2["x"] + room2["w"] / 2
	var y2 = room2["y"] + room2["h"] / 2

	# Carve horizontal then vertical corridor
	if randi() % 2 == 0:
		# Horizontal first
		for x in range(min(x1, x2), max(x1, x2) + 1):
			if y1 >= 0 and y1 < grid_height and x >= 0 and x < grid_width:
				map[y1][x] = 0
		# Then vertical
		for y in range(min(y1, y2), max(y1, y2) + 1):
			if y >= 0 and y < grid_height and x2 >= 0 and x2 < grid_width:
				map[y][x2] = 0
	else:
		# Vertical first
		for y in range(min(y1, y2), max(y1, y2) + 1):
			if y >= 0 and y < grid_height and x1 >= 0 and x1 < grid_width:
				map[y][x1] = 0
		# Then horizontal
		for x in range(min(x1, x2), max(x1, x2) + 1):
			if y2 >= 0 and y2 < grid_height and x >= 0 and x < grid_width:
				map[y2][x] = 0

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
