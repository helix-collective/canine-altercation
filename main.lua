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
end

function love.update(dt)
    -- update ship angle
    if love.keyboard.isDown('right') then
        shipAngle = (shipAngle + anglePerDt * dt) % (2 * math.pi)
    elseif love.keyboard.isDown('left') then
        shipAngle = (shipAngle - anglePerDt * dt) % (2 * math.pi)
    end

    -- update ship speed
    -- TODO(jeeva): Think about math here, I don't think we need the if extra if statements
    shipSpeedFactor = math.sqrt(1-(math.abs(shipSpeed*shipSpeed)/(maxSpeed*maxSpeed)))
    if love.keyboard.isDown('up') then
        if shipSpeed > 0 then -- apply limiting factor if speed is too high
            shipSpeed = shipSpeed + (shipSpeedDt * dt * shipSpeedFactor)
        else
            shipSpeed = shipSpeed + (shipSpeedDt * dt)
        end
    elseif love.keyboard.isDown('down') then
        if shipSpeed > 0 then -- apply limiting factor if backwards speed is too high
            shipSpeed = shipSpeed - (shipSpeedDt * dt)
        else
            shipSpeed = shipSpeed - (shipSpeedDt * dt * shipSpeedFactor)
        end
    end

    if shipSpeed > maxSpeed then
        shipSpeed = maxSpeed
    end
    if shipSpeed < -maxSpeed then
        shipSpeed = -maxSpeed
    end

    shipSpeedX = math.cos(shipAngle) * shipSpeed
    shipSpeedY = math.sin(shipAngle) * shipSpeed

    -- Update bullet positions
    for _, bullet in ipairs(bullets) do
        bullet.x = (bullet.x + math.cos(bullet.angle) * bulletSpeed * dt)
        bullet.y = (bullet.y + math.sin(bullet.angle) * bulletSpeed * dt)
    end

    -- Update ship position
    shipX = (shipX + shipSpeedX * dt)
    shipY = (shipY + shipSpeedY * dt)

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
    if ((shipX + shipRadius) >= arenaWidth) then
      shipAngle = (1 - (shipAngle/math.pi))*math.pi + math.pi
      shipSpeed = -shipSpeed
    end

    if ((shipX - shipRadius) <= 0) then
      shipAngle = (1 - (shipAngle/math.pi))*math.pi + math.pi
      shipSpeed = -shipSpeed
    end

    if ((shipY + shipRadius) >= arenaHeight) then
      shipAngle = (1 - (shipAngle/math.pi))*math.pi
      shipSpeed = -shipSpeed
    end

    if ((shipY - shipRadius) <= 0) then
      shipAngle = (1 - (shipAngle/math.pi))*math.pi
      shipSpeed = -shipSpeed
    end
end 

function love.keypressed(key)
    if key == "space" then
         table.insert(bullets, {
             x = shipX + math.cos(shipAngle) * shipRadius,
             y = shipY + math.sin(shipAngle) * shipRadius,
             angle = shipAngle,
         })
    end
    if key == 'q' then 
        dead = true
        deathPsystem:reset()
    end
end

function love.draw()
    -- draw the ship
    love.graphics.draw(shipSprite, shipX, shipY, shipAngle - math.pi/2, 0.75, 0.75, shipSprite:getWidth()/2, shipSprite:getHeight()/2)

    for bulletIndex, bullet in ipairs(bullets) do
        love.graphics.setColor(0, 1, 0)
        love.graphics.circle('fill', bullet.x, bullet.y, 5)
    end

    -- Debug
    love.graphics.setColor(1, 1, 1)
    love.graphics.print(table.concat({
        'shipAngle: '..shipAngle,
        'shipX: '..shipX,
        'shipY: '..shipY,
        'shipSpeed: '..shipSpeed,
        'shipSpeedX: '..shipSpeedX,
        'shipSpeedY: '..shipSpeedY,
        'shipSpeedFactor: '..shipSpeedFactor,
    }, '\n'))

    -- Thruster
    thrustCurrentTic = thrustCurrentTic + 1
    if thrustCurrentTic > 15 then
        thrustCurrentTic = 0
    end
    local thrustCurrentFrame = math.floor(thrustCurrentTic / 5)
    local thrustX = shipX - shipRadius * math.cos(shipAngle) 
    local thrustY = shipY - shipRadius * math.sin(shipAngle)

    if shipSpeed > 0 then
        local thrustScale = (1 - shipSpeedFactor) * 3
        love.graphics.draw(thrustAnim[thrustCurrentFrame], thrustX, thrustY, shipAngle + math.pi / 2, thrustScale, thrustScale, thrustWidth / 2, thrustHeight / 2)
    end
    
    -- psystem:setDirection(shipAngle)
    -- psystem:setLinearAcceleration(0, 0, -shipSpeed / 10 * math.cos(shipAngle), -shipSpeed / 10 * math.sin(shipAngle))
    -- psystem:setPosition(-30 * math.cos(shipAngle), -30 * math.sin(shipAngle))
    -- love.graphics.draw(psystem, shipX, shipY)
    
    -- If ship is dead, spend a few tics drawing particles
    love.graphics.draw(deathPsystem, shipX, shipY)
end
