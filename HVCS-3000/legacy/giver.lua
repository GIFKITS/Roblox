-- BY GIFKITS --
-- visual only

warn("Loading...")

local player = game:GetService("Players").LocalPlayer
local scanner = game:GetObjects("rbxassetid://108162649962275")[1]
scanner.Parent = player.Backpack

local handle = scanner:WaitForChild("Handle")
local module = scanner:WaitForChild("ToolModule")
local animationsFolder = scanner:WaitForChild("Animations")

animationsFolder.equip.AnimationId = "rbxassetid://8683347070"
animationsFolder.fire.AnimationId = "rbxassetid://8683147284"
animationsFolder.idle.AnimationId = "rbxassetid://8683041690"

handle.Disable.SoundId = "rbxassetid://8690667956"
handle.Idle.SoundId = "rbxassetid://8689839904"
handle.Use.SoundId = "rbxassetid://8689839379"

local moduleSource = loadstring(game:HttpGet("https://raw.githubusercontent.com/GIFKITS/Roblox/refs/heads/main/HVCS-3000/legacy/source.lua"))
setfenv(moduleSource, setmetatable({script = module}, {__index = getfenv()}))
local toolModuleTable = moduleSource()

warn("Loaded")
