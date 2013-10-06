Leap = require("leapjs")
EventEmitter = require("events").EventEmitter;
child_process = require("child_process");
keyListener = require("./keyListener.coffee");
Math.nag = (num)->
    if num > 0
        return 1
    else if num < 0
        return -1
    else
        return 0
Math.point = (x,y)->
    if x instanceof Array
        return [x[0],x[1]]
    return [x,y]
Math.distance = (p1,p2)->
    return Math.sqrt(Math.distanceSquare(p1,p2))
Math.distanceSquare = (p1,p2)->
    return (p1[0]-p2[0])*(p1[0]-p2[0])+(p1[1]-p2[1])*(p1[1]-p2[1])
controller = new Leap.Controller();
controller.on "connect",()->
    console.log("connected") 
controller.on "deviceConnected",()->
    console.log "device connected"
controller.on "deviceDisconnected",()->
    console.log "device disconnected"
class VirtualPanel
    constructor:()->
        @maxHeight = 700
        @baseHeight = 220
        @minHeight = 50
        @horizentalCenter = 0
        @setup()
    setup:()->
        @rA = (@maxHeight-@minHeight)/2
        @rC = @rA-(@baseHeight-@minHeight)
        @rB = Math.sqrt(@rA*@rA-@rC*@rC)
        console.log @rB,"!!!!!!!"
        @r = @rA-@rC
    transformToO:(p)->
        p[1]-=@baseHeight
        return p
    eclipseFunc:(p)->
        return p[0]*p[0]/(@rB*@rB)+p[1]*p[1]/(@rA*@rA)
    pointToUnitRound:(p)->
        p = @transformToO(p)
        # make sure it's inside eclipse
        scale =  @eclipseFunc(p)
        if scale > 1
            p[0]/=Math.sqrt(scale)
            p[1]/=Math.sqrt(scale)
            scale = 1
        pClone = Math.point(p)
        # find shadow on eclipse
        pClone[0]/=Math.sqrt(scale)
        pClone[1]/=Math.sqrt(scale)
        distance1 = Math.distance(pClone,Math.point(0,0))
        ratio = 1/distance1
        p[0]*=ratio
        p[1]*=ratio
        return p
        
class LeapAdaptor extends EventEmitter
    constructor:()->
        @virtualPanel = new VirtualPanel()
        @mouse = require("./mouse.coffee")
        @v = [0,0]
        @maxSpeed = 100
        keyListener.on "key",(type,code,value)=>
            KeyChange = 1
            KeyPress = 0
            KeyDown = 1
            KeyUp = 0
            RightAlt = 100
            ScrollLock = 70
            RightKey = 119
            if type is KeyChange and code is ScrollLock
                if value is KeyDown
                    @mouse.mouseDownLeft()
                if value is KeyUp
                    @mouse.mouseUpLeft()
            if type is KeyChange and code is RightKey
                if value is KeyDown
                    @mouse.mouseDownRight()
                if value is KeyUp
                    @mouse.mouseUpRight()
            console.log type,code,value,'111111111111'
    onFrame:(frame)->
        if not @lastFrameDate
            @lastFrameDate = Date.now()
            return
        time = Date.now() - @lastFrameDate
        hand = frame.hands[0]
        position = hand.palmPosition
        p = @virtualPanel.pointToUnitRound([position[0],position[1]])
        @mouse.move @transform(p[0]),-@transform(p[1])
    transform:(v)->
        return Math.nag(v)*Math.pow(v,2)*@maxSpeed
    update:(position,velocity)->
adaptor = new LeapAdaptor()
lastId = null
controller.on "frame",(frame)->
    if not frame then return false
    if not frame.hands or not frame.hands.length  or frame.hands.length == 0
        return
    adaptor.onFrame(frame)
controller.connect()
xController = child_process.spawn("python",["xControllServer.py"])
xController.stdout.pipe process.stdout
xController.stderr.pipe process.stderr