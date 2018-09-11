function love.load()
    -- Game Constants
    anglePerDt = 10
    shipSpeedDt = 100
    arenaWidth = 800
    arenaHeight = 600

    -- Game State
    shipX = arenaWidth / 2
    shipY = arenaHeight / 2

    shipAngle = 0
    shipSpeed = 0
    shipSpeedX = 0
    shipSpeedY = 0
end

function love.update(dt)
    -- update ship angle
    if love.keyboard.isDown('right') then
        shipAngle = (shipAngle + anglePerDt * dt) % (2 * math.pi)
    elseif love.keyboard.isDown('left') then
        shipAngle = (shipAngle - anglePerDt * dt) % (2 * math.pi)
    end

    -- update ship speed
    if love.keyboard.isDown('up') then
        shipSpeed = shipSpeed + (shipSpeedDt * dt)
    elseif love.keyboard.isDown('down') then
        shipSpeed = shipSpeed - (shipSpeedDt * dt)
    end

    local shipSpeedX = shipSpeedX + math.cos(shipAngle) * shipSpeed
    local shipSpeedY = shipSpeedY + math.sin(shipAngle) * shipSpeed
    shipX = (shipX + shipSpeedX * dt) % arenaWidth
    shipY = (shipY + shipSpeedY * dt) % arenaHeight
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

    -- Temporary
    local shipSpeedX = shipSpeedX + math.cos(shipAngle) * shipSpeed
    local shipSpeedY = shipSpeedY + math.sin(shipAngle) * shipSpeed
    love.graphics.setColor(1, 1, 1)
    love.graphics.print(table.concat({
        'shipAngle: '..shipAngle,
        'shipX: '..shipX,
        'shipY: '..shipY,
        'shipSpeed: '..shipSpeed,
        'shipSpeedX: '..shipSpeedX,
        'shipSpeedY: '..shipSpeedY
    }, '\n'))
end
