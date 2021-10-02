lick = require "lick"
lick.reset = true -- reload the love.load everytime you save

sounds = require 'sounds'
world = require 'oo'
hitbox = require 'hitbox.hitbox'
local punchable = require 'factories.punchable'
local player_factory = require 'factories.player'

local joysticks = {}
for i,v in ipairs(love.joystick.getJoysticks()) do
    joysticks[i] = {
        available = true,
        instance = v
    }
end

function love.load() 
    world:add(punchable(200,100))
    world:add(punchable(200,130))
    world:add(punchable(200,160))
end

function love.update(dt)
    if love.keyboard.isDown("a") then
        world:add(player_factory(100,100))
    end
    if love.keyboard.isDown("d") then
        world:del(p)
    end
    for i,v in pairs(joysticks) do
        if v.available and v.instance:isGamepadDown("start") then
            v.available = false
            local np = player_factory(v,100,100)
            v.player = np
            world:add(np)
            sound_player_join:play()
        end
        if not v.available and v.instance:isGamepadDown("back") then
            v.available = true
            world:del(v.player)
            sound_player_disconnect:play()
        end
    end
    world:update(dt)
end

function love.draw()
    for i, joystick in ipairs(joysticks) do
        love.graphics.print(joystick.instance:getName(), 10, i * 20)
        love.graphics.print(joystick.available and "OPEN" or "USED", 200, i * 20)
        
        love.graphics.print(joystick.instance:getGamepadMappingString(), 10, i * 20 + 10)
    end
    world:draw()
end