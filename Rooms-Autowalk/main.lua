-- SETUP --

getgenv().gifscript = {connections = {}, hooks = {}}
local gifscript = getgenv().gifscript

gifscript.onUnload = Instance.new("BindableEvent")
gifscript.unloaded = false

-- MODULES --

local char = loadstring(game:HttpGet("https://raw.githubusercontent.com/GIFKITS/Roblox/refs/heads/main/Rooms-Autowalk/Utils/char.lua"))()
gifscript.char = char

local rooms = loadstring(game:HttpGet("https://raw.githubusercontent.com/GIFKITS/Roblox/refs/heads/main/Rooms-Autowalk/Utils/rooms.lua"))()
local move = loadstring(game:HttpGet("https://raw.githubusercontent.com/GIFKITS/Roblox/refs/heads/main/Rooms-Autowalk/Utils/move.lua"))()

local pathfinding = loadstring(game:HttpGet("https://raw.githubusercontent.com/GIFKITS/Roblox/refs/heads/main/Rooms-Autowalk/Pathfinding/main.lua"))()
gifscript.pathfinding = pathfinding

-- SERVICES --

local replicatedStorage = game:GetService("ReplicatedStorage")

-- UI --

local fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()
local window = fluent:CreateWindow({
	Title = "Rooms Autowalk",
	SubTitle = "by gifkits",
	TabWidth = 160,
	Size = UDim2.fromOffset(580, 460),
	Acrylic = false,
	Theme = "Dark",
	MinimizeKey = Enum.KeyCode.LeftAlt
})
local tabs = {
	main = window:AddTab({ Title = "Main", Icon = "home" }),
}
gifscript.ui = {}
gifscript.ui.lib = fluent
gifscript.ui.window = window
gifscript.ui.tabs = tabs

tabs.main:AddButton({Title = "Unload", Description = "unloads script", Callback = function()
	loadstring(game:HttpGet("https://raw.githubusercontent.com/GIFKITS/Roblox/refs/heads/main/Rooms-Autowalk/unload.lua"))()
end})
table.insert(gifscript.connections, fluent.GUI.Destroying:Connect(function()
	loadstring(game:HttpGet("https://raw.githubusercontent.com/GIFKITS/Roblox/refs/heads/main/Rooms-Autowalk/unload.lua"))()
end))

window:SelectTab(1)

-- PATHFINDING --

tabs.main:AddToggle("pathfindingToggle", {Title = "Pathfinding", Default = false, Callback = function(value)
	pathfinding.toggle(value)
	char.collisionEnabled = not value
	char.frictionEnabled = value
end})

local actions = {}

actions.door = pathfinding.createAction("door", 1, function()
	return rooms.getDoor():GetPivot().Position
end)

actions.locker = pathfinding.createAction("locker", 2, function()
	if not rooms.checkEntities() or not char.checkCharacter() then return end
	local locker = rooms.getClosestLocker()
	return locker and rooms.getLockerVector(locker), locker or nil
end)

table.insert(gifscript.connections, actions.locker.pathCompleted:Connect(function(locker)
	fireproximityprompt(rooms.getLockerPrompt(locker))
	repeat task.wait() until not rooms.checkEntities()
	rooms.leaveLocker()
end))

actions.stop = pathfinding.createAction("stop", 3, function()
	return (rooms.checkA90() and char.checkCharacter() and not char.character:GetAttribute("Hiding")) and Vector3.one * math.huge or nil
end)

warn("Loaded")
