local gifscript = getgenv().gifscript
local char = gifscript.char

local collectionService = game:GetService("CollectionService")
local runService = game:GetService("RunService")
local lighting = game:GetService("Lighting")

local ui = gifscript.ui
local tabs = ui.tabs

local visualTab = tabs.visual

-- Fullbright --

local fullbrightToggle = visualTab:AddToggle("fullbrightToggle", {Title = "Fullbright", Description = "allows you to see in the dark", Default = false})
local fullbrightColor = visualTab:AddColorpicker("fullbrightColor", {Title = "Fullbright Color", Default = Color3.new(1, 1, 1)})

-- Landing --

visualTab:AddSection("Landing")

local landingMap = nil
local landingMapGui = Instance.new("ScreenGui", game.CoreGui)

local landingMapHandler = Instance.new("CanvasGroup", landingMapGui)
landingMapHandler.BackgroundTransparency = 1
landingMapHandler.BorderSizePixel = 0
landingMapHandler.Size = UDim2.fromScale(1, 1)

local function getCurrentLanding()
	local landings = collectionService:GetTagged("LandingPalette")
	local playerLanding = char.player:GetAttribute("CurrentRoom")
	return table.find(landings, tostring(playerLanding))
end

local function updateLandingMap()
	if landingMap then landingMap:Destroy() end
	
	local currentLanding = getCurrentLanding()
	local mapBoard = currentLanding and currentLanding:FindFirstChild("StairwellChunkMapBoard", true) or nil
	if not mapBoard then return end
	
	local mapFrame: Frame = mapBoard:FindFirstChild("MapContainer", true)
	if not mapFrame then return end
	mapFrame = mapFrame:Clone()
	
	mapFrame.Parent = landingMapHandler
	mapFrame.Rotation = 0
	
	for _,icon in pairs(mapFrame:GetChildren()) do
		if icon:IsA("ImageLabel") then icon.Rotation = 0 end
	end
	
	landingMap = mapFrame
end

local showLandingMapToggle = visualTab:AddToggle("showLandingMapToggle", {Title = "Show Landing Map", Description = "displays a landing map in the center of your screen", Default = false, Callback = function(value)
	if not landingMap then updateLandingMap() end
	landingMapGui.Enabled = value
end})

-- Connections--

gifscript.onUnload.Event:Once(function()
	landingMapGui:Destroy()
end)

table.insert(gifscript.connections, char.player.AttributeChanged(function(name)
	if name ~= "CurrentRoom" or not getCurrentLanding() then return end
	updateLandingMap()
end))

table.insert(gifscript.connections, runService.RenderStepped:Connect(function()
	if fullbrightToggle.Value then lighting.Ambient = fullbrightColor.Value end
end))
