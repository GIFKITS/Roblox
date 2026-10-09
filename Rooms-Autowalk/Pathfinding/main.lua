local module = {}

local gifscript = getgenv().gifscript
local char = gifscript.char

local runService = game:GetService("RunService")

module.enabled = false
module.updateRate = 2

module.waypoints = {}
module.waypointIndex = 0

module.agentParams = {AgentRadius = 1, AgentHeight = 5, AgentCanJump = false,}
module.path = nil
module.pathCompleted = false

module.targetVector = nil
module.prevVector = nil

module.currentAction = nil
module.actions = {}

local lastUpdated = 0

local actions = loadstring(game:HttpsGet("https://raw.githubusercontent.com/GIFKITS/Roblox/refs/heads/main/Rooms-Autowalk/Pathfinding/actions.lua"))()
local path = loadstring(game:HttpsGet("https://raw.githubusercontent.com/GIFKITS/Roblox/refs/heads/main/Rooms-Autowalk/Pathfinding/path.lua"))()

function module.currentlyWalking()
	return path.currentlyWalking(module)
end

function module.resetPath(...)
	path.resetPath(module, ...)
end

function module.followWaypoint()
	path.followWaypoint(module)
end

function module.computePath()
	path.computePath(module)
end

function module.updateAction()
	actions.updateAction(module)
end

function module.createAction(...)
	return actions.createAction(module, ...)
end

function module.toggle(enable)
	if enable == module.enabled then return end
	module.enabled = enable
	
	if enable and char.checkCharacter() then char.root.CustomPhysicalProperties = PhysicalProperties.new(100) end
	if enable then return end
	if char.checkCharacter() then char.root.CustomPhysicalProperties = PhysicalProperties.new(0.7) end
	
	module.resetPath(true)
	module.currentAction = nil
	module.targetVector = nil
	gifscript.moveVector = nil
end

table.insert(gifscript.connections, runService.Heartbeat:Connect(function()
	if not module.enabled or not char.checkCharacter() then return end
	module.followWaypoint()
	
	local currentTime = os.clock()
	if currentTime - lastUpdated < 1 / module.updateRate then return end
	lastUpdated = currentTime
	
	local rootVelocity = char.root.AssemblyLinearVelocity * Vector3.new(1, 0, 1)
	if rootVelocity.Magnitude < char.humanoid.WalkSpeed / 10 and module.currentlyWalking() then warn("Stuck") module.resetPath(true) end
	
	module.updateAction()
	module.computePath()
end))

return module
