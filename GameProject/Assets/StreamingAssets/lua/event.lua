--------------------------------------------------------------------------------
--      Copyright (c) 2015 - 2016 , 蒙占志(topameng) topameng@gmail.com
--      All rights reserved.
--      Use, modification and distribution are subject to the "MIT License"
--------------------------------------------------------------------------------

local setmetatable = setmetatable
local xpcall = xpcall
local pcall = pcall
local assert = assert
local rawget = rawget
local error = error
local print = print
local traceback = tolua.traceback
local ilist = ilist

local _xpcall = {}
local handleTable={} --存储添加过的方法

_xpcall.__call = function(self, ...)	
	if jit then
		if nil == self.obj then
			return xpcall(self.func, traceback, ...)					
		else		
			return xpcall(self.func, traceback, self.obj, ...)					
		end
	else
		local args = {...}
			
		if nil == self.obj then
			local func = function() self.func(unpack(args)) end
			return xpcall(func, traceback)					
		else		
			local func = function() self.func(self.obj, unpack(args)) end
			return xpcall(func, traceback)
		end
	end	
end

_xpcall.__eq = function(lhs, rhs)
	return lhs.func == rhs.func and lhs.obj == rhs.obj
end

local function xfunctor(func, obj)	
	return setmetatable({func = func, obj = obj}, _xpcall)			
end

local _pcall = {}

_pcall.__call = function(self, ...)
	if nil == self.obj then
		return pcall(self.func, ...)					
	else		
		return pcall(self.func, self.obj, ...)					
	end	
end

_pcall.__eq = function(lhs, rhs)
	return lhs.func == rhs.func and lhs.obj == rhs.obj
end

local function functor(func, obj)	
	return setmetatable({func = func, obj = obj}, _pcall)			
end

local _event = {}
_event.__index = _event

--废弃
function _event:Add(func, obj)
	assert(func)		

	if self.keepSafe then			
		func = xfunctor(func, obj)
	else
		func = functor(func, obj)
	end	

	if self.lock then
		local node = {value = func, _prev = 0, _next = 0, removed = true}
		table.insert(self.opList, function() self.list:pushnode(node) end)			
		return node
	else
		return self.list:push(func)
	end	
end

--废弃
function _event:Remove(func, obj)	
	for i, v in ilist(self.list) do							
		if v.func == func and v.obj == obj then
			if self.lock then
				table.insert(self.opList, function() self.list:remove(i) end)				
			else
				self.list:remove(i)
			end
			break
		end
	end		
end

--创建update监听
--func  要添加的update函数
--obj   要添加的update类型，UpdateBeat或者LateUpdateBeat等等
function _event:CreateListener(func, obj)
	if self.keepSafe then			
		func = xfunctor(func, obj)
	else
		func = functor(func, obj)
	end	
	return {value = func, _prev = 0, _next = 0, removed = true} 		
end

--添加某个update函数监听
function _event:AddListener(handle)	
	assert(handle)

	if self.lock then		
		table.insert(self.opList, function() self.list:pushnode(handle) end)	
	else
		self.list:pushnode(handle)
	end	
	
end

--移除某个update函数监听
function _event:RemoveListener(handle)	
	assert(handle)	

	if self.lock then		
		table.insert(self.opList, function() self.list:remove(handle) end)				
	else
		self.list:remove(handle)
	end
end

--获取注册update的数量
function _event:Count()
	return self.list.length
end	


--清除所有update注册
function _event:Clear()
	self.list:clear()
	self.opList = {}	
	self.lock = false
	self.keepSafe = false
	self.current = nil
end

--打印update的信息
function _event:Dump()
	local count = 0
	
	for _, v in ilist(self.list) do
		if v.obj then
			print("update function:", v.func, "object name:", v.obj.name)
		else
			print("update function: ", v.func)
		end
		
		count = count + 1
	end
	
	print("all function is:", count)
end

_event.__call = function(self, ...)			
	local _list = self.list	
	self.lock = true
	local ilist = ilist				

	for i, f in ilist(_list) do		
		self.current = i						
		local flag, msg = f(...)
		
		if not flag then			
			_list:remove(i)			
			self.lock = false		
			error(msg)				
		end
	end	

	local opList = self.opList	
	self.lock = false		

	for i, op in ipairs(opList) do									
		op()
		opList[i] = nil
	end
end

--创建对应的update总管理  一般不需要管
function event(name, safe)
	safe = safe or false
	return setmetatable({name = name, keepSafe = safe, lock = false, opList = {}, list = list:new()}, _event)				
end



---自添Update链接方法
function _event:Connect(func)
	assert(type(func)=='function',
		'   error value type is not \'function\' Please input type is \'function\' value!'
	)
	local updatehandle=UpdateBeat:CreateListener(func,self)
	UpdateBeat:AddListener(updatehandle)
	handleTable[func]=updatehandle
end

function _event:DisConnect(func)
	assert(type(func)=='function',
		'   error value type is not \'function\' Please input type is \'function\' value!'
	)
	assert(handleTable[func]~=nil,
		'    error Did not add this \'function\' , dont need DisConnect!'
	)
	local handle=handleTable[func]
	UpdateBeat:RemoveListener(handle)

end




UpdateBeat 		= event("Update", true)
LateUpdateBeat	= event("LateUpdate", true)
FixedUpdateBeat	= event("FixedUpdate", true)
CoUpdateBeat	= event("CoUpdate")				--只在协同使用

local Time = Time
local UpdateBeat = UpdateBeat
local LateUpdateBeat = LateUpdateBeat
local FixedUpdateBeat = FixedUpdateBeat
local CoUpdateBeat = CoUpdateBeat


--逻辑update
function Update(deltaTime, unscaledDeltaTime)
	Time:SetDeltaTime(deltaTime, unscaledDeltaTime)				
	UpdateBeat()	
end

function LateUpdate()	
	LateUpdateBeat()		
	CoUpdateBeat()		
	Time:SetFrameCount()		
end

--物理update
function FixedUpdate(fixedDeltaTime)
	Time:SetFixedDelta(fixedDeltaTime)
	FixedUpdateBeat()
end

function PrintEvents()
	UpdateBeat:Dump()
	FixedUpdateBeat:Dump()
end