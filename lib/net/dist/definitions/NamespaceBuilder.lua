-- Compiled with roblox-ts v1.3.3
local TS = require(script.Parent.Parent.TS.RuntimeLib)
local ClientDefinitionBuilder = TS.import(script, script.Parent, "ClientDefinitionBuilder").ClientDefinitionBuilder
local ServerDefinitionBuilder = TS.import(script, script.Parent, "ServerDefinitionBuilder").ServerDefinitionBuilder
local RunService = game:GetService("RunService")
-- Isolate the definitions since we don't need to access them anywhere else.
local declarationMap = setmetatable({}, {
	__mode = "k",
})
--[[
	*
	* A namespace builder. Internally used to construct definition builders
]]
local NamespaceBuilder
do
	NamespaceBuilder = setmetatable({}, {
		__tostring = function()
			return "NamespaceBuilder"
		end,
	})
	NamespaceBuilder.__index = NamespaceBuilder
	function NamespaceBuilder.new(...)
		local self = setmetatable({}, NamespaceBuilder)
		return self:constructor(...) or self
	end
	function NamespaceBuilder:constructor(declarations, config)
		self.config = config
		local _self = self
		declarationMap[_self] = declarations
		local _ = declarations
	end
	function NamespaceBuilder:_CombineConfigurations(parentConfig)
		local _object = {}
		for _k, _v in pairs(parentConfig) do
			_object[_k] = _v
		end
		local _spread = self.config
		if type(_spread) == "table" then
			for _k, _v in pairs(_spread) do
				_object[_k] = _v
			end
		end
		local newConfig = _object
		return newConfig
	end
	function NamespaceBuilder:_BuildServerDefinition(configuration, namespace)
		local _arg0 = RunService:IsServer()
		assert(_arg0)
		local _ = nil
		local _1 = nil
		local _self = self
		return ServerDefinitionBuilder.new(declarationMap[_self], configuration, namespace)
	end
	function NamespaceBuilder:_BuildClientDefinition(configuration, namespace)
		local _arg0 = RunService:IsClient()
		assert(_arg0)
		local _ = nil
		local _1 = nil
		local _self = self
		return ClientDefinitionBuilder.new(declarationMap[_self], configuration, namespace)
	end
end
return {
	NamespaceBuilder = NamespaceBuilder,
}
