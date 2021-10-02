local hitbox = {}

function hitbox.new(ox, oy, width, height, callback) 
    local new_hitbox = {}
    new_hitbox.ox = ox
    new_hitbox.oy = oy
    new_hitbox.width = width
    new_hitbox.height = height
    new_hitbox.callback = callback
    new_hitbox.cooldown = 0
    return new_hitbox
end

function hitbox.tryhit(attacker, x, y, width, height, callback_arg)
    for i, v in pairs(world.objects) do
        if v.hitbox then
            hit = v.hitbox

            a_x0 = x
            a_y0 = y
            a_x1 = x + width
            a_y1 = y + height
            
            b_x0 = (v.x + hit.ox)
            b_y0 = (v.y + hit.oy)
            b_x1 = (v.x + hit.ox + hit.width)
            b_y1 = (v.y + hit.oy + hit.height)

            if (a_x0 < b_x1) and (b_x0 < a_x1) and (a_y0 < b_y1) and (b_y0 < a_y1) then
                -- print("attacker : " .. attacker.tag)
                -- print("A = {" .. a_x0 .. ", " .. a_y0 .. "}, B = {" .. a_x1 .. ", " .. a_y1 .. "}")
                -- print("target   : " .. v.tag)
                -- print("A = {" .. b_x0 .. ", " .. b_y0 .. "}, B = {" .. b_x1 .. ", " .. b_y1 .. "}")
                -- print()
                v.hitbox.callback(attacker, callback_arg)
            end
        end
    end
end

return hitbox