local QuestObject = _G.QuestObject
local function GrantCoin(amount)
    return function(player)
        print("GrantCoin/ ", player, amount)
    end
end
local Quests = {
    QuestObject.new("Beat 5 Zombies", "Beat 5 Zombies To Earn It!", GrantCoin(5), 5, "rbxassetid://0", 5),
}
_G.QuestService:SetQuest(Quests)
