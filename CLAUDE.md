# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

A collaborative real-time drawing web application using Node.js and Socket.io. Users can draw on an HTML5 canvas, and their strokes are broadcast in real-time to all connected clients via WebSocket communication.

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
- Receives `drawClick` events from clients with coordinates and event type
- Broadcasts `draw` events to all other connected clients via `socket.broadcast.emit()`

**Client (`client/`):**
- Static HTML/CSS/JS served from filesystem (no web server needed)
- Entry point: `index.html`
- Main logic: `scripts/app.js`
- Uses jQuery 3.7.1 and jquery.event.drag-2.0.js for event handling
- Socket.io client v4.8.1 connects to server for real-time sync

### Real-Time Drawing Flow

1. User drags mouse on canvas → triggers jQuery drag events (`dragstart`, `drag`, `dragend`)
2. Client draws locally on canvas immediately
3. Client emits `drawClick` event to server with {x, y, type}
4. Server broadcasts `draw` event to all OTHER connected clients
5. Other clients receive `draw` event and render the stroke

### Canvas Implementation

- HTML5 Canvas API with 2D context
- Canvas sized to full viewport (`window.innerWidth` × `window.innerHeight`)
- Drawing state machine: `beginPath()` on dragstart → `lineTo()` + `stroke()` on drag → `closePath()` on dragend
- Fixed styling: 5px blue (#1376AF) stroke with round caps

## Code Organization

```
server/
├── server.js         # Main server (compiled from CoffeeScript)
├── server.coffee     # CoffeeScript source
└── package.json      # Dependencies and start script

client/
├── index.html        # HTML entry point
├── scripts/
│   ├── app.js        # Main client logic (compiled from CoffeeScript)
│   ├── app.coffee    # CoffeeScript source
│   └── jquery.event.drag-2.0.js  # jQuery drag plugin
└── styles/
    └── style.css     # Minimal styling
```

## Key Technical Details

- **Language:** Originally written in CoffeeScript, compiled to JavaScript (no build system in repo)
- **Dependencies:**
  - Server: `socket.io@^4.8.1`
  - Client: jQuery 3.7.1 (Google CDN), socket.io-client v4.8.1 (served from server)
- **Port:** Server hardcoded to port 4000 (both in server.js:5-10 and client/index.html:7)
- **jQuery Version:** 3.7.1 with modern `.on()` event delegation (client/scripts/app.js:44)
- **CORS:** Socket.io v4 requires explicit CORS configuration - currently set to allow all origins
- **No persistence:** Drawings are not saved; only live-streamed during active sessions

## Modifying the Application

When making changes:
- Server changes require restart: `npm start` in server/
- Client changes need browser refresh
- If changing port, update both `server/server.js` lines 5-10 and `client/index.html` line 7
- Socket.io event contracts: ensure client `emit('drawClick', ...)` matches server `on('drawClick', ...)` signatures
- CORS configuration can be adjusted in server initialization for production security

## Recent Updates (November 2025)

- **Socket.io**: Upgraded from v1.4.8 to v4.8.1
  - Added CORS configuration for compatibility with v4
  - Updated initialization syntax
- **jQuery**: Upgraded from v1.6.2 to v3.7.1
  - Replaced deprecated `.live()` with `.on()` event delegation
  - All event handling now uses modern jQuery patterns
