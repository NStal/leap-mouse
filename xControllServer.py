import mouse
import zmq
import json
context = zmq.Context()
socket = context.socket(zmq.REP)
socket.bind("tcp://127.0.0.1:37729")
while True:
    msg = socket.recv()
    try:
        data = json.loads(str(msg))
    except Exception:
        socket.send("{state:false}");
        continue
    if not data.has_key("action"):
        socket.send("{state:false}")
        continue
    action = data["action"]
    detail = data["data"]
    if action == "warp": 
        print "warp",int(detail["x"]),int(detail["y"])
        mouse.warp(int(detail["x"]),int(detail["y"]))
    elif action == "move":
        print "move",int(detail["x"]),int(detail["y"])
        mouse.move(int(detail["x"]),int(detail["y"]))
    elif action == "mouseDownLeft": 
        print "mouseDownLeft"
        mouse.mouseDown()
    elif action == "mouseUpLeft":
        print "mouseUpLeft"
        mouse.mouseUp()
    elif action == "mouseDownRight": 
        print "mouseDownRight"
        mouse.mouseDown(3)
    elif action == "mouseUpRight":
        print "mouseUpRight"
        mouse.mouseUp(3)
    else:
        print "unknown request",data
        socket.send("{state:false}")
        continue


    
    socket.send("{state:true}")
    


