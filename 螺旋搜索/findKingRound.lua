-- 世界分区域
--[[
-----------------
leftTop	| 	top	|rightTop|
-----|
]]
local DirCode = {
    -- inside = 0,--0b0000,
    left = 1,--0b0001,
    right = 2,--0b0010,
    top = 8,--0b1000,
    bottom = 4,--0b0100
    leftTop = 9,
    rightTop = 10,
    leftBottom = 5,
    rightBottom = 6,
}

local BlockCode = {
	
}


-- (2*level)^2
local LevelGather = {}
local getRoundInfo
local function getLevel(value)
	-- 可优化
	local level = math.ceil(math.sqrt(value) / 2) 
	return level
end
local function getMaxValueByLevel(level)
	return (2 * level) ^ 2
end
-- 获取该层的最大最小数字
local function getLevelInfo(level)
	if not LevelGather or not LevelGather[level] then
		LevelGather[level] = {}
		LevelGather[level].minValue = getMaxValueByLevel(level - 1) + 1
		LevelGather[level].maxValue = getMaxValueByLevel(level)
	end
	return LevelGather[level].minValue, LevelGather[level].maxValue
end

-- 给出一个数值 获取他所在区域 以及 区域内的位置
local function getPosByValue(value)
	local level = getLevel(value)
	local minV, maxV = getLevelInfo(level)
	local index = value - minV
	local interval = (maxV - minV + 1) / 4
	local block = math.floor(index / interval) + 1
	local pos = index % interval + 1
 	return block, pos, level, interval
end
-- 获取数值 第几层 哪个区域 区域内的位置
local function getValue(level, block, pos)
	if level < 1 then
		if block == 1 then
			block = 2
			pos = 1
		elseif block == 2 then
			block = 3
			pos = 1
		elseif block == 3 then
			block = 4
			pos = 1
		elseif block == 4 then
			block = 1
			pos = 1
		end
		-- print("blockblock", level, block, pos)
		return getValue(1, block, pos)
	end
	local minV, maxV = getLevelInfo(level)
	local interval = (maxV - minV + 1) / 4
	if pos <= 0 then
		if block == 1 then
			block = 4
			pos = interval
		elseif block == 2 then
			block = block - 1
			pos = interval
		elseif block == 3 then
			block = block - 1
			pos = interval
		end
	elseif pos > interval then
		if block == 1 then
			block = block + 1
			pos = 1
			return getValue(level + 1, block, pos)
		elseif block == 2 then
			block = block + 1
			pos = 1
			return getValue(level + 1, block, pos)
		elseif block == 3 then
			block = block + 1
			pos = 1
			return getValue(level + 1, block, pos)
		end
	end
	local value = interval * (block - 1) + pos - 1
	-- print("getValue", minV + value)
	return minV + value
end

local function getDirRoundValue(value, dir)
	local block, pos, level = getPosByValue(value)
	if block == 1 then
		if dir == DirCode.top then
			level = level + 1
			pos = pos + 1
		elseif dir == DirCode.left then
			pos = pos - 1
		elseif dir == DirCode.right then
			pos = pos + 1
		elseif dir == DirCode.bottom then
			pos = pos - 1
			level = level - 1
		end
	elseif block == 2 then
		if dir == DirCode.top then
			pos = pos - 1
		elseif dir == DirCode.left then
			level = level - 1
			pos = pos - 1
		elseif dir == DirCode.right then
			level = level + 1
			pos = pos + 1
		elseif dir == DirCode.bottom then
			pos = pos + 1
		end
	elseif block == 3 then
		if dir == DirCode.top then
			level = level - 1
			pos = pos - 1
		elseif dir == DirCode.left then
			pos = pos + 1
		elseif dir == DirCode.right then
			pos = pos - 1
		elseif dir == DirCode.bottom then
			level = level + 1
			pos = pos + 1
		end
	elseif block == 4 then
		if dir == DirCode.top then
			pos = pos + 1
		elseif dir == DirCode.left then
			level = level + 1
			pos = pos + 1
		elseif dir == DirCode.right then
			level = level - 1
			pos = pos - 1
		elseif dir == DirCode.bottom then
			pos = pos - 1
		end	
	end
	return getValue(level, block, pos)
end

-- dir 方向 0代表all
local function getRoundValue(value, dir)
	local valueTable = {}
	if dir then
		table.insert(valueTable, getDirRoundValue(value, dir))
	else
		local dirTable = {DirCode.top, DirCode.right, DirCode.bottom, DirCode.left}
		for i, v in ipairs(dirTable) do
			table.insert(valueTable, getDirRoundValue(value, v))
		end
	end
	print("value ", value)
	for i, v in ipairs(valueTable) do
		print("		", v)
	end
	return valueTable
end

-- 取3为原点 算各点坐标
local function getCoordByValue(value)
	local block, pos, level, interval = getPosByValue(value)
	local coord = {x = 0, y = 0}
	if block == 1 then
		coord.y = level
		local offset = level > 1 and level - 1 or 0
		coord.x = pos - offset
	elseif block == 2 then
		coord.x = level
		coord.y = interval - pos - (level - 1)
	elseif block == 3 then
		coord.y = - (level - 1)
		coord.x = interval - pos - (level - 1)
	elseif block == 4 then
		coord.x = - (level - 1)
		coord.y = pos - (level - 1)
	end
	print(coord.x, coord.y)
	return coord
end

local function getIntervalByLevel(level)
	local minV, maxV = getLevelInfo(level)
	local interval = (maxV - minV + 1) / 4
	return interval
end
-- 每区取值范围
--[[
    1 y = -x + 2 y = x y > 0
    2 y = 2 * x - 2  y = -x + 1 x > 0
    	x > 0 
    3 y = x y = -x  y <= 0 
		y <= 0 x >= y and x <= -y 
    4 y = x + 1 (x < 0) -> y = - x + 1
    	x <= 0 y >= x + 1 and y <= -x + 1
]]
-- 从某个位置 获取该点的数据
local function getValueByCoord(coord)
	local block, pos, level
	local x, y = coord.x, coord.y
	if x <= 0 and y >= x + 1 and y <= -x + 1 then
		block = 4
	elseif y > 0 and x >= 2 - y and x <= y then
		block = 1
	elseif x > 0 and y <= 2 * x - 2 and y >= -x + 1 then
		block = 2
	elseif y <= 0 and x >= y and x <= -y  then
		block = 3
	else
		print("error ", x, y)
	end
	if block == 1 then
		level = y
		local offset = level > 1 and level - 1 or 0
		pos = x + offset
	elseif block == 2 then
		level = x
		local interval = getIntervalByLevel(level)
		pos = interval - (level - 1) - y
	elseif block == 3 then
		level = -y + 1
		local interval = getIntervalByLevel(level)
		pos = interval - (level - 1) - x
	elseif block == 4 then
		level = -x + 1
		pos = y + level - 1
	end
	--print(level, block, pos)
	local value = getValue(level, block, pos)
	return value, block, pos, level
end

local ColorDefalut = {}
local DefalutColorInfo = {
	{coord = {x = 0, y = 0}, color = "000"},
	{coord = {x = 1, y = 0}, color = "010"},
	{coord = {x = 2, y = 0}, color = "100"},
	{coord = {x = 2, y = 1}, color = "110"},
	{coord = {x = 1, y = 1}, color = "011"},
	{coord = {x = 0, y = 1}, color = "001"},
}
for i, v in ipairs(DefalutColorInfo) do
	local coord = v.coord
	if not DefalutColorInfo[coord.x] then
		DefalutColorInfo[coord.x] = {}
	end
	if not DefalutColorInfo[coord.x][coord.y] then
		DefalutColorInfo[coord.x][coord.y] = {}
	end
	DefalutColorInfo[coord.x][coord.y].color = v.color
end

local DefalutSize = {width = 3, height = 2}
local function getColorByCoord(coord)
	local w = coord.x % DefalutSize.width
	local h = coord.y % DefalutSize.height
	return DefalutColorInfo[w][h].color
end

for y = 5, -5 , -1 do
	local ss = ""
	for x = -5, 5 do
		local coord = {x = x, y = y}
		local value = getValueByCoord(coord)
		local color = getColorByCoord(coord)
		ss = string.format("%s%3d(%d) ", ss, value, color)
	end
	print(ss)
	print("------------")
end
