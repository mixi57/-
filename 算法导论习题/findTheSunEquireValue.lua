-- 找出数组里 和为 x 的两个数
local t = {3, 4, 2, 6, 9, 5}
local sun = 11

function printAll(t)
	for i, v in pairs(t) do
		print(i, v)
	end
end

-- 遍历 --这样子是不是重复了 
function stupidFind(A, sun)
	for i = 1, #A do
		for j = i + 1, #A do
			if i ~= j then
				if A[i] + A[j] == sun then
					print(string.format("A[%d] + A[%d] = %d + %d = %d", i, j, A[i], A[j], sun))
				end
			end
		end
	end
end

--stupidFind(t, sun)

-- 方法2 归并排序
function merget(A, s, m, e)
	local i, j = s, m + 1
	local newA = {}
	local newAIndex = 1
	while i <= m and j <= e do
		if A[i] < A[j] then 
			newA[newAIndex] = A[i]
			i = i + 1
		else
			newA[newAIndex] = A[j]
			j = j + 1
		end
		newAIndex = newAIndex + 1
	end 
	
	local lastIndex = i <= m and i or j
	local lastMaxIndex = i <= m and m or e
	for k = lastIndex, lastMaxIndex do
		newA[newAIndex] = A[k]
		newAIndex = newAIndex + 1
	end
	
	for i = 1, e - s + 1 do
		A[s + i - 1] = newA[i]
	end
	return A
end

function mergetSort(A, s, m, e)
	local s, e = s or 1, e or #A
	local m = m or math.floor((s + e) / 2)
	if e <= s then
		return nil
	end
	print(s, m, e)
	local newM = math.floor((s + m) / 2)
	mergetSort(A, s, math.floor((s + m) / 2), m)
	mergetSort(A, m + 1, math.floor((m + 1 + e) / 2), e)
	A = merget(A, s, m, e)
	return A
end

--local tt = {1, 3, 4, 9, 2, 5, 6}
--printAll(merget(tt, 1, 4, 7))
--printAll(mergetSort(t))

function halfSearch(A, s, m, e, v)
	local s, e = s or 1, e or #A 
	local m = m or math.floor((s + e) / 2)
	if A[s] > v or A[e] < v then
		return false
	end
	
	if A[m] == v then
		return m
	elseif A[m] > v then
		return halfSearch(A, s, math.floor((s + m) / 2), m, v)
	else
		return halfSearch(A, m + 1, math.floor((m + 1 + e) / 2), e, v)
	end
end

--local tt = {1, 3, 5, 6, 7}
--print(halfSearch(tt, false, false, false, 7))

function wayTwoFind(A, sun)
	local A = mergetSort(A)
	local halfSun = math.ceil(sun / 2)
	for i = 1, #A do
		if A[i] < halfSun then
			local pos = halfSearch(A, false, false, false, sun - A[i])
			if pos then
				print(string.format("A[%d] + A[%d] = %d + %d = %d", i, pos, A[i], A[pos], sun))
			end
		else
			break
		end
	end
end

--wayTwoFind(t, sun)

-- 第三种方法 
function wayThreeFind(A, sun)
	local function removeSameValue(array)
		local t = {}
		for i, v in ipairs(array) do
			t[v] = true
		end
		array = {}
		for v, _ in pairs(t) do
			table.insert(array, v)
		end
		return array
	end
	
	local A = removeSameValue(A)
	A = mergetSort(A)
	local newA = {}
	for i, v in ipairs(A) do
		table.insert(newA, sun - v)
	end
	printAll(A)
	print("------")
	printAll(newA)
	local len = #A
	-- check same
	local j = len
	local i = 1
	while i <= len and j > 0 do
		if A[i] == newA[j] then
			print(string.format("%d + %d = %d", A[i], sun - A[i], sun))
			i = i + 1
			j = j - 1
		elseif A[i] < newA[j] then
			i = i + 1
		else 
			j = j - 1
		end
	end
end

wayThreeFind(t, sun)