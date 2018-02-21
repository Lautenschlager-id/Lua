local enum = function(list)
	local out = {}
	
	for index, value in next, list do
		if not out[value] then
			out[value] = index
		end
	end
	
	return setmetatable({}, {
		__call = function(t, index)
			return out[index]
		end,
		__index = function(t, index)
			return list[index]
		end,
		__pairs = function()
			return next, list
		end,
		__newindex = function()
			return
		end,
		__tostring = function()
			return "enum"
		end,
		__metatable = 'enum'
	})
end

local constants = enum({
	e = 2.71828175,
	log10e = .4342945,
	log2e = 1.442695,
	pi = 3.14159274,
	piOver2 = 1.57079637,
	piOver4 = .7853982,
	twoPi = 6.28318548,
})

local mathHelper = {
	barycentric = function(value1, value2, value3, amount1, amount2)
		return value1 + (value2 - value1) * amount1 + (value3 - value1) * amount2
	end,
	catmullRom = function(value1, value2, value3, value4, amount)
		return (.5 * (2 * value2 + (value3 - value1) * amount + (2 * value1 - 5 * value2 + 4 * value3 - value4) * (amount ^ 2) + (3 * value2 - value1 - 3 * value3 + value4) * (amount ^ 3)))
	end,
	clamp = function(value, min, max)
		return value < min and min or value > max and max or value
	end,
	distance = function(value1, value2)
		return math.abs(value1 - value2)
	end,
	hermite = function(value1, tangent1, value2, tangent2, amount)
		if amount == 0 then
			return value1
		elseif amount == 1 then
			return value2
		else
			return (2 * value1 - 2 * value2 + tangent2 + tangent1) * (amount ^ 3) + (3 * value2 - 3 * value1 - 2 * tangent1 - tangent2) * (amount ^ 2) + tangent1 * amount + value1
		end
	end,
	lerp = function(value1, value2, amount)
		return value1 + (value2 - value1) * amount
	end,
	lerpPrecise = function(value1, value2, amount)
		return ((1 - amount) * value1) + (value2 * amount)
	end,
	wrapAngle = function(angle)
		if angle > -constants.pi and angle <= constants.pi then
			return angle
		end
		
		angle = angle % constants.twoPi
		
		if angle <= -constants.pi then
			return angle + constants.twoPi
		elseif angle > constants.pi then
			return angle - constants.twoPi
		end
		
		return angle
	end,
	isPowerOfTwo = function(value)
		return value > 0 and bit32.band(value, value - 1) == 0
	end,
}
mathHelper.smoothStep = function(value1, value2, amount)
	return mathHelper.hermite(value1, 0, value2, 0, mathHelper.clamp(amount, 0, 1))
end

local point, vector2, vector3, vector4 = {}, {}, {}, {}

