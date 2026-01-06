extends Node2D

# Dungeon settings
var room_count = 10
var room_min_size = Vector2(400, 300)
var room_max_size = Vector2(600, 500)
var tile_size = 32

# Colors for simple visualization
var floor_color = Color(0.3, 0.3, 0.3)
var wall_color = Color(0.15, 0.15, 0.15)

# Room data
var rooms = []

func _ready():
	generate_dungeon()

func generate_dungeon():
	# Clear existing rooms
	for child in get_children():
		child.queue_free()
	rooms.clear()

	# Generate rooms
	for i in range(room_count):
		var room_size = Vector2(
			randf_range(room_min_size.x, room_max_size.x),
			randf_range(room_min_size.y, room_max_size.y)
		)

		var room_pos = Vector2(
			randf_range(0, 1920 - room_size.x),
			randf_range(0, 1080 - room_size.y)
		)

		var room = create_room(room_pos, room_size)
		rooms.append(room)

	# Connect rooms with corridors (simple implementation)
	for i in range(rooms.size() - 1):
		create_corridor(rooms[i], rooms[i + 1])

func create_room(pos, size):
	var room = ColorRect.new()
	room.position = pos
	room.size = size
	room.color = floor_color
	add_child(room)

	# Add walls
	var wall_thickness = 4

	# Top wall
	var top_wall = create_wall(Vector2(0, 0), Vector2(size.x, wall_thickness))
	room.add_child(top_wall)

	# Bottom wall
	var bottom_wall = create_wall(Vector2(0, size.y - wall_thickness), Vector2(size.x, wall_thickness))
	room.add_child(bottom_wall)

	# Left wall
	var left_wall = create_wall(Vector2(0, 0), Vector2(wall_thickness, size.y))
	room.add_child(left_wall)

	# Right wall
	var right_wall = create_wall(Vector2(size.x - wall_thickness, 0), Vector2(wall_thickness, size.y))
	room.add_child(right_wall)

	return room

func create_wall(pos, wall_size):
	# Create a StaticBody2D for collision
	var wall = StaticBody2D.new()
	wall.position = pos

	# Add visual representation
	var visual = ColorRect.new()
	visual.size = wall_size
	visual.color = wall_color
	wall.add_child(visual)

	# Add collision shape
	var collision = CollisionShape2D.new()
	var shape = RectangleShape2D.new()
	shape.size = wall_size
	collision.shape = shape
	collision.position = wall_size / 2  # Center the collision shape
	wall.add_child(collision)

	return wall

func create_corridor(room1, room2):
	var corridor = ColorRect.new()

	# Simple horizontal corridor
	var start = room1.position + room1.size / 2
	var end = room2.position + room2.size / 2

	var corridor_width = 40
	var corridor_pos = Vector2(min(start.x, end.x), start.y - corridor_width / 2)
	var corridor_size = Vector2(abs(end.x - start.x), corridor_width)

	corridor.position = corridor_pos
	corridor.size = corridor_size
	corridor.color = floor_color
	add_child(corridor)

func get_spawn_position():
	# Return the center of the first room as spawn position
	if rooms.size() > 0:
		return rooms[0].position + rooms[0].size / 2
	return Vector2(640, 360)
