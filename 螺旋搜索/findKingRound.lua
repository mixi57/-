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
local function getLevelInfo(level)
	if not LevelGather or not LevelGather[level] then
		LevelGather[level] = {}
		LevelGather[level].minValue = getMaxValueByLevel(level - 1) + 1
		LevelGather[level].maxValue = getMaxValueByLevel(level)
	end
	return LevelGather[level].minValue, LevelGather[level].maxValue
end
local function getPosByValue(value)
	local level = getLevel(value)
	local minV, maxV = getLevelInfo(level)
--	print("minV maxV", minV, maxV)
	local index = value - minV-- + 1
--	print("index", index)
	local interval = (maxV - minV + 1) / 4
--	print("interval", interval)
	local dir = math.floor(index / interval) + 1--(level ~= 1 and 1 or 0)
	local pos = index % interval + 1 --(level ~= 1 and 0 or 1)
--	print(dir, pos)
	getRoundInfo(level, dir, pos)
 	return dir, pos 
end
local function getValue(level, dir, pos)
	if level < 1 then
		if dir == 1 then
			dir = 2
			pos = 1
		elseif dir == 2 then
			dir = 3
			pos = 1
		elseif dir == 3 then
			dir = 4
			pos = 1
		elseif dir == 4 then
			dir = 1
			pos = 1
		end
		print("dirdir", level, dir, pos)
		return getValue(1, dir, pos)
	end
	local minV, maxV = getLevelInfo(level)
	local interval = (maxV - minV + 1) / 4
	if pos <= 0 then
		if dir == 1 then
			dir = 4
			pos = interval
		elseif dir == 2 then
			dir = dir - 1
			pos = interval
		elseif dir == 3 then
			dir = dir - 1
			pos = interval
		end
	elseif pos > interval then
		if dir == 1 then
			dir = dir + 1
			pos = 1
			return getValue(level + 1, dir, pos)
		elseif dir == 2 then
			dir = dir + 1
			pos = 1
			return getValue(level + 1, dir, pos)
		elseif dir == 3 then
			dir = dir + 1
			pos = 1
			return getValue(level + 1, dir, pos)
		end
	end
	local value = interval * (dir - 1) + pos - 1
	print("getValue", minV + value)
	return minV + value
end
getRoundInfo = function(level, dir, pos)
	local top, left, bottom, right
	
	if dir == 1 then
		top = getValue(level + 1, dir, pos + 1)
		left = getValue(level, dir, pos - 1)
		right = getValue(level, dir, pos + 1)
		bottom = getValue(level - 1, dir, pos - 1)
	elseif dir == 2 then
		top = getValue(level, dir, pos - 1)
		left = getValue(level - 1, dir, pos - 1)
		right = getValue(level + 1, dir, pos + 1)
		bottom = getValue(level, dir, pos + 1)
	elseif dir == 3 then
		top = getValue(level - 1, dir, pos - 1)
		left = getValue(level, dir, pos + 1)
		right = getValue(level, dir, pos - 1)
		bottom = getValue(level + 1, dir, pos + 1)
	elseif dir == 4 then
		top = getValue(level, dir, pos + 1)
		left = getValue(level + 1, dir, pos + 1)
		right = getValue(level - 1, dir, pos - 1)
		bottom = getValue(level, dir, pos - 1)
	end
	print(top, left, bottom, right)
	return top, left, bottom, right
end
math.randomseed(os.time()) 
local testNum = math.random(5, 36)
print("testNum", testNum)
local level = getLevel(testNum)
print(level)
local value = getValue(level, getPosByValue(testNum))



--print(value)
--[[
print(level)
print(getLevelInfo(level))
print(getPosByValue(testNum))]]
