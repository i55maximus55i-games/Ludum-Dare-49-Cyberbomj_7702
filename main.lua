sounds = require 'sounds'
sharedstates = require 'sharedstates'
world = require 'oo'
hitbox = require 'hitbox.hitbox'
local punchable = require 'factories.punchable'
local player_factory = require 'factories.player'
local picture_factory = require 'factories.pictureobject'

font = love.graphics.newFont("/assets/uni0553-webfont.ttf")
love.graphics.setFont(font)

screenCanvas = love.graphics.newCanvas(160*2,90*2)
--love.graphics.setDefaultFilter("nearest")
screenCanvas:setFilter("nearest","nearest")

joysticks = {}
for i,v in ipairs(love.joystick.getJoysticks()) do
    joysticks[i] = {
        available = true,
        instance = v,
        playerobj = false,
    }
end

function love.load() 
    world:add(picture_factory(-320,0,"/assets/backdrop.png"))
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
            v.playerobj = np
            np.team = i
        end
        if not v.available and (v.instance:isGamepadDown("back") or v.playerobj.health < 1 or v.playerobj.inactivity > 30)  then
            v.available = true
            world:del(v.player)
            v.playerobj = false
            sound_player_disconnect:play()
        end
    end
    world:update(dt)
end

function love.draw()
  
    
    love.graphics.setCanvas(screenCanvas)
    local camsum = 0
    local camcount = 0
    local camx = 0
    for i,object in pairs(world.objects) do
        if object.isplayer then
            camcount = camcount + 1
            camsum = camsum + object.x
        else
        end
    end
    
    if camcount > 0 then
        camx = camsum / camcount - 160
    end
    if camx < -160 then
        camx = -160
    end
    if camx > 320 then
        camx = 320
    end
    love.graphics.clear()
    love.graphics.translate(math.floor(-camx),0)
    love.graphics.line(0,0,0,200)
    
    world:draw()
    
    love.graphics.setCanvas()
    love.graphics.translate(camx,0)
    love.graphics.draw(screenCanvas,0,0,0,3,3)
    for i, joystick in ipairs(joysticks) do
        local offset = (160*i)-80
        if not joystick.available then
            local str = string.format(
[[PLAYER %d
HEALTH: %d
SELECT TO LEAVE
]],i,joystick.playerobj.health)
            love.graphics.setColor(0,0,0,1)
            for xi=-5,5 do
                for yi=-5,5 do
                    love.graphics.print(str,offset+xi,50+yi)
                end
            end
            love.graphics.setColor(1,1,1,1)
            love.graphics.print(str,offset,50,0)
        else
            love.graphics.setColor(0,0,0,1)
            for xi=-5,5 do
                for yi=-5,5 do
                    love.graphics.print("PRESS START\nPLAYER " .. i,offset+xi,50+yi)
                end
            end
            love.graphics.setColor(1,1,1,1)
            love.graphics.print("PRESS START\nPLAYER " .. i,offset,50,0)
        end
    end
end