-- GIFSCRIPT --

local gifscript = getgenv().gifscript
local char = gifscript.char

-- UI

local ui = gifscript.ui
local lib = ui.lib
local window = ui.window
local tabs = ui.tabs

tabs.main:AddSection("other")

-- SERVICES --

local virtualUser = game:GetService("VirtualUser")
local runService = game:GetService("RunService")
local lighting = game:GetService("Lighting")

-- Fullbright --

local fullbrightToggle = tabs.main:AddToggle({Title = "Fullbright", Default = false})

table.insert(gifscript.connections, runService.Heartbeat:Connect(function()
	if fullbrightToggle.Value then lighting.Ambient = Color3.new(1, 1, 1) end
end))

-- ANTI AFK --

local antiAfkToggle = tabs.main:AddToggle({Title = "Anti-AFK", Default = false})

table.insert(gifscript.connections, char.player.Idled:Connect(function()
	if not antiAfkToggle.Value then return end
	virtualUser:CaptureController()
	virtualUser:ClickButton2(Vector2.new())
end))
