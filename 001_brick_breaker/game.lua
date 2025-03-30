-- 1、初始化
function _init()

end

-- 2、更新
function _update()
    -- 1、小球遇到转角或者板子，则反弹的角度有一定的随机性，或者有一定的变化，这里的算法:
    -- TODO
    -- 2、砖块的碰撞检测，边缘的碰撞检测，板子的碰撞检测
    -- TODO
    
    move_with_vector(balls[1])
    move_with_btn(player,true,false,false)
    
end

-- 3、绘制
function _draw()
    cls()
    draw_sprite(player)
    draw_shape(balls[1])
end


