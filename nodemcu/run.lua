
local server = "modbus.lewei50.com"
--local server = "192.168.0.5"
local serverPort = 9970
local socket = nil
local retryCount = 0
rcv = ""
if (bps == nil) then bps = 9600 end

function sendData(data)
     if(socket ~= nil) then
          socket:send(data)
     end
end
function resolveData(data)
     sendData(data)
end


function connectSvr(svr,port)
     retryCount = retryCount + 1
     if(retryCount > 100)then node.restart() end
     print("try "..retryCount .. " times")
     server = svr
     serverPort = port
     --print("\nconnecting to "..server..":"..serverPort)
     socket = net.createConnection(net.TCP, 0)
     socket:on("receive", function(sck, c) 
          uart.write(0,c)
     end)
     socket:connect(port,svr)
     socket:on("connection", function(sck, c)
          retryCount = 0
          if(regPacket ~=nil)then
               sendData(regPacket)
          end
          uart.setup(0, bps, 8, uart.PARITY_NONE, uart.STOPBITS_1, 1)
          uart.on("data", 0,
            function(data)
               tmr.register(0, 50, tmr.ALARM_SINGLE, function()
               resolveData(rcv)
               rcv = ""
               end)
               rcv = rcv..data
               tmr.start(0)
          end, 0)

     end)
     socket:on("disconnection",function(sck, c)
          tmr.alarm(1, 5000, tmr.ALARM_SINGLE, function()
          --if(server ~=nil and serverPort ~= nil) then
          connectSvr(server,serverPort)
          --end
          end)
          socket = nil
     end)
end

connectSvr(server,serverPort)
