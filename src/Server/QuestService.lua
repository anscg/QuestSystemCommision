--[=[
    @class QuestService

    Questing
    (c) 2023 Bloxcode A/C Antcar
]=]

local require = require(script.parent.loader).load(script)

local Players = game:GetService("Players")

local PlayerDataStoreService = require("PlayerDataStoreService")

local Maid = require("Maid")
local ValueObject = require("ValueObject")

local QuestService = {}
QuestService.ServiceName = "QuestService"

function QuestService:Init()
    self._serviceBag = assert(self._serviceBag, "ServiceBag is nil")

    self._playerDataStoreService = self._serviceBag:GetService(PlayerDataStoreService)
    self._maid = Maid.new()

    Players.PlayerAdded:Connect(self:_handlePlayer)
    Players.PlayerRemoving:Connect(function(player)
        self._maid[player] = nil
    end)

    --Incase players are already in the game
    for _, player in pairs(Players:GetPlayers()) do
        self:_handlePlayer(player)
    end
end

function QuestService:_handlePlayer(player)
    local maid = Maid.new()

    self._playerData[player] = ValueObject.new({})

    maid:GivePromise(PlayerDataStoreService:PromiseDataStore(player)):Then(function(dataStore)
        maid:GivePromise(dataStore:Load("quest",0))
            :Then(function(questData)
                self._playerData[player].Value = questData
            end)
    end)

    self._maid[player] = maid
end

return QuestService
