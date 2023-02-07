-- Compiled with roblox-ts v1.3.3
local TS = require(script.Parent.TS.RuntimeLib)
local AsyncFunction = TS.import(script, script, "ServerAsyncFunction").default
local Event = TS.import(script, script, "ServerEvent").default
local MessagingEvent = TS.import(script, script, "ServerMessagingEvent").default
local Function = TS.import(script, script, "ServerFunction").default
return {
	Event = Event,
	AsyncFunction = AsyncFunction,
	Function = Function,
	MessagingEvent = MessagingEvent,
}
