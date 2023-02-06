local require = require(game:GetService("ServerScriptService"):FindFirstChild("LoaderUtils", true).Parent).load(script)

local Maid = require("Maid")
local StoryBarPaneUtils = require("StoryBarPaneUtils")
local StoryBarUtils = require("StoryBarUtils")
local QuestScreen = require("QuestScreen")

return function(target)
    local maid = Maid.new()

    local questScreen = QuestScreen.new()
    questScreen.Gui.Parent = target
    questScreen:SetDisplayName("Quests!")
    questScreen:Show()
    maid:GiveTask(questScreen)

    local bar = StoryBarUtils.createStoryBar(maid, target)
    StoryBarPaneUtils.makeVisibleSwitch(bar, questScreen)

    return function()
        maid:DoCleaning()
    end
end
