
local server = "modbus.lewei50.com"
if(_G['server']~=nil)then server = _G['server'] end
--local server = "114.55.54.60"
local serverPort = 9970
if(_G['serverPort']~=nil)then serverPort = _G['serverPort'] end
local socket = nil
local retryCount = 0
local bConnected = false
rcv = ""
if (baudRate == nil) then baudRate = 9600 end

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
          tmr.stop(1)
          bConnected = true
          retryCount = 0
          if(regCode ~=nil)then
               sendData(regCode)
          end
          uart.setup(0, baudRate, 8, uart.PARITY_NONE, uart.STOPBITS_1, 1)
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
     			bConnected = false
          tmr.alarm(1, 5000, tmr.ALARM_AUTO, function()
          --if(server ~=nil and serverPort ~= nil) then
          if(bConnected == false) then
          	connectSvr(server,serverPort)
          else
          	tmr.stop(1)
          end
          --end
          end)
          socket = nil
     end)
end

connectSvr(server,serverPort)
