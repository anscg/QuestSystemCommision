-- Compiled with roblox-ts v1.3.3
local TS = require(script.Parent.Parent.TS.RuntimeLib)
-- * @internal
local MiddlewareEvent
do
	MiddlewareEvent = {}
	function MiddlewareEvent:constructor(middlewares)
		if middlewares == nil then
			middlewares = {}
		end
		self.middlewares = middlewares
	end
	function MiddlewareEvent:_use(middleware)
		local _exp = (self.middlewares)
		table.insert(_exp, middleware)
	end
	function MiddlewareEvent:_processMiddleware(callback)
		local _binding = self
		local middlewares = _binding.middlewares
		local _exitType, _returns = TS.try(function()
			local _arg0 = type(middlewares) == "table"
			local _arg1 = "The middleware argument should be an array of middlewares not a " .. typeof(middlewares)
			assert(_arg0, _arg1)
			if #middlewares > 0 then
				local callbackFn = callback
				-- Run through each middleware
				for _, middleware in ipairs(middlewares) do
					callbackFn = middleware(callbackFn, self)
				end
				return TS.TRY_RETURN, { callbackFn }
			else
				return TS.TRY_RETURN, { callback }
			end
		end, function(e)
			warn("[rbx-net] " .. tostring(e))
		end)
		if _exitType then
			return unpack(_returns)
		end
	end
end
local default = MiddlewareEvent
return {
	default = default,
}
