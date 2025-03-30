-- 类的定义放这里

-- 因为pico8不支持lua中导入模块，所以在p8主文件中导入了middleclass，并将名称直接改为了class
-- 忽略这里class未定义的报错

-------------------------------------
-- 基础类声明 ↓
-------------------------------------

-- 【位置类】
-- 坐标（横坐标x、纵坐标y）
local position_class = class("position_class")
function position_class:initialize(x,y)
    self.x = x
    self.y = y
end
position_class.static.min = 0
position_class.static.max = 127

-- 【物体类（无精灵）】
-- 坐标（横坐标x、纵坐标y）
-- 大小（宽w、高h）
-- 移动速度（s）
local object_class = class('object_class', position_class)
function object_class:initialize(x,y,w,h,s)
    position_class.initialize(x,y,w,h)
    self.s = s
end

-- 【物体类】
-- 坐标（横坐标x、纵坐标y）
-- 大小（宽w、高h）
-- 移动速度（s）
local spr_class = class('spr_class', object_class)
function object_class:initialize(x,y,w,h,s,spr)
    object_class.initialize(x,y,w,h)
    self.spr = spr
end

-------------------------------------
-- 自定义类声明 ↓
-------------------------------------



