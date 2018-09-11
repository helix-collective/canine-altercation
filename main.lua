function love.load()
    shipX = 800 / 2
    shipY = 600 / 2
    shipAngle = 0
end

function love.update(dt)
    if love.keyboard.isDown('right') then
         shipAngle = shipAngle + 10 * dt
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

    -- Temporary
    love.graphics.setColor(1, 1, 1)
    love.graphics.print('shipAngle: '..shipAngle)
end
