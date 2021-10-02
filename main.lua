lick = require "lick"
lick.reset = true -- reload the love.load everytime you save

local world = require 'oo'
local player_factory = require 'factories.player'

local p = player_factory(100,100)

function love.load() 
    world:add(p)
end

function love.update(dt)
    if love.keyboard.isDown("a") then
        world:add(player_factory(100,100))
    end
    if love.keyboard.isDown("d") then
        world:del(p)
    end
    world:update(dt)
end

function love.draw()
    world:draw(dt)
end