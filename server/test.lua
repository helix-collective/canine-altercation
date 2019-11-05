local enet = require "enet"
local host = enet.host_create("localhost:6789")

local socket = require("socket")
local udp = socket.udp()

udp:settimeout(0)
udp:setpeername("localhost", 12345)

local running = true

while running do
  
  udp:send("helloworld!!!")
  print("xx")

  local data = udp:receive()
  print(data)
  
  socket.sleep(1)
end

