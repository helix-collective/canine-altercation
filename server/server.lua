
print("server starting")
json = require('rxi-json-lua')

DEFAULT_TIMEOUT_SECS = 10

-- From https://leafo.net/lua-enet/#tutorial
-- server.lua
require "enet"
local host = enet.host_create("*:12345")

state = {}
state.objs = {}

while true do
  local tNow = os.time()
  local event = host:service(100)

  if event and event.type == "receive" then
    -- print("Got message: ", event.data, event.peer)
    statePart = json.decode(event.data)

    for id,val in pairs(statePart.objs) do
      state.objs[id] = val
    end

    for id,val in pairs(state.objs) do
      if (val.forgetAt ~= nil) then
        if (val.forgetAt < tNow) then
          state.objs[id] = nil
        end
      else
        val.forgetAt = tNow + DEFAULT_TIMEOUT_SECS
      end
    end

    event.peer:send(json.encode(state))
  end  
end


