-- Compiled with roblox-ts v1.3.3
local TS = require(script.Parent.Parent.TS.RuntimeLib)
local _internal = TS.import(script, script.Parent.Parent, "internal")
local findOrCreateRemote = _internal.findOrCreateRemote
local IS_SERVER = _internal.IS_SERVER
local MiddlewareFunction = TS.import(script, script.Parent, "MiddlewareFunction").default
local CollectionService = game:GetService("CollectionService")
local ServerFunction
do
	local super = MiddlewareFunction
	ServerFunction = setmetatable({}, {
		__tostring = function()
			return "ServerFunction"
		end,
		__index = super,
	})
	ServerFunction.__index = ServerFunction
	function ServerFunction.new(...)
		local self = setmetatable({}, ServerFunction)
		return self:constructor(...) or self
	end
	function ServerFunction:constructor(name, middlewares)
		if middlewares == nil then
			middlewares = {}
		end
		super.constructor(self, middlewares)
		self.instance = findOrCreateRemote("RemoteFunction", name, function(instance)
			-- Default listener
			instance.OnServerInvoke = ServerFunction.DefaultFunctionHook
			CollectionService:AddTag(instance, "NetDefaultListener")
		end)
		assert(IS_SERVER, "Cannot create a Net.ServerFunction on the Client!")
	end
	function ServerFunction:GetInstance()
		return self.instance
	end
	function ServerFunction:SetCallback(callback)
		if CollectionService:HasTag(self.instance, "NetDefaultListener") then
			CollectionService:RemoveTag(self.instance, "NetDefaultListener")
		end
		self.instance.OnServerInvoke = function(player, ...)
			local args = { ... }
			local _result = self:_processMiddleware(callback)
			if _result ~= nil then
				_result = _result(player, unpack(args))
			end
			local result = _result
			if TS.Promise.is(result) then
				warn("[rbx-net] WARNING: Promises should be used with an AsyncFunction!")
				local success, value = result:await()
				if success then
					return value
				else
					error(value)
				end
			end
			return result
		end
	end
	ServerFunction.DefaultFunctionHook = function()
		-- TODO: 2.2 make usable for analytics?
		-- Although, unlike `Event`, this will need to be part of `SetCallback`'s stuff.
		return nil
	end
end
return {
	default = ServerFunction,
}
