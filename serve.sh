#!/bin/bash
# Simple web server for testing the HTML5 build

cd build/web
echo "Starting web server on port 8000..."
echo "Access the game at: http://localhost:8000"
echo "Or from your phone using your computer's IP address"
echo ""
echo "To find your IP address:"
echo "  - Linux/Mac: ip addr show | grep inet"
echo "  - Windows: ipconfig"
echo ""
echo "Then open: http://YOUR_IP:8000 on your phone"
echo ""
python3 -m http.server 8000
