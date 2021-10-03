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

local bum_frames = {}
bum_frames[1] = {
    idle = love.graphics.newImage("/assets/blue_idle_00.png"),
    punch1 = love.graphics.newImage("/assets/blue_ready_00.png"),
    punch2 = love.graphics.newImage("/assets/blue_punch_02.png"),
    block = love.graphics.newImage("/assets/blue_block_00.png"),
    hit = love.graphics.newImage("/assets/blue_hit_00.png"),
    knockover = love.graphics.newImage("/assets/blue_knockover_00.png"),
    down = love.graphics.newImage("/assets/blue_down_00.png"),
    
    uppercut1 = love.graphics.newImage("/assets/blue_uppercut_00.png"),
    uppercut2 = love.graphics.newImage("/assets/blue_uppercut_02.png"),
    kick2 = love.graphics.newImage("/assets/blue_kick_02.png"),
    elbow2 = love.graphics.newImage("/assets/blue_elbowpunch_02.png"),

    walk1 = love.graphics.newImage("/assets/blue_idlewalk_0.png"),
    walk2 = love.graphics.newImage("/assets/blue_idlewalk_1.png")
}
bum_frames[2] = {
    idle = love.graphics.newImage("/assets/green_idle_00.png"),
    punch1 = love.graphics.newImage("/assets/green_ready_00.png"),
    punch2 = love.graphics.newImage("/assets/green_punch_04.png"),
    block = love.graphics.newImage("/assets/green_block_00.png"),
    hit = love.graphics.newImage("/assets/green_hit_00.png"),
    knockover = love.graphics.newImage("/assets/green_knockover_00.png"),
    down = love.graphics.newImage("/assets/green_down_00.png"),
    
    uppercut1 = love.graphics.newImage("/assets/green_uppercut_00.png"),
    uppercut2 = love.graphics.newImage("/assets/green_uppercut_02.png"),
    kick2 = love.graphics.newImage("/assets/green_kick_02.png"),
    elbow2 = love.graphics.newImage("/assets/green_elbowpunch_02.png"),

    walk1 = love.graphics.newImage("/assets/green_idlewalk_2.png"),
    walk2 = love.graphics.newImage("/assets/green_idlewalk_6.png")
}
bum_frames[3] = {
    idle = love.graphics.newImage("/assets/idle_placeholder.png"),
    punch1 = love.graphics.newImage("/assets/readytopunch_placeholder.png"),
    punch2 = love.graphics.newImage("/assets/punch_placeholder.png"),
    block = love.graphics.newImage("/assets/block_placeholder.png"),
    hit = love.graphics.newImage("/assets/hit_placeholder.png"),
    knockover = love.graphics.newImage("/assets/knockover_placeholder.png"),
    down = love.graphics.newImage("/assets/down_placeholder.png"),
    
    uppercut1 = love.graphics.newImage("/assets/sit_placeholder.png"),
    uppercut2 = love.graphics.newImage("/assets/uppercut_placeholder.png"),
    kick2 = love.graphics.newImage("/assets/kick_placeholder.png"),
    elbow2 = love.graphics.newImage("/assets/elbowpunch_placeholder.png"),

    walk1 = love.graphics.newImage("/assets/idle_walk1.png"),
    walk2 = love.graphics.newImage("/assets/idle_walk2.png")
}

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
            np.frames = bum_frames[i]
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
SCORE: %d
SELECT TO LEAVE
]],i,joystick.playerobj.health, joystick.playerobj.score)
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