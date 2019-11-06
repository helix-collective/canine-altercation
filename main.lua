socket = require('socket')
uuid = require('./util/uuid')
uuid.randomseed(socket.gettime()*10000)
json = require('./util/json')

require "camera"

function love.load()
  love.window.setMode(0, 0, {fullscreen=true, resizable=true, vsync=false})

  -- Game Constants
  anglePerDt = 5
  shipSpeedDt = 200
  arenaWidth = love.graphics.getWidth() * 2
  arenaHeight = love.graphics.getHeight() * 2
  maxSpeed = 500
  bulletSpeed = 1000
  shipRadius = 30
  scale = 1

  RELOAD_DELAY = 2 -- seconds

  CATEGORY_BULLET = 9
  NEXT_SHIP_CATEGORY = 10
  ASTEROIDS = 10
  ASTEROID_SPEED = 20

  thisQuad = love.graphics.newQuad(0,0,arenaWidth,arenaHeight,32,32)
  thisImage = love.graphics.newImage('assets/PNG/Sprites/Effects/spaceEffects_001.png')
  thisImage:setWrap('repeat','repeat')

    -- loading the sound effect files
    bulletSound = love.audio.newSource("assets/sound/pew.mp3", "static")
    shipZoomSound = love.audio.newSource("assets/sound/zoom.mp3", "static")
    shipZoomSound:setVolume(0.5)
    shipBreakSound = love.audio.newSource("assets/sound/spacebreaks.mp3", "static")
  -- Game State
  resetGameState()

  -- Networking
  enet = require("enet")
  host = enet.host_create()
  server = host:connect("localhost:12345")
  camera:setScale(scale, scale)
end

function newShip(ship_sprite, id)
    -- Ship death explosion

    local ship = {}
    ship.id = id
    ship.type = 'ship'
    -- place the body somewhere in the arena
    ship.body = love.physics.newBody(world, love.math.random(math.floor(shipRadius), math.floor(arenaWidth - shipRadius)), love.math.random(math.floor(shipRadius), math.floor(arenaHeight - shipRadius)), "dynamic")
    ship.body:setAngularDamping(1000)  --for colissions
    ship.shape = love.physics.newCircleShape(shipRadius)
    ship.fixture = love.physics.newFixture(ship.body, ship.shape, 1) -- Attach fixture to body and give it a density of 1.
    ship.fixture:setRestitution(0.1)  -- how objects bounce of each other. https://www.scienceabc.com/pure-sciences/coefficient-of-restitution-definition-explanation-and-formula.html
    ship.fixture:setUserData(ship)
    ship.fixture:setCategory(NEXT_SHIP_CATEGORY)
    NEXT_SHIP_CATEGORY = NEXT_SHIP_CATEGORY + 1
    ship.speed = 0
    ship.reload_delay = 0

    -- Ship death explosion
    local img = love.graphics.newImage('t1.png')
    ship.deathPsystem = love.graphics.newParticleSystem(img, 200)
    ship.deathPsystem:setParticleLifetime(1, 10)
    ship.deathPsystem:setEmissionRate(0)
    ship.deathPsystem:setSizeVariation(1)
    ship.deathPsystem:setSizes(0.1, 0.07, 0.05)
    ship.deathPsystem:setLinearAcceleration(-200, -200, 200, 200)

    ship.sprite = love.graphics.newImage(ship_sprite)
    return ship
end

