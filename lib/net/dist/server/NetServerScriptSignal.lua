-- Compiled with roblox-ts v1.3.3
local TS = require(script.Parent.Parent.TS.RuntimeLib)
--[[
	*
	* A wrapper around a RBXScriptSignal for remotes, that always has a listener set.
]]
local NetServerScriptSignal
do
	NetServerScriptSignal = setmetatable({}, {
		__tostring = function()
			return "NetServerScriptSignal"
		end,
	})
	NetServerScriptSignal.__index = NetServerScriptSignal
	function NetServerScriptSignal.new(...)
		local self = setmetatable({}, NetServerScriptSignal)
		return self:constructor(...) or self
	end
	function NetServerScriptSignal:constructor(signalInstance, instance)
		self.signalInstance = signalInstance
		self.instance = instance
		self.connections = {}
		self.connectionRefs = setmetatable({}, {
			__mode = "k",
		})
		self.defaultConnectionDelegate = (function(player, ...)
			local args = { ... }
		end)
		self.defaultConnection = signalInstance:Connect(self.defaultConnectionDelegate)
		local sig
		sig = self.instance.AncestryChanged:Connect(function(child, parent)
			if child == instance and parent == nil then
				self:DisconnectAll()
				sig:Disconnect()
			end
		end)
	end
	function NetServerScriptSignal:Connect(callback)
		if self.defaultConnection then
			self.defaultConnection:Disconnect()
			self.defaultConnection = nil
		end
		local connection = self.signalInstance:Connect(callback)
		local _connections = self.connections
		table.insert(_connections, connection)
		local ref
		local _arg0 = {
			NetSignal = self,
			RBXSignal = connection,
			Connected = connection.Connected,
			Disconnect = function(self)
				local _connections_1 = self.NetSignal.connections
				local _arg0_1 = function(f)
					return f == ref
				end
				-- ▼ ReadonlyArray.findIndex ▼
				local _result = -1
				for _i, _v in ipairs(_connections_1) do
					if _arg0_1(_v, _i - 1, _connections_1) == true then
						_result = _i - 1
						break
					end
				end
				-- ▲ ReadonlyArray.findIndex ▲
				local idx = _result
				if idx ~= -1 then
					self.NetSignal:DisconnectAt(idx)
					self.Connected = false
				end
			end,
		}
		ref = _arg0
		self.connectionRefs[ref] = true
		return ref
	end
	function NetServerScriptSignal:Wait()
		return self.signalInstance:Wait()
	end
	function NetServerScriptSignal:WaitAsync()
		return TS.Promise.defer(function(resolve)
			local result = { self.signalInstance:Wait() }
			resolve(result)
		end)
	end
	function NetServerScriptSignal:GetCount()
		return #self.connections
	end
	function NetServerScriptSignal:DisconnectAt(index)
		local connection = self.connections[index + 1]
		if connection then
			connection:Disconnect()
			table.remove(self.connections, index + 1)
		end
		if #self.connections == 0 then
			self.defaultConnection = self.signalInstance:Connect(self.defaultConnectionDelegate)
		end
	end
	function NetServerScriptSignal:DisconnectAll()
		for _, connection in ipairs(self.connections) do
			connection:Disconnect()
		end
		table.clear(self.connections)
		for ref in pairs(self.connectionRefs) do
			ref.Connected = false
		end
		table.clear(self.connectionRefs)
		self.defaultConnection = self.signalInstance:Connect(self.defaultConnectionDelegate)
	end
end
return {
	NetServerScriptSignal = NetServerScriptSignal,
}
