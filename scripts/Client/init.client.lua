--[[
	@class ClientMain
]]

local ReplicatedFirst = game:GetService("ReplicatedFirst")

local packages = ReplicatedFirst:WaitForChild("_SoftShutdownClientPackages")

local QuestServiceClient = require(packages.QuestService)
local serviceBag = require(packages.ServiceBag).new()

serviceBag:GetService(QuestServiceClient)

serviceBag:Init()
serviceBag:Start()