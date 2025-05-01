function debug_prop_ballplus()
    if btn(4) then
        -- 测试：吃到增加球的道具
        balls[#balls + 1] = new_ball('ball', next_color)
        next_color = next_color + 1 == 16 and 1 or (next_color + 1) % 16
    end
end
