local world = {
    objects = {},
    update = function(self,dt) 
        for i,v in pairs(self.objects) do
            v:update(dt)
        end
    end,
    draw = function(self,dt)
        table.sort(self.objects, function (left, right)
            return left.y < right.y
        end)
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
        local todelete = nil
        for i,v in pairs(o) do
            if v.myid == old.myid then
                todelete = i
            end
        end
        if o[todelete] then
            table.remove(o,todelete)
        else
            print("Deleting nonexistant object",todelete)
        end
    end
}
return world