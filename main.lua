function love.load()
    love.window.maximize()
    
    -- Game Constants
    anglePerDt = 10
    shipSpeedDt = 200
    arenaWidth = love.graphics.getWidth()
    arenaHeight = love.graphics.getHeight()
    maxSpeed = 500

    -- Game State
    shipX = arenaWidth / 2
    shipY = arenaHeight / 2

    shipAngle = 0
    shipSpeed = 0
    
    -- Calculated Game State
    shipSpeedX = 0
    shipSpeedY = 0
    
    local img = love.graphics.newImage('t1.png')
    psystem = love.graphics.newParticleSystem(img, 32)
    psystem:setParticleLifetime(1, 3) -- Particles live at least 2s and at most 5s.
    psystem:setEmissionRate(20)
    psystem:setSizeVariation(1)
    psystem:setSizes(0.1)
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
    shipX = (shipX + shipSpeedX * dt) % arenaWidth
    shipY = (shipY + shipSpeedY * dt) % arenaHeight

    psystem:update(dt)
end 

function love.draw()
    love.graphics.setColor(0, 0, 1)
    love.graphics.circle('fill', shipX, shipY, 30)

    love.graphics.setColor(0, 1, 1)
    local shipCircleDistance = 20
    love.graphics.circle(
        'fill',
        shipX + math.cos(shipAngle) * shipCircleDistance,
        shipY + math.sin(shipAngle) * shipCircleDistance,
        5
    )

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

    psystem:setDirection(shipAngle)
    psystem:setLinearAcceleration(0, 0, -100 * math.cos(shipAngle), -100 * math.sin(shipAngle))
    psystem:setPosition(-30 * math.cos(shipAngle), -30 * math.sin(shipAngle))
    love.graphics.draw(psystem, shipX, shipY)
end
