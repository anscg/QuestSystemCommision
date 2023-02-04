--[=[
    @class QuestObject
]=]

local require = require(script.Parent.loader).load(script)

local BaseObject = require("BaseObject")

local QuestObject = setmetatable({}, BaseObject)
QuestObject.__index = QuestObject
QuestObject.ClassName = "QuestObject"

function QuestObject.new(name, description, reward, requirements, rewardImage, rewardAmount)
    local self = setmetatable(BaseObject.new(), QuestObject)

    self.Name = name
    self.Description = description
    self.Reward = reward
    self.Requirements = requirements
    self.RewardImage = rewardImage
    self.RewardAmount = rewardAmount

    return self
end

return QuestObject