do
	local globalMeta = {
		__newindex = function()
			return
		end,
		__index = function(list, index)
			if index == "__call" then
				return
			end
		end,
		__concat = function(o1, o2)
			return tostring(o1) .. tostring(o2)
		end
	}

	local pointMeta = {
		__call = function(list, x, y)
			self = {}
			
			self.x = x or 0
			self.y = y or self.x

			self.equals = function(self, objB)
				return point.equals(self, objB)
			end
			self.toVector2 = function(self)
				return vector2(self.x, self.y)
			end
			
			return setmetatable(self, {
				__add = function(value1, value2)
					return point(value1.x + value2.x, value1.y + value2.y)
				end,
				__sub = function(value1, value2)
					return point(value1.x - value2.x, value1.y - value2.y)
				end,
				__mul = function(value1, value2)
					return point(value1.x * value2.x, value1.y * value2.y)
				end,
				__div = function(source, divisor)
					return point(source.x / divisor.x, source.y / divisor.y)
				end,
				__eq = function(value1, value2)
					return value1.x == value2.x and value1.y == value2.y
				end,
				__tostring = function()
					return "{x:".. self.x .." y:".. self.y .. "}"
				end,
				__concat = globalMeta.__concat,
				__metatable = 'point'
			})
		end,
	}
	
	point.zero = pointMeta.__call()
	
	point.equals = function(objA, objB)
		return objA.x == objB.x and objA.y == objB.y
	end

	point = setmetatable(point, { __call = pointMeta.__call, __newindex = globalMeta.__newindex, __metatable = 'point' })

	local getValNum = function(value1, value2)
		if type(value1) == "number" then
			return value2, value1
		elseif type(value2) == "number" then
			return value1, value2
		end
		return false
	end
	local unpackArgs = function(args, param)
		local out = {}
		for k, v in next, args do
			out[#out + 1] = (type(v) == "table" and assert(getmetatable(v):find('vector'), 'Invalid parameter.')) and v[param] or v
		end
		
		return out
	end
	local getVectorSelf = function(vec, i)
		local self = {}
		
		self.equals = function(self, value2)
			return vec.__eq(self, value2)
		end

		if i == 2 then
			self.toPoint = function(self)
				return point(self.x, self.y)
			end
		end
		
		self.lengthSquared = function(self)
			return vec.dot(self)
		end
		self.length = function(self)
			return self.lengthSquared(self) ^ .5
		end
		self.normalize = function(self)		
			return vec.normalize(self)
		end
		
		return self
	end
	
	local vectorX = {}
	for i = 2, 4 do
		local vec = {}
		for k, v in next, {'barycentric', 'catmullRom', 'clamp', 'hermite', 'lerp', 'smoothStep'} do
			vec[v] = function(...)
				local args = {...}
				
				local out = {}
				out[#out + 1] = mathHelper[v](table.unpack(unpackArgs(args, 'x')))
				out[#out + 1] = mathHelper[v](table.unpack(unpackArgs(args, 'y')))
				if i > 2 then
					out[#out + 1] = mathHelper[v](table.unpack(unpackArgs(args, 'z')))
				end
				if i > 3 then
					out[#out + 1] = mathHelper[v](table.unpack(unpackArgs(args, 'w')))
				end

				return vec(table.unpack(out))
			end
		end
		
		vec.__add = function(value1, value2)
			local out = {}
			
			out[#out + 1] = value1.x + value2.x
			out[#out + 1] = value1.y + value2.y
			if i > 2 then
				out[#out + 1] = value1.z + value2.z
			end
			if i > 3 then
				out[#out + 1] = value1.w + value2.w
			end
			
			return vec.__call(nil, table.unpack(out))
		end
		vec.__sub = function(value1, value2)
			local out = {}
		
			out[#out + 1] = value1.x - value2.x
			out[#out + 1] = value1.y - value2.y
			if i > 2 then
				out[#out + 1] = value1.z - value2.z
			end
			if i > 3 then
				out[#out + 1] = value1.w - value2.w
			end
			
			return vec.__call(nil, table.unpack(out))
		end
		vec.__mul = function(value1, value2)
			local vector, number = getValNum(value1, value2)
			
			local scale = vector and number
			
			local out = {}
			
			out[#out + 1] = value1.x * (scale or value2.x)
			out[#out + 1] = value1.y * (scale or value2.y)
			if i > 2 then
				out[#out + 1] = value1.z * (scale or value2.z)
			end
			if i > 3 then
				out[#out + 1] = value1.w * (scale or value2.w)
			end
			
			return vec.__call(nil, table.unpack(out))
		end
		vec.__div = function(value1, value2)
			local vector, number = getValNum(value1, value2)
			
			local factor = vector and number
			
			local out = {}
			
			out[#out + 1] = value1.x / (factor or value2.x)
			out[#out + 1] = value1.y / (factor or value2.y)
			if i > 2 then
				out[#out + 1] = value1.z / (factor or value2.z)
			end
			if i > 3 then
				out[#out + 1] = value1.w / (factor or value2.w)
			end
			
			return vec.__call(nil, table.unpack(out))
		end
		vec.__unm = function(value)
			local out = {}
			
			out[#out + 1] = -value.x
			out[#out + 1] = -value.y
			if i > 2 then
				out[#out + 1] = -value.z
			end
			if i > 3 then
				out[#out + 1] = -value.w
			end
			
			return vec.__call(nil, table.unpack(out))
		end
		vec.__eq = function(value1, value2)
			local out = value1.x == value2.x and value1.y == value2.y
			if out and i > 2 then
				out = value1.z == value2.z
			end
			if out and i > 3 then
				out = value1.w == value2.w
			end
			
			return out
		end
        
		vec.add = vec.__add
		vec.subtract = vec.__sub
		vec.multiply = vec.__mul
		vec.divide = vec.__div
		vec.negate = vec.__unm
		
		vec.distanceSquared = function(value1, value2)
			local sub = vec.__sub(value1, value2)
			
			return sub.x^2 + sub.y^2 + (sub.z or 0)^2 + (sub.w or 0)^2
		end
		vec.distance = function(value1, value2)
			return vec.distanceSquared(value1, value2) ^ .5
		end
		vec.dot = function(value1, value2)
			value2 = value2 or value1
			
			local mul = vec.__mul(value1, value2)
			
			return mul.x + mul.y + (mul.z or 0) + (mul.w or 0)
		end
		vec.equals = vec.__eq
		vec.max = function(value1, value2)
			local out = {}
			out[#out + 1] = math.max(value1.x, value2.x)
			out[#out + 1] = math.max(value1.y, value2.y)
			if i > 2 then
				out[#out + 1] = math.max(value1.z, value2.z)
			end
			if i > 3 then
				out[#out + 1] = math.max(value1.w, value2.w)
			end
			
			return vec(table.unpack(out))
		end
		vec.min = function(value1, value2)
			local out = {}
			out[#out + 1] = math.min(value1.x, value2.x)
			out[#out + 1] = math.min(value1.y, value2.y)
			if i > 2 then
				out[#out + 1] = math.min(value1.z, value2.z)
			end
			if i > 3 then
				out[#out + 1] = math.min(value1.w, value2.w)
			end
			
			return vec(table.unpack(out))
		end		
		vec.normalize = function(value)
			return vec.__mul(value, (1 / (vec.dot(value) ^ .5)))
		end
		
		vec.__call = function(list, x, y, z, w)
			local self = getVectorSelf(vec, i)
			
			if i > 2 then
				if type(x) == "table" then
					local err = "Vector" .. i .. ": The arguments x, y, z" .. (i == 4 and ", w" or "") .. " are needed"
					
					local meta = getmetatable(x)
					if meta then
						assert(type(y) == "number", err)
						
						if i == 3 then
							z = y
						else
							if meta == "vector2" then
								z, w = y, z
							elseif meta == "vector3" then
								z = assert(x.z, err)
								w = y
							else
								error(err)
							end							
						end

						y = assert(x.y, err)
						x = assert(x.x, err)
					else
						error(err)
					end
				end
			end

			self.x = x or 0
			self.y = y or self.x
			if i > 2 then
				assert(not (y and not z), "Vector" .. i .. ": Z is missing.")
				self.z = z or self.x
			end
			if i > 3 then
				assert(not (y and not w), "Vector" .. i .. ": W is missing.")
				self.w = w or self.x
			end

			return setmetatable(self, {
				__add = vec.__add,
				__sub = vec.__sub,
				__mul = vec.__mul,
				__div = vec.__div,
				__unm = vec.__unm,
				__eq = vec.__eq,
				
				__tostring = function()
					return "{x:".. self.x .." y:".. self.y .. (i>2 and (" z:"..self.z) or "") .. (i>3 and (" w:"..self.w) or "") .. "}"
				end,
				__concat = globalMeta.__concat,
				
				__metatable = 'vector'..i
			})
		end

		vectorX["vector" .. i] = vec
	end
	
	do
		vectorX.vector2.one = vectorX.vector2.__call(nil, 1, 1)
		vectorX.vector2.unitX = vectorX.vector2.__call(nil, 1, 0)
		vectorX.vector2.unitY = vectorX.vector2.__call(nil, 0, 1)
		vectorX.vector2.zero = vectorX.vector2.__call(nil, 0, 0)
		
		vectorX.vector2.reflect = function(vector, normal)
			local v = 2 * vector2.dot(vector, normal)
			
			local result = vector2.zero
			result.x = vector.x - (normal.x * v)
			result.y = vector.y - (normal.y * v)
			
			return result
		end

		vectorX.vector3.backward = vectorX.vector3.__call(nil, 0, 0, 1)
		vectorX.vector3.down = vectorX.vector3.__call(nil, 0, -1, 0)
		vectorX.vector3.forward = vectorX.vector3.__call(nil, 0, 0, -1)
		vectorX.vector3.left = vectorX.vector3.__call(nil, -1, 0, 0)
		vectorX.vector3.one = vectorX.vector3.__call(nil, 1, 1, 1)
		vectorX.vector3.right = vectorX.vector3.__call(nil, -1, 0, 0)
		vectorX.vector3.unitX = vectorX.vector3.__call(nil, 1, 0, 0)
		vectorX.vector3.unitY = vectorX.vector3.__call(nil, 0, 1, 0)
		vectorX.vector3.unitZ = vectorX.vector3.__call(nil, 0, 0, 1)
		vectorX.vector3.up = vectorX.vector3.__call(nil, 0, 1, 0)
		vectorX.vector3.zero = vectorX.vector3.__call(nil, 0, 0, 0)
		
		vectorX.vector3.cross = function(value1, value2)
			local x, y, z
			
			x = value1.y * value2.z - value2.y * value1.z
			y = -(value1.x * value2.z - value2.x * value1.z)
			z = value1.x * value2.y - value2.x * value1.y
			
			return vector3(x, y, z)
		end
		vectorX.vector3.reflect = function(vector, normal)
			local x, y, z
			
			local v = vector3.dot(vector, normal)
			x = vector.x - (2 * normal.x) * v
			y = vector.y - (2 * normal.y) * v
			z = vector.z - (2 * normal.z) * v
			
			return vector3(x, y, z)
		end

		vectorX.vector4.one = vectorX.vector4.__call(nil, 1, 1, 1, 1)
		vectorX.vector4.unitX = vectorX.vector4.__call(nil, 1, 0, 0, 0)
		vectorX.vector4.unitY = vectorX.vector4.__call(nil, 0, 1, 0, 0)
		vectorX.vector4.unitZ = vectorX.vector4.__call(nil, 0, 0, 1, 0)
		vectorX.vector4.unitW = vectorX.vector4.__call(nil, 0, 0, 0, 1)
		vectorX.vector4.zero = vectorX.vector4.__call(nil, 0, 0, 0, 0)
	end
	
	vector2 = setmetatable(vectorX.vector2, { __newindex = globalMeta.__newindex, __index = globalMeta.__index, __metatable = 'vector2',
		__call = vectorX.vector2.__call
	})
	vector3 = setmetatable(vectorX.vector3, { __newindex = globalMeta.__newindex, __index = globalMeta.__index, __metatable = 'vector3',
		__call = vectorX.vector3.__call
	})
	vector4 = setmetatable(vectorX.vector4, { __newindex = globalMeta.__newindex, __index = globalMeta.__index, __metatable = 'vector4',
		__call = vectorX.vector4.__call
	})
end
