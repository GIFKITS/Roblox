local char = {}
local gifscript = getgenv().gifscript

local runService = game:GetService("RunService")
local players = game:GetService("Players")
local player = players.LocalPlayer

char.player = player :: Player?

char.character = nil :: Model?
char.humanoid = nil :: Humanoid?
char.root = nil :: BasePart?

char.collision = nil :: BasePart?
char.crouchCollision = nil :: BasePart?
char.collisionEnabled = true :: boolean

local oldFriction = nil :: PhysicalProperties
local friction = PhysicalProperties.new(100, 0.3, 0.5)
char.frictionEnabled = false :: boolean

function char.checkCharacter()
	return (char.character and char.humanoid and char.root and char.collision and char.crouchCollision) and true or false
end

function char.updateCharacter()
	char.character = player.Character or player.CharacterAdded:Wait()
	char.humanoid = char.character:FindFirstChildOfClass("Humanoid") or char.character:WaitForChild("Humanoid")
	char.root = char.character:WaitForChild("HumanoidRootPart")
	
	oldFriction = char.root.CustomPhysicalProperties
	
	char.collision = char.character:WaitForChild("Collision")
	char.crouchCollision = char.collision:WaitForChild("CollisionCrouch")
end

table.insert(gifscript.connections, runService.Heartbeat:Connect(function()
	if not char.checkCharacter() then return end
	if char.root.CustomPhysicalProperties ~= friction and char.frictionEnabled then
		char.root.CustomPhysicalProperties = friction
	elseif char.root.CustomPhysicalProperties ~= oldFriction and not char.frictionEnabled then
		char.root.CustomPhysicalProperties = oldFriction
	end
	if not char.collisionEnabled then
		if char.collision.CanCollide then char.collision.CanCollide = false end
		if char.crouchCollision.CanCollide then char.crouchCollision.CanCollide = false end
	end
end))
table.insert(gifscript.connections, player.CharacterAdded:Connect(char.updateCharacter))
char.updateCharacter()

return char
