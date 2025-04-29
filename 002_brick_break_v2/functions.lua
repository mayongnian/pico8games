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
        -- 按下z键，开始发球
        stage = "serve"
    elseif stage == "serve" and btnp(4) then
        -- 发球后正式开始游戏
        stage = "game"
        -- 给小球一个初速度
        balls[1].vector = new_vector(1, -1)
    elseif stage == "game" then
        if player.hp <= 0 then
            -- 游玩时玩家生命值为0，游戏结束
            stage = "over"
        elseif #balls == 0 then
            -- 所有小球都消失，并且还有剩余生命，重新发球
            stage = "serve"
            -- 新增一个小球
            balls[#balls + 1] = new_ball('player')
        end
    elseif stage == "over" and btnp(4) then
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
    if type == 'player' then
        -- 1、玩家所在位置（新发球）；
        obj.x = ((const.screen_min + const.screen_max) / 2) - obj.r / 2
        obj.y = const.screen_max - obj.r
        obj.vector = new_vector(0, 0)
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
    obj.speed = 4
    obj.hit_box = new_hit_box(-obj.r, -obj.r, obj.r * 2, obj.r * 2)
    return obj
end

-- 小球的碰撞检测
function balls_hit_detect()
    local phb = get_hit_box(player)
    for i = #balls, 1, -1 do
        move_with_vector(balls[i])
        -- 小球与玩家的碰撞检测
        if balls[i].x + balls[i].r > phb.x1 and
            balls[i].x - balls[i].r < phb.x2 and
            balls[i].y + balls[i].r > phb.y1 and
            balls[i].y - balls[i].r < phb.y2 then
            balls[i].vector.y = -balls[i].vector.y
        end
        -- 小球与左、上、右边界的碰撞检测
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
        -- 删除超出屏幕的小球
        if balls[i].y - balls[i].r > const.screen_max then
            remove_element_unordered(balls, i)
            if player.hp > 0 then
                player.hp = player.hp - 1
            end
        end
    end
end
