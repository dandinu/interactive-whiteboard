# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

A collaborative real-time drawing web application using Node.js and Socket.io. Users can draw on an HTML5 canvas with customizable colors and brush sizes, and their strokes are broadcast in real-time to all connected clients via WebSocket communication.

## Development Commands

**Server Setup:**
```bash
cd server
npm install                    # Install dependencies (socket.io)
npm start                      # Start server on port 4000
# or: node server.js
```

**Client Access:**
- Open `client/index.html` in a web browser
- Client connects to `http://localhost:4000` for Socket.io communication
- For multi-user testing, open multiple browser windows/tabs

**Note:** No build tools, linters, or test frameworks are configured. The project uses pre-compiled JavaScript files.

## Architecture

### Client-Server Model

**Server (`server/server.js`):**
- Node.js server using Socket.io v4.8.1
- Listens on port 4000
- **Stateless** - does not maintain drawing history
- CORS enabled for all origins (configurable in server initialization)
- Receives `drawClick` events from clients with coordinates, event type, color, and lineWidth
- Broadcasts `draw` events to all other connected clients via `socket.broadcast.emit()`

**Client (`client/`):**
- Static HTML/CSS/JS served from filesystem (no web server needed)
- Entry point: `index.html`
- Main logic: `scripts/app.js`
- Uses jQuery 3.7.1 for event handling
- Socket.io client v4.8.1 connects to server for real-time sync

### Real-Time Drawing Flow

1. User drags mouse on canvas → triggers mousedown/mousemove/mouseup events
2. Client draws locally on canvas immediately with user's selected color/size
3. Client emits `drawClick` event to server with `{x, y, type, color, lineWidth}`
4. Server broadcasts `draw` event to all OTHER connected clients
5. Other clients receive `draw` event and render the stroke with the sender's color/size

### Socket.io Event Contract

```javascript
// Client emits:
socket.emit('drawClick', {
  x: number,           // X coordinate
  y: number,           // Y coordinate
  type: string,        // 'dragstart' | 'drag' | 'dragend'
  color: string,       // Hex color, e.g. '#FF5733'
  lineWidth: number    // Brush size in pixels
});

// Server broadcasts to other clients:
socket.broadcast.emit('draw', {
  x: number,
  y: number,
  type: string,
  color: string,       // Defaults to '#1376AF' if not provided
  lineWidth: number    // Defaults to 5 if not provided
});
```

### Canvas Implementation

- HTML5 Canvas API with 2D context
- Canvas sized to viewport minus toolbar height (`window.innerWidth` × `window.innerHeight - 60`)
- Drawing state machine: `beginPath()` on dragstart → `lineTo()` + `stroke()` on drag → `closePath()` on dragend
- User-selectable colors and brush sizes via toolbar

### Toolbar UI (`client/index.html`, `client/styles/style.css`)

- Fixed bottom toolbar (60px height)
- **Color palette**: 10 preset colors (blue, black, white, red, green, bright blue, yellow, magenta, cyan, gray)
- **Brush size**: 4 preset buttons (S=2px, M=5px, L=10px, XL=20px) plus slider (1-30px)
- **Preview dot**: Shows current brush color and size

## Code Organization

```
server/
├── server.js         # Main server (compiled from CoffeeScript)
├── server.coffee     # CoffeeScript source (outdated)
└── package.json      # Dependencies and start script

client/
├── index.html        # HTML entry point with toolbar
├── scripts/
│   ├── app.js        # Main client logic with toolbar handlers
│   └── app.coffee    # CoffeeScript source (outdated)
└── styles/
    └── style.css     # Toolbar and canvas styling
```

## Key Technical Details

- **Language:** Originally written in CoffeeScript, now maintained as JavaScript
- **Dependencies:**
  - Server: `socket.io@^4.8.1`
  - Client: jQuery 3.7.1 (Google CDN), socket.io-client v4.8.1 (served from server)
- **Port:** Server hardcoded to port 4000 (both in server.js:5-10 and client/index.html:6)
- **CORS:** Socket.io v4 requires explicit CORS configuration - currently set to allow all origins
- **No persistence:** Drawings are not saved; only live-streamed during active sessions

## Modifying the Application

When making changes:
- Server changes require restart: `npm start` in server/
- Client changes need browser refresh
- If changing port, update both `server/server.js` lines 5-10 and `client/index.html` line 6
- Socket.io event contracts: ensure client `emit('drawClick', ...)` matches server `on('drawClick', ...)` signatures
- CORS configuration can be adjusted in server initialization for production security
- Adding new drawing tools: update toolbar HTML, add CSS, handle events in `App.initToolbar()`

## Key Functions in app.js

- `App.init()` - Initializes canvas, socket connection, toolbar
- `App.draw(x, y, type, color, lineWidth)` - Renders strokes (local and remote)
- `App.initToolbar()` - Sets up color/size button handlers
- `App.setColor(color)` / `App.setSize(size)` - Update brush settings
- `App.updatePreview()` - Updates the preview dot in toolbar