function newBorderWall(pos)
    local wall = {}
    wall.type = 'wall'
    wall.pos = pos
    if pos == 'top' then
      wall.body = love.physics.newBody(world, arenaWidth / 2, 0, "static")
      wall.fixture = love.physics.newFixture(wall.body, love.physics.newRectangleShape(arenaWidth, 1))
    elseif pos == 'bottom' then
      wall.body = love.physics.newBody(world, arenaWidth / 2, arenaHeight, "static")
      wall.fixture = love.physics.newFixture(wall.body, love.physics.newRectangleShape(arenaWidth, 1))
    elseif pos == 'left' then
      wall.body = love.physics.newBody(world, 0, arenaHeight / 2, "static")
      wall.fixture = love.physics.newFixture(wall.body, love.physics.newRectangleShape(1, arenaHeight))
    elseif pos == 'right' then
      wall.body = love.physics.newBody(world, arenaWidth, arenaHeight / 2, "static")
      wall.fixture = love.physics.newFixture(wall.body, love.physics.newRectangleShape(1, arenaHeight))
    end

    wall.fixture:setRestitution(0.2)
    wall.fixture:setUserData(wall)

    return wall
end

function newAsteroid()
    local asteroid = {}
    asteroid.type = "asteroid"
    asteroid.body = love.physics.newBody(world, love.math.random(0, arenaWidth), love.math.random(0, arenaHeight), "dynamic")
    asteroid.sprite = love.graphics.newImage('assets/PNG/Sprites/Meteors/spaceMeteors_001.png')
    asteroid.size = love.math.randomNormal(0.15, 0.5)
    asteroid.body:setLinearVelocity(love.math.random(-ASTEROID_SPEED, ASTEROID_SPEED),
                                    love.math.random(-ASTEROID_SPEED, ASTEROID_SPEED))
    return asteroid
end

function resetGameState()
    -- Game State
    collisionText = ''

    -- Thruster
    thrustAnim = {}
    thrustAnim[1] = love.graphics.newImage('assets/PNG/Sprites/Effects/spaceEffects_001.png')
    thrustAnim[2] = love.graphics.newImage('assets/PNG/Sprites/Effects/spaceEffects_002.png')
    thrustAnim[3] = love.graphics.newImage('assets/PNG/Sprites/Effects/spaceEffects_003.png')
    thrustAnim[4] = love.graphics.newImage('assets/PNG/Sprites/Effects/spaceEffects_004.png')
    thrustWidth = thrustAnim[1]:getWidth()
    thrustHeight = thrustAnim[1]:getHeight()

    love.physics.setMeter(64)
    thrustCurrentTic = 0
    world = love.physics.newWorld(0, 0, arenaWidth, arenaHeight)
    world:setCallbacks(beginContact, endContact, preSolve, postSolve)

    -- table to hold all our physical objects
    objects = {}

    -- All ships (both current player, and others)
    objects.ships = {}
    objects.myShip = newShip("/assets/PNG/Sprites/Ships/spaceShips_009.png", uuid())
    table.insert(objects.ships, objects.myShip)

    -- Uncomment to add back in world borders (currently, world operates in wrap-around mode)
    -- objects.borders = {}
    -- objects.borders.top = newBorderWall('top')
    -- objects.borders.bottom = newBorderWall('bottom')
    -- objects.borders.left = newBorderWall('left')
    -- objects.borders.right = newBorderWall('right')

    -- Bullets in flight

    objects.asteroids = {}
    for i=1,ASTEROIDS do
        local asteroid = newAsteroid()
        table.insert(objects.asteroids, asteroid)
    end

    objects.bullets = {} -- list of bullets
end

function beginContact(a, b, coll)

    collisionText = a:getUserData().type..' with '..b:getUserData().type

    -- Find the ship that collided
    local colShip
    local colWall
    local colBullet

    if a:getUserData().type == 'ship' then
        colShip = a:getUserData()
    elseif b:getUserData().type == 'ship' then
        colShip = b:getUserData()
    end

    if a:getUserData().type == 'wall' then
        colWall = a:getUserData()
    elseif b:getUserData().type == 'wall' then
        colWall = b:getUserData()
    end

    if a:getUserData().type == 'bullet' then
        lBullet = a:getUserData()
    elseif b:getUserData().type == 'bullet' then
        colBullet = b:getUserData()
    end

    -- Seems like you can't update objects in callbacks (results in error)
    -- so just mark it and process next tic
    if (not (colWall == nil) and not (colBullet == nil)) then
        colBullet.dead = true -- remove a bullet when it hits the wall in the next tic
    elseif (not (colShip == nil) and not (colBullet == nil)) then
        -- If the ship isn't already dead, kick of the death animation
        if not (colShip.dead) then
            colShip.deathPsystem:reset()
            colShip.deathPsystem:emit(1000)
        end

        colBullet.dead = true
        colShip.dead = true
    end
end

function endContact(a, b, coll)
    --collisionText = ''
end

function preSolve(a, b, coll)
end

function postSolve(a, b, coll, normalimpulse, tangentimpulse)
end

function updateWorldObject(object)
    if object.body:getX() < 0 then
        object.body:setX(arenaWidth)
    elseif object.body:getX() > arenaWidth then
        object.body:setX(0)
    end
    if object.body:getY() < 0 then
        object.body:setY(arenaHeight)
    elseif object.body:getY() > arenaHeight then
        object.body:setY(0)
    end
end

function love.update(dt)
    world:update(dt)
    camera:setPosition(objects.myShip.body:getX() - (scale * love.graphics.getWidth() / 2), objects.myShip.body:getY() - (scale * love.graphics.getHeight() / 2))

    -- remove all dead bullets
    local deadBulletIds = {}
    for bulletId, bullet in pairs(objects.bullets) do
        updateWorldObject(bullet)
        if (bullet.dead) then
            bullet.body:destroy()
            table.insert(deadBulletIds, bulletIndex)
        end
    end

    for i, deadBulletId in pairs(deadBulletIds) do
      objects.bullets[deadBulletIndex] = nil
    end

    -- update ship angle
    if love.keyboard.isDown('right') then
        objects.myShip.body:setAngle(objects.myShip.body:getAngle() + anglePerDt * dt)
    elseif love.keyboard.isDown('left') then
        objects.myShip.body:setAngle(objects.myShip.body:getAngle() - anglePerDt * dt)
    end

    -- Accelerate
    if love.keyboard.isDown('up') then
        objects.myShip.speed = objects.myShip.speed + math.max(0, maxSpeed - objects.myShip.speed) * dt
        shipZoomSound:play()
    elseif love.keyboard.isDown('down') then
        objects.myShip.speed = objects.myShip.speed + math.min(0, -maxSpeed - objects.myShip.speed) * dt
        shipBreakSound:play()
    end

    -- Update reload Delay
    objects.myShip.reload_delay = objects.myShip.reload_delay - dt

    for shipId, ship in pairs(objects.ships) do
        if ship.dead then
          -- Do the death animation
          ship.deathPsystem:update(dt)

          -- Hack, removing a ship entirely is hard, so instead we set set it's speed to 0,
          -- and change it to a sensor, which will stop any collision responses.
          -- https://love2d.org/wiki/Fixture:setSensor
          ship.fixture:setSensor(true)
          ship.speed = 0
        end

        -- update velocity of all ships based on current state. We do this per tick as opposed to using the physics engine so we can control the gameplay
        -- as ships don't move in 'real world' physics
        ship.body:setLinearVelocity(math.cos(ship.body:getAngle()) * ship.speed,
                                    math.sin(ship.body:getAngle()) * ship.speed)
        updateWorldObject(ship)
    end

    for asteroidIndex, asteroid in ipairs(objects.ships) do
        updateWorldObject(asteroid)
    end

    networkSendTic()
end

function shipToJson(state, ship)
    local obj = {}
    obj.dead = not(not(ship.dead))
    if not(ship.dead) then
        obj.type = 'ship'
        obj.pos = {}
        obj.pos.x = ship.body:getX()
        obj.pos.y = ship.body:getY()
        obj.angle = ship.body:getAngle()
        obj.speed = ship.shipSpeed
    end
    state.objs[ship.id] = obj
end

function jsonToShips(state)
    local myShipId = objects.myShip.id
    
    for id,obj in pairs(state.objs) do
        if (obj.type == 'ship' and id ~= myShipId) then
            -- test if its in objects already
            local otherShip = objects.ships[id]
            if otherShip == nil then
                -- if not create it
                otherShip = newShip("/assets/PNG/Sprites/Ships/spaceShips_004.png", id)
                objects.ships[id] = otherShip
            end

            -- update
            otherShip.body:setX(obj.pos.x)
            otherShip.body:setY(obj.pos.y)
            otherShip.body:setAngle(obj.angle)
            otherShip.shipSpeed = obj.speed
        end
    end

end


function bulletToJson(state, bullet)
    local obj = {}
    obj.dead = not(not(bullet.dead))
    if (not bullet.dead) then
        obj.type = 'bullet'
        obj.pos = {}
        obj.vel = {}
        obj.pos.x = bullet.body:getX()
        obj.pos.y = bullet.body:getY()
        obj.vel.x, obj.vel.y = bullet.body:getLinearVelocity()
    end
    state.bullets[bullet.id] = obj
end

function networkSendTic()
    local event = host:service(0)

    local state = {}
    state.objs = {}

    shipToJson(state, objects.myShip)


    -- todo: deal with bullet dead -> no bullet in object state!
    --for bulletIndex, bullet in ipairs(objects.bullets) do
    --    bulletToJson(state, bullet)
    --end

    local stateJsonStr = json.encode(state)
    
    --local msg = string.format("%s %s $", objects.localShips[1].body:getX(), objects.localShips[1].body:getY())
    --udp:send(msg)
    if(event) then
      event.peer:send(stateJsonStr)

      if event.type == "connect" then
        print("Connected to", event.peer)  
      elseif event.type == "receive" then
        print("rx...", event.data)   
        stateIn = json.decode(event.data)

        jsonToShips(stateIn)
      end
    end
end

function love.keypressed(key)
    if objects.myShip.reload_delay < 0 and not(objects.myShip.dead) and key == "space" then
        local newBullet = {}
        newBullet.body = love.physics.newBody(world,
                                objects.myShip.body:getX() + math.cos(objects.myShip.body:getAngle()) * shipRadius,
                                objects.myShip.body:getY() + math.sin(objects.myShip.body:getAngle()) * shipRadius,
                                "dynamic")
        newBullet.body:setLinearVelocity(math.cos(objects.myShip.body:getAngle()) * bulletSpeed,
                                         math.sin(objects.myShip.body:getAngle()) * bulletSpeed)
        newBullet.body:setAngle(objects.myShip.body:getAngle())
        newBullet.id = uuid()
        newBullet.id = uuid()
        newBullet.shape = love.physics.newCircleShape(5)
        newBullet.sprite = love.graphics.newImage("/assets/PNG/Sprites/Missiles/spaceMissiles_001.png")
        newBullet.fixture = love.physics.newFixture(newBullet.body, newBullet.shape, 1)
        newBullet.fixture:setRestitution(0.1)
        newBullet.fixture:setCategory(CATEGORY_BULLET, objects.myShip.fixture:getCategory())
        newBullet.fixture:setMask(CATEGORY_BULLET, objects.myShip.fixture:getCategory())
        newBullet.fixture:setUserData(newBullet)
        newBullet.type = 'bullet'
        newBullet.id = uuid()

        objects.bullets[newBullet.id] = newBullet
        bulletSound:play()
        objects.myShip.reload_delay = RELOAD_DELAY
    end

    if key == 'r' then
      resetGameState()
    end

    if key == 'q' then
        love.event.quit()
    end
end

-- Low level sprite duplication helper
function drawInWorld(drawable, x, y, r, sx, sy, ox, oy)
    for i=-1,1 do
        for j=-1,1 do
            love.graphics.draw(drawable, x + i * arenaWidth, y + j * arenaHeight, r, sx, sy, ox, oy)
        end
    end
end

