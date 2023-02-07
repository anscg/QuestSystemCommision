-- Compiled with roblox-ts v1.3.3
local TS = require(script.Parent.TS.RuntimeLib)
local createLoggerMiddleware = TS.import(script, script, "LoggerMiddleware")
local createRateLimiter = TS.import(script, script, "RateLimitMiddleware").default
local NetTypeCheckingMiddleware = TS.import(script, script, "TypeCheckMiddleware")
local NetMiddleware = {}
do
	local _container = NetMiddleware
	local RateLimit = createRateLimiter
	_container.RateLimit = RateLimit
	local Logging = createLoggerMiddleware
	_container.Logging = Logging
	-- * The type checking middleware
	local TypeChecking = NetTypeCheckingMiddleware
	_container.TypeChecking = TypeChecking
	--[[
		*
		* Creates a global read-only middleware for use in `Net.Definitions` global middleware.
	]]
	local function Global(middleware)
		local _arg0 = function(processNext, event)
			return function(sender, ...)
				local args = { ... }
				middleware(event:GetInstance().Name, args, sender)
				return processNext(sender, unpack(args))
			end
		end
		return _arg0
	end
	_container.Global = Global
end
local createTypeChecker = NetTypeCheckingMiddleware
return {
	NetMiddleware = NetMiddleware,
	createRateLimiter = createRateLimiter,
	createTypeChecker = createTypeChecker,
}
