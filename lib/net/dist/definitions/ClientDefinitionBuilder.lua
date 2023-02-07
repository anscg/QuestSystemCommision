-- Compiled with roblox-ts v1.3.3
local TS = require(script.Parent.Parent.TS.RuntimeLib)
local ClientAsyncFunction = TS.import(script, script.Parent.Parent, "client", "ClientAsyncFunction").default
local ClientEvent = TS.import(script, script.Parent.Parent, "client", "ClientEvent").default
local ClientFunction = TS.import(script, script.Parent.Parent, "client", "ClientFunction").default
local _internal = TS.import(script, script.Parent.Parent, "internal")
local getGlobalRemote = _internal.getGlobalRemote
local NAMESPACE_ROOT = _internal.NAMESPACE_ROOT
local NAMESPACE_SEPARATOR = _internal.NAMESPACE_SEPARATOR
-- Keep the declarations fully isolated
local declarationMap = setmetatable({}, {
	__mode = "k",
})
local shouldYield = setmetatable({}, {
	__mode = "k",
})
local ClientDefinitionBuilder
do
	ClientDefinitionBuilder = setmetatable({}, {
		__tostring = function()
			return "ClientDefinitionBuilder"
		end,
	})
	ClientDefinitionBuilder.__index = ClientDefinitionBuilder
	function ClientDefinitionBuilder.new(...)
		local self = setmetatable({}, ClientDefinitionBuilder)
		return self:constructor(...) or self
	end
	function ClientDefinitionBuilder:constructor(declarations, configuration, namespace)
		if namespace == nil then
			namespace = NAMESPACE_ROOT
		end
		self.configuration = configuration
		self.namespace = namespace
		local _self = self
		declarationMap[_self] = declarations
		local _exp = self
		local _result = configuration
		if _result ~= nil then
			_result = _result.ClientGetShouldYield
		end
		local _condition = _result
		if _condition == nil then
			_condition = true
		end
		shouldYield[_exp] = _condition
	end
	function ClientDefinitionBuilder:toString()
		return "[" .. ("ClientDefinitionBuilder" .. "]")
	end
	function ClientDefinitionBuilder:Get(remoteId)
		local _self = self
		if shouldYield[_self] then
			return self:WaitFor(remoteId):expect()
		else
			return self:GetOrThrow(remoteId)
		end
	end
	function ClientDefinitionBuilder:GetNamespace(namespaceId)
		local _self = self
		local group = declarationMap[_self][namespaceId]
		local _arg1 = "Group " .. (namespaceId .. (" does not exist under namespace " .. self.namespace))
		assert(group, _arg1)
		local _arg0 = group.Type == "Namespace"
		assert(_arg0)
		local _fn = group.Definitions
		local _exp = group.Definitions:_CombineConfigurations(self.configuration or {})
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
		return _fn:_BuildClientDefinition(_exp, _result)
	end
	function ClientDefinitionBuilder:GetOrThrow(remoteId)
		local _self = self
		local item = declarationMap[_self][remoteId]
		local _result
		if self.namespace ~= NAMESPACE_ROOT then
			-- ▼ ReadonlyArray.join ▼
			local _nAMESPACE_SEPARATOR = NAMESPACE_SEPARATOR
			if _nAMESPACE_SEPARATOR == nil then
				_nAMESPACE_SEPARATOR = ", "
			end
			-- ▲ ReadonlyArray.join ▲
			_result = (table.concat({ self.namespace, remoteId }, _nAMESPACE_SEPARATOR))
		else
			_result = remoteId
		end
		remoteId = _result
		local _arg0 = item and item.Type
		local _arg1 = "'" .. (remoteId .. "' is not defined in this definition.")
		assert(_arg0, _arg1)
		local _ = nil
		local _1 = nil
		if item.Type == "Function" then
			return ClientFunction.new(remoteId)
		elseif item.Type == "Event" then
			return ClientEvent.new(remoteId)
		elseif item.Type == "AsyncFunction" then
			return ClientAsyncFunction.new(remoteId)
		elseif item.Type == "ExperienceEvent" then
			return ClientEvent.new(getGlobalRemote(remoteId))
		end
		error("Type '" .. (item.Type .. "' is not a valid client remote object type"))
	end
	ClientDefinitionBuilder.WaitFor = TS.async(function(self, remoteId)
		local _self = self
		local item = declarationMap[_self][remoteId]
		local _result
		if self.namespace ~= NAMESPACE_ROOT then
			-- ▼ ReadonlyArray.join ▼
			local _nAMESPACE_SEPARATOR = NAMESPACE_SEPARATOR
			if _nAMESPACE_SEPARATOR == nil then
				_nAMESPACE_SEPARATOR = ", "
			end
			-- ▲ ReadonlyArray.join ▲
			_result = (table.concat({ self.namespace, remoteId }, _nAMESPACE_SEPARATOR))
		else
			_result = remoteId
		end
		remoteId = _result
		local _arg0 = item and item.Type
		local _arg1 = "'" .. (remoteId .. "' is not defined in this definition.")
		assert(_arg0, _arg1)
		local _ = nil
		local _1 = nil
		if item.Type == "Function" then
			return ClientFunction:Wait(remoteId)
		elseif item.Type == "Event" then
			return ClientEvent:Wait(remoteId)
		elseif item.Type == "AsyncFunction" then
			return ClientAsyncFunction:Wait(remoteId)
		elseif item.Type == "ExperienceEvent" then
			return ClientEvent:Wait(getGlobalRemote(remoteId))
		end
		error("Type '" .. (item.Type .. "' is not a valid client remote object type"))
	end)
	ClientDefinitionBuilder.OnEvent = TS.async(function(self, name, fn)
		local result = (TS.await(self:WaitFor(name)))
		return result:Connect(fn)
	end)
	ClientDefinitionBuilder.OnFunction = TS.async(function(self, name, fn)
		local result = (TS.await(self:WaitFor(name)))
		result:SetCallback(fn)
	end)
	function ClientDefinitionBuilder:__tostring()
		return self:toString()
	end
end
return {
	ClientDefinitionBuilder = ClientDefinitionBuilder,
}
