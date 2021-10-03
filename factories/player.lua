return function (joyrecord,x,y)
    local player = {}
    print(love.filesystem.getWorkingDirectory())

    player.team = 0
    player.joy = joyrecord.instance
    player.inputbuffer = {}
    player.x = x
    player.y = y
    player.z = 0
    player.health = 3
    player.stamina = 3
    player.inactivity = 0
    player.score = 0

    player.isplayer = true

    

    player.hitbox = hitbox.new(0, 0, 0, 24, 32, 5, function (attacker,hitv)
        player.knockvx = hitv[1]
        player.knockvz = hitv[3]
        player.stamina = player.stamina - 1
        
        if hitv[3] > 10 then
            player.stamina = -1
            
        end
        player.hitbox.enabled = false
        if player.stamina > 0 then
            player:setstate("hit1")
        else
            attacker.score = attacker.score + 1
            player:setstate("knockover")
        end
    
    end)
    

    player.statetimer = 0

    player.left = false

    player.update_states = sharedstates.create_update_states()
    player.draw_states = sharedstates.create_draw_states()

    local function walk_movement(self, dt)
        local ax1, ax2 = self.joy:getAxes()
        if math.abs(ax1) < 0.2 then ax1 = 0 end
        if math.abs(ax2) < 0.2 then ax2 = 0 end

        if ax1 < -0.1 then player.left = true  end
        if ax1 >  0.1 then player.left = false end

        self.x = self.x + ((ax1)*dt)*70
        self.y = self.y + ((ax2/2)*dt)*50

        if math.abs(ax1) > 0.2 then
            self.inactivity = 0
        end
    end

    -- state normal
    function player.update_states.normal(self, dt)
        self.inactivity = self.inactivity + dt
        walk_movement(self, dt)
        if self.joy:isGamepadDown("x") then
            self:setstate("elbow1")
        end
        if self.joy:isGamepadDown("y") then
            self:setstate("uppercut1")
        end
        if self.joy:isGamepadDown("a") then
            self:setstate("kick1")
        end
        if self.joy:isGamepadDown("b") then
            self:setstate("punch1")
        end

        if self.joy:isGamepadDown("leftshoulder", "rightshoulder") then
            self.hitbox.enabled = false
            self:setstate("block")
        end
    end
    
    function player.draw_states.normal(self,dx,dy,dz,f,ox)
        local ax1, ax2 = self.joy:getAxes()
        if math.abs(ax1) > 0.2 or math.abs(ax2) > 0.2 then
            if self.statetimer % 0.4 < 0.2 then love.graphics.draw(self.frames.walk1,dx,dy - dz,nil,f,1,ox)
            else love.graphics.draw(self.frames.walk2,dx,dy - dz,nil,f,1,ox) end
        else
            love.graphics.draw(self.frames.idle,dx,dy - dz,nil,f,1,ox)
        end

        
    end


    function player.setstate(self, newstate)
        self.statetimer = 0
        self.inactivity = 0
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
        if self.x < -140 then
            self.x = -140
        end
        if self.x > 600 then
            self.x = 600
        end
        if self.y < 110 then
            self.y = 110
        end
        if self.y > 160 then
            self.y = 160
        end
        self:current_update_state(dt)
        self.statetimer = self.statetimer + dt
        self.z = self.z - dt * 10
        if self.z < 0 then self.z = 0 end
    end

    function player.draw(self)
        local dx, dy, dz = math.floor(self.x), math.floor(self.y), math.floor(self.z)
        local f = self.left and -1 or 1
        local ox = self.left and 24 or 0
        if self.z > 3 then
            love.graphics.setColor(0,0,0,0.5)
            love.graphics.ellipse("fill",self.x+12,self.y+32,8,4)
            love.graphics.setColor(1,1,1,1)
        end 
        self:current_draw_state(dx,dy,dz,f,ox)
    end

    return player
end