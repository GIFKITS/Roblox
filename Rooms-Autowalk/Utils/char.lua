local char = {}
local gifscript = _G.gifscript

local players = game:GetService("Players")
local player = players.LocalPlayer

char.character = nil :: Model
char.humanoid = nil :: Humanoid
char.root = nil :: BasePart

function char.checkCharacter()
	return (char.character and char.humanoid and char.root) and true or false
end

function char.updateCharacter()
	char.character = player.Character or player.CharacterAdded:Wait()
	char.humanoid = char.character:FindFirstChildOfClass("Humanoid") or char.character:WaitForChild("Humanoid")
	char.root = char.character:WaitForChild("HumanoidRootPart")
end

table.insert(gifscript.connections, player.CharacterAdded:Connect(char.updateCharacter))
char.updateCharacter()

return char
