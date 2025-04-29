-- 类的定义放这里

-- 因为pico8不支持lua中导入模块，所以在p8主文件中导入了middleclass，并将名称直接改为了class
-- 忽略这里class未定义的报错

-------------------------------------
-- 基础类声明 ↓
-------------------------------------

-- 【向量】
local vector_class = class("vector_class")
function vector_class:initialize(dx,dy)
    self.dx = dx
    self.dy = dy
end

-- 【margin】
local margin_class = class("margin_class")
function margin_class:initialize(left,right,top,bottom)
    self.left = left
    self.right = right
    self.top = top
    self.bottom = bottom
end

-- 【位置类】
-- 坐标（横坐标x、纵坐标y）
local position_class = class("position_class")
function position_class:initialize(x,y)
    self.x = x
    self.y = y
end
-- 屏幕内的最大坐标
position_class.static.min = 0
-- 屏幕内的最小坐标
position_class.static.max = 127
-- 屏幕内的中心坐标
position_class.static.mid = (position_class.min + position_class.max) / 2 
-- 若横向纵向同时移动，速度的修正比例（根号二分支一）
position_class.static.speed_adjust_rate = 0.7
-- 移动
-- @param dx 横坐标移动“向量”
-- @param dy 纵坐标移动“向量”
function position_class:move(dx,dy)
    self.x += dx
    self.y += dy
end
-- 移动
-- @param vector 移动向量
function position_class:move(vector)
    if vector:isInstanceOf(vector_class) then
        self.x += vector.dx
        self.y += vector.dy
    end
end

-- 【物体类（无精灵）】
-- 坐标（横坐标x、纵坐标y）
-- 大小（宽w、高h）
-- 中心位置（横坐标mid_x、纵坐标mid_y）(用于逻辑判断)
-- 移动速度（s）
local object_class = class('object_class', position_class)
function object_class:initialize(x,y,w,h,s,v)
    position_class.initialize(self,x,y)
    self.w = w
    self.h = h
    self.s = s
    self.v = v
    self.mid_x = x + w / 2
    self.mid_y = y + h / 2
end

-- 【物体类】
-- 坐标（横坐标x、纵坐标y）
-- 大小（宽w、高h）
-- 移动速度（s）
local sprite_class = class('sprite_class', object_class)
function sprite_class:initialize(x,y,w,h,s,v,spr)
    object_class.initialize(self,x,y,w,h,s,v)
    self.spr = spr
end
sprite_class.static.spr_size = 8

-------------------------------------
-- 自定义类声明 ↓
-------------------------------------




