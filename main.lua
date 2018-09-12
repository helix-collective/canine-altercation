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

    -- Game State
    shipAngle = 0
    shipSpeed = 0
    shipSprite = love.graphics.newImage("/assets/PNG/Sprites/Ships/spaceShips_009.png")

    shipSpeedX = 0
    shipSpeedY = 0
    
    shipX = arenaWidth / 2
    shipY = arenaHeight / 2

    bullets = {
        -- (x,y,angle)
    }
    
    collisionText = ''

    local img = love.graphics.newImage('t1.png')

    -- Ship death explosion
    deathPsystem = love.graphics.newParticleSystem(img, 200)
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
   
    dead = false

    love.physics.setMeter(64)
    world = love.physics.newWorld(0, 0, arenaWidth, arenaHeight)
    world:setCallbacks(beginContact, endContact, preSolve, postSolve)

    objects = {} -- table to hold all our physical objects
    objects.ship = {}
    objects.ship.type = 'ship'
    objects.ship.body = love.physics.newBody(world, arenaWidth / 2, arenaHeight / 2, "dynamic") --place the body in the center of the world and make it dynamic, so it can move around
    objects.ship.body:setAngularDamping(1000)  --for colissions
    objects.ship.shape = love.physics.newCircleShape(20)
    objects.ship.fixture = love.physics.newFixture(objects.ship.body, objects.ship.shape, 1) -- Attach fixture to body and give it a density of 1.
    objects.ship.fixture:setRestitution(0.1) 
    objects.ship.fixture:setUserData(objects.ship)
    objects.ship.shipSpeed = 0
    
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
    
end



function beginContact(a, b, coll)
    
    
    -- Find the ship that collided
    local colShip
    local colWall
    if a:getUserData().type == 'ship' then
        colShip = a:getUserData()
        colWall = b:getUserData()
    elseif b:getUserData().type == 'ship' then
        colShip = b:getUserData()
        colWall = a:getUserData()
    else
        return
    end

    -- Seems like you can't update objects in callbacks (results in error)
    -- so just mark it and process next tic
    colShip.bounceProgress = 1
    colShip.bounceType = colWall.reflectType
    if (colWall.reflectType == 'y') then
       colShip.bounceAngle = (1 - (colShip.body:getAngle()/math.pi))*math.pi + math.pi
    else
        colShip.bounceAngle = (1 - (colShip.body:getAngle()/math.pi))*math.pi 
    end

    collisionText = a:getUserData().type..' with '..b:getUserData().type
    
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
    if (objects.ship.bounceProgress == 1) then
        objects.ship.body:setAngle(objects.ship.bounceAngle)
        objects.ship.shipSpeed = -objects.ship.shipSpeed
        objects.ship.bounceProgress = 0
    end

    -- update ship angle
    if love.keyboard.isDown('right') then
        objects.ship.body:setAngle(objects.ship.body:getAngle() + anglePerDt * dt)
    elseif love.keyboard.isDown('left') then
        objects.ship.body:setAngle(objects.ship.body:getAngle() - anglePerDt * dt)
    end

    -- update ship speed
    -- TODO(jeeva): Think about math here, I don't think we need the if extra if statements
    objects.ship.shipSpeedFactor = math.sqrt(1-(math.abs(objects.ship.shipSpeed*objects.ship.shipSpeed)/(maxSpeed*maxSpeed)))

    if love.keyboard.isDown('up') then
        if objects.ship.shipSpeed > 0 then -- apply limiting factor if speed is too high
            objects.ship.shipSpeed = objects.ship.shipSpeed + (shipSpeedDt * dt * objects.ship.shipSpeedFactor)
        else
            objects.ship.shipSpeed = objects.ship.shipSpeed + (shipSpeedDt * dt)
        end
    elseif love.keyboard.isDown('down') then
        if objects.ship.shipSpeed > 0 then -- apply limiting factor if backwards speed is too high
            objects.ship.shipSpeed = objects.ship.shipSpeed - (shipSpeedDt * dt)
        else
            objects.ship.shipSpeed = objects.ship.shipSpeed - (shipSpeedDt * dt * objects.ship.shipSpeedFactor)
        end
    end

    if objects.ship.shipSpeed > maxSpeed then
        objects.ship.shipSpeed = maxSpeed
    end
    if objects.ship.shipSpeed < -maxSpeed then
        objects.ship.shipSpeed = -maxSpeed
    end

    objects.ship.body:setLinearVelocity(math.cos(objects.ship.body:getAngle()) * objects.ship.shipSpeed, 
                                        math.sin(objects.ship.body:getAngle()) * objects.ship.shipSpeed)

    -- Update bullet positions
    for _, bullet in ipairs(bullets) do
        bullet.x = (bullet.x + math.cos(bullet.angle) * bulletSpeed * dt)
        bullet.y = (bullet.y + math.sin(bullet.angle) * bulletSpeed * dt)
    end

    -- psystem:update(dt)
    if dead then
        dead = false
        deathPsystem:emit(1000)
    end
    deathPsystem:update(dt)

    -- COLLISION DETECTION / Handling
    --------------------------------
    
    -- Arena bounce
    -- TODO(jeeva): generalise once we add asteroids + other ships (should be a general for each thing, for each thing, calc bounce)
    -- TODO(jeeva): Make bounce smooth, to sleep to work out now :)
    
