local gifscript = getgenv().gifscript
local char = gifscript.char

local collectionService = game:GetService("CollectionService")
local runService = game:GetService("RunService")
local lighting = game:GetService("Lighting")
local pathfinding = game:GetService("PathfindingService")

local ui = gifscript.ui
local lib = ui.lib
local tabs = ui.tabs

local visualTab = tabs.visual

-- Fullbright --

local fullbrightToggle = visualTab:AddToggle("fullbrightToggle", {Title = "Fullbright", Description = "allows you to see in the dark", Default = false})
local fullbrightColor = visualTab:AddColorpicker("fullbrightColor", {Title = "Fullbright Color", Default = Color3.new(1, 1, 1)})

-- Landing --

visualTab:AddSection("Pathfinding")

local currentRooms = workspace:WaitForChild("CurrentRooms")

local path = nil
local agentParams = {AgentRadius = 1, AgentHeight = 5, WaypointSpacing = 1, AgentCanJump = false}
local pathDebris = {}

local function getCurrentLanding()
	return currentRooms:FindFirstChild(tostring(char.player:GetAttribute("CurrentRoom")))
end

local function getExitVector()
	local landing = getCurrentLanding()
	if not landing then return end

	local exitSign = landing:FindFirstChild("ExitSignStairwell", true)
	if not exitSign then return end

	local pivot: CFrame = exitSign:GetPivot()
	return pivot.Position - Vector3.new(0, 7, 0)
end

local function removePathDebris()
	for _,debris in pairs(pathDebris) do
		debris:Destroy()
	end
	path = nil
end

local function visualizePath(targetVector: Vector3)
	if not targetVector or not char.checkCharacter() then return end
	
	removePathDebris()
	path = pathfinding:CreatePath(agentParams)
	
	local success, err = pcall(function()
		path:ComputeAsync(getExitVector(), targetVector)
	end)
	
	if not success or path.Status == Enum.PathStatus.NoPath then lib:Notify({Title = "Error", Content = tostring(err), Duration = 5}) return end
	local waypoints = path:GetWaypoints()
	
	for index, waypoint in pairs(waypoints) do
		local attach = Instance.new("Attachment")
		attach.Parent = workspace
		attach.Name = "PathAttachment"
		attach.WorldPosition = waypoint.Position
		attach.Visible = true
		table.insert(pathDebris, attach)
	end
end

local function getFireAlarm()
	local landing = getCurrentLanding()
	return landing and landing:FindFirstChild("StairwellFireAlarm", true) or nil
end

local function getFireAlarmVector()
	local fireAlarm = getFireAlarm()
	if not fireAlarm then return end
	
	local pivot: CFrame = fireAlarm:GetPivot()
	return pivot.Position - Vector3.new(0, 1.5, 0) + pivot.LookVector * 2.5
end

local fireAlarmPathFindToggle = visualTab:AddToggle("fireAlarmPathFindToggle", {Title = "Compute Path To Fire Alarm", Description = "leads the way to the fire alarm", Default = false, Callback = function(value)
	if value then
		visualizePath(getFireAlarmVector())
	else
		removePathDebris()
	end
end})

-- ESP --

visualTab:AddSection("ESP")


-- Connections--

gifscript.onUnload.Event:Once(function()
	removePathDebris()
end)

table.insert(gifscript.connections, char.player.AttributeChanged:Connect(function(name)
	if name ~= "CurrentRoom" then return end
	visualizePath(getFireAlarmVector())
end))

table.insert(gifscript.connections, runService.RenderStepped:Connect(function()
	if fullbrightToggle.Value then lighting.Ambient = fullbrightColor.Value end
end))
