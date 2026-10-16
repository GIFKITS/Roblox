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
		path:ComputeAsync(char.root.Position, targetVector)
	end)
	
	if not success then
		warn(err, success)
	end
	if err then
		warn(err, success)
	end
	warn(path.Status.Name)
	
	if not success or path.Status == Enum.PathStatus.NoPath then lib:Notify({Title = "Error", Content = "path computing error", Duration = 5}) return end
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

local function getFireAlarmVector()
	local landing = currentRooms:FindFirstChild(tostring(char.player:GetAttribute("CurrentRoom")))
	if not landing then return end
	
	local fireAlarm = landing:FindFirstChild("StairwellFireAlarm", true)
	if not fireAlarm then return end
	
	return fireAlarm:GetPivot().Position
end

local fireAlarmPathFindToggle = visualTab:AddToggle("fireAlarmPathFindToggle", {Title = "Compute Path To Fire Alarm", Description = "leads the way to the fire alarm", Default = false, Callback = function(value)
	if value then
		visualizePath(Vector3.new(326.878876, 69, -138.733398))
	else
		removePathDebris()
	end
end})

-- Connections--

gifscript.onUnload.Event:Once(function()
	removePathDebris()
end)

table.insert(gifscript.connections, runService.RenderStepped:Connect(function()
	if fullbrightToggle.Value then lighting.Ambient = fullbrightColor.Value end
end))
