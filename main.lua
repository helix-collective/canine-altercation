
require "camera"

function love.load()
  love.window.setMode(0, 0, {fullscreen=true, resizable=true, vsync=false})
  
  -- Game Constants
  anglePerDt = 5
  shipSpeedDt = 200
  arenaWidth = love.graphics.getWidth()
  arenaHeight = love.graphics.getHeight()
  maxSpeed = 500
  bulletSpeed = 1000
  shipRadius = 30

  RELOAD_DELAY = 2 -- seconds

  CATEGORY_BULLET = 9
  NEXT_SHIP_CATEGORY = 10

  thisQuad = love.graphics.newQuad(0,0,arenaWidth,arenaHeight,32,32)
  thisImage = love.graphics.newImage('assets/PNG/Sprites/Effects/spaceEffects_001.png')
  thisImage:setWrap('repeat','repeat')

  -- Game State
  resetGameState()
end

function newShip(ship_sprite)
    -- Ship death explosion

    local ship = {}
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
    ship.shipSpeed = 0
    ship.reload_delay = 0

    -- Ship death explosion
    local img = love.graphics.newImage('t1.png')
    ship.deathPsystem = love.graphics.newParticleSystem(img, 200)
    ship.deathPsystem:setParticleLifetime(1, 100)
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

    objects = {} -- table to hold all our physical objects
    objects.ships = {}
    table.insert(objects.ships, newShip("/assets/PNG/Sprites/Ships/spaceShips_009.png"))
    table.insert(objects.ships, newShip("/assets/PNG/Sprites/Ships/spaceShips_004.png"))
    
    -- objects.borders = {}
    -- objects.borders.top = newBorderWall('top')
    -- objects.borders.bottom = newBorderWall('bottom')
    -- objects.borders.left = newBorderWall('left')
    -- objects.borders.right = newBorderWall('right')

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
    camera:setPosition(objects.ships[1].body:getX() - (arenaWidth / 2), objects.ships[1].body:getY() - (arenaHeight / 2))

    -- remove any bullets that have hit a wall
    for bulletIndex, bullet in ipairs(objects.bullets) do
        updateWorldObject(bullet)
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
    if love.keyboard.isDown('d') then
        objects.ships[2].body:setAngle(objects.ships[2].body:getAngle() + anglePerDt * dt)
    elseif love.keyboard.isDown('a') then
        objects.ships[2].body:setAngle(objects.ships[2].body:getAngle() - anglePerDt * dt)
    end
    
    -- Accelerate ships
    if love.keyboard.isDown('up') then
        objects.ships[1].shipSpeed = objects.ships[1].shipSpeed + math.max(0, maxSpeed - objects.ships[1].shipSpeed) * dt
    elseif love.keyboard.isDown('down') then
        objects.ships[1].shipSpeed = objects.ships[1].shipSpeed + math.min(0, -maxSpeed - objects.ships[1].shipSpeed) * dt
    end

    if love.keyboard.isDown('w') then
        objects.ships[2].shipSpeed = objects.ships[2].shipSpeed + math.max(0, maxSpeed - objects.ships[2].shipSpeed) * dt
    elseif love.keyboard.isDown('s') then
        objects.ships[2].shipSpeed = objects.ships[2].shipSpeed + math.min(0, -maxSpeed - objects.ships[2].shipSpeed) * dt
    end

    -- If a ship is dead it can no longer move
    for shipIndex, ship in ipairs(objects.ships) do
        if ship.dead then
            ship.shipSpeed = 0
        end
        ship.reload_delay = ship.reload_delay - dt
    end

    for shipIndex, ship in ipairs(objects.ships) do
        ship.body:setLinearVelocity(math.cos(ship.body:getAngle()) * ship.shipSpeed,
                                    math.sin(ship.body:getAngle()) * ship.shipSpeed)
        updateWorldObject(ship)
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
    if objects.ships[1].reload_delay < 0 and not(objects.ships[1].dead) and key == "space" then
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
        newBullet.fixture:setCategory(CATEGORY_BULLET, objects.ships[1].fixture:getCategory())
        newBullet.fixture:setMask(CATEGORY_BULLET, objects.ships[1].fixture:getCategory())
        newBullet.fixture:setUserData(newBullet) 
        newBullet.type = 'bullet'
        
        table.insert(objects.bullets, newBullet)
        objects.ships[1].reload_delay = RELOAD_DELAY
    end
    if objects.ships[2].reload_delay < 0 and not(objects.ships[2].dead) and key == "tab" then
        local newBullet = {}
        newBullet.body = love.physics.newBody(world,
            objects.ships[2].body:getX() + math.cos(objects.ships[2].body:getAngle()) * shipRadius,
            objects.ships[2].body:getY() + math.sin(objects.ships[2].body:getAngle()) * shipRadius,
            "dynamic")
        newBullet.body:setLinearVelocity(math.cos(objects.ships[2].body:getAngle()) * bulletSpeed,
            math.sin(objects.ships[2].body:getAngle()) * bulletSpeed)
        newBullet.shape = love.physics.newCircleShape(5)
        newBullet.fixture = love.physics.newFixture(newBullet.body, newBullet.shape, 1)
        newBullet.fixture:setRestitution(0.1)
        newBullet.fixture:setCategory(CATEGORY_BULLET, objects.ships[2].fixture:getCategory())
        newBullet.fixture:setMask(CATEGORY_BULLET, objects.ships[2].fixture:getCategory())
        newBullet.fixture:setUserData(newBullet)
        newBullet.type = 'bullet'

        table.insert(objects.bullets, newBullet)
        objects.ships[2].reload_delay = RELOAD_DELAY
    end

    if key == 'r' then 
      resetGameState()
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
    for shipIndex, ship in ipairs(objects.ships) do
        if not(ship.dead) then
            love.graphics.setShader(ship.shader)
            drawInWorld(ship.sprite, ship.body:getX(), ship.body:getY(), ship.body:getAngle() - math.pi/2, 0.75, 0.75, ship.sprite:getWidth()/2, ship.sprite:getHeight()/2)
            love.graphics.setShader()
        end
    end
end

function drawBullets()
    for bulletIndex, bullet in ipairs(objects.bullets) do
        love.graphics.setColor(0, 1, 0)
        love.graphics.circle('fill', bullet.body:getX(), bullet.body:getY(), 5)
    end
end

-- Draw in game objects, to be duplicated for wraparound
function drawWorld()
    -- draw the ship
    drawShips()
    drawBullets()

    -- Thruster
    thrustCurrentTic = thrustCurrentTic + 1
    if thrustCurrentTic > 15 then
        thrustCurrentTic = 0
    end
    local thrustCurrentFrame = math.floor(thrustCurrentTic / 5) + 1
    for shipIndex, ship in ipairs(objects.ships) do
        local thrustX = ship.body:getX() - ship.shape:getRadius() * math.cos(ship.body:getAngle()) 
        local thrustY = ship.body:getY() - ship.shape:getRadius() * math.sin(ship.body:getAngle())
    
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


function love.draw()
    -- Debug
    love.graphics.setColor(1, 1, 1)
    love.graphics.print(table.concat({
        'shipAngle: '..objects.ships[1].body:getAngle(),
        'shipX: '..objects.ships[1].body:getX(),
        'shipY: '..objects.ships[1].body:getY(),
        'reloadDelay: '..objects.ships[1].reload_delay,
        'shipSpeed: '..objects.ships[1].shipSpeed,
        'collision: '..collisionText
    }, '\n'))

    camera:set()
    love.graphics.draw(thisImage,thisQuad,0,0)
    drawWorld()
    camera:unset()
end
