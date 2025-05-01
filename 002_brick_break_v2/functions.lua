-- 非通用方法，只在这个游戏中用

-- 全局变量声明
function game_global()
    balls = {}
    bricks = {}
    -- 对象初始化
    player = new_player()
    -- 每次生成不同颜色的小球
    next_color = 1
    stage = "welcome"
end

-- 处理游戏状态
function switch_stage()
    if stage == "welcome" and btnp(4) then
        sfx(3)
        -- 按下z键，开始发球
        stage = "serve"
        -- 生成一个小球
        if #balls == 0 then
            balls[1] = new_ball('player')
        end
        -- 初始化砖块
        bricks = init_level(1)
    elseif stage == "serve" and btnp(4) then
        sfx(0)
        -- 发球后正式开始游戏
        stage = "game"
        -- 给小球一个初速度
        balls[1].vector = new_vector(1, -1)
        balls[1].state = 'free'
    elseif stage == "game" then
        if player.hp <= 0 then
            sfx(2)
            -- 游玩时玩家生命值为0，游戏结束
            stage = "over"
        elseif #balls == 0 then
            sfx(1)
            -- 所有小球都消失，并且还有剩余生命，重新发球
            stage = "serve"
            -- 新增一个小球
            balls[#balls + 1] = new_ball('player')
        end
    elseif stage == "over" and btnp(4) then
        sfx(0)
        -- 按下z键，重新开始游戏
        game_global()
    end
end

-- debug用的网格
function draw_grid()
    for i = const.screen_min, const.screen_max, const.spr_pixels * 2 do
        line(i, const.screen_min, i, const.screen_max, 1)
    end
    for i = const.screen_min, const.screen_max, const.spr_pixels * 2 do
        line(const.screen_min, i, const.screen_max, i, 1)
    end
end

-- 绘制ui
function draw_ui()
    -- 剩余机会
    local heart_str = ""
    for i = 1, player.hp do
        heart_str = heart_str .. "♥"
    end
    print(heart_str,0,0,4)
end

function draw_debug_bottom()
    draw_grid()
end

function draw_debug_top()
    -- 场景中活动的球数
    print("balls:"..#balls,const.screen_middle,0,7)
    print("stage:"..stage,const.screen_middle,8,7)
end

-- 玩家对象获取
function new_player()
    local obj = {}
    obj.spr_w = 3
    obj.spr_h = 1
    -- 玩家初始位置为屏幕中间最底部
    obj.x = ((const.screen_min + const.screen_max) / 2) - obj.spr_w * const.spr_pixels / 2
    obj.y = const.screen_max - (obj.spr_h * const.spr_pixels)
    obj.speed = 3
    obj.spr = 1
    obj.hit_box = new_hit_box(0, 4, 24, 4)
    obj.hp = 3
    return obj
end

-- 新增小球
-- params 初始位置类型 颜色
function new_ball(type, color)
    local obj = {}
    obj.r = 2
    -- 小球的状态
    -- attach 附着在玩家上
    -- free 自由移动（可能静止）
    obj.state = 'free'
    if type == 'player' then
        -- 1、玩家所在位置（新发球）；
        obj.x = ((const.screen_min + const.screen_max) / 2) - obj.r / 2
        obj.y = const.screen_max + obj.r * 2 - player.hit_box.h
        obj.vector = new_vector(0, 0)
        obj.state = 'attach'
    elseif type == 'ball' then
        -- 2、小球所在位置（吃到增加球的道具）；
        obj.x = balls[1].x
        obj.y = balls[1].y
        obj.vector = new_vector(-balls[1].vector.x, -balls[1].vector.y)
        balls[1].vector:add(new_vector(rnd(2) - 1, rnd(2) - 1))
        balls[1].vector:normalize()
    elseif type == 'middle' then
        -- 3、屏幕中间（debug时用）；
        obj.x = ((const.screen_min + const.screen_max) / 2) - obj.r / 2
        obj.y = ((const.screen_min + const.screen_max) / 2) - obj.r / 2
        obj.vector = new_vector(1, -1)
    end
    obj.color = color or 10
    obj.speed = 3
    obj.hit_box = new_hit_box(-obj.r, -obj.r, obj.r * 2, obj.r * 2)
    return obj
end

-- 小球的碰撞检测
function game_object_move()
    local phb = get_hit_box(player)

    -- 与小球相关的逻辑，放到同一个loop
    for i = #balls, 1, -1 do
        -- 小球的移动
        if balls[i].state == 'attach' then
            -- 小球附着在玩家上，跟随玩家移动
            balls[i].x = player.x + balls[i].hit_box.x
            balls[i].y = player.y + player.hit_box.y - balls[i].r
        elseif balls[i].state == 'free' then
            move_with_vector(balls[i], btn(4) and 2 or 1)
        end

        -- 碰撞检测
        -- 小球与玩家
        if balls[i].x + balls[i].r > phb.x1 and
            balls[i].x - balls[i].r < phb.x2 and
            balls[i].y + balls[i].r > phb.y1 and
            balls[i].y - balls[i].r < phb.y2 then
            balls[i].vector.y = -balls[i].vector.y
        end
        -- 小球与砖块
        for j = #bricks, 1, -1 do
            if balls[i].x + balls[i].r > bricks[j].x and
                balls[i].x - balls[i].r < bricks[j].x + bricks[j].w and
                balls[i].y + balls[i].r > bricks[j].y and
                balls[i].y - balls[i].r < bricks[j].y + bricks[j].h then
                -- 反弹小球
                if abs(balls[i].x - (bricks[j].x + bricks[j].w / 2)) > abs(balls[i].y - (bricks[j].y + bricks[j].h / 2)) then
                    balls[i].vector.y = -balls[i].vector.y
                else
                    balls[i].vector.x = -balls[i].vector.x
                end
                -- 撞到砖块，删除砖块
                remove_element_unordered(bricks, j)
            end
        end
        -- 小球与左、上、右边界
        if balls[i].x - balls[i].r < const.screen_min then
            balls[i].vector.x = -balls[i].vector.x
            balls[i].x = const.screen_min + balls[i].r
        end
        if balls[i].x + balls[i].r > const.screen_max then
            balls[i].vector.x = -balls[i].vector.x
            balls[i].x = const.screen_max - balls[i].r
        end
        if balls[i].y - balls[i].r < const.screen_min then
            balls[i].vector.y = -balls[i].vector.y
            balls[i].y = const.screen_min + balls[i].r
        end
        -- 小球与下边界，测试用，下边界也会弹回
        -- TODO DEBUG
        -- if balls[i].y + balls[i].r > const.screen_max then
        --     balls[i].vector.y = -balls[i].vector.y
        --     balls[i].y = const.screen_max - balls[i].r
        -- end
        -- 删除超出屏幕的小球
        if balls[i].y - balls[i].r > const.screen_max then
            remove_element_unordered(balls, i)
            if #balls == 0 then
                player.hp = player.hp - 1
            end
        end
    end
end

function init_level(level)
    -- 初始化砖块
    local bricks = {}
    local brick_w = 8
    local brick_h = 4
    local x = const.screen_min + (const.screen_max - const.screen_min) / 2 - (brick_w * 8) / 2
    local y = const.screen_min + 16
    for i = 1, 8 do
        for j = 1, 4 do
            bricks[#bricks + 1] = new_brick(x + (i - 1) * brick_w, y + (j - 1) * brick_h, brick_w, brick_h)
        end
    end
    return bricks
end
function new_brick(x, y, w, h)
    local obj = {}
    obj.x = x
    obj.y = y
    obj.w = w
    obj.h = h
    obj.hit_box = new_hit_box(0, 0, w, h)
    obj.color = 9
    return obj
end

ability_use = function()
    -- 玩家使用技能
    if btnp(5) then
        for i = 1, #balls do
            balls[i].vector:add(new_vector(rnd(2) - 1, rnd(2) - 1))
                balls[i].vector:normalize()
        end
    end
end
