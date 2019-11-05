-- From https://leafo.net/lua-enet/#tutorial
-- client.lua
require "enet"
local host = enet.host_create()
local server = host:connect("localhost:12345")
print('connect ')

local done = false
while not done do
  local event = host:service(100)
  print('event ', event)
  if event then
    if event.type == "connect" then
      print("Connected to", event.peer)
      event.peer:send("hello world")
    elseif event.type == "receive" then
      print("Got message: ", event.data, event.peer)
      done = true
    end
  end
end

server:disconnect()
host:flush()
