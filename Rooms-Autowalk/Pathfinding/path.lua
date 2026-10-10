local module = {}

local gifscript = getgenv().gifscript
local char = gifscript.char

local pathfinding = game:GetService("PathfindingService")

function module.currentlyWalking(self)
	return (#self.waypoints ~= 0 and not self.pathCompleted and self.targetVector and self.enabled) and true or false
end

function module.resetPath(self, recompute)
	self.path = nil
	self.pathCompleted = false
	
	self.waypoints = {}
	self.waypointIndex = 0
	gifscript.moveVector = nil
	
	if recompute then self.prevVector = nil end
end

function module.followWaypoint(self)
	if not self.currentlyWalking() then return end
	
	if self.waypointIndex > #self.waypoints then
		self.pathCompleted = true
		gifscript.moveVector = nil
		
		local pathCompletedEvent = self.currentAction and self.currentAction.pathCompletedEvent or nil
		if pathCompletedEvent then pathCompletedEvent:Fire(self.currentAction.params) end
		return
	end

	local waypointVector = self.waypoints[self.waypointIndex].Position + Vector3.new(0, char.humanoid.HipHeight, 0)
	local direction = (waypointVector - char.root.Position) * Vector3.new(1, 0, 1)
	
	gifscript.moveVector = direction
	if direction.Magnitude < 1 then self.waypointIndex += 1 end
end

function module.computePath(self)
	if not self.targetVector then self.resetPath(true) end
	
	if self.prevVector == self.targetVector then return end
	self.prevVector = self.targetVector
	
	self.resetPath(false)
	self.path = pathfinding:CreatePath(self.agentParams)
	
	local success, err = pcall(function()
		self.path:ComputeAsync(char.root.Position, self.targetVector)
	end)
	
	if success and self.path.Status == Enum.PathStatus.Success then
		self.waypoints = self.path:GetWaypoints()
		self.waypointIndex = 2
		return
	end
	
	self.resetPath(true)
end

return module
