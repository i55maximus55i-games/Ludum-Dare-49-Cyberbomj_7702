return function (x,y)
    local player = {}
    player.inputbuffer = {}
    player.x = x
    player.y = y
    player.tt = 0
    function player.update(self,dt)
        self.tt = self.tt + dt
        self.x = self.x + math.sin(self.tt)
        self.y = self.y + math.cos(self.tt)
    end
    function player.draw(self,dt)
        love.graphics.circle("fill", self.x, self.y, 16,16)
    end

    return player
end