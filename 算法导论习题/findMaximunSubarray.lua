local t = {13, -3, -25, 20, -3, -16, -23, 18, 20, -7, 12, -5, -22, 15, -4, 7}

function stupidFind(A)
	local s, e, sun, maxSun = 1, 1, 0, A[1]
	local len = #A
	for i = 1, len do
		sun = A[i]
		for j = i + 1, len do
			sun = sun + A[j]
			if sun > maxSun then
				s = i
				e = j
				maxSun = sun
			end
		end
	end
	print(string.format("s = %d e = %d maxSun = %d", s, e, maxSun))
end


-- local t = {13, -3, -25, 20, -3, -16, -23, 18, 20, -7, 12, -5, -22, 15, -4, 7}
function crossFind(A, s, m, e)
	local sun = A[m]
	
	local prevIndex = m - 1
	if prevIndex < s then
		prevIndex = false
	end
	local suffIndex = m + 1
	if suffIndex > e then
		suffIndex = false 
	end
--	print("sun ", sun, prevIndex, suffIndex)
	local maxSun, sunV, low = 0, 0, m
	if prevIndex then
		for i = prevIndex, s, -1 do
			sunV = sunV + A[i]
			if sunV > maxSun then
				maxSun = sunV
				low = i
			end
		end
		sun = sun + maxSun
--		print("prev", sun, maxSun)
	end
	
	maxSun = 0
	sunV = 0
	local high = m
	if suffIndex then
		for i = suffIndex, e do
			sunV = sunV + A[i]
			if sunV > maxSun then
				maxSun = sunV
				high = i 
			end
		end
		sun = sun + maxSun
--		print("suff", sun, maxSun)
	end

	return low, high, sun
end
local index = 0
function wholeFind(A, s, m, e)
	local s, e = s or 1, e or #A 
	local m = m or math.floor((s + e) / 2)
	index = index + 1
	if s == e then
		return s, s, A[s]
	end
	
	local llow, lhigh, lsun = wholeFind(A, s, math.floor((s + m) / 2), m)
--	print("index llow, lhigh, lsun", index, s, math.floor((s + m) / 2), m, llow, lhigh, lsun)
	local rlow, rhigh, rsun = wholeFind(A, m + 1, math.floor((m + 1 + e) / 2), e)
--	print("index rlow, rhigh, rsun", index, m + 1, math.floor((m + 1 + e) / 2), e, rlow, rhigh, rsun)
	local clow, chigh, csun = crossFind(A, s, m, e)
--	print("index clow, chigh, csun", index, s, m, e, clow, chigh, csun)
	if lsun < rsun then
		if rsun < csun then
			return clow, chigh, csun
		else
			return rlow, rhigh, rsun
		end
	else
		if lsun < csun then
			return clow, chigh, csun
		else
			return llow, lhigh, lsun
		end
	end
end

-- local t = {13, -3, -25, 20, -3, -16, -23, 18, 20, -7, 12, -5, -22, 15, -4, 7}
function iterationFind(A)
	-- 内部最大 边界最大
	local maxSun, maxRightSun = A[1], A[1]
	--local sun, rightSun = maxSun, maxRightSun
	local low, high = 1, 1
	local rlow, rhigh = 1, 1
	for i = 2, #A do
		if A[i] > 0 and high + 1 == i then
			local sun = maxSun + A[i]
			maxSun = sun
			high = i
		end
		
		rhigh = i
		if maxRightSun > 0 then
			maxRightSun = maxRightSun + A[i]
		else
			local ss = A[i]
			maxRightSun = ss
			rlow = i
			for j = i - 1, 1 do
				ss = ss + A[j]
				if ss > maxRightSun then
					maxRightSun = ss
					rlow = j
				end
			end
		end
		
		if maxSun < maxRightSun then
			maxSun = maxRightSun
			low = rlow
			high = rhigh
		end
	end
	
	print(maxSun, low, high)
	print(maxRightSun, rlow, rhigh)
end

--stupidFind(t)
--print(wholeFind(t))
--print(crossFind(t, 1, 2, 3))
--print(wholeFind(t, 1, 1, 2))
--print(crossFind(t, 1, 8, 16))
local t2 = {13, -3, -25, 20, -3, -16, -23, 18, 20, -7, 12, -5, -22, 15, -4, 7}
local num = 16
local t1 = {}
for i = 1, num do
	table.insert(t1, t2[i])
end
iterationFind(t1)