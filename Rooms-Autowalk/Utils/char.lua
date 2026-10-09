local char = {}
local gifscript = getgenv().gifscript

local player = game:GetService("Players").LocalPlayer

char.player = player :: Player?

char.character = nil :: Model?
char.humanoid = nil :: Humanoid?
char.root = nil :: BasePart?

char.collision = nil :: BasePart?
char.crouchCollision = nil :: BasePart?

char.collisionEnabled = true :: boolean

local collisionConnection = nil :: RBXScriptConnection?
local crouchCollisionConnection = nil :: RBXScriptConnection?

local function applyCollision()
	if char.collisionEnabled then return end
	if char.collision then char.collision.CanCollide = false end
	if char.crouchCollision then char.crouchCollision.CanCollide = false end
end

function char.checkCharacter(): boolean
	return char.character ~= nil and char.humanoid ~= nil and char.root ~= nil
end

function char.toggleCollision(enable: boolean)
	char.collisionEnabled = enable
	if char.collision then char.collision.CanCollide = enable end
	if char.crouchCollision then char.crouchCollision.CanCollide = enable end
end

function char.updateCharacter(newCharacter: Model?)
	local character = newCharacter or player.Character or player.CharacterAdded:Wait()

	char.character = character
	char.humanoid = (character:FindFirstChildOfClass("Humanoid") or character:WaitForChild("Humanoid")) :: Humanoid
	char.root = character:WaitForChild("HumanoidRootPart") :: BasePart

	char.collision = character:WaitForChild("Collision") :: BasePart
	char.crouchCollision = character:WaitForChild("CollisionCrouch") :: BasePart

	if collisionConnection then collisionConnection:Disconnect() end
	if crouchCollisionConnection then crouchCollisionConnection:Disconnect() end

	applyCollision()

	collisionConnection = char.collision:GetPropertyChangedSignal("CanCollide"):Connect(applyCollision)
	crouchCollisionConnection = char.crouchCollision:GetPropertyChangedSignal("CanCollide"):Connect(applyCollision)

	table.insert(gifscript.connections, collisionConnection)
	table.insert(gifscript.connections, crouchCollisionConnection)
end

table.insert(gifscript.connections, player.CharacterAdded:Connect(char.updateCharacter))

if player.Character then
	task.spawn(char.updateCharacter, player.Character)
end

return char
