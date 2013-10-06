Leap = require("leapjs")
EventEmitter = require("events").EventEmitter;
child_process = require("child_process");
controller = new Leap.Controller({enableGestures:true});
controller.on "connect",()->
    console.log("connected") 
controller.on "deviceConnected",()->
    console.log "device connected"
controller.on "deviceDisconnected",()->
    console.log "device disconnected"

controller.on "frame",(frame)->
    if not frame then return false
    if not frame.hands or not frame.hands.length  or frame.hands.length == 0
        return
    hand = frame.hands[0]
    position = frame.hands[0].palmPosition
    console.log position 
    #console.log "position",position
    #console.log "tan^2",((position[0]*position[0])+(position[2]*position[2]))/(position[1]*position[1])
    #console.log "velocity",frame.hands[0].palmVelocity
controller.connect()
