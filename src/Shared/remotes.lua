--[=[
    @class remotes

    Networking with rbx-net
    (c) 2023 Bloxcode
]=]

local require = require(script.Parent.loader).load(script)

local Net = require("net")

local Remotes = Net.CreateDefinitions({
    PlayerQuestUpdated = Net.Definitions.ServerToClientEvent(),

    PlayerClaimQuestReward = Net.Definitions.ClientToServerEvent(),
})

return Remotes
