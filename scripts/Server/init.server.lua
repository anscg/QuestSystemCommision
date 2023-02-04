--[=[
    @class Quest

    Questing
    (c) 2023 Bloxcode A/P Antcar
]=]

local ReplicatedFirst = game:GetService("ReplicatedFirst")
local client, server, shared = require(script:FindFirstChild("LoaderUtils", true)).toWallyFormat(script.src, false)

server.Name = "_QuestServerPackages"
server.Parent = script

client.Name = "_QuestClientPackages"
client.Parent = ReplicatedFirst

shared.Name = "_QuestPackages"
shared.Parent = ReplicatedFirst

local clientScript = script.ClientScript
clientScript.Name = "QuestClientScript"
clientScript:Clone().Parent = ReplicatedFirst

local serviceBag = require(server.ServiceBag).new()
local Service = serviceBag:GetService(require(server.QuestService))

serviceBag:Init()
serviceBag:Start()

--expose this to gobal
_G.QuestService = Service
_G.QuestObject = require(shared.QuestObject)
