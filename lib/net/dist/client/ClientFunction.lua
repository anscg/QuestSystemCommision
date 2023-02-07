-- Compiled with roblox-ts v1.3.3
local TS = require(script.Parent.Parent.TS.RuntimeLib)
local _internal = TS.import(script, script.Parent.Parent, "internal")
local getRemoteOrThrow = _internal.getRemoteOrThrow
local IS_SERVER = _internal.IS_SERVER
local waitForRemote = _internal.waitForRemote
local CollectionService = game:GetService("CollectionService")
local ClientFunction
do
	ClientFunction = setmetatable({}, {
		__tostring = function()
			return "ClientFunction"
		end,
	})
	ClientFunction.__index = ClientFunction
	function ClientFunction.new(...)
		local self = setmetatable({}, ClientFunction)
		return self:constructor(...) or self
	end
	function ClientFunction:constructor(name)
		self.name = name
		self.instance = getRemoteOrThrow("RemoteFunction", name)
		local _arg0 = not IS_SERVER
		assert(_arg0, "Cannot create a Net.ClientFunction on the Server!")
	end
	function ClientFunction:Wait(name)
		return TS.Promise.defer(TS.async(function(resolve)
			TS.await(waitForRemote("RemoteFunction", name, 60))
			resolve(ClientFunction.new(name))
		end))
	end
	function ClientFunction:CallServer(...)
		local args = { ... }
		if CollectionService:HasTag(self.instance, "NetDefaultListener") then
			error("Attempted to call Function '" .. (self.name .. "' - which has no user defined callback"))
		end
		return self.instance:InvokeServer(unpack(args))
	end
	ClientFunction.CallServerAsync = TS.async(function(self, ...)
		local args = { ... }
		return TS.Promise.defer(function(resolve)
			local result = self.instance:InvokeServer(unpack(args))
			resolve(result)
		end)
	end)
end
return {
	default = ClientFunction,
}
