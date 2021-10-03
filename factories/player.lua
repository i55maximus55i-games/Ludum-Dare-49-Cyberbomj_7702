return function (joyrecord,x,y)
    local player = {}
    print(love.filesystem.getWorkingDirectory())
    player.frames = {
        idle = love.graphics.newImage("/assets/idle_placeholder.png"),
        punch1 = love.graphics.newImage("/assets/readytopunch_placeholder.png"),
        punch2 = love.graphics.newImage("/assets/punch_placeholder.png"),
        block = love.graphics.newImage("/assets/block_placeholder.png"),
        
        uppercut1 = love.graphics.newImage("/assets/sit_placeholder.png"),
        uppercut2 = love.graphics.newImage("/assets/uppercut_placeholder.png"),
        kick2 = love.graphics.newImage("/assets/kick_placeholder.png"),
        elbow2 = love.graphics.newImage("/assets/elbowpunch_placeholder.png")
    }

    player.team = 0
    player.joy = joyrecord.instance
    player.inputbuffer = {}
    player.x = x
    player.y = y
    player.z = 0
    player.health = 10

    player.hitbox = hitbox.new(0, 0, 0, 24, 32, 5, function (attacker)
        player.hitbox.enabled = false
        player:setstate("hit1")
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

        self.x = self.x + ((ax1)*dt)*30
        self.y = self.y + ((ax2/2)*dt)*30
    end

    -- state normal
    function player.update_states.normal(self, dt)
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
    end
    function player.draw_states.normal(self,dx,dy,dz,f,ox)
        love.graphics.draw(self.frames.idle,dx,dy - dz,nil,f,1,ox)
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
        local dx, dy, dz = math.floor(self.x), math.floor(self.y), math.floor(self.z)
        local f = self.left and -1 or 1
        local ox = self.left and 24 or 0
        self:current_draw_state(dx,dy,dz,f,ox)
    end

    return player
end