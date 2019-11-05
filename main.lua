
require "camera"

function love.load()
  love.window.setMode(0, 0, {fullscreen=true, resizable=true, vsync=false})
  
  -- Game Constants
  anglePerDt = 5
  shipSpeedDt = 200
  arenaWidth = love.graphics.getWidth() * 1
  arenaHeight = love.graphics.getHeight() * 1
  maxSpeed = 500
  bulletSpeed = 1000
  shipRadius = 30

  CATEGORY_BULLET = 9
  SHIP_CATEGORY_BASE = 10


  thisQuad = love.graphics.newQuad(0,0,arenaWidth,arenaHeight,32,32)
  thisImage = love.graphics.newImage('assets/PNG/Sprites/Effects/spaceEffects_001.png')
  thisImage:setWrap('repeat','repeat')
  PLANETS = 20

  -- Game State
  resetGameState()
end

function resetGameState()
        -- Game State
    collisionText = ''

    local img = love.graphics.newImage('t1.png')

    -- Ship death explosion
    local deathPsystem = love.graphics.newParticleSystem(img, 200)
    deathPsystem:setParticleLifetime(1, 100)
    deathPsystem:setEmissionRate(0)
    deathPsystem:setSizeVariation(1)
    deathPsystem:setSizes(0.1, 0.07, 0.05)
    deathPsystem:setLinearAcceleration(-200, -200, 200, 200)

    thrustAnim = {}
    thrustAnim[1] = love.graphics.newImage('assets/PNG/Sprites/Effects/spaceEffects_001.png')
    thrustAnim[2] = love.graphics.newImage('assets/PNG/Sprites/Effects/spaceEffects_002.png')
    thrustAnim[3] = love.graphics.newImage('assets/PNG/Sprites/Effects/spaceEffects_003.png')
    thrustAnim[4] = love.graphics.newImage('assets/PNG/Sprites/Effects/spaceEffects_004.png')
    thrustCurrentTic = 0
    thrustWidth = thrustAnim[1]:getWidth()
    thrustHeight = thrustAnim[1]:getHeight()

    effect = love.graphics.newShader[[
    extern vec4 tint;
    extern number strength;
    vec4 effect(vec4 color, Image texture, vec2 tc, vec2 _) {
      color = Texel(texture, tc);
      number luma = dot(vec3(0.299f, 0.587f, 0.114f), color.rgb);
      return mix(color, tint * luma, strength);
    }]]
    effect:send("tint", {
        0.0, 1, 1, 1
    })
    effect:send("strength", 0.4)

    love.physics.setMeter(64)
    world = love.physics.newWorld(0, 0, arenaWidth, arenaHeight)
    world:setCallbacks(beginContact, endContact, preSolve, postSolve)

    objects = {} -- table to hold all our physical objects
    objects.ships = {}
    local ship1 = {}
    ship1.type = 'ship'
    ship1.body = love.physics.newBody(world, arenaWidth / 4, arenaHeight / 4, "dynamic") --place the body in the center of the world and make it dynamic, so it can move around
    ship1.body:setAngularDamping(1000)  --for colissions
    ship1.shape = love.physics.newCircleShape(shipRadius)
    ship1.fixture = love.physics.newFixture(ship1.body, ship1.shape, 1) -- Attach fixture to body and give it a density of 1.
    ship1.fixture:setRestitution(0.1) 
    ship1.fixture:setUserData(ship1)
    ship1.fixture:setCategory(SHIP_CATEGORY_BASE + 1)
    ship1.shipSpeed = 0
    ship1.rate_limited = 0
    ship1.deathPsystem = deathPsystem:clone()
    ship1.sprite = love.graphics.newImage("/assets/PNG/Sprites/Ships/spaceShips_009.png")
    table.insert(objects.ships, ship1)

    objects.planets = {}
    for i=1,PLANETS,1 do
        local planet = {}
        planet.body = love.physics.newBody(world, love.math.random(arenaWidth), love.math.random(arenaHeight), "static") --place the body in the center of the world and make it dynamic, so it can move around
        planet.sprite = love.graphics.newImage("/assets/PNG/Sprites/Meteors/spaceMeteors_001.png")
        table.insert(objects.planets, planet)
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
        colBullet.dead = true
        if not (colShip.dead) then
            colShip.deathPsystem:reset()
        end
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

function love.update(dt)
    
    world:update(dt)
    camera:setPosition(objects.ships[1].body:getX() - (arenaWidth / 2), objects.ships[1].body:getY() - (arenaHeight / 2))

    -- remove any bullets that have hit a wall
    for bulletIndex, bullet in ipairs(objects.bullets) do
        if (bullet.dead) then
            table.remove(objects.bullets, bulletIndex)
        end
    end

    -- update ship angle
    if love.keyboard.isDown('right') then
        objects.ships[1].body:setAngle(objects.ships[1].body:getAngle() + anglePerDt * dt)
    elseif love.keyboard.isDown('left') then
        objects.ships[1].body:setAngle(objects.ships[1].body:getAngle() - anglePerDt * dt)
    end
    

    -- Accelerate ships
    if love.keyboard.isDown('up') then
        objects.ships[1].shipSpeed = objects.ships[1].shipSpeed + math.max(0, maxSpeed - objects.ships[1].shipSpeed) * dt
    elseif love.keyboard.isDown('down') then
        objects.ships[1].shipSpeed = objects.ships[1].shipSpeed + math.min(0, -maxSpeed - objects.ships[1].shipSpeed) * dt
    end

    -- If a ship is dead it can no longer move
    for shipIndex, ship in ipairs(objects.ships) do
        if ship.dead then
            ship.shipSpeed = 0
        end
        ship.rate_limited = ship.rate_limited - 1
    end

    for shipIndex, ship in ipairs(objects.ships) do
        ship.body:setLinearVelocity(math.cos(ship.body:getAngle()) * ship.shipSpeed,
                                    math.sin(ship.body:getAngle()) * ship.shipSpeed)
        if ship.body:getX() < 0 then
            ship.body:setX(arenaWidth)
        elseif ship.body:getX() > arenaWidth then
            ship.body:setX(0)
        end
        if ship.body:getY() < 0 then
            ship.body:setY(arenaHeight)
        elseif ship.body:getY() > arenaHeight then
            ship.body:setY(0)
        end
    end

    for shipIndex, ship in ipairs(objects.ships) do
        if ship.dead and not(ship.deadAnimationDone) then
            ship.deadAnimationDone = true
            ship.deathPsystem:emit(1000)
        end

        ship.deathPsystem:update(dt)
    end
end

function love.keypressed(key)
    if objects.ships[1].rate_limited < 0 and not(objects.ships[1].dead) and key == "space" then
        local newBullet = {}
        newBullet.body = love.physics.newBody(world, 
                                objects.ships[1].body:getX() + math.cos(objects.ships[1].body:getAngle()) * shipRadius,
                                objects.ships[1].body:getY() + math.sin(objects.ships[1].body:getAngle()) * shipRadius, 
                                "dynamic")
        newBullet.body:setLinearVelocity(math.cos(objects.ships[1].body:getAngle()) * bulletSpeed, 
                                         math.sin(objects.ships[1].body:getAngle()) * bulletSpeed)
        newBullet.shape = love.physics.newCircleShape(5)
        newBullet.fixture = love.physics.newFixture(newBullet.body, newBullet.shape, 1)
        newBullet.fixture:setRestitution(0.1)
        newBullet.fixture:setCategory(CATEGORY_BULLET, SHIP_CATEGORY_BASE + 1)
        newBullet.fixture:setMask(CATEGORY_BULLET, SHIP_CATEGORY_BASE + 1)
        newBullet.fixture:setUserData(newBullet) 
        newBullet.type = 'bullet'
        
        table.insert(objects.bullets, newBullet)
        objects.ships[1].rate_limited = 1000
    end

    if key == 'r' then 
      resetGameState()
    end
end

function love.draw()
    -- Debug
    love.graphics.setColor(1, 1, 1)
    love.graphics.print(table.concat({
        'shipAngle: '..objects.ships[1].body:getAngle(),
        'shipX: '..objects.ships[1].body:getX(),
        'shipY: '..objects.ships[1].body:getY(),
        'shipSpeed: '..objects.ships[1].shipSpeed,
        'collision: '..collisionText
    }, '\n'))

    camera:set()
    for i=-1,1 do
        for j=-1,1 do
            love.graphics.draw(thisImage,thisQuad,0,0)
            for planetIndex, planet in ipairs(objects.planets) do
                love.graphics.draw(planet.sprite, planet.body:getX() + j * arenaWidth, planet.body:getY() + i * arenaHeight, planet.body:getAngle() - math.pi/2, 0.75, 0.75, planet.sprite:getWidth()/2, planet.sprite:getHeight()/2)
            end
            -- draw the ship
            for shipIndex, ship in ipairs(objects.ships) do
                if not(ship.dead) then
                    love.graphics.setShader(ship.shader)
                    love.graphics.draw(ship.sprite, ship.body:getX() + j * arenaWidth, ship.body:getY() + i * arenaHeight, ship.body:getAngle() - math.pi/2, 0.75, 0.75, ship.sprite:getWidth()/2, ship.sprite:getHeight()/2)
                    love.graphics.setShader()
                end
            end

            for bulletIndex, bullet in ipairs(objects.bullets) do
                love.graphics.setColor(0, 1, 0)
                love.graphics.circle('fill', bullet.body:getX() + j * arenaWidth, bullet.body:getY() + i * arenaHeight, 5)
            end


            -- Thruster
            thrustCurrentTic = thrustCurrentTic + 1
            if thrustCurrentTic > 15 then
                thrustCurrentTic = 0
            end
            local thrustCurrentFrame = math.floor(thrustCurrentTic / 5) + 1
            for shipIndex, ship in ipairs(objects.ships) do
                local thrustX = ship.body:getX() - ship.shape:getRadius() * math.cos(ship.body:getAngle()) + j * arenaWidth
                local thrustY = ship.body:getY() - ship.shape:getRadius() * math.sin(ship.body:getAngle()) + i * arenaHeight
            
                if ship.shipSpeed > 0 and not(ship.dead) then
                    local thrustScale = ship.shipSpeed / maxSpeed * 3
                    love.graphics.draw(thrustAnim[thrustCurrentFrame], thrustX, thrustY, ship.body:getAngle() + math.pi / 2, thrustScale, thrustScale, thrustWidth / 2, thrustHeight / 2)
                end

                -- If ship is dead, spend a few tics drawing particles
                if (ship.dead) then
                    love.graphics.draw(ship.deathPsystem, ship.body:getX(), ship.body:getY())
                end
            end
            
            -- Game over text if a ship is dead
            local numAliveShips = 0
            local aliveShipIndex = -1
            for shipIndex, ship in ipairs(objects.ships) do
                if not(ship.dead) then 
                    numAliveShips = numAliveShips + 1
                    aliveShipIndex = shipIndex
                end
            end

            local winMessage
            if numAliveShips == 1 then
                winMessage = 'Player '..aliveShipIndex..' wins!'
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
    end
    camera:unset()
end
