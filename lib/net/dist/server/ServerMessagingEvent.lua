-- Compiled with roblox-ts v1.3.3
local TS = require(script.Parent.Parent.TS.RuntimeLib)
local _ExperienceBroadcastEvent = TS.import(script, script.Parent.Parent, "messaging", "ExperienceBroadcastEvent")
local ExperienceBroadcastEvent = _ExperienceBroadcastEvent.default
local isSubscriptionMessage = _ExperienceBroadcastEvent.isSubscriptionMessage
local _internal = TS.import(script, script.Parent.Parent, "internal")
local getGlobalRemote = _internal.getGlobalRemote
local IS_CLIENT = _internal.IS_CLIENT
local isLuaTable = _internal.isLuaTable
local ServerEvent = TS.import(script, script.Parent, "ServerEvent").default
local Players = game:GetService("Players")
local function isTargetedSubscriptionMessage(value)
	if isSubscriptionMessage(value) then
		if isLuaTable(value.Data) then
			return value.Data.InnerData ~= nil
		end
	end
	return false
end
--[[
	*
	* Similar to a ServerEvent, but works across all servers.
]]
local ServerMessagingEvent
do
	ServerMessagingEvent = setmetatable({}, {
		__tostring = function()
			return "ServerMessagingEvent"
		end,
	})
	ServerMessagingEvent.__index = ServerMessagingEvent
	function ServerMessagingEvent.new(...)
		local self = setmetatable({}, ServerMessagingEvent)
		return self:constructor(...) or self
	end
	function ServerMessagingEvent:constructor(name)
		self.instance = ServerEvent.new(getGlobalRemote(name))
		self.event = ExperienceBroadcastEvent.new(name)
		local _arg0 = not IS_CLIENT
		assert(_arg0, "Cannot create a Net.GlobalServerEvent on the Client!")
		self.eventHandler = self.event:Connect(function(message)
			if isTargetedSubscriptionMessage(message) then
				self:recievedMessage(message.Data)
			else
				warn("[rbx-net] Recieved malformed message for ServerGameEvent: " .. name)
			end
		end)
	end
	function ServerMessagingEvent:getPlayersMatchingId(matching)
		if type(matching) == "number" then
			return Players:GetPlayerByUserId(matching)
		else
			local players = {}
			for _, id in ipairs(matching) do
				local player = Players:GetPlayerByUserId(id)
				if player then
					table.insert(players, player)
				end
			end
			return players
		end
	end
	function ServerMessagingEvent:recievedMessage(message)
		if message.TargetIds then
			local players = self:getPlayersMatchingId(message.TargetIds)
			if players then
				self.instance:SendToPlayers(players, unpack(message.InnerData))
			end
		elseif message.TargetId ~= nil then
			local player = self:getPlayersMatchingId(message.TargetId)
			if player then
				self.instance:SendToPlayer(player, unpack(message.InnerData))
			end
		else
			self.instance:SendToAllPlayers(unpack(message.InnerData))
		end
	end
	function ServerMessagingEvent:Connect(serverListener)
		return self.event:Connect(function(data, sent)
			serverListener(data, sent)
		end)
	end
	function ServerMessagingEvent:SendToAllServers(...)
		local args = { ... }
		self.event:SendToAllServers({
			InnerData = args,
		})
	end
	function ServerMessagingEvent:SendToServer(jobId, ...)
		local args = { ... }
		self.event:SendToServer(jobId, {
			InnerData = args,
		})
	end
	function ServerMessagingEvent:SendToUserId(userId, ...)
		local args = { ... }
		local player = Players:GetPlayerByUserId(userId)
		-- If the player exists in this instance, just send it straight to them.
		if player then
			self.instance:SendToPlayer(player, unpack(args))
		else
			self.event:SendToAllServers({
				InnerData = args,
				TargetId = userId,
			})
		end
	end
	function ServerMessagingEvent:SendToUserIds(userIds, ...)
		local args = { ... }
		-- Check to see if any of these users are in this server first, and handle accordingly.
		for _, targetId in ipairs(userIds) do
			local player = Players:GetPlayerByUserId(targetId)
			if player then
				self.instance:SendToPlayer(player, unpack(args))
				table.remove(userIds, targetId + 1)
			end
		end
		if #userIds > 0 then
			self.event:SendToAllServers({
				InnerData = args,
				TargetIds = userIds,
			})
		end
	end
end
return {
	default = ServerMessagingEvent,
}
