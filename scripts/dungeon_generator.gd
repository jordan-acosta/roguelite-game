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

	# Generate rooms with door tracking
	for i in range(room_count):
		var room_size = Vector2(
			randf_range(room_min_size.x, room_max_size.x),
			randf_range(room_min_size.y, room_max_size.y)
		)

		var room_pos = Vector2(
			randf_range(0, 1920 - room_size.x),
			randf_range(0, 1080 - room_size.y)
		)

		var room = create_room_container(room_pos, room_size)
		rooms.append(room)

	# Connect rooms with corridors and mark door positions
	for i in range(rooms.size() - 1):
		create_corridor(rooms[i], rooms[i + 1])

	# Add walls with doors to all rooms
	for room in rooms:
		add_walls_to_room(room)

func create_room_container(pos, size):
	# Create room container without walls (walls added later)
	var room = Node2D.new()
	room.position = pos
	add_child(room)

	# Add floor visual
	var floor = ColorRect.new()
	floor.size = size
	floor.color = floor_color
	room.add_child(floor)

	# Store room data
	room.set_meta("room_size", size)
	room.set_meta("doors", [])  # Track door positions

	return room

func add_walls_to_room(room):
	var size = room.get_meta("room_size")
	var doors = room.get_meta("doors")
	var wall_thickness = 4
	var door_width = 80

	# Top wall
	create_wall_with_doors(room, Vector2(0, 0), Vector2(size.x, wall_thickness), "top", doors, door_width)

	# Bottom wall
	create_wall_with_doors(room, Vector2(0, size.y - wall_thickness), Vector2(size.x, wall_thickness), "bottom", doors, door_width)

	# Left wall
	create_wall_with_doors(room, Vector2(0, 0), Vector2(wall_thickness, size.y), "left", doors, door_width)

	# Right wall
	create_wall_with_doors(room, Vector2(size.x - wall_thickness, 0), Vector2(wall_thickness, size.y), "right", doors, door_width)

func create_wall_with_doors(room, pos, wall_size, side, doors, door_width):
	# Check if this wall has any doors
	var doors_on_this_side = []
	for door in doors:
		if door.side == side:
			doors_on_this_side.append(door.position)

	if doors_on_this_side.size() == 0:
		# No doors, create solid wall
		var wall = create_wall(pos, wall_size)
		room.add_child(wall)
	else:
		# Create wall segments with gaps for doors
		if side == "top" or side == "bottom":
			# Horizontal wall
			var segments = get_wall_segments(0, wall_size.x, doors_on_this_side, door_width)
			for segment in segments:
				var segment_pos = Vector2(pos.x + segment.start, pos.y)
				var segment_size = Vector2(segment.end - segment.start, wall_size.y)
				var wall = create_wall(segment_pos, segment_size)
				room.add_child(wall)
		else:
			# Vertical wall
			var segments = get_wall_segments(0, wall_size.y, doors_on_this_side, door_width)
			for segment in segments:
				var segment_pos = Vector2(pos.x, pos.y + segment.start)
				var segment_size = Vector2(wall_size.x, segment.end - segment.start)
				var wall = create_wall(segment_pos, segment_size)
				room.add_child(wall)

func get_wall_segments(wall_start, wall_end, door_positions, door_width):
	# Calculate wall segments around door openings
	var segments = []
	var current_pos = wall_start

	# Sort door positions
	door_positions.sort()

	for door_pos in door_positions:
		var door_start = door_pos - door_width / 2
		var door_end = door_pos + door_width / 2

		# Add segment before door if there's space
		if current_pos < door_start:
			segments.append({"start": current_pos, "end": door_start})

		current_pos = door_end

	# Add final segment after last door
	if current_pos < wall_end:
		segments.append({"start": current_pos, "end": wall_end})

	return segments

func create_wall(pos, wall_size):
	# Create a StaticBody2D for collision
	var wall = StaticBody2D.new()
	wall.position = pos

	# Add visual representation (ColorRect uses offset properties)
	var visual = ColorRect.new()
	visual.offset_left = 0
	visual.offset_top = 0
	visual.offset_right = wall_size.x
	visual.offset_bottom = wall_size.y
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
	var room1_size = room1.get_meta("room_size")
	var room2_size = room2.get_meta("room_size")
	var start = room1.position + room1_size / 2
	var end = room2.position + room2_size / 2

	var corridor_width = 40

	# Determine which room is on the left and which is on the right
	var left_room = room1 if start.x < end.x else room2
	var right_room = room2 if start.x < end.x else room1
	var left_room_size = left_room.get_meta("room_size")
	var right_room_size = right_room.get_meta("room_size")

	# Add doors to the rooms
	# Left room gets a door on the right side
	var left_room_doors = left_room.get_meta("doors")
	left_room_doors.append({"side": "right", "position": left_room_size.y / 2})
	left_room.set_meta("doors", left_room_doors)

	# Right room gets a door on the left side
	var right_room_doors = right_room.get_meta("doors")
	right_room_doors.append({"side": "left", "position": right_room_size.y / 2})
	right_room.set_meta("doors", right_room_doors)

	# Create corridor visual
	var corridor = ColorRect.new()
	var corridor_pos = Vector2(min(start.x, end.x), start.y - corridor_width / 2)
	var corridor_size = Vector2(abs(end.x - start.x), corridor_width)

	corridor.position = corridor_pos
	corridor.size = corridor_size
	corridor.color = floor_color
	add_child(corridor)

func get_spawn_position():
	# Return the center of the first room as spawn position
	if rooms.size() > 0:
		var room_size = rooms[0].get_meta("room_size")
		return rooms[0].position + room_size / 2
	return Vector2(640, 360)
