lick = require "lick"
lick.reset = true -- reload the love.load everytime you save

function love.load()
    circle = {}
    circle.x = 1
end

function love.update(dt)
    circle.x = circle.x + dt*5
end

function love.draw(dt)
    love.graphics.circle("fill", 400+100*math.sin(circle.x), 400+100*math.cos(circle.x*2), 16,16)
end