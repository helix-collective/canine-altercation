
print("server starting")
json = require('rxi-json-lua')

-- From https://leafo.net/lua-enet/#tutorial
-- server.lua
require "enet"
local host = enet.host_create("*:12345")

state = {}
state.ships = {}
state.bullets = {}

while true do
  local event = host:service(100)

  if event and event.type == "receive" then
    -- print("Got message: ", event.data, event.peer)
    statePart = json.decode(event.data)

    for id,val in pairs(statePart.ships) do state.ships[id] = val end
    for id,val in pairs(statePart.bullets) do state.bullets[id] = val end

    event.peer:send(json.encode(state))
  end

  -- print("....", event)
  
end


