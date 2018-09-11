function love.load()
    love.window.maximize()
    
    -- Game Constants
    anglePerDt = 10
    shipSpeedDt = 200
    arenaWidth = love.graphics.getWidth()
    arenaHeight = love.graphics.getHeight()
    maxSpeed = 500
    bulletSpeed = 700

    -- Game State
    shipAngle = 0
    shipSpeed = 0

    shipSpeedX = 0
    shipSpeedY = 0
    
    shipX = arenaWidth / 2
    shipY = arenaHeight / 2

    bullets = {
        -- (x,y,angle)
    }

    -- Trailing partical sprites
    local img = love.graphics.newImage('t1.png')
    psystem = love.graphics.newParticleSystem(img, 32)
    psystem:setParticleLifetime(1, 3) -- Particles live at least 2s and at most 5s.
    psystem:setEmissionRate(5)
    psystem:setSizeVariation(1)
    psystem:setSizes(0.03, 0.02)
    
    thrustAnim = {}
    thrustAnim[0] = love.graphics.newImage('assets/PNG/Sprites/Effects/spaceEffects_002.png')
    thrustAnim[1] = love.graphics.newImage('assets/PNG/Sprites/Effects/spaceEffects_003.png')
    thrustAnim[2] = love.graphics.newImage('assets/PNG/Sprites/Effects/spaceEffects_004.png')
    thrustAnim[3] = love.graphics.newImage('assets/PNG/Sprites/Effects/spaceEffects_005.png')
    thrustCurrentTic = 0
    thrustWidth = thrustAnim[0]:getWidth()
    thrustHeight = thrustAnim[0]:getHeight()
    
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
    shipX = (shipX + shipSpeedX * dt) % arenaWidth
    shipY = (shipY + shipSpeedY * dt) % arenaHeight

    psystem:update(dt)
end 

function love.keypressed(key)
    if key == "space" then
         table.insert(bullets, {
             x = shipX + math.cos(shipAngle) * 30,
             y = shipY + math.sin(shipAngle) * 30,
             angle = shipAngle,
         })
    end
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
    local thrustX = shipX - 30 * math.cos(shipAngle) 
    local thrustY = shipY - 30 * math.sin(shipAngle)
    love.graphics.draw(psystem, shipX, shipY)
    love.graphics.draw(thrustAnim[thrustCurrentFrame], thrustX, thrustY, shipAngle + math.pi / 2, 1, 1, thrustWidth / 2, thrustHeight / 2)

    psystem:setDirection(shipAngle)
    psystem:setLinearAcceleration(0, 0, -shipSpeed / 10 * math.cos(shipAngle), -shipSpeed / 10 * math.sin(shipAngle))
    psystem:setPosition(-30 * math.cos(shipAngle), -30 * math.sin(shipAngle))
end
