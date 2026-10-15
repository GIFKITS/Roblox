local gifscript = getgenv().gifscript
local char = gifscript.char

local runService = game:GetService("RunService")
local lighting = game:GetService("Lighting")

local ui = gifscript.ui
local tabs = ui.tabs

local visualTab = tabs.visual

-- Fullbright --

local fullbrightToggle = visualTab:AddToggle("fullbrightToggle", {Title = "Fullbright", Description = "allows you to see in the dark", Default = false})
local fullbrightColor = visualTab:AddColorpicker("fullbrightColor", {Title = "Fullbright Color", Default = Color3.new(1, 1, 1)})

-- Connections --

gifscript.onUnload.Event:Once(function()
	
end)

table.insert(gifscript.connections, runService.RenderStepped:Connect(function()
	if fullbrightToggle.Value then lighting.Ambient = fullbrightColor.Value end
end))
