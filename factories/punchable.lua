return function (x,y)
    local punchable = {}
    print(love.filesystem.getWorkingDirectory( ))
    punchable.frames = {
        idle = love.graphics.newImage("/assets/idle_placeholder.png"),
        hit = love.graphics.newImage("/assets/hit_placeholder.png")
    }

    punchable.team = 1
    punchable.x = x
    punchable.y = y
    punchable.z = 0
    
    punchable.hitbox = hitbox.new(0, 0, 0, 24, 32, 5, function (attacker)
        punchable.hitbox.enabled = false
        punchable:setstate("hit1")
    end)

    punchable.update_states = sharedstates.create_update_states()
    punchable.draw_states = sharedstates.create_draw_states()

    ------ UPDATE STATES
    function punchable.update_states.normal(self, dt)

    end



    ------ DRAW STATES
    function punchable.draw_states.normal(self,x,y)
        love.graphics.draw(self.frames.idle,x,y)
    end



    
    function punchable.setstate(self, newstate)
        self.statetimer = 0
        if self.update_states[newstate] then 
            print("CHANGIN STATE!!11 " .. newstate)
            self.current_update_state = self.update_states[newstate] 
            self.current_draw_state = self.draw_states[newstate]
        else 
            print("BAD STATE " .. newstate)
        end
    end

    punchable:setstate("normal")

    function punchable.update(self,dt)
        self:current_update_state(dt)
        self.statetimer = self.statetimer + dt
    end

    function punchable.draw(self)
        local dx, dy, dz = math.floor(self.x), math.floor(self.y), math.floor(self.z)
        local f = self.left and -1 or 1
        local ox = self.left and 24 or 0
        self:current_draw_state(dx,dy,dz,f,ox)
    end

    return punchable
end