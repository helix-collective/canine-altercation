
print("server starting")

-- From https://leafo.net/lua-enet/#tutorial
-- server.lua
require "enet"
local host = enet.host_create("*:12345")

print("host created")

while true do
  local event = host:service(100)

  if event and event.type == "receive" then
    print("Got message: ", event.data, event.peer)
    event.peer:send(event.data)
  end

  print("....", event)
  
end


