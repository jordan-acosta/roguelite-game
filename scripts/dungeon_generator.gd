extends Node2D

# Dungeon settings
var room_count = 6  # Reduced for clearer layout
var grid_cols = 3
var grid_rows = 2
var room_size = Vector2(400, 300)
var corridor_width = 120
var spacing = 100  # Gap between rooms for corridors

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

	# Create rooms in a grid layout (no overlap possible)
	for row in range(grid_rows):
		for col in range(grid_cols):
			var room_x = col * (room_size.x + spacing) + 50
			var room_y = row * (room_size.y + spacing) + 50
			var room = create_room(Vector2(room_x, room_y), room_size)
			rooms.append(room)

	# Connect each room to the room on its right
	for row in range(grid_rows):
		for col in range(grid_cols - 1):
			var room1 = rooms[row * grid_cols + col]
			var room2 = rooms[row * grid_cols + col + 1]
			create_horizontal_corridor(room1, room2)

	# Connect each room to the room below it
	for row in range(grid_rows - 1):
		for col in range(grid_cols):
			var room1 = rooms[row * grid_cols + col]
			var room2 = rooms[(row + 1) * grid_cols + col]
			create_vertical_corridor(room1, room2)

func create_room(pos, size):
	var room = Node2D.new()
	room.position = pos
	add_child(room)

	# Add floor visual
	var floor = ColorRect.new()
	floor.size = size
	floor.color = floor_color
	room.add_child(floor)

	# Add walls (4 pixel thick, solid - no doors needed with external corridors)
	var wall_thickness = 4

	# Top wall
	create_wall(room, Vector2(0, 0), Vector2(size.x, wall_thickness))
	# Bottom wall
	create_wall(room, Vector2(0, size.y - wall_thickness), Vector2(size.x, wall_thickness))
	# Left wall
	create_wall(room, Vector2(0, 0), Vector2(wall_thickness, size.y))
	# Right wall
	create_wall(room, Vector2(size.x - wall_thickness, 0), Vector2(wall_thickness, size.y))

	room.set_meta("room_size", size)
	rooms.append(room)

	return room

func create_wall(parent, pos, wall_size):
	var wall = StaticBody2D.new()
	wall.position = pos
	parent.add_child(wall)

	# Visual
	var visual = Polygon2D.new()
	visual.polygon = PackedVector2Array([
		Vector2(0, 0),
		Vector2(wall_size.x, 0),
		Vector2(wall_size.x, wall_size.y),
		Vector2(0, wall_size.y)
	])
	visual.color = wall_color
	wall.add_child(visual)

	# Collision
	var collision = CollisionShape2D.new()
	var shape = RectangleShape2D.new()
	shape.size = wall_size
	collision.shape = shape
	collision.position = wall_size / 2
	wall.add_child(collision)

func create_horizontal_corridor(room1, room2):
	# Corridor connects right edge of room1 to left edge of room2
	var room1_size = room1.get_meta("room_size")
	var corridor_x = room1.position.x + room1_size.x
	var corridor_y = room1.position.y + room1_size.y / 2 - corridor_width / 2
	var corridor_length = room2.position.x - corridor_x

	var corridor = ColorRect.new()
	corridor.position = Vector2(corridor_x, corridor_y)
	corridor.size = Vector2(corridor_length, corridor_width)
	corridor.color = floor_color
	add_child(corridor)

func create_vertical_corridor(room1, room2):
	# Corridor connects bottom edge of room1 to top edge of room2
	var room1_size = room1.get_meta("room_size")
	var corridor_x = room1.position.x + room1_size.x / 2 - corridor_width / 2
	var corridor_y = room1.position.y + room1_size.y
	var corridor_length = room2.position.y - corridor_y

	var corridor = ColorRect.new()
	corridor.position = Vector2(corridor_x, corridor_y)
	corridor.size = Vector2(corridor_width, corridor_length)
	corridor.color = floor_color
	add_child(corridor)

func get_spawn_position():
	# Spawn in center of first room
	if rooms.size() > 0:
		var room_size = rooms[0].get_meta("room_size")
		return rooms[0].position + room_size / 2
	return Vector2(640, 360)
