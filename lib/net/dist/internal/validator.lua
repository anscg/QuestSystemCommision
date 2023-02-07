-- Compiled with roblox-ts v1.3.3
local TS = require(script.Parent.Parent.TS.RuntimeLib)
local isMixed = TS.import(script, script.Parent, "tables").isMixed
local Workspace = game:GetService("Workspace")
local ServerStorage = game:GetService("ServerStorage")
local ServerScriptService = game:GetService("ServerScriptService")
-- * @internal
local isSerializable
local function validateArguments(...)
	local args = { ... }
	for index, value in ipairs(args) do
		if not isSerializable.check(value) then
			error(string.format(isSerializable.errorMessage, index), 2)
		end
		if typeof(value) == "Instance" then
			if value:IsDescendantOf(ServerStorage) or value:IsDescendantOf(ServerScriptService) then
				error("[rbx-net] Instance at argument #" .. (tostring(index) .. " is inside a server-only container and cannot be sent via remotes."))
			end
			if not value:IsDescendantOf(game) then
				error("[rbx-net] Instance at argument #" .. (tostring(index) .. " is not a valid descendant of game, and wont replicate"))
			end
		end
	end
end
-- * @internal
isSerializable = {
	errorMessage = "Argument #%d is not serializable. - see http://docs.vorlias.com/rbx-net/docs/2.0/serialization",
	check = function(value)
		-- Can't allow functions or threads
		if type(value) == "function" or type(value) == "thread" then
			return false
		end
		-- Can't allow metatabled objects
		if type(value) == "table" and getmetatable(value) ~= nil then
			return false
		end
		-- Ensure not a mixed table type
		if type(value) == "table" then
			return not isMixed(value)
		end
		return true
	end,
}
-- * @internal
local function oneOf(...)
	local values = { ... }
	return {
		errorMessage = "Expected one of: " .. table.concat(values, ", "),
		check = function(value)
			if not (type(value) == "string") then
				return false
			end
			for _, cmpValue in ipairs(values) do
				if value == cmpValue then
					return true
				end
			end
			return false
		end,
	}
end
return {
	validateArguments = validateArguments,
	oneOf = oneOf,
	isSerializable = isSerializable,
}
