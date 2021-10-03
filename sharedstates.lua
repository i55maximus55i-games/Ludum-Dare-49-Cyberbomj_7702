local sharedstates = {}

sharedstates.update_states = {}
sharedstates.draw_states = {}

function sharedstates.create_update_states()
    local new_update_states = {}
    function new_update_states.punch1(self)
        if self.statetimer > 0.1 then
            self:setstate("punch2")
        end
    end
    function new_update_states.punch2(self)
        if self.left then
            hitbox.tryhit(self, self.x, self.y+12, self.z, 5, 5, 5, {-5, 0, 5})            
        else
            hitbox.tryhit(self, self.x+19, self.y+12, self.z, 5, 5, 5, {5, 0, 5})
        end
        if self.statetimer > 0.1 then
            self:setstate("normal")
        end
    end
    return new_update_states
end


function sharedstates.create_draw_states()
    local new_draw_states = {}
    function new_draw_states.punch1(self,dx,dy,dz,f,ox)
        love.graphics.draw(self.frames.punch1, dx, dy - dz,nil,f,1,ox)
    end
    function new_draw_states.punch2(self,dx,dy,dz,f,ox)
        love.graphics.draw(self.frames.punch2, dx, dy - dz,nil,f,1,ox)
    end
    return new_draw_states
end

return sharedstates