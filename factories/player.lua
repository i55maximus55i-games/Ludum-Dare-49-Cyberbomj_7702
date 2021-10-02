return function (joyrecord,x,y)
    local player = {}
    player.joy = joyrecord.instance
    player.inputbuffer = {}
    player.x = x
    player.y = y
    player.tt = 0
    player.left = false

    function player.update(self,dt)
        self.tt = self.tt + dt
        local ax1, ax2, ax3, ax4 = self.joy:getAxes()
        self.x = self.x + ax1
        self.y = self.y + ax2
        self.left = ax1 < 0
    end
    function player.draw(self,dt)
        love.graphics.circle("fill", self.x, self.y, 16,16)
    end

    return player
end