function love.load()
    love.window.maximize()
    
    -- Game Constants
    anglePerDt = 10
    shipSpeedDt = 200
    arenaWidth = love.graphics.getWidth()
    arenaHeight = love.graphics.getHeight()
    maxSpeed = 500
    bulletSpeed = 700
    shipRadius = 30

    CATEGORY_BULLET = 2

    -- Game State
    shipSprite = love.graphics.newImage("/assets/PNG/Sprites/Ships/spaceShips_009.png")

    collisionText = ''

    local img = love.graphics.newImage('t1.png')

    -- Ship death explosion
    local deathPsystem = love.graphics.newParticleSystem(img, 200)
    deathPsystem:setParticleLifetime(1, 100)
    deathPsystem:setEmissionRate(0)
    deathPsystem:setSizeVariation(1)
    deathPsystem:setSizes(0.1, 0.07, 0.05)
    deathPsystem:setLinearAcceleration(-200, -200, 200, 200)

    -- Trailing partical sprites
    -- NOTE(jeeva): Removed, as it should really leave a trail behind the ship, seems a bit harder to do, and not
    --              important given we have awesome thruster sprites now :)
    -- psystem = love.graphics.newParticleSystem(img, 32)
    -- psystem:setParticleLifetime(1, 3) -- Particles live at least 2s and at most 5s.
    -- psystem:setEmissionRate(5)
    -- psystem:setSizeVariation(1)
    -- psystem:setSizes(0.03, 0.02)
    
    thrustAnim = {}
    thrustAnim[0] = love.graphics.newImage('assets/PNG/Sprites/Effects/spaceEffects_002.png')
    thrustAnim[1] = love.graphics.newImage('assets/PNG/Sprites/Effects/spaceEffects_003.png')
    thrustAnim[2] = love.graphics.newImage('assets/PNG/Sprites/Effects/spaceEffects_004.png')
    thrustAnim[3] = love.graphics.newImage('assets/PNG/Sprites/Effects/spaceEffects_005.png')
    thrustCurrentTic = 0
    thrustWidth = thrustAnim[0]:getWidth()
    thrustHeight = thrustAnim[0]:getHeight()
   
    love.physics.setMeter(64)
    world = love.physics.newWorld(0, 0, arenaWidth, arenaHeight)
    world:setCallbacks(beginContact, endContact, preSolve, postSolve)

    objects = {} -- table to hold all our physical objects
    objects.ships = {}
    local ship1 = {}
    ship1.type = 'ship'
    ship1.body = love.physics.newBody(world, arenaWidth / 4, arenaHeight / 4, "dynamic") --place the body in the center of the world and make it dynamic, so it can move around
    ship1.body:setAngularDamping(1000)  --for colissions
    ship1.shape = love.physics.newCircleShape(20)
    ship1.fixture = love.physics.newFixture(ship1.body, ship1.shape, 1) -- Attach fixture to body and give it a density of 1.
    ship1.fixture:setRestitution(0.1) 
    ship1.fixture:setUserData(ship1)
    ship1.shipSpeed = 0
    ship1.deathPsystem = deathPsystem:clone()
    table.insert(objects.ships, ship1)

    local ship2 = {}
    ship2.type = 'ship'
    ship2.body = love.physics.newBody(world, arenaWidth / 4 * 3, arenaHeight / 4 * 3, "dynamic") --place the body in the center of the world and make it dynamic, so it can move around
    ship2.body:setAngularDamping(1000)  --for colissions
    ship2.shape = love.physics.newCircleShape(20)
    ship2.fixture = love.physics.newFixture(ship2.body, ship2.shape, 1) -- Attach fixture to body and give it a density of 1.
    ship2.fixture:setRestitution(0.1)
    ship2.fixture:setUserData(ship2)
    ship2.shipSpeed = 0
    ship2.deathPsystem = deathPsystem:clone()
    table.insert(objects.ships, ship2)
    
    objects.topWall = {}
    objects.topWall.type = 'wall'
    objects.topWall.reflectType = 'x'
    objects.topWall.body = love.physics.newBody(world, arenaWidth / 2, 0, "static")
    objects.topWall.angle = -math.pi / 2
    objects.topWall.shape = love.physics.newRectangleShape(arenaWidth, 1)
    objects.topWall.fixture = love.physics.newFixture(objects.topWall.body, objects.topWall.shape)
    objects.topWall.fixture:setRestitution(0.2)
    objects.topWall.fixture:setUserData(objects.topWall)

    objects.bottomWall = {}
    objects.bottomWall.type = 'wall'
    objects.bottomWall.reflectType = 'x'
    objects.bottomWall.body = love.physics.newBody(world, arenaWidth / 2, arenaHeight, "static")
    objects.bottomWall.angle = math.pi / 2
    objects.bottomWall.shape = love.physics.newRectangleShape(arenaWidth, 1)
    objects.bottomWall.fixture = love.physics.newFixture(objects.bottomWall.body, objects.bottomWall.shape)
    objects.bottomWall.fixture:setRestitution(0.2)
    objects.bottomWall.fixture:setUserData(objects.bottomWall)

    objects.leftWall = {}
    objects.leftWall.type = 'wall'
    objects.leftWall.reflectType = 'y'
    objects.leftWall.body = love.physics.newBody(world, 0, arenaHeight / 2, "static")
    objects.leftWall.angle = 0
    objects.leftWall.shape = love.physics.newRectangleShape(1, arenaHeight)
    objects.leftWall.fixture = love.physics.newFixture(objects.leftWall.body, objects.leftWall.shape)
    objects.leftWall.fixture:setRestitution(0.2)
    objects.leftWall.fixture:setUserData(objects.leftWall)

    objects.rightWall = {}
    objects.rightWall.type = 'wall'
    objects.rightWall.reflectType = 'y'
    objects.rightWall.body = love.physics.newBody(world, arenaWidth, arenaHeight / 2, "static")
    objects.rightWall.angle = math.pi
    objects.rightWall.shape = love.physics.newRectangleShape(1, arenaHeight)
    objects.rightWall.fixture = love.physics.newFixture(objects.rightWall.body, objects.rightWall.shape)
    objects.rightWall.fixture:setRestitution(0.2)
    objects.rightWall.fixture:setUserData(objects.rightWall)
    
    objects.bullets = {} -- list of bullets

    -- change this to true to make ships reflect off walls
    shipsReflectOffWalls = false
    
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
        colBullet = a:getUserData()
    elseif b:getUserData().type == 'bullet' then
        colBullet = b:getUserData()
    end

    -- Seems like you can't update objects in callbacks (results in error)
    -- so just mark it and process next tic
    if (not (colShip == nil) and not (colWall == nil)) then
        colShip.bounceProgress = 1
        colShip.bounceType = colWall.reflectType
        if ((not shipsReflectOffWalls and colWall.reflectType == 'y') or 
            (shipsReflectOffWalls and colWall.reflectType == 'x')) then
           colShip.bounceAngle = (1 - (colShip.body:getAngle()/math.pi))*math.pi + math.pi
        else
            colShip.bounceAngle = (1 - (colShip.body:getAngle()/math.pi))*math.pi 
        end
    elseif (not (colWall == nil) and not (colBullet == nil)) then
        colBullet.dead = true -- remove a bullet when it hits the wall in the next tic
    elseif (not (colShip == nil) and not (colBullet == nil)) then
        colShip.dead = true
        colBullet.dead = true
        colShip.deathPsystem:reset()
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

    -- process any pending bounces
    for shipIndex, ship in ipairs(objects.ships) do
        if (ship.bounceProgress == 1) then
            ship.body:setAngle(ship.bounceAngle)
            if not shipsReflectOffWalls then 
                ship.shipSpeed = -ship.shipSpeed
            end
            ship.bounceProgress = 0
        end
    end
    
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

    -- update ship speed
    -- TODO(jeeva): Think about math here, I don't think we need the if extra if statements
    for shipIndex, ship in ipairs(objects.ships) do
        ship.shipSpeedFactor = math.sqrt(1-(math.abs(ship.shipSpeed*ship.shipSpeed)/(maxSpeed*maxSpeed)))
    end

    if love.keyboard.isDown('up') then
        if objects.ships[1].shipSpeed > 0 then -- apply limiting factor if speed is too high
            objects.ships[1].shipSpeed = objects.ships[1].shipSpeed + (shipSpeedDt * dt * objects.ships[1].shipSpeedFactor)
        else
            objects.ships[1].shipSpeed = objects.ships[1].shipSpeed + (shipSpeedDt * dt)
        end
    elseif love.keyboard.isDown('down') then
        if objects.ships[1].shipSpeed > 0 then -- apply limiting factor if backwards speed is too high
            objects.ships[1].shipSpeed = objects.ships[1].shipSpeed - (shipSpeedDt * dt)
        else
            objects.ships[1].shipSpeed = objects.ships[1].shipSpeed - (shipSpeedDt * dt * objects.ships[1].shipSpeedFactor)
        end
    end

    for shipIndex, ship in ipairs(objects.ships) do
        if ship.shipSpeed > maxSpeed then
            ship.shipSpeed = maxSpeed
        end
        if ship.shipSpeed < -maxSpeed then
            ship.shipSpeed = -maxSpeed
        end
    end

    for shipIndex, ship in ipairs(objects.ships) do
        ship.body:setLinearVelocity(math.cos(ship.body:getAngle()) * ship.shipSpeed,
                                    math.sin(ship.body:getAngle()) * ship.shipSpeed)
    end

    -- psystem:update(dt)

    for shipIndex, ship in ipairs(objects.ships) do
        if ship.dead and not(ship.deadAnimationDone) then
            ship.deadAnimationDone = true
            ship.deathPsystem:emit(1000)
        end

        ship.deathPsystem:update(dt)
    end
    
    

    -- COLLISION DETECTION / Handling
    --------------------------------
    
    -- Arena bounce
    -- TODO(jeeva): generalise once we add asteroids + other ships (should be a general for each thing, for each thing, calc bounce)
    -- TODO(jeeva): Make bounce smooth, to sleep to work out now :)
    
