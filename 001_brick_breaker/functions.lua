-- 通用方法放这里

-- 玩家移动是通过按钮控制的
-- @param_type object_class
function move_with_btn(object,is_not_vertical,is_not_horizontal,is_not_screen_border_detect)
    local speed
    if is_not_vertical or is_not_horizontal then
        speed = object.s
    elseif btn(0) and btn(2) or btn(0) and btn(3) or btn(1) and btn(2) or btn(1) and btn(3) then
        speed = object.s * position_class.speed_adjust_rate
    else
        speed = object.s
    end
    -- 是否可以向左移动
    is_move_direcr_0 = 
        not is_not_horizontal 
        and btn(0) 
        and (is_not_screen_border_detect or not is_not_screen_border_detect and object.x - speed >= position_class.min)
    -- 是否可以向右移动
    is_move_direcr_1 = 
        not is_not_horizontal 
        and btn(1) 
        and (is_not_screen_border_detect or not is_not_screen_border_detect and object.x + object.w + speed <= position_class.max)
    -- 是否可以向上移动
    is_move_direcr_2 = 
        not is_not_vertical 
        and btn(2) 
        and (is_not_screen_border_detect or not is_not_screen_border_detect and object.y - speed >= position_class.min)
    -- 是否可以向下移动
    is_move_direcr_3 = 
        not is_not_vertical 
        and btn(3) 
        and (is_not_screen_border_detect or not is_not_screen_border_detect and object.y + object.h + speed <= position_class.max)
    -- 移动
    if is_move_direcr_0 then object.x -= speed end
    if is_move_direcr_1 then object.x += speed end
    if is_move_direcr_2 then object.y -= speed end
    if is_move_direcr_3 then object.y += speed end
end

function move_with_vector(object)
    object.x += object.v.dx
    object.y += object.v.dy
end

function draw_sprite(sprite)
    spr(sprite.spr,
     sprite.x, 
     sprite.y, 
     sprite.w / sprite_class.spr_size, 
     sprite.h / sprite_class.spr_size
    )
end

-- @param shape 1:circle 2:rectangle 3:line
function draw_shape(sprite,shape,is_not_solid)
    if shape == 2 then
        if is_not_solid then
            rect(sprite.x, sprite.y,sprite.x+sprite.w,sprite.y+sprite.h,sprite.spr)
        else
            rectfill(sprite.x, sprite.y,sprite.x+sprite.w,sprite.y+sprite.h,sprite.spr)
        end
    elseif shape == 3 then
        line(sprite.x, sprite.y,sprite.x+sprite.w,sprite.y+sprite.h,sprite.spr)
    else
        if is_not_solid then
            circ(sprite.x, sprite.y, sprite.w, sprite.spr)
        else
            circfill(sprite.x, sprite.y, sprite.w, sprite.spr)
        end
    end
end

-- @param object sprite_class
-- @param is_move_with_vector boolean true:向量匀速移动，加入反弹机制 false:键盘控制移动，边缘停止
-- @return is_move
-- function collision_detection_screen_edge(object, is_move_with_vector)
--     if is_move_with_vector then
--         -- 向量匀速移动，加入反弹机制
--     else
--         -- 键盘控制移动，边缘停止
--         if object.x + object.w >= position_class.max then
--         end
--         -- 加入返回值，是否继续移动
--         return false
--     end
-- end