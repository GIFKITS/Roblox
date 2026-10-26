getgenv().gifscript = {connections = {}}
local gifscript = getgenv().gifscript

local unloader = loadstring(game:HttpGet("https://raw.githubusercontent.com/GIFKITS/Roblox/refs/heads/main/Chess-Solver/unloader.lua"))
gifscript.onUnload = Instance.new("BindableEvent")

local fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()
local window = fluent:CreateWindow({Title = "Chess Solver", SubTitle = "by gifkits", TabWidth = 160, Size = UDim2.fromOffset(580, 460), Acrylic = false, Theme = "Darker", MinimizeKey = Enum.KeyCode.LeftAlt,})
local tabs = {}

tabs.main = window:AddTab({Title = "Main", Icon = "home"})
tabs.solver = window:AddTab({Title = "Solver", Icon = "brain"})

fluent:ToggleTransparency(false)
window:SelectTab(1)

gifscript.ui = {}
gifscript.ui.lib = fluent
gifscript.ui.window = window
gifscript.ui.tabs = tabs

tabs.main:AddButton({Title = "Unload", Description = "unload the script", Callback = unloader})
table.insert(gifscript.connections, fluent.GUI.Destroying:Once(unloader))

local main = loadstring(game:HttpGet("https://raw.githubusercontent.com/GIFKITS/Roblox/refs/heads/main/Chess-Solver/main.lua"))()
