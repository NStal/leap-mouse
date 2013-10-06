zmq = require "zmq"
socket = zmq.socket "req"
addr = "tcp://localhost:37729"
socket.connect(addr)
socket.on "message",(message)->
    #console.log "get res",message.toString()
exports.send = (action,data)->
    message = {action:action,data:data} 
    socket.send(JSON.stringify(message))