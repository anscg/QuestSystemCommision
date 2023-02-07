-- Compiled with roblox-ts v1.3.3
local TS = require(script.Parent.Parent.TS.RuntimeLib)
local _internal = TS.import(script, script.Parent.Parent, "internal")
local getRemoteOrThrow = _internal.getRemoteOrThrow
local IS_SERVER = _internal.IS_SERVER
local waitForRemote = _internal.waitForRemote
--[[
	*
	* Interface for client listening events
]]
--[[
	*
	* Interface for client sender events
]]
local ClientEvent
do
	ClientEvent = setmetatable({}, {
		__tostring = function()
			return "ClientEvent"
		end,
	})
	ClientEvent.__index = ClientEvent
	function ClientEvent.new(...)
		local self = setmetatable({}, ClientEvent)
		return self:constructor(...) or self
	end
	function ClientEvent:constructor(name)
		self.instance = getRemoteOrThrow("RemoteEvent", name)
		local _arg0 = not IS_SERVER
		assert(_arg0, "Cannot fetch NetClientEvent on the server!")
	end
	function ClientEvent:GetInstance()
		return self.instance
	end
	function ClientEvent:Wait(name)
		return TS.Promise.defer(TS.async(function(resolve)
			TS.await(waitForRemote("RemoteEvent", name, 60))
			resolve(ClientEvent.new(name))
		end))
	end
	function ClientEvent:SendToServer(...)
		local args = { ... }
		self.instance:FireServer(unpack(args))
	end
	function ClientEvent:Connect(callback)
		return self.instance.OnClientEvent:Connect(callback)
	end
end
local default = ClientEvent
return {
	default = default,
}
