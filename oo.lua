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
        o[#o+1] = new
        new.myid = #o
    end,
    del = function(self,old) 
        local o = self.objects
        o[old.myid] = nil
    end
}
return world