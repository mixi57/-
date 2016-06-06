-- 买买买计算器 凑单计算器
local price = {1, 4, 3, 5}
local maxOverflow = 2
local targetPrice = 10

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
	print(num, index, p)
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
		indexT[tonumber(index)] = true
		local priceG = price[index]
		if priceIntervalT[num - 1] then
			local priceIntervalIndexT = priceIntervalT[num - 1]
			for i, p in pairs(priceIntervalIndexT) do
				local oldIndexT = globalIndexT[i]
				if not oldIndexT[index] then
					local newT = cloneTable(oldIndexT)
					newT[index] = true
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
for num, info in pairs(priceIntervalT) do
	--print(num)
	for i, p in pairs(info) do
		if targetPrice <= p and p <= targetPrice + maxOverflow then
			print(p)
			local indexT = globalIndexT[i]
			for index, _ in pairs(indexT) do
				print("index", index)
			end
			print("------")
		end
	end
end