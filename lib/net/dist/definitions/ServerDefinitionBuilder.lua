-- Compiled with roblox-ts v1.3.3
local TS = require(script.Parent.Parent.TS.RuntimeLib)
local ServerAsyncFunction = TS.import(script, script.Parent.Parent, "server", "ServerAsyncFunction").default
local ServerEvent = TS.import(script, script.Parent.Parent, "server", "ServerEvent").default
local ServerFunction = TS.import(script, script.Parent.Parent, "server", "ServerFunction").default
local _internal = TS.import(script, script.Parent.Parent, "internal")
local NAMESPACE_ROOT = _internal.NAMESPACE_ROOT
local NAMESPACE_SEPARATOR = _internal.NAMESPACE_SEPARATOR
local ExperienceBroadcastEvent = TS.import(script, script.Parent.Parent, "messaging", "ExperienceBroadcastEvent").default
local ServerMessagingEvent = TS.import(script, script.Parent.Parent, "server", "ServerMessagingEvent").default
local CollectionService = game:GetService("CollectionService")
local RunService = game:GetService("RunService")
-- Tidy up all the types here.
-- Keep the declarations fully isolated
local declarationMap = setmetatable({}, {
	__mode = "k",
})
local remoteEventCache = {}
local remoteAsyncFunctionCache = {}
local remoteFunctionCache = {}
local messagingEventCache = {}
local messagingServerEventCache = {}
local ServerDefinitionBuilder
do
	ServerDefinitionBuilder = setmetatable({}, {
		__tostring = function()
			return "ServerDefinitionBuilder"
		end,
	})
	ServerDefinitionBuilder.__index = ServerDefinitionBuilder
	function ServerDefinitionBuilder.new(...)
		local self = setmetatable({}, ServerDefinitionBuilder)
		return self:constructor(...) or self
	end
	function ServerDefinitionBuilder:constructor(declarations, config, namespace)
		if namespace == nil then
			namespace = NAMESPACE_ROOT
		end
		self.config = config
		self.namespace = namespace
		local _binding = config
		local AutoGenerateServerRemotes = _binding.ServerAutoGenerateRemotes
		if AutoGenerateServerRemotes == nil then
			AutoGenerateServerRemotes = true
		end
		local GlobalMiddleware = _binding.ServerGlobalMiddleware
		local _self = self
		declarationMap[_self] = declarations
		local _ = declarations
		-- We only run remote creation on the server
		if RunService:IsServer() and AutoGenerateServerRemotes then
			self:_InitServer()
		end
		self.globalMiddleware = GlobalMiddleware
	end
	function ServerDefinitionBuilder:_CreateOrGetInstance(id, declaration)
		local _arg0 = RunService:IsServer()
		assert(_arg0, "Can only create server instances on the server")
		--[[
			*
			* This is used to generate or fetch the specified remote from a declaration
			*
			* The generated remote id is based off the current namespace.
		]]
		local _result
		if self.namespace ~= NAMESPACE_ROOT then
			-- ▼ ReadonlyArray.join ▼
			local _nAMESPACE_SEPARATOR = NAMESPACE_SEPARATOR
			if _nAMESPACE_SEPARATOR == nil then
				_nAMESPACE_SEPARATOR = ", "
			end
			-- ▲ ReadonlyArray.join ▲
			_result = table.concat({ self.namespace, id }, _nAMESPACE_SEPARATOR)
		else
			_result = id
		end
		local namespacedId = _result
		if declaration.Type == "Function" then
			local func
			if remoteFunctionCache[namespacedId] ~= nil then
				return remoteFunctionCache[namespacedId]
			else
				if declaration.ServerMiddleware then
					func = ServerFunction.new(namespacedId, declaration.ServerMiddleware)
				else
					func = ServerFunction.new(namespacedId)
				end
				CollectionService:AddTag(func:GetInstance(), "NetDefinitionManaged")
				local _func = func
				remoteFunctionCache[namespacedId] = _func
				local _result_1 = self.globalMiddleware
				if _result_1 ~= nil then
					local _arg0_1 = function(mw)
						return func:_use(mw)
					end
					for _k, _v in ipairs(_result_1) do
						_arg0_1(_v, _k - 1, _result_1)
					end
				end
				return func
			end
		elseif declaration.Type == "AsyncFunction" then
			local asyncFunction
			-- This should make certain use cases cheaper
			if remoteAsyncFunctionCache[namespacedId] ~= nil then
				return remoteAsyncFunctionCache[namespacedId]
			else
				if declaration.ServerMiddleware then
					asyncFunction = ServerAsyncFunction.new(namespacedId, declaration.ServerMiddleware)
				else
					asyncFunction = ServerAsyncFunction.new(namespacedId)
				end
				CollectionService:AddTag(asyncFunction:GetInstance(), "NetDefinitionManaged")
				local _asyncFunction = asyncFunction
				remoteAsyncFunctionCache[namespacedId] = _asyncFunction
			end
			local _result_1 = self.globalMiddleware
			if _result_1 ~= nil then
				local _arg0_1 = function(mw)
					return asyncFunction:_use(mw)
				end
				for _k, _v in ipairs(_result_1) do
					_arg0_1(_v, _k - 1, _result_1)
				end
			end
			return asyncFunction
		elseif declaration.Type == "Event" then
			local event
			-- This should make certain use cases cheaper
			if remoteEventCache[namespacedId] ~= nil then
				return remoteEventCache[namespacedId]
			else
				if declaration.ServerMiddleware then
					event = ServerEvent.new(namespacedId, declaration.ServerMiddleware)
				else
					event = ServerEvent.new(namespacedId)
				end
				CollectionService:AddTag(event:GetInstance(), "NetDefinitionManaged")
				local _event = event
				remoteEventCache[namespacedId] = _event
			end
			local _result_1 = self.globalMiddleware
			if _result_1 ~= nil then
				local _arg0_1 = function(mw)
					return event:_use(mw)
				end
				for _k, _v in ipairs(_result_1) do
					_arg0_1(_v, _k - 1, _result_1)
				end
			end
			return event
		elseif declaration.Type == "Messaging" then
			local event
			if messagingEventCache[namespacedId] ~= nil then
				return messagingEventCache[namespacedId]
			else
				event = ExperienceBroadcastEvent.new(namespacedId)
				local _event = event
				messagingEventCache[namespacedId] = _event
			end
			return event
		elseif declaration.Type == "ExperienceEvent" then
			local event
			if messagingServerEventCache[namespacedId] ~= nil then
				return messagingServerEventCache[namespacedId]
			else
				event = ServerMessagingEvent.new(namespacedId)
				local _event = event
				messagingServerEventCache[namespacedId] = _event
			end
			return event
		else
			error("Unhandled type")
		end
	end
	function ServerDefinitionBuilder:_InitServer()
		--[[
			*
			* Used to generate all the remotes on the server-side straight away.
			*
			* So long as the remote declaration file is imported, and it's the server this _should_ run.
			*
			* This will fix https://github.com/roblox-aurora/rbx-net/issues/57, which is a long standing race-condition issue
			* I, as well as many other users have run into from time to time.
		]]
		local _ = nil
		local _1 = nil
		local _self = self
		local declarations = declarationMap[_self]
		for id, declaration in pairs(declarations) do
			local _exp = declaration.Type
			repeat
				local _fallthrough = false
				if _exp == "Event" then
					_fallthrough = true
				end
				if _fallthrough or _exp == "AsyncFunction" then
					_fallthrough = true
				end
				if _fallthrough or _exp == "Function" then
					_fallthrough = true
				end
				if _fallthrough or _exp == "Messaging" then
					self:_CreateOrGetInstance(id, declaration)
					break
				end
				if _exp == "Namespace" then
					self:GetNamespace(id)
					break
				end
			until true
		end
	end
	function ServerDefinitionBuilder:toString()
		return "[" .. ("ServerDefinitionBuilder" .. "]")
	end
	function ServerDefinitionBuilder:OnEvent(name, fn)
		local result = self:Get(name)
		return result:Connect(fn)
	end
	function ServerDefinitionBuilder:GetNamespace(namespaceId)
		local _self = self
		local group = declarationMap[_self][namespaceId]
		local _arg1 = "Group " .. (namespaceId .. (" does not exist under namespace " .. self.namespace))
		assert(group, _arg1)
		local _arg0 = group.Type == "Namespace"
		assert(_arg0)
		local _ = nil
		local _1 = nil
		local _fn = group.Definitions
		local _exp = group.Definitions:_CombineConfigurations(self.config)
		local _result
		if self.namespace ~= NAMESPACE_ROOT then
			-- ▼ ReadonlyArray.join ▼
			local _nAMESPACE_SEPARATOR = NAMESPACE_SEPARATOR
			if _nAMESPACE_SEPARATOR == nil then
				_nAMESPACE_SEPARATOR = ", "
			end
			-- ▲ ReadonlyArray.join ▲
			_result = table.concat({ self.namespace, namespaceId }, _nAMESPACE_SEPARATOR)
		else
			_result = namespaceId
		end
		return _fn:_BuildServerDefinition(_exp, _result)
	end
	function ServerDefinitionBuilder:Get(remoteId)
		local _self = self
		local item = declarationMap[_self][remoteId]
		local _arg0 = item and item.Type
		local _arg1 = "'" .. (remoteId .. "' is not defined in this definition.")
		assert(_arg0, _arg1)
		if item.Type == "Function" or (item.Type == "AsyncFunction" or (item.Type == "Event" or item.Type == "Messaging")) then
			if remoteAsyncFunctionCache[remoteId] ~= nil then
				local _ = nil
				local _1 = nil
				return remoteAsyncFunctionCache[remoteId]
			else
				return self:_CreateOrGetInstance(remoteId, item)
			end
		else
			error("Invalid type for " .. remoteId)
		end
	end
	function ServerDefinitionBuilder:Create(remoteId)
		return self:Get(remoteId)
	end
	function ServerDefinitionBuilder:OnFunction(name, fn)
		local result = self:Get(name)
		result:SetCallback(fn)
	end
	function ServerDefinitionBuilder:__tostring()
		return self:toString()
	end
end
return {
	ServerDefinitionBuilder = ServerDefinitionBuilder,
}
