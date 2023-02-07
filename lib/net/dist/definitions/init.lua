-- Compiled with roblox-ts v1.3.3
local TS = require(script.Parent.TS.RuntimeLib)
-- eslint-disable @typescript-eslint/no-explicit-any
local DeclarationTypeCheck = TS.import(script, script, "Types").DeclarationTypeCheck
local ServerDefinitionBuilder = TS.import(script, script, "ServerDefinitionBuilder").ServerDefinitionBuilder
local ClientDefinitionBuilder = TS.import(script, script, "ClientDefinitionBuilder").ClientDefinitionBuilder
local NamespaceBuilder = TS.import(script, script, "NamespaceBuilder").NamespaceBuilder
local NetDefinitions = {}
do
	local _container = NetDefinitions
	--[[
		*
		* Validates the specified declarations to ensure they're valid before usage
		* @param declarations The declarations
	]]
	local function validateDeclarations(declarations)
		for _, declaration in pairs(declarations) do
			local _arg0 = DeclarationTypeCheck.check(declaration.Type)
			local _errorMessage = DeclarationTypeCheck.errorMessage
			assert(_arg0, _errorMessage)
		end
	end
	--[[
		*
		* Creates definitions for Remote instances that can be used on both the client and server.
		* @description https://docs.vorlias.com/rbx-net/docs/3.0/definitions#definitions-oh-my
		* @param declarations
	]]
	local function Create(declarations, configuration)
		if configuration == nil then
			configuration = {}
		end
		validateDeclarations(declarations)
		local _arg0 = {
			Server = ServerDefinitionBuilder.new(declarations, configuration),
			Client = ClientDefinitionBuilder.new(declarations, configuration),
		}
		return _arg0
	end
	_container.Create = Create
	--[[
		*
		* Defines a namespace of remote definitions, which can be retrieved via `GetNamespace(namespaceId)`
		*
		* E.g.
		* ```ts
		* const Remotes = Net.Definitions.Create({
		* 		ExampleGroup: Net.Definitions.Namespace({
		* 			ExampleGroupRemote: Net.Definitions.ServerToClientEvent<[message: string]>(),
		* 		}),
		* });
		* const ExampleGroupRemote = Remotes.Server.GetNamespace("ExampleGroup").Create("ExampleGroupRemote");
		* ```
		*
		* This is useful for categorizing remotes by feature.
	]]
	local function Namespace(declarations, configuration)
		return {
			Type = "Namespace",
			Definitions = NamespaceBuilder.new(declarations, configuration),
		}
	end
	_container.Namespace = Namespace
	--[[
		*
		* Defines a function in which strictly the client can call the server asynchronously
		*
		* `Client` [`Calls`] -> `Server` [`Recieves Call`]
		* ... (asynchronously) ...
		* `Server` [`Responds to Call`] -> `Client` [`Recieves Response`]
	]]
	local function ServerAsyncFunction(mw)
		return {
			Type = "AsyncFunction",
			ServerMiddleware = mw,
		}
	end
	_container.ServerAsyncFunction = ServerAsyncFunction
	--[[
		*
		* @version 3.0
		*
		* **_Note_: This uses {@link MessagingService}, and thus is subject to those quotas/limits.**
		*
		* **_Note_: Unlike other definitions in Net, this is only available on the server.**
		*
		* Defines an event in which allows broadcasting messages between servers in the experience.
		*
		* `Source Server` [`Broadcasts`] -> `Other Servers` [`Recieves Broadcast`]
		*
		* or at a target {@link DataModel.JobId JobId}
		*
		* `Source Server [`Broadcasts`] -> `Target Server` [`Recieves Broadcast`]
		*
	]]
	local function ExperienceBroadcastEvent()
		return {
			Type = "Messaging",
		}
	end
	_container.ExperienceBroadcastEvent = ExperienceBroadcastEvent
	--[[
		*
		* @version 3.0
		*
		* **_Note_: This uses {@link MessagingService}, and thus is subject to those quotas/limits.**
		*
		* Defines an event that allows a server to broadcast to all or specified _clients_ in the experience.
		*
		* `Source Server` [`Broadcasts`] -> `Other Servers` [`Recieves Broadcast`] -> `Client` [`Recieves Forwarded Broadcast`]
		*
		* @hidden Experimental API
		* @deprecated Not yet official API, could be changed or removed.
		* @internal
	]]
	local function EXPERIMENTAL_ExperienceReplicatedEvent()
		return {
			Type = "ExperienceEvent",
		}
	end
	_container.EXPERIMENTAL_ExperienceReplicatedEvent = EXPERIMENTAL_ExperienceReplicatedEvent
	--[[
		*
		* Defines a function in which strictly the server can call the client asynchronously
		*
		* `Server` [`Calls`] -> `Client` [`Recieves Call`]
		* ... (asynchronously) ...
		* `Client` [`Responds to Call`] -> `Server` [`Recieves Response`]
	]]
	local function ClientAsyncFunction()
		return {
			Type = "AsyncFunction",
		}
	end
	_container.ClientAsyncFunction = ClientAsyncFunction
	--[[
		*
		* Defines a regular function in which strictly the client can call the server synchronously
		*
		* (Synchronous) `Client` [`Calls`, `Recieves Response`] <- (yields for response) -> `Server` [`Recieves Call`, `Responds`]
	]]
	local function ServerFunction(mw)
		return {
			Type = "Function",
			ServerMiddleware = mw,
		}
	end
	_container.ServerFunction = ServerFunction
	--[[
		*
		* Defines an event in which strictly the server fires an event that is recieved by clients
		*
		* `Server` [`Sends`] => `Client(s)` [`Recieves`]
		*
		* On the client, this will give an event that can use `Connect`.
		*
		* On the server, this will give an event that can use `SendToPlayer`, `SendToAllPlayers`, `SendToAllPlayersExcept`
		*
	]]
	local function ServerToClientEvent()
		return {
			ServerMiddleware = {},
			Type = "Event",
		}
	end
	_container.ServerToClientEvent = ServerToClientEvent
	--[[
		*
		* Defines an event in which strictly clients fire an event that's recieved by the server
		*
		* `Client(s)` [`Sends`] => `Server` [`Recieves`]
		*
		* On the client, this will give an event that can use `SendToServer`.
		*
		* On the server, this will give an event that can use `Connect`.
		*
		* @param mw The middleware of this event.
	]]
	local function ClientToServerEvent(mw)
		return {
			Type = "Event",
			ServerMiddleware = mw,
		}
	end
	_container.ClientToServerEvent = ClientToServerEvent
	--[[
		*
		* Defines a remote event that can be fired both from the client and server
		*
		* This should only be required in rare use cases where `ClientToServerEvent` or `ServerToClientEvent` is not sufficient.
		*
		* Check to see if {@link ServerAsyncFunction} is more sufficient for your use case.
	]]
	local function BidirectionalEvent()
		return {
			Type = "Event",
			ServerMiddleware = {},
		}
	end
	_container.BidirectionalEvent = BidirectionalEvent
end
local default = NetDefinitions
return {
	default = default,
}
