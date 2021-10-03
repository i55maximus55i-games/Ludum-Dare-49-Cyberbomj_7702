return function (joyrecord,x,y)
    local player = {}
    print(love.filesystem.getWorkingDirectory())
    player.frames = {
        idle = love.graphics.newImage("/assets/idle_placeholder.png"),
        punch1 = love.graphics.newImage("/assets/readytopunch_placeholder.png"),
        punch2 = love.graphics.newImage("/assets/punch_placeholder.png")
    }

    player.team = 0
    player.joy = joyrecord.instance
    player.inputbuffer = {}
    player.x = x
    player.y = y
    player.z = 0

    player.statetimer = 0

    player.left = false

    player.update_states = sharedstates.create_update_states()
    player.draw_states = sharedstates.create_draw_states()

    local function walk_movement(self, dt)
        local ax1, ax2 = self.joy:getAxes()
        if math.abs(ax1) < 0.2 then ax1 = 0 end
        if math.abs(ax2) < 0.2 then ax2 = 0 end
        self.x = self.x + ((ax1)*dt)*30
        self.y = self.y + ((ax2/2)*dt)*30
    end

    -- state normal
    function player.update_states.normal(self, dt)
        walk_movement(self, dt)
        if self.joy:isGamepadDown("b") then
            self:setstate("punch1")
        end
    end
    function player.draw_states.normal(self)
        love.graphics.draw(self.frames.idle,self.x,self.y - self.z)
    end



    





    function player.setstate(self, newstate)
        self.statetimer = 0
        if self.update_states[newstate] then 
            print("CHANGIN STATE!!11 " .. newstate)
            self.current_update_state = self.update_states[newstate] 
            self.current_draw_state = self.draw_states[newstate]
        else 
            print("BAD STATAE " .. newstate)
        end
    end

    player:setstate("normal")

    function player.update(self,dt)
        self:current_update_state(dt)
        self.statetimer = self.statetimer + dt
        self.z = self.z - dt * 10
        if self.z < 0 then self.z = 0 end
    end

    function player.draw(self)
        self:current_draw_state()
    end

    return player
end