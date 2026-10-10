local gifscript = getgenv().gifscript
local char = gifscript.char

local runService = game:GetService("RunService")

for key, value in pairs(getreg()) do
	if type(value) ~= "table" or not rawget(value, "GetMoveVector") then continue end
	local method = value.GetMoveVector

	table.insert(gifscript.hooks, {value, "GetMoveVector", method})

	value.GetMoveVector = function(self, ...)
		if gifscript.moveVector then return Vector3.new(0, 0, -1) end
		return method(self, ...)
	end

	break
end

table.insert(gifscript.connections, runService.RenderStepped:Connect(function()
	if not char.checkCharacter() or not gifscript.moveVector then return end
	char.humanoid:Move(gifscript.moveVector)
end))
