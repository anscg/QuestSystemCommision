--[=[
    @class GameService

    Everything Questtttttttttt
    (c) 2023 Bloxcode
]=]

local require = require(script.Parent.loader).load(script)

local QuestService = require("QuestService")
local QuestObject = require("QuestObject")

local GameService = {}
GameService.ServiceName = "GameService"

function GameService:Init(serviceBag)
    self._serviceBag = assert(serviceBag, "GameService/ ServiceBag is nil")

    self._questService = self._serviceBag:GetService(QuestService)
end

function GameService:Start()
    print("GameService/ Starting...")

    local function GrantCoin(amount)
        return function(player)
            print("GrantCoin/ ", player, amount)
        end
    end
    local Quests = {
        ["5zombie"] = QuestObject.new("Beat 5 Zombies", "Beat 5 Zombies To Earn It!", GrantCoin(5), 5, "rbxassetid://0", 5)
    }
    self._questService:SetQuest(Quests)

    print(self._questService:GetQuestList())

    --repeat print for 5 times
    for i = 1, 5 do
        task.spawn(function()
            game.Players:WaitForChild("antcar0929")
            task.wait(5)
            self._questService:DoQuest(game.Players.antcar0929, "5zombie")
            print(i)
        end)
    end


    print("GameService/ Started!")
end

return GameService
