io = require('socket.io')(4000, {
	cors: {
		origin: "*"
		methods: ["GET", "POST"]
	}
})

io.sockets.on 'connection', (socket) ->
	socket.on 'drawClick', (data) ->
		socket.broadcast.emit 'draw',{ x : data.x, y : data.y, type: data.type}
		return
	return