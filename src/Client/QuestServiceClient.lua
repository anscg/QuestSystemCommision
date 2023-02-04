--[=[
    @class QuestServiceClient

    Questing, but Client!
    (c) 2023 Bloxcode A/P Antcar
]=]

local require = require(script.Parent.loader).load(script)

local QuestServiceClient = {}
QuestServiceClient.ServiceName = "QuestServiceClient"

function QuestServiceClient:Init(serviceBag)
    self._serviceBag = assert(serviceBag, "QuestServiceClient/ ServiceBag is nil")

    print("QuestServiceClient/ Initializing...")

    

    print("QuestServiceClient/ Initialized!")
end
