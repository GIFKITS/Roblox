local module = {}
local gifscript = getgenv().gifscript
local char = gifscript.char

local replicatedStorage = game:GetService("ReplicatedStorage")
local collectionService = game:GetService("CollectionService")

local gameDataFolder = replicatedStorage:WaitForChild("GameData")
local latestRoom = gameDataFolder:WaitForChild("LatestRoom")
local currentRoomsFolder = workspace:WaitForChild("CurrentRooms")

function module.getCurrentRoom()
	return currentRoomsFolder:FindFirstChild(latestRoom.Value)
end

function module.getDoor()
	return module.getCurrentRoom():FindFirstChild("Door")
end

function module.getLockerPrompt(locker)
	return locker:FindFirstChildOfClass("ProximityPrompt")
end

function module.getLockerVector(locker)
	return locker:FindFirstChild("EnterAttachment", true).WorldPosition
end

function module.getClosestLocker()
	if not char.checkCharacter() then return end
	local closestLocker = nil
	local closestDistance = math.huge
	
	for _,locker in pairs(collectionService:GetTagged("HidingSpot")) do
		local distance = (char.root.Position - module.getLockerVector(locker)).Magnitude
		if distance < closestDistance then closestDistance = distance closestLocker = locker end
	end
	
	return closestLocker
end
