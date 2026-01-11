# Roguelite Game - Claude Code Configuration

## Project Overview

A roguelite game built with Godot Engine 4.3 using GDScript. Features procedural dungeon generation, player movement, and web deployment.

### Key Files

- `scripts/dungeon_generator.gd` - Grid-based procedural dungeon generation (120x80 grid, 32px cells)
- `scripts/player.gd` - Player controller with health system
- `scripts/main.gd` - Game coordinator
- `scenes/` - Godot scene files (.tscn)

### Technical Details

- Cell/tile size: 32x32 pixels
- Viewport: 1280x720
- Current graphics: ColorRect placeholders (ready for pixel art)
- Texture filtering: Nearest neighbor (pixel-art optimized)

---

## Agents

### pixel-art-generator

Specialized agent for creating and modifying pixel art assets for the roguelite game.

**Capabilities:**
- Generate pixel art sprites as base64-encoded PNGs or describe them for implementation
- Design tile sets for walls, floors, and dungeon decorations
- Create character sprites with animation frame suggestions
- Design UI elements that match the game's aesthetic
- Suggest color palettes appropriate for roguelite/dungeon crawler themes

**Context:**
- All sprites should be 32x32 pixels (or multiples thereof) to match the grid system
- Use limited color palettes (8-16 colors) for authentic pixel art look
- Consider animation frames for characters (idle, walk cycles)
- Dark, atmospheric palettes work well for dungeon environments
- Assets will replace existing ColorRect placeholder nodes with Sprite2D

**Workflow:**
1. Understand the asset request and its purpose in the game
2. Suggest appropriate dimensions, color palette, and style
3. Provide implementation guidance for Godot (Sprite2D, AnimatedSprite2D)
4. Consider how the asset fits with existing visual elements

### dungeon-validator

Specialized agent for testing, analyzing, and improving procedural dungeon generation.

**Capabilities:**
- Analyze dungeon generation algorithms for playability issues
- Detect problems: dead ends, unreachable areas, unfair spawn positions
- Validate room connectivity and corridor traversability
- Suggest improvements to generation parameters
- Test difficulty distribution and pacing
- Verify collision and navigation consistency

**Context:**
- Current generator: `scripts/dungeon_generator.gd`
- Grid: 120x80 cells, 32px per cell (3840x2560 total)
- Room count: 20 rooms, sizes 5-15 cells
- Corridors: 2 cells wide, L-shaped connections
- Map values: 0 = floor, 1 = wall
- Rooms stored in `rooms` array with position and size

**Analysis Tasks:**
1. Verify all rooms are reachable from spawn
2. Check corridor widths allow player passage (player is 32x32)
3. Identify potential softlock scenarios
4. Analyze room distribution and spacing
5. Suggest parameters for difficulty progression

**Code Patterns:**
```gdscript
# Access map data
var cell = map[y][x]  # 0 = floor, 1 = wall

# Room structure
var room = {position: Vector2i, size: Vector2i}

# Spawn position
var spawn = dungeon_generator.get_spawn_position()
```
