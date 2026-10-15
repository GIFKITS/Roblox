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
landingMapGui.Enabled = false
landingMapGui.DisplayOrder = -100
landingMapGui.IgnoreGuiInset = true

local landingMapHandler = Instance.new("CanvasGroup", landingMapGui)
landingMapHandler.BackgroundTransparency = 1
landingMapHandler.BorderSizePixel = 0
landingMapHandler.Size = UDim2.fromScale(1, 1)

local function getCurrentLanding()
	local playerLanding = char.player:GetAttribute("CurrentRoom")
	for _,landing in pairs(collectionService:GetTagged("LandingPalette")) do
		if landing.Name == tostring(playerLanding) then return landing end
	end
end

local function updateLandingMap()
	if landingMap then landingMap:Destroy() landingMap = nil end
	
	local currentLanding = getCurrentLanding()
	local mapBoard = currentLanding and currentLanding:FindFirstChild("StairwellChunkMapBoard", true) or nil
	if not mapBoard then return end
	
	local mapFrame: Frame = mapBoard:FindFirstChild("Map", true)
	local mapContainer: Frame = mapFrame and mapFrame:WaitForChild("MapContainer", 20) or nil
	task.wait(1)
	
	if not mapContainer then return end
	mapContainer = mapContainer:Clone()
	
	mapContainer.Parent = landingMapHandler
	mapContainer.Rotation = 0
	
	for _,element in pairs(mapContainer:GetChildren()) do
		if element:IsA("ImageLabel") then element.Rotation = 0 end
		if element:IsA("Frame") and element.Name == "Wall" then element.Size = UDim2.fromScale(element.Size.X.Scale, 0.0025) end
	end
	
	landingMap = mapContainer
end

local showLandingMapToggle = visualTab:AddToggle("showLandingMapToggle", {Title = "Show Landing Map", Description = "displays a landing map in the center of your screen", Default = false, Callback = function(value)
	if not landingMap then updateLandingMap() end
	landingMapGui.Enabled = value
end})

-- Connections--

gifscript.onUnload.Event:Once(function()
	landingMapGui:Destroy()
end)

table.insert(gifscript.connections, char.player.AttributeChanged:Connect(function(name)
	if name ~= "CurrentRoom" then return end
	updateLandingMap()
end))

table.insert(gifscript.connections, runService.RenderStepped:Connect(function()
	if fullbrightToggle.Value then lighting.Ambient = fullbrightColor.Value end
end))
