zmq = require "./zmq.coffee"
mouse = {x:0,y:0,down:false}
exports.move = (x,y)->
    mouse.x += x
    mouse.y += y 
    moveX = Math.nag(mouse.x)*Math.floor(Math.abs(mouse.x))
    moveY = Math.nag(mouse.y)*Math.floor(Math.abs(mouse.y)) 
    #console.log "move",mouse,moveX,moveY
    mouse.x -= moveX
    mouse.y -= moveY
    if moveX is 0 and moveY is 0
        return
    zmq.send "move",{x:moveX,y:moveY}
exports.warp = (x,y)-> 
    moveX = Math.nag(mouse.x)*Math.abs(mouse.x)-Math.floor(Math.abs(mouse.x))
    moveY = Math.nag(mouse.y)*Math.abs(mouse.y)-Math.floor(Math.abs(mouse.y)) 
    mouse.x -= moveX
    mouse.y -= moveY
    
    if moveX is 0 and moveY is 0
        return
    zmq.send "warp",{x:parseInt(x),y:parseInt(y)} 
exports.mouseDownRight = ()->
    if mouse.down
        return
    mouse.down = true
    zmq.send "mouseDownRight",{}
exports.mouseUpRight = ()->
    if not mouse.down
        return
    mouse.down = false
    zmq.send "mouseUpRight",{}
exports.mouseDownLeft = ()->
    if mouse.down
        return
    mouse.down = true
    zmq.send "mouseDownLeft",{}
exports.mouseUpLeft = ()->
    if not mouse.down
        return
    mouse.down = false
    zmq.send "mouseUpLeft",{}
