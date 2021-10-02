return function (joyrecord,x,y)
    local player = {}
    print(love.filesystem.getWorkingDirectory( ))
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
    
    player.statetimer = 0

    player.left = false

    player.update_states = {}
    player.draw_states = {}

    local function walk_movement(self, dt)
        local ax1, ax2 = self.joy:getAxes()
        self.x = self.x + ((ax1)*dt)*10
        self.y = self.y + ((ax2/2)*dt)*10
    end

    function player.update_states.normal(self, dt)
        walk_movement(self, dt)
        if self.joy:isGamepadDown("b") then
            self:setstate("punch1")
        end
        if self.joy:isGamepadDown("b") then
            self:setstate("punch1")
        end
        if self.joy:isGamepadDown("b") then
            self:setstate("punch1")
        end
    end

    function player.draw_states.normal(self)
        love.graphics.draw(self.frames.idle,self.x,self.y)
    end


    function player.update_states.punch1(self)
        if self.statetimer > 0.1 then
            self:setstate("punch2")
        end
    end

    function player.update_states.punch2(self)
        if self.statetimer > 0.1 then
            self:setstate("normal")
        end
    end

    function player.draw_states.punch1(self)
        love.graphics.draw(self.frames.punch1,self.x,self.y)
    end

    function player.draw_states.punch2(self)
        love.graphics.draw(self.frames.punch2,self.x,self.y)
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
    end

    function player.draw(self)
        self:current_draw_state()
    end

    return player
end