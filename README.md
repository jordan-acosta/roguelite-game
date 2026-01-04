# Roguelite Game Prototype

A simple 2D roguelite game built with Godot Engine 4.3.

## Features

- **Player Movement**: WASD or Arrow keys to move
- **Procedural Dungeon Generation**: Random rooms and corridors generated each run
- **Player Stats**: Health system with UI display
- **Simple Graphics**: Colored rectangles for rapid prototyping
- **Web/HTML5 Export**: Play directly in your browser or on your phone!
- **GitHub Pages Ready**: Host your game online for free!

## Project Structure

```
roguelite-game/
├── scenes/          # Godot scene files (.tscn)
│   ├── main.tscn   # Main game scene
│   ├── player.tscn # Player character scene
│   └── ui.tscn     # User interface scene
├── scripts/         # GDScript files
│   ├── main.gd              # Main game logic
│   ├── player.gd            # Player controller and stats
│   ├── dungeon_generator.gd # Procedural dungeon generation
│   └── ui.gd                # UI controller
├── assets/          # Game assets
│   └── sprites/     # Sprite files (placeholder for now)
└── project.godot    # Godot project configuration
```

## How to Run

### Option 1: Play Online (GitHub Pages) - EASIEST!

**The game is hosted online!** Just visit:
```
https://YOUR_USERNAME.github.io/roguelite-game/
```

**To enable GitHub Pages:**
1. Go to your GitHub repo → Settings → Pages
2. Under "Source", select: **Deploy from a branch**
3. Under "Branch", select: **main** and **/docs**
4. Click **Save**
5. Wait a few minutes, then visit the URL above

Anyone can play your game without downloading anything!

### Option 2: Local Web Server (Test on Phone)

1. **Start the web server**:
   ```bash
   ./serve.sh
   ```

2. **On your computer**: Open `http://localhost:8000`

3. **On your phone**:
   - Make sure you're on the same WiFi network
   - Find your computer's IP address (`ip addr show` on Linux)
   - Open `http://YOUR_IP:8000` in your phone's browser
   - Example: `http://192.168.1.100:8000`

### Option 3: Godot Editor

1. **Open the project in Godot**:
   ```bash
   ./Godot_v4.3-stable_linux.x86_64 --path . --editor
   ```

2. **Press F5 to run**

## Controls

- **WASD** or **Arrow Keys**: Move player
- **Space/Enter**: Restart game with new dungeon

## Game Mechanics (Implemented)

- ✅ Player movement
- ✅ Procedural dungeon generation
- ✅ Health system
- ✅ UI display
- ✅ Camera following player
- ✅ Game restart
- ✅ HTML5/Web export for mobile testing

## Next Steps (Ideas for Expansion)

- Add enemies with simple AI
- Implement combat system
- Add items and inventory
- Create power-ups and upgrades
- Add different room types
- Implement permadeath and run progression
- Add sound effects and music
- Create particle effects
- Add more advanced procedural generation (BSP trees, cellular automata)
- Implement saving/loading (for meta-progression)

## Roguelite Core Features to Add

1. **Permadeath**: Already partially implemented (restart on death)
2. **Procedural Generation**: Basic implementation complete
3. **Meta-progression**: Not yet implemented
4. **Run-based gameplay**: Basic structure in place
5. **Random power-ups**: Not yet implemented

## Development Notes

This is a basic framework designed for rapid prototyping. The graphics are intentionally simple (colored rectangles) to focus on game mechanics. Replace the ColorRect nodes with Sprite2D nodes when you're ready to add actual art.

## License

Free to use and modify for learning and prototyping.
