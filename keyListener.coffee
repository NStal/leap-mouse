fs = require "fs"
jParser = require "jParser"
keyboardPath = "/dev/input/event2"
module.exports = new (require("events").EventEmitter);
stream = fs.createReadStream(keyboardPath)
stream.on "end",()->
    console.log "end"
stream.on "error",(err)->
    console.error err
stream.on "data",(data)->
    event = {
        event:{
            time:["array","int32",4]
            ,type:"int16"
            ,code:"int16"
            ,value:"int32"
        }
        ,keyEvent:"event"
    }
    parser = new jParser(data,event)
    event1 = parser.parse("event");
    event2 = parser.parse("event");
    module.exports.emit("key",event2.type,event2.code,event2.value)
    #console.log "event1 type:",event1.type,"code:",event1.code
    #console.log "event2 type:",event2.type,"code:",event2.code,"value:",event2.value

    #type = data.slice(16,18).readUInt16LE(0)
    #code = data.slice(18,20).readUInt16LE(0)
    #value = data.slice(20,24).readUInt16LE(0)
    #console.log "1:type #{type},code #{code},value #{value}"
    #data = data.slice(24,48)
    #type = data.slice(16,18).readUInt16LE(0)
    #code = data.slice(18,20).readUInt16LE(0)
    #value = data.slice(20,24).readUInt32LE(0)
    #console.log "2:type #{type},code #{code},value #{value}"