end 

function love.keypressed(key)
    if objects.ships[1].dead then
        return
    end
    
    if key == "space" then
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
        newBullet.fixture:setCategory(CATEGORY_BULLET)
        newBullet.fixture:setMask(CATEGORY_BULLET)
        newBullet.fixture:setUserData(newBullet) 
        newBullet.type = 'bullet'
        
        table.insert(objects.bullets, newBullet)
    end
    if key == 'q' then 
        objects.ships[1].dead = true
        objects.ships[1].deathPsystem:reset()
    end
end

function love.draw()
    -- draw the ship
    --love.graphics.draw(shipSprite, shipX, shipY, shipAngle - math.pi/2, 0.75, 0.75, shipSprite:getWidth()/2, shipSprite:getHeight()/2)

    for shipIndex, ship in ipairs(objects.ships) do
        if not(ship.dead) then
            love.graphics.draw(shipSprite, ship.body:getX(), ship.body:getY(), ship.body:getAngle() - math.pi/2, 0.75, 0.75, shipSprite:getWidth()/2, shipSprite:getHeight()/2)
        end
    end

    for bulletIndex, bullet in ipairs(objects.bullets) do
        love.graphics.setColor(0, 1, 0)
        love.graphics.circle('fill', bullet.body:getX(), bullet.body:getY(), 5)
    end

    -- Debug
    love.graphics.setColor(1, 1, 1)
    love.graphics.print(table.concat({
        'shipAngle: '..objects.ships[1].body:getAngle(),
        'shipX: '..objects.ships[1].body:getX(),
        'shipY: '..objects.ships[1].body:getY(),
        'shipSpeed: '..objects.ships[1].shipSpeed,
        'shipSpeedFactor: '..objects.ships[1].shipSpeedFactor,
        'collision: '..collisionText
    }, '\n'))

    -- Thruster
    thrustCurrentTic = thrustCurrentTic + 1
    if thrustCurrentTic > 15 then
        thrustCurrentTic = 0
    end
    local thrustCurrentFrame = math.floor(thrustCurrentTic / 5)
    for shipIndex, ship in ipairs(objects.ships) do
        local thrustX = ship.body:getX() - ship.shape:getRadius() * math.cos(ship.body:getAngle()) 
        local thrustY = ship.body:getY() - ship.shape:getRadius() * math.sin(ship.body:getAngle())
    
        if ship.shipSpeed > 0 then
            local thrustScale = (1 - ship.shipSpeedFactor) * 3
            love.graphics.draw(thrustAnim[thrustCurrentFrame], thrustX, thrustY, ship.body:getAngle() + math.pi / 2, thrustScale, thrustScale, thrustWidth / 2, thrustHeight / 2)
        end

        -- If ship is dead, spend a few tics drawing particles
        if (ship.dead) then
            love.graphics.draw(ship.deathPsystem, ship.body:getX(), ship.body:getY())
        end
    end
    
    -- psystem:setDirection(shipAngle)
    -- psystem:setLinearAcceleration(0, 0, -shipSpeed / 10 * math.cos(shipAngle), -shipSpeed / 10 * math.sin(shipAngle))
    -- psystem:setPosition(-30 * math.cos(shipAngle), -30 * math.sin(shipAngle))
    -- love.graphics.draw(psystem, shipX, shipY)
    
    
end