function drawShips()
    for shipId, ship in pairs(objects.ships) do
        if not(ship.dead) then
            love.graphics.setShader(ship.shader)
            drawInWorld(ship.sprite, ship.body:getX(), ship.body:getY(), ship.body:getAngle() - math.pi/2, 0.75, 0.75, ship.sprite:getWidth()/2, ship.sprite:getHeight()/2)
            love.graphics.setShader()
        end
    end
end

function drawBullets()
    -- Once a bullet is an image, we can use the "drawInWorld" function
    for bulletId, bullet in pairs(objects.bullets) do
        drawInWorld(bullet.sprite, bullet.body:getX(), bullet.body:getY(), bullet.body:getAngle() + math.pi/2, 0.75, 0.75, bullet.sprite:getWidth()/2, bullet.sprite:getHeight()/2)
    end
end

function drawAsteroids()
    for asteroidIndex, asteroid in ipairs(objects.asteroids) do
        drawInWorld(asteroid.sprite, asteroid.body:getX(), asteroid.body:getY(), 0, asteroid.size, asteroid.size, asteroid.sprite:getWidth()/2, asteroid.sprite:getHeight()/2)
    end
end

-- Draw in game objects, to be duplicated for wraparound
function drawWorld()
    -- draw the ship
    drawAsteroids()
    drawShips()
    drawBullets()

    -- Thruster TODO(jeeva): Move into draw ship?
    thrustCurrentTic = thrustCurrentTic + 1
    if thrustCurrentTic > 15 then
        thrustCurrentTic = 0
    end
    local thrustCurrentFrame = math.floor(thrustCurrentTic / 5) + 1
    for shipId, ship in pairs(objects.ships) do
        local thrustX = ship.body:getX() - ship.shape:getRadius() * math.cos(ship.body:getAngle())
        local thrustY = ship.body:getY() - ship.shape:getRadius() * math.sin(ship.body:getAngle())

        if ship.speed > 0 and not(ship.dead) then
            local thrustScale = ship.speed / maxSpeed * 3
            love.graphics.draw(thrustAnim[thrustCurrentFrame], thrustX, thrustY, ship.body:getAngle() + math.pi / 2, thrustScale, thrustScale, thrustWidth / 2, thrustHeight / 2)
        end

        -- If ship is dead, spend a few tics drawing particles
        if (ship.dead) then
            drawInWorld(ship.deathPsystem, ship.body:getX(), ship.body:getY())
        end
    end

    -- Game over text if a ship is dead
    local numAliveShips = 0
    local aliveShipId = nil
    for shipId, ship in pairs(objects.ships) do
        if not(ship.dead) then
            numAliveShips = numAliveShips + 1
            aliveShipId = shipId
        end
    end

    local winMessage
    if numAliveShips == 1 then
        winMessage = 'Player '..aliveShipId..' wins!'
    elseif numAliveShips == 0 then
        winMessage = 'Nobody wins!'
    end

    if not(winMessage == nil) then
        local prevFont = love.graphics.getFont()
        local winFont = love.graphics.newFont(50)
        love.graphics.setFont(winFont)
        love.graphics.print(winMessage, arenaWidth / 2 - winFont:getWidth(winMessage) / 2,
                                        arenaHeight / 2 - winFont:getHeight() / 2)
        love.graphics.setFont(prevFont)
    end
end


function love.draw()
    -- Debug
    love.graphics.setColor(1, 1, 1)
    love.graphics.print(table.concat({
        'shipAngle: '..objects.myShip.body:getAngle(),
        'shipX: '..objects.myShip.body:getX(),
        'shipY: '..objects.myShip.body:getY(),
        'reloadDelay: '..objects.myShip.reload_delay,
        'shipSpeed: '..objects.myShip.speed,
        'collision: '..collisionText
    }, '\n'))

    camera:set()
    -- love.graphics.draw(thisImage,thisQuad,0,0)
    drawWorld()
    camera:unset()
end
