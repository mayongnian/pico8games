
-- pico character set
-- ⬅️➡️⬆️⬇️🅾️❎♥

function global()
    const = {
        screen_min = 0,
        screen_max = 127,
        screen_middle = 63.5,
        pixel_fix = 2,
        -- 精灵每个单位像素数
        spr_pixels = 8
    }
end

function remove_element_unordered(list, index)
    list[index] = list[#list] -- 将最后一个元素移到目标位置
    list[#list] = nil         -- 删除最后一个元素
end

-- 定义共享的向量方法
local function vector_add(self, v)
    self.x = self.x + v.x
    self.y = self.y + v.y
end

local function vector_sub(self, v)
    self.x = self.x - v.x
    self.y = self.y - v.y
end

local function vector_mul(self, scalar)
    self.x = self.x * scalar
    self.y = self.y * scalar
end

local function vector_length(self)
    return sqrt(self.x ^ 2 + self.y ^ 2)
end

local function vector_normalize(self)
    local len = self:length()
    if len > 0 then
        self.x = self.x / len
        self.y = self.y / len
    end
end

function new_vector(x, y)
    local obj = {}
    obj.x = x or 0
    obj.y = y or 0

    -- 绑定共享方法
    obj.add = vector_add
    obj.sub = vector_sub
    obj.mul = vector_mul
    obj.length = vector_length
    obj.normalize = vector_normalize

    obj:normalize() -- 自动归一化
    return obj
end

function get_hit_box(obj)
    -- 获取对象的碰撞盒
    local hit_box = {}
    hit_box.x1 = obj.x + obj.hit_box.x
    hit_box.x2 = obj.x + obj.hit_box.x + obj.hit_box.w
    hit_box.y1 = obj.y + obj.hit_box.y
    hit_box.y2 = obj.y + obj.hit_box.y + obj.hit_box.h
    return hit_box
end

function new_hit_box(x, y, w, h)
    local obj = {}
    obj.x = x
    obj.y = y
    obj.w = w
    obj.h = h
    return obj
end

function move_with_dpad(obj)
    -- 玩家对象的移动
    if btn(0) then
        obj.x = obj.x - obj.speed
    end
    if btn(1) then
        obj.x = obj.x + obj.speed
    end
    -- 边界检测
    local ohb = get_hit_box(obj)
    if ohb.x1 < const.screen_min then
        obj.x = const.screen_min - obj.hit_box.x
    end
    if ohb.x2 > const.screen_max then
        obj.x = const.screen_max - (obj.hit_box.w + obj.hit_box.x)
    end
end

-- 根据对象的向量移动
-- param 对象 obj
-- param 加速倍率 speed_adjust_rate
function move_with_vector(obj, speed_multi)
    -- 小球对象的移动
    obj.x = obj.x + obj.vector.x 
        * (speed_multi == nil and obj.speed or obj.speed * speed_multi)
    obj.y = obj.y + obj.vector.y
        * (speed_multi == nil and obj.speed or obj.speed * speed_multi)
end