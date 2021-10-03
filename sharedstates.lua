local sharedstates = {}

sharedstates.update_states = {}
sharedstates.draw_states = {}

function sharedstates.create_update_states()
    local new_update_states = {}

    function new_update_states.knockover(self,dt)
        self.x = self.z + dt*self.knockvz 
        self.knockvz = self.knockvz - dt * 4
        if self.z < 0 then
            self.z = 0
            self:setstate("down")
        end
    end

    function new_update_states.down(self,dt)
        if self.statetimer > 1 then
            self:setstate("normal")
        end
    end

    function new_update_states.hit1(self,dt)
        self.x = self.x + dt*self.knockvx * 6
        if self.statetimer > 0.1 then
            self:setstate("hit2")
        end
    end
    function new_update_states.hit2(self)
        if self.statetimer > 0.1 then
            self.hitbox.enabled = true
            self:setstate("normal")
        end
    end

    function new_update_states.punch1(self)
        if self.statetimer > 0.1 then
            self:setstate("punch2")
        end
    end
    function new_update_states.punch2(self)
        if self.left then
            hitbox.tryhit(self, self.x, self.y+12, self.z, 5, 5, 5, {-5, 0, 0})            
        else
            hitbox.tryhit(self, self.x+19, self.y+12, self.z, 5, 5, 5, {5, 0, 0})
        end
        if self.statetimer > 0.1 then
            self:setstate("normal")
        end
    end

    function new_update_states.uppercut1()
        if self.statetimer > 0.1 then
            self:setstate("uppercut2")
        end
    end
    function new_update_states.uppercut2()
        if self.left then
            hitbox.tryhit(self, self.x, self.y+12, self.z, 5, 5, 5, {-5, 0, 15})            
        else
            hitbox.tryhit(self, self.x+19, self.y+12, self.z, 5, 5, 5, {5, 0, 15})
        end
        if self.statetimer > 0.1 then
            self:setstate("normal")
        end
    end

    function new_update_states.kick1()
        if self.statetimer > 0.1 then
            self:setstate("kick2")
        end
    end
    function new_update_states.kick2()
        if self.left then
            hitbox.tryhit(self, self.x, self.y+12, self.z, 5, 5, 5, {-5, 0, 0})            
        else
            hitbox.tryhit(self, self.x+19, self.y+12, self.z, 5, 5, 5, {5, 0, 0})
        end
        if self.statetimer > 0.1 then
            self:setstate("normal")
        end
    end

    function new_update_states.elbow1()
        if self.statetimer > 0.1 then
            self:setstate("elbow2")
        end
    end
    function new_update_states.elbow2()
        if self.left then
            hitbox.tryhit(self, self.x+19, self.y+12, self.z, 5, 5, 5, {5, 0, 0})
        else
            hitbox.tryhit(self, self.x, self.y+12, self.z, 5, 5, 5, {-5, 0, 0})            
        end
        if self.statetimer > 0.1 then
            self:setstate("normal")
        end
    end

    return new_update_states
end


function sharedstates.create_draw_states()
    local new_draw_states = {}
    
    function new_draw_states.knockover(self,dx,dy,dz,f,ox)
        love.graphics.draw(self.frames.knockover,dx, dy - dz,nil,f,1,ox)
    end

    function new_draw_states.down(self,dx,dy,dz,f,ox)
        love.graphics.draw(self.frames.knockover,dx, dy - dz+4,nil,f,1,ox)
    end

    function new_draw_states.hit1(self,dx,dy,dz,f,ox)
        love.graphics.draw(self.frames.hit,dx, dy - dz,nil,f,1,ox)
    end
    function new_draw_states.hit2(self,dx,dy,dz,f,ox)
        love.graphics.draw(self.frames.hit,dx, dy - dz,nil,f,1,ox)
    end
    
    function new_draw_states.punch1(self,dx,dy,dz,f,ox)
        love.graphics.draw(self.frames.punch1, dx, dy - dz,nil,f,1,ox)
    end
    function new_draw_states.punch2(self,dx,dy,dz,f,ox)
        love.graphics.draw(self.frames.punch2, dx, dy - dz,nil,f,1,ox)
    end    

    function new_draw_states.uppercut1(self,dx,dy,dz,f,ox)
        love.graphics.draw(self.frames.uppercut1, dx, dy - dz,nil,f,1,ox)
    end
    function new_draw_states.uppercut2(self,dx,dy,dz,f,ox)
        love.graphics.draw(self.frames.uppercut2, dx, dy - dz,nil,f,1,ox)
    end    

    function new_draw_states.kick1(self,dx,dy,dz,f,ox)
        love.graphics.draw(self.frames.kick1, dx, dy - dz,nil,f,1,ox)
    end
    function new_draw_states.kick2(self,dx,dy,dz,f,ox)
        love.graphics.draw(self.frames.kick2, dx, dy - dz,nil,f,1,ox)
    end
        
    function new_draw_states.elbow1(self,dx,dy,dz,f,ox)
        love.graphics.draw(self.frames.elbow1, dx, dy - dz,nil,f,1,ox)
    end
    function new_draw_states.elbow2(self,dx,dy,dz,f,ox)
        love.graphics.draw(self.frames.elbow2, dx, dy - dz,nil,f,1,ox)
    end
    
    return new_draw_states
end

return sharedstates