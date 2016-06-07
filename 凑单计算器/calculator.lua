-- 买买买计算器 凑单计算器
local price = {16.4, 16.9, 12.9, 7.5, 9.6, 8.8, 7.9, 5.9, 9.8}--, 29.5, 16.4, 16.9, 7.5, 9.6, 8.8, 7.9,}
local maxOverflow = 1
local targetPrice = 199 - 178.6--38.6
local canRepeat = true
--print(math.bor()

local priceIntervalT = {}

local priceNum = #price

local globalIndexT = {}
local globalIndexNum = 0


local function getIndex(indexT)
	local value = 0
	for i, v in pairs(indexT) do
		value = value + math.pow(2, i)
	end
	return value
end
local function addIndexT(indexT)
	local index = getIndex(indexT)
	
	globalIndexT[index] = indexT
	return index
end


local function addPriceToPriceIntervalT(num, indexT, p)
	if not priceIntervalT[num] then
		priceIntervalT[num] = {}
	end
	local index = addIndexT(indexT)
	priceIntervalT[num][index] = p
	--print(num, index, p)
end

local function cloneTable(t)
	local newT = {}
	for i, v in pairs(t) do
		newT[i] = v
	end
	return newT
end

for num = 1, priceNum do
	for index = 1, priceNum do
		local indexT = {}
		indexT[tonumber(index)] = 1--true
		local priceG = price[index]
		if priceIntervalT[num - 1] then
			local priceIntervalIndexT = priceIntervalT[num - 1]
			for i, p in pairs(priceIntervalIndexT) do
				local oldIndexT = globalIndexT[i]
				-- 一开始不包含自己是为了不想重复 但是想想可以重复
				if not oldIndexT[index] then
					local newT = cloneTable(oldIndexT)
					newT[index] = (newT[index] or 0) + 1--true
					local newIndex = getIndex(newT)
					if not priceIntervalT[num] or not priceIntervalT[num][newIndex] then
						local newPriceG = priceG + p
						addPriceToPriceIntervalT(num, newT, newPriceG)
					end
				end
			end
		else
			addPriceToPriceIntervalT(num, indexT, priceG)
		end
	end
end

local newPriceT = {}
local indexTable = {}
local pTable = {}

for num, info in pairs(priceIntervalT) do
	--print(num)
	for i, p in pairs(info) do
		if targetPrice <= p and p <= targetPrice + maxOverflow then
			--print(p)
			if not indexTable[p] then
				indexTable[p] = {}
			end
			table.insert(indexTable[p], i)
			
			table.insert(pTable, p)
		end
	end
end

table.sort(pTable)
for i, p in ipairs(pTable) do
	--print(p, indexTable[p], #indexTable[p])
	for _, index in ipairs(indexTable[p]) do
		print(p)
		print("~~~~~~")
		local indexT = globalIndexT[index]
		for index, times in pairs(indexT) do
			print("index", index, times, price[index])
		end
		print("------")
	end
end