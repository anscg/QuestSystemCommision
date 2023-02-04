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

function QuestService:Init(serviceBag)
    self._serviceBag = assert(serviceBag, "QuestService/ ServiceBag is nil")

    print("QuestService/ Initializing...")

    self._playerDataStoreService = self._serviceBag:GetService(PlayerDataStoreService)
    self._maid = Maid.new()

    self._playerData = {}

    Players.PlayerAdded:Connect(function(player)
        self:_handlePlayer(player)
    end)
    Players.PlayerRemoving:Connect(function(player)
        print("QuestService/ PlayerRemoving: ", player)
        self._maid[player] = nil
    end)

    --Incase players are already in the game
    for _, player in pairs(Players:GetPlayers()) do
        self:_handlePlayer(player)
    end
    print('QuestService/ {self._serviceBag}')
    print("QuestService/ Initialized!")
end

function QuestService:_handlePlayer(player)
    local maid = Maid.new()

    self._playerData[player] = ValueObject.new({})

    maid:GivePromise(self._playerDataStoreService:PromiseDataStore(player)):Then(function(dataStore)
        maid:GivePromise(dataStore:Load("quest",{}))
            :Then(function(questData)
                self._playerData[player].Value = questData
                maid:GiveTask(dataStore:StoreOnValueChange("quest", self._playerData[player]))
            end)
    end)

    self._maid[player] = maid
end

return QuestService
