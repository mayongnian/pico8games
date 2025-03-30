-- 参数放这里

-- 物体有哪些
-- 1、玩家控制的板子
-- 2、来回弹射的小球
-- 3、砖块

-- 1
local player_params = {
    spr_w = sprite_class.spr_size * 2,
    spr_h = sprite_class.spr_size,
    w = 16,
    h = 2
}
-- 全局变量 player
player = sprite_class : new (
    position_class.mid - player_params.spr_w / 2, 
    position_class.max - player_params.spr_h, 
    player_params.w, 
    player_params.h,
    2,
    nil, 
    {1,1,1}
)

-- 2
local ball_params = {
    r = 2
}
-- 全局变量 balls
balls = {}
add(balls,sprite_class:new(
    position_class.mid, 
    position_class.max - ball_params.r - player_params.h, 
    ball_params.r, 
    ball_params.r,
    1.5,
    vector_class:new(0.7,-0.7), 
    10
))

