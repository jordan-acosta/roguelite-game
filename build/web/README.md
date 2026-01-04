# Roguelite Game - Web Build

This is the HTML5/WebAssembly build of the roguelite game.

## How to Play on Your Phone

1. **Start the web server** (on your computer):
   ```bash
   cd ../..  # Go back to project root
   ./serve.sh
   ```

2. **Find your computer's IP address**:
   - Linux/Mac: `ip addr show | grep "inet "`
   - Windows: `ipconfig`
   - Look for something like `192.168.1.X` or `10.0.0.X`

3. **On your phone**:
   - Make sure your phone is on the same WiFi network
   - Open your web browser (Chrome, Safari, etc.)
   - Go to: `http://YOUR_COMPUTER_IP:8000`
   - Example: `http://192.168.1.100:8000`

4. **Play the game!**
   - Touch controls should work automatically
   - The game supports mobile browsers

## Controls

- **Desktop**: WASD or Arrow Keys to move
- **Mobile**: Touch/swipe to move (if you add touch controls)

## Files

- `index.html` - Main HTML file
- `index.wasm` - WebAssembly game engine
- `index.pck` - Game data package
- `index.js` - JavaScript loader

## Notes

- Requires a modern browser with WebAssembly support
- Works best on Chrome, Firefox, Safari, Edge
- May have performance differences from native builds
- Currently uses keyboard controls (touch controls can be added)