end 

function love.keypressed(key)
    if key == "space" then
         table.insert(bullets, {
             x = objects.ship.body:getX() + math.cos(objects.ship.body:getAngle()) * shipRadius,
             y = objects.ship.body:getY() + math.sin(objects.ship.body:getAngle()) * shipRadius,
             angle = objects.ship.body:getAngle(),
         })
    end
    if key == 'q' then 
        dead = true
        deathPsystem:reset()
    end
end

function love.draw()
    -- draw the ship
    --love.graphics.draw(shipSprite, shipX, shipY, shipAngle - math.pi/2, 0.75, 0.75, shipSprite:getWidth()/2, shipSprite:getHeight()/2)

    love.graphics.draw(shipSprite, objects.ship.body:getX(), objects.ship.body:getY(), objects.ship.body:getAngle() - math.pi/2, 0.75, 0.75, shipSprite:getWidth()/2, shipSprite:getHeight()/2)
    


    for bulletIndex, bullet in ipairs(bullets) do
        love.graphics.setColor(0, 1, 0)
        love.graphics.circle('fill', bullet.x, bullet.y, 5)
    end

    -- Debug
    love.graphics.setColor(1, 1, 1)
    love.graphics.print(table.concat({
        'shipAngle: '..objects.ship.body:getAngle(),
        'shipX: '..objects.ship.body:getX(),
        'shipY: '..objects.ship.body:getY(),
        'shipSpeed: '..objects.ship.shipSpeed,
        'shipSpeedX: '..shipSpeedX,
        'shipSpeedY: '..shipSpeedY,
        'shipSpeedFactor: '..objects.ship.shipSpeedFactor,
        'collision: '..collisionText
    }, '\n'))

    -- Thruster
    thrustCurrentTic = thrustCurrentTic + 1
    if thrustCurrentTic > 15 then
        thrustCurrentTic = 0
    end
    local thrustCurrentFrame = math.floor(thrustCurrentTic / 5)
    local thrustX = objects.ship.body:getX() - objects.ship.shape:getRadius() * math.cos(objects.ship.body:getAngle()) 
    local thrustY = objects.ship.body:getY() - objects.ship.shape:getRadius() * math.sin(objects.ship.body:getAngle())

    if objects.ship.shipSpeed > 0 then
        local thrustScale = (1 - objects.ship.shipSpeedFactor) * 3
        love.graphics.draw(thrustAnim[thrustCurrentFrame], thrustX, thrustY, objects.ship.body:getAngle() + math.pi / 2, thrustScale, thrustScale, thrustWidth / 2, thrustHeight / 2)
    end
    
    -- psystem:setDirection(shipAngle)
    -- psystem:setLinearAcceleration(0, 0, -shipSpeed / 10 * math.cos(shipAngle), -shipSpeed / 10 * math.sin(shipAngle))
    -- psystem:setPosition(-30 * math.cos(shipAngle), -30 * math.sin(shipAngle))
    -- love.graphics.draw(psystem, shipX, shipY)
    
    -- If ship is dead, spend a few tics drawing particles
    love.graphics.draw(deathPsystem, objects.ship.body:getX(), objects.ship.body:getY())
end
