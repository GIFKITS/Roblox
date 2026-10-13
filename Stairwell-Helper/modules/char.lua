local module = {}
local gifscript = getgenv().gifscript

local players = game:GetService("Players")
local player = players.LocalPlayer

module.player = player
module.character = nil :: Model?
module.humanoid = nil :: Humanoid?
module.root = nil :: BasePart?

function module.checkCharacter()
	return (module.character and module.character.Parent ~= nil and module.humanoid and module.humanoid.Parent ~= nil and module.root and module.root.Parent ~= nil) and true or false
end

function module.updateCharacter()
	module.character = player.Character or player.CharacterAdded:Wait()
	module.humanoid = module.character:FindFirstChildOfClass("Humanoid") or module.character:WaitForChild("Humanoid")
	module.root = module.character:WaitForChild("HumanoidRootPart")
end

table.insert(gifscript.connections, player.CharacterAdded:Connect(module.updateCharacter))
module.updateCharacter()

return module
