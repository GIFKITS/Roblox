-- GIFSCRIPT --

local gifscript = getgenv().gifscript
local char = gifscript.char

-- UI

local ui = gifscript.ui
local lib = ui.lib
local window = ui.window
local tabs = ui.tabs

-- SERVICES --

local virtualUser = game:GetService("VirtualUser")
local runService = game:GetService("RunService")
local lighting = game:GetService("Lighting")
local replicatedStorage = game:GetService("ReplicatedStorage")

-- EVENTS --

local remotesFolder = replicatedStorage:WaitForChild("RemotesFolder")
local crouchEvent = remotesFolder:WaitForChild("Crouch")
local unloadEvent = gifscript.onUnload

-- SPEED BOOST --

tabs.main:AddSection("speed boost")

local speedboostInput = tabs.main:AddSlider("speedboostInput", {Title = "Speed Boost", Default = 0, Min = 0, Max = 30, Rounding = 1})

local speedboostToggle = tabs.main:AddToggle("speedboostToggle", {Title = "Speed Boost Enabled", Default = false, Callback = function(value)
	if value then
		char.character:SetAttribute("SpeedBoost", speedboostInput.Value)
	else
		char.character:SetAttribute("SpeedBoost", 0)
	end
end,})

speedboostInput:OnChanged(function(value)
	if not speedboostToggle.Value or not char.checkCharacter() then return end
	char.character:SetAttribute("SpeedBoost", value)
end)

-- FULLBRIGHT --

tabs.main:AddSection("other")

local fullbrightToggle = tabs.main:AddToggle("fullbrightToggle", {Title = "Fullbright", Default = false})

-- ANTI AFK --

local antiAfkToggle = tabs.main:AddToggle("antiAfkToggle", {Title = "Anti-AFK", Default = false})

table.insert(gifscript.connections, char.player.Idled:Connect(function()
	if not antiAfkToggle.Value then return end
	virtualUser:CaptureController()
	virtualUser:ClickButton2(Vector2.new())
end))

-- LOOP --

table.insert(gifscript.connections, runService.RenderStepped:Connect(function()
	if fullbrightToggle.Value then lighting.Ambient = Color3.new(1, 1, 1) end
	if speedboostToggle.Value and char.checkCharacter() then crouchEvent:FireServer(false, true) end
end))
