local socket = require "socket"
local udp = socket.udp()

local enet = require "enet"
local host = enet.host_create("localhost:6789")

udp:settimeout(1)
udp:setsockname('*', 12345)
local running = true

print "Beginning server loop."
while running do
  data, msg_or_ip, port_or_nil = udp:receivefrom()
  print("data:", data)
  --print("msg_or_ip:", msg_or_ip)
  --print("port_or_nil:", port_or_nil)

  if (msg_or_ip and port_or_nil) then
    udp:sendto("foooo!", msg_or_ip, port_or_nil)
  end

  socket.sleep(0.01)
end

