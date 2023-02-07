-- Compiled with roblox-ts v1.3.3
local TS = require(script.Parent.Parent.TS.RuntimeLib)
local ServerEventV2 = TS.import(script, script.Parent, "ServerEvent").default
local function isMiddlewareArgument(args)
	local _condition = #args > 1
	if _condition then
		local _arg0 = args[1]
		_condition = type(_arg0) == "table"
	end
	return _condition
end
--[[
	*
	* Creates a server listening event
]]
local function createServerListener(id, ...)
	local args = { ... }
	local event
	if isMiddlewareArgument(args) then
		local _binding = args
		local middleware = _binding[1]
		local connect = _binding[2]
		event = ServerEventV2.new(id, middleware)
		return event:Connect(connect)
	else
		local _binding = args
		local connect = _binding[1]
		event = ServerEventV2.new(id)
		return event:Connect(connect)
	end
end
return {
	default = createServerListener,
}
