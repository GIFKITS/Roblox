local gifscript = getgenv().gifscript
local char = gifscript.char

local runService = game:GetService("RunService")

local ui = gifscript.ui
local tabs = ui.tabs
local playerTab = tabs.player

playerTab:AddParagraph({Title = char.checkCharacter() and char.humanoid.DisplayName or "Unknown", Content = string.format("@%s", char.player.Name)})
local humanoidSection = playerTab:AddSection("Humanoid")

-- Speed Boost --

local crouchHook
local crouchHookEnabled = false
local crouchEvent = game:GetService("ReplicatedStorage"):WaitForChild("RemotesFolder"):WaitForChild("Crouch")

local speedBoostSlider = playerTab:AddSlider("MySlider", {Title = "SpeedBoost", Description = "Change speedboost", Default = 0, Min = 0, Max = 100, Rounding = 0, Callback = function(value)
	if char.checkCharacter() and value == 0 then char.character:SetAttribute("SpeedBoost", 0) end
	crouchHookEnabled = value ~= 0
	crouchEvent:FireServer(false, true)
end})

crouchHook = hookmetamethod(game, "__namecall", newcclosure(function(self, ...)
	local method = getnamecallmethod()
	local args = table.pack(...)
	
	if crouchHookEnabled and self == crouchEvent and method == "FireServer" then
		args[2] = true
	end
	
	return crouchHook(self, table.unpack(args))
end))

crouchEvent:FireServer(false)
task.spawn(function()
	if not char.checkCharacter() then return end
	
	local connection
	connection = char.character.AttributeChanged:Connect(function(name)
		if name ~= "Sliding" or not char.checkCharacter() then return end
		char.character:SetAttribute("Sliding", false)
		connection:Disconnect()
	end)
	table.insert(gifscript.connections, connection)
end)

table.insert(gifscript.hooks, {"metamethod", game, "__namecall", crouchHook})

table.insert(gifscript.connections, gifscript.onUnload.Event:Connect(function()
	if char.checkCharacter() then char.character:SetAttribute("SpeedBoost", 0) end
end))

table.insert(gifscript.connections, runService.Heartbeat:Connect(function()
	if speedBoostSlider.Value ~= 0 and char.checkCharacter() then char.character:SetAttribute("SpeedBoost", speedBoostSlider.Value) end
end))
