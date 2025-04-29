---@diagnostic disable: lowercase-global

----------------------------------------------------
-- pico-8游戏循环 开始
----------------------------------------------------
-- 1、初始化
function _init()
    global()
    game_global()
end

-- 2、更新
function _update()
    switch_stage()
    if btn(4) then
        sfx(0)
    end
    move_with_dpad(player)
    -- player_hit_box
    -- 小球的碰撞检测 TODO 待重构，这里直接用了全局变量
    balls_hit_detect()
    if btn(4) then
        -- 测试：吃到增加球的道具
        -- balls[#balls + 1] = new_ball('ball', next_color)
        next_color = next_color + 1 == 16 and 1 or (next_color + 1) % 16
    end
end

-- 3、绘制
function _draw()
    cls()
    draw_debug_bottom()
    if stage == "welcome" then
        -- 初始界面
        print("press z to start", const.screen_middle, const.screen_middle, 7)
        if #balls == 0 then
            balls[#balls + 1] = new_ball('player')
        end
    elseif stage == "serve" or stage == "game" then
        -- 游戏界面
        for i = 1, #balls do
            -- 绘制小球
            circfill(balls[i].x, balls[i].y, balls[i].r, balls[i].color)
        end
        -- 绘制玩家
        spr(player.spr, player.x, player.y, player.spr_w, player.spr_h)
        draw_ui()
    elseif stage == "over" then
        -- 游戏结束
        print("game over", const.screen_middle, const.screen_middle, 7)
        print("press z to restart", const.screen_middle, const.screen_middle + 8, 7)
    end
    draw_debug_top()
end

----------------------------------------------------
-- pico-8游戏循环 结束
----------------------------------------------------

