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
local playerMarker = nil
local exitSign = nil

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

local function updatePlayerMarker()
	if not playerMarker or not exitSign or not char.checkCharacter() then return end
	
	local playerPos: Vector3 = char.root.Potition - exitSign.Position
	local markerPos = UDim2.fromOffset(playerPos.X, playerPos.Z)
	
	playerMarker.Position = markerPos
end

local function updateLandingMap()
	if landingMap then landingMap:Destroy() landingMap = nil end
	
	local currentLanding = getCurrentLanding()
	if not currentLanding then return end
	
	local mapContainer: Model
	repeat task.wait() mapContainer = currentLanding:FindFirstChild("MapContainer", true) until mapContainer
	task.wait(.5)
	
	mapContainer = mapContainer:Clone()
	
	mapContainer.Parent = landingMapHandler
	mapContainer.Rotation = 0
	
	for _,element in pairs(mapContainer:GetChildren()) do
		if element:IsA("Frame") and element.Name == "Wall" then element.Size = UDim2.fromScale(element.Size.X.Scale, 0.0045) end
	end
		
	exitSign = currentLanding:FindFirstChild("ExitSign", true)
	playerMarker = mapContainer:FindFirstChild("Marker_YouAreHere")
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
	landingMapGui.Enabled = (showLandingMapToggle.Value and getCurrentLanding()) and true or false
	updateLandingMap()
end))

table.insert(gifscript.connections, runService.RenderStepped:Connect(function()
	if fullbrightToggle.Value then lighting.Ambient = fullbrightColor.Value end
	if landingMapGui.Enabled then updatePlayerMarker() end
end))
