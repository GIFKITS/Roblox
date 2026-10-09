local char = {}
local gifscript = getgenv().gifscript

local players = game:GetService("Players")
local player = players.LocalPlayer

char.player = player :: Player?

char.character = nil :: Model?
char.humanoid = nil :: Humanoid?
char.root = nil :: BasePart?

char.collision = nil :: BasePart?
char.crouchCollision = nil :: BasePart?

char.collisionEnabled = true :: boolean

local collisionConnection = nil :: RBXScriptConnection?
local crouchCollisionConnection = nil :: RBXScriptConnection?

local function collsionChanged(property)
	if property ~= "CanCollide" or char.collisionEnabled then return end
	char.collision.CanCollide = false
	char.crouchCollision.CanCollide = false
end

function char.checkCharacter()
	return (char.character and char.humanoid and char.root) and true or false
end

function char.updateCharacter()
	char.character = player.Character or player.CharacterAdded:Wait()
	char.humanoid = char.character:FindFirstChildOfClass("Humanoid") or char.character:WaitForChild("Humanoid")
	char.root = char.character:WaitForChild("HumanoidRootPart")
	
	char.collision = char.character:WaitForChild("Collision")
	char.crouchCollision = char.character:WaitForChild("CollisionCrouch")
	
	if not char.collisionEnabled then
		char.collision.CanCollide = false
		char.crouchCollision.CanCollide = false
	end
	
	if collisionConnection then collisionConnection:Disconnect() end
	if crouchCollisionConnection then crouchCollisionConnection:Disconnect() end
	
	collisionConnection = char.collision.Changed:Connect(collsionChanged)
	crouchCollisionConnection = char.crouchCollision.Changed:Connect(collsionChanged)
	table.insert(gifscript.connections, collisionConnection)
	table.insert(gifscript.connections, crouchCollisionConnection)
end

function char.toggleCollision(enable)
	if char.collisionEnabled == enable then return end
	char.collisionEnabled = enable
	char.crouchCollision.CanCollide = enable
	char.collision.CanCollide = enable
end

table.insert(gifscript.connections, player.CharacterAdded:Connect(char.updateCharacter))
char.updateCharacter()

return char
