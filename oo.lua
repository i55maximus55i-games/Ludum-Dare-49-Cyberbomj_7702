local world = {
    objects = {},
    update = function(self,dt) 
        for i,v in pairs(self.objects) do
            v:update(dt)
        end
    end,
    draw = function(self,dt)
        for i,v in pairs(self.objects) do
            v:draw(dt)
        end
    end,
    add = function(self,new)
        local o = self.objects
        local newid = love.math.random(999999999)
        o[#o+1] = new
        new.myid = newid
    end,
    del = function(self,old) 
        local o = self.objects
        for i,v in pairs(o) do
            if v.myid == old.myid then
                o[i] = nil
            end
        end
    end
}
return world