# Interactive Whiteboard

A simple, collaborative real-time drawing web application built with Node.js and Socket.io. Multiple users can draw simultaneously on a shared HTML5 canvas, with all strokes instantly synchronized across connected clients.

![License](https://img.shields.io/badge/license-ISC-blue.svg)
![Socket.io](https://img.shields.io/badge/socket.io-4.8.1-green.svg)
![jQuery](https://img.shields.io/badge/jquery-3.7.1-blue.svg)

## Features

- **Real-time Collaboration**: Draw with multiple users simultaneously
- **WebSocket Communication**: Low-latency synchronization using Socket.io
- **HTML5 Canvas**: Smooth drawing experience with customizable stroke styles
- **Lightweight**: No complex build tools or frameworks
- **Easy Setup**: Get started with just a few commands

## Technology Stack

- **Backend**: Node.js with Socket.io v4.8.1
- **Frontend**: HTML5 Canvas, jQuery 3.7.1, jquery.event.drag-2.0
- **Real-time Communication**: WebSocket via Socket.io
- **Language**: JavaScript (compiled from CoffeeScript)

## Prerequisites

- Node.js (v14 or higher recommended)
- npm (comes with Node.js)
- A modern web browser with HTML5 Canvas support

## Installation

1. **Clone the repository:**
   ```bash
   git clone https://github.com/dandinu/interactive-whiteboard.git
   cd interactive-whiteboard
   ```

2. **Install server dependencies:**
   ```bash
   cd server
   npm install
   ```

## Usage

### Starting the Server

From the `server` directory:
```bash
npm start
```
Or directly:
```bash
node server.js
```

The server will start on port **4000**.

### Accessing the Application

1. Open `client/index.html` in your web browser
2. Start drawing on the canvas!
3. Open the same file in multiple browser windows/tabs to test collaboration
4. All connected clients will see drawing updates in real-time

## How It Works

### Architecture

The application uses a client-server architecture with WebSocket communication:

1. **Server** (`server/server.js`):
   - Listens for client connections on port 4000
   - Receives `drawClick` events from clients
   - Broadcasts `draw` events to all other connected clients
   - Stateless design (no drawing history persistence)

2. **Client** (`client/`):
   - HTML5 Canvas for rendering
   - jQuery for DOM manipulation and event handling
   - Socket.io client for real-time communication
   - Drag events trigger local drawing and emit coordinates to server

### Drawing Flow

```
User drags mouse → Canvas draws locally → Emit to server →
Server broadcasts → Other clients receive → Other clients draw
```

### Key Files

```
interactive-whiteboard/
├── server/
│   ├── server.js         # Main server (Socket.io)
│   ├── server.coffee     # CoffeeScript source
│   └── package.json      # Server dependencies
├── client/
│   ├── index.html        # Main HTML page
│   ├── scripts/
│   │   ├── app.js        # Client logic
│   │   └── jquery.event.drag-2.0.js
│   └── styles/
│       └── style.css     # Minimal styling
└── README.md
```

## Configuration

### Changing the Port

To use a different port, update:
- `server/server.js` (lines 5-10): Socket.io initialization
- `client/index.html` (line 7): Socket.io client connection URL

### CORS Settings

CORS is configured in `server/server.js` to allow all origins by default. For production, update the CORS configuration:

```javascript
io = require('socket.io')(4000, {
  cors: {
    origin: "https://yourdomain.com",  // Specify your domain
    methods: ["GET", "POST"]
  }
});
```

## Recent Updates (November 2025)

- ✅ **Socket.io**: Upgraded from v1.4.8 to v4.8.1
  - Added CORS configuration for v4 compatibility
  - Updated initialization syntax

- ✅ **jQuery**: Upgraded from v1.6.2 to v3.7.1
  - Replaced deprecated `.live()` with `.on()` event delegation
  - Modern event handling patterns

- ✅ All dependencies updated to latest stable versions
- ✅ Comprehensive testing completed

## Limitations

- **No Persistence**: Drawings are not saved; they only exist during the session
- **No Drawing History**: New clients joining see a blank canvas
- **Single Drawing Tool**: Fixed 5px blue stroke with round caps
- **No Undo/Redo**: No ability to reverse drawing actions

## Future Enhancements

Potential improvements for the project:
- Add drawing tools (pen, eraser, shapes)
- Implement color picker
- Add undo/redo functionality
- Persist drawings to a database
- Add user authentication
- Implement room/session management
- Export canvas as image

## License

This project is licensed under the ISC License - see the [LICENSE](LICENSE) file for details.

## Contributing

Contributions are welcome! Feel free to open issues or submit pull requests.

## Acknowledgments

- Built with [Socket.io](https://socket.io/)
- Uses [jQuery](https://jquery.com/) and [jquery.event.drag](http://threedubmedia.com/code/event/drag)