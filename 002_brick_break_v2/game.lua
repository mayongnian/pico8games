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
    move_with_dpad(player)
    ability_use()

    -- 小球的碰撞检测 TODO 待重构，这里直接用了全局变量
    game_object_move()

    -- debug工具
    -- debug_prop_ballplus()
end

-- 3、绘制
function _draw()
    cls()
    draw_debug_bottom()
    if stage == "welcome" then
        -- 初始界面
        print("🅾️ shoot", 40, const.screen_middle + 24, 7)
        print("❎ use power", 40, const.screen_middle + 32, 7)
        print("press 🅾️ to start", 32, const.screen_max - 8, 7)
    elseif stage == "serve" or stage == "game" then
        -- 游戏界面
        for i = 1, #balls do
            -- 绘制小球
            circfill(balls[i].x, balls[i].y, balls[i].r, balls[i].color)
        end
        -- 绘制砖块
        for i = 1, #bricks do
            -- 绘制砖块
            rectfill(bricks[i].x, bricks[i].y, bricks[i].x + bricks[i].w, bricks[i].y + bricks[i].h, bricks[i].color)
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

