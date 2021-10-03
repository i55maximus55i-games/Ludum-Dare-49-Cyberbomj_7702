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

    punchable.update_states = {}
    punchable.draw_states = {}

    ------ UPDATE STATES
    function punchable.update_states.normal(self, dt)

    end

    function punchable.update_states.hit1(self,dt)
        self.x = self.x + dt*30
        if self.statetimer > 0.1 then
            self:setstate("hit2")
        end
    end

    function punchable.update_states.hit2(self)
        if self.statetimer > 0.1 then
            punchable.hitbox.enabled = true
            self:setstate("normal")
        end
    end

    ------ DRAW STATES
    function punchable.draw_states.normal(self,x,y)
        love.graphics.draw(self.frames.idle,x,y)
    end

    function punchable.draw_states.hit1(self,x,y)
        love.graphics.draw(self.frames.hit,x,y)
    end

    function punchable.draw_states.hit2(self,x,y)
        love.graphics.draw(self.frames.hit,x,y)
    end



    
    function punchable.setstate(self, newstate)
        self.statetimer = 0
        if self.update_states[newstate] then 
            print("CHANGIN STATE!!11 " .. newstate)
            self.current_update_state = self.update_states[newstate] 
            self.current_draw_state = self.draw_states[newstate]
        else 
            print("BAD STATAE " .. newstate)
        end
    end

    punchable:setstate("normal")

    function punchable.update(self,dt)
        self:current_update_state(dt)
        self.statetimer = self.statetimer + dt
    end

    function punchable.draw(self)
        local dx, dy = math.floor(self.x), math.floor(self.y)
        self:current_draw_state(dx,dy)
    end

    return punchable
end