return function (x,y,path)
    local new_picture = {}

    new_picture.drawable = love.graphics.newImage(path)
    new_picture.x = x
    new_picture.y = y

    function new_picture.draw(self)
        love.graphics.draw(self.drawable,self.x,self.y)
    end

    function new_picture.update(self)
        --nop
    end

    return new_picture
end