local screenUI = script:WaitForChild("ScreenUI")
local player = game.Players.LocalPlayer
local tool = script.Parent
local handle = tool:WaitForChild("Handle", 1)

local isRunning = true
local scannerEnabled = true

local camera = Instance.new("Camera")
camera.Parent = screenUI
camera.FieldOfView = 50

local previousRoom = -1
local currentRoom = -1
local nextFireTime = tick()

local tweenService = game:GetService("TweenService")

screenUI:WaitForChild("ViewNormal").CurrentCamera = camera
screenUI:WaitForChild("ViewSpecial").CurrentCamera = camera

local loadedAnimations = {}

local module = {
	anim = {}
}

local function startScanner()
	screenUI.OffScreen.Visible = false
	screenUI.Static1.ImageTransparency = 0

	tweenService:Create(
		screenUI.Static1,
		TweenInfo.new(3, Enum.EasingStyle.Quart, Enum.EasingDirection.InOut),
		{
			ImageTransparency = 0.9
		}
	):Play()

	screenUI.ViewSpecial.ImageColor3 = Color3.fromRGB(217, 255, 206)

	tweenService:Create(
		screenUI.ViewSpecial,
		TweenInfo.new(0.2, Enum.EasingStyle.Quart, Enum.EasingDirection.InOut, 10, true),
		{
			ImageColor3 = Color3.fromRGB(53, 93, 52)
		}
	):Play()

	camera.FieldOfView = 1

	tweenService:Create(
		camera,
		TweenInfo.new(3, Enum.EasingStyle.Quart, Enum.EasingDirection.InOut),
		{
			FieldOfView = 30
		}
	):Play()

	tool.Handle.Use:Play()
	tool.Handle.Idle:Play()
end

local function disableScanner()
	screenUI.OffScreen.Visible = true
	screenUI.OffScreen.Frame.Size = UDim2.new(1, 0, 1, 0)

	tweenService:Create(
		screenUI.OffScreen.Frame,
		TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
		{
			Size = UDim2.new(1, 0, 0.1, 0)
		}
	):Play()

	delay(0.31, function()
		tweenService:Create(
			screenUI.OffScreen.Frame,
			TweenInfo.new(0.4, Enum.EasingStyle.Quad, Enum.EasingDirection.In, 0),
			{
				Size = UDim2.new(0, 0, 0.1, 0)
			}
		):Play()
	end)

	screenUI.OffScreen.BackgroundColor3 = Color3.fromRGB(39, 59, 33)

	tweenService:Create(
		screenUI.OffScreen,
		TweenInfo.new(2, Enum.EasingStyle.Quart, Enum.EasingDirection.Out, 0),
		{
			BackgroundColor3 = Color3.fromRGB(3, 6, 2)
		}
	):Play()

	tool.Handle.Disable:Play()
	tool.Handle.Idle:Stop()
end

local function renderRoom(room)
	local roomModel = Instance.new("Model")
	roomModel.Name = room.Name
	roomModel.Parent = screenUI.ViewNormal

	for _, descendant in pairs(room:GetDescendants()) do
		if descendant:IsA("BasePart") and descendant.Transparency ~= 1 and descendant.Size.Magnitude > 0.2 then
			local clonedPart = descendant:Clone()
			clonedPart.CanQuery = false
			clonedPart.Parent = roomModel

			if descendant.Anchored == false then
				task.spawn(function()
					while true do
						wait(0.5)

						if not (descendant and descendant.Parent) then
							break
						end

						clonedPart.Position = descendant.Position
					end

					clonedPart:Destroy()
				end)
			end
		end

		if descendant:IsA("Model") and (
			descendant.Name == "KeyObtain"
				or descendant.Name == "LeverForGate"
				or descendant.Name == "LiveBreakerPolePickup"
				or descendant.Name == "LiveHintBook"
			) then
			local marker = script:WaitForChild("Star"):Clone()
			marker.CFrame = descendant.PrimaryPart.CFrame
			marker.Transparency = 0
			marker.Parent = screenUI.ViewSpecial
		end
	end

	local descendantAddedConnection = room.DescendantAdded:Connect(function(descendant)
		if descendant:IsA("BasePart")
			and descendant.Transparency ~= 1
			and descendant.Anchored == true
			and descendant.Size.Magnitude > 0.2
		then
			local clonedPart = descendant:Clone()
			clonedPart.CanQuery = false
			clonedPart.Parent = roomModel

			if descendant.Anchored == false then
				task.spawn(function()
					while true do
						wait(0.5)

						if not (descendant and descendant.Parent) then
							break
						end

						clonedPart.Position = descendant.Position
					end

					clonedPart:Destroy()
				end)
			end
		end
	end)

	roomModel.AncestryChanged:Connect(function()
		descendantAddedConnection:Disconnect()
	end)
end

function module.equip(_tool)
	print("scanner module: tool equipped!")

	for _, animation in pairs(tool:WaitForChild("Animations"):GetChildren()) do
		loadedAnimations[animation.Name] = player.Character.Humanoid:LoadAnimation(animation)
	end

	loadedAnimations.equip:Play()
	loadedAnimations.idle:Play()

	screenUI.Parent = player.PlayerGui
	screenUI.Enabled = true
	screenUI.Adornee = tool:WaitForChild("Handle"):WaitForChild("Screen")

	currentRoom = player:GetAttribute("CurrentRoom")
	previousRoom = currentRoom

	for roomNumber = currentRoom, currentRoom do
		local roomInstance = workspace.CurrentRooms:FindFirstChild(roomNumber)
		local roomExists

		if roomInstance and screenUI.ViewNormal:FindFirstChild(roomNumber) == nil then
			renderRoom(roomInstance)
			roomExists = roomNumber
		else
			roomExists = roomNumber
		end
	end

	wait(0.2)

	isRunning = true
	scannerEnabled = true

	startScanner()

	while isRunning do
		if scannerEnabled == true then
			local _, errorMessage = pcall(function()
				camera.CFrame = tool.Handle.Screen.CFrame * CFrame.Angles(0, 3.141592653589793, 0)

				screenUI.ViewNormal.LightDirection = camera.CFrame.LookVector - Vector3.new(0, 1, 0)

				screenUI.Static1.Position = UDim2.new(
					0.5,
					math.random(-28, 28) * 6,
					0.5,
					math.random(-18, 18) * 6
				)

				screenUI.Static1.Image = math.random(1, 2) == 2
					and "rbxassetid://8681113666"
					or "rbxassetid://8681113503"

				currentRoom = player:GetAttribute("CurrentRoom")

				for _, marker in pairs(screenUI.ViewSpecial:GetChildren()) do
					if marker:IsA("BasePart") then
						marker.CFrame = CFrame.new(marker.Position, camera.CFrame.p)
					end
				end

				if currentRoom ~= previousRoom then
					previousRoom = currentRoom

					startScanner()

					for _, child in pairs(screenUI.ViewNormal:GetChildren()) do
						if child:IsA("Model") then
							child:Destroy()
						end
					end

					for _, child in pairs(screenUI.ViewSpecial:GetChildren()) do
						if child:IsA("BasePart") then
							child:Destroy()
						end
					end

					for roomNumber = currentRoom, currentRoom do
						local roomInstance = workspace.CurrentRooms:FindFirstChild(roomNumber)
						local roomExists

						if roomInstance and screenUI.ViewNormal:FindFirstChild(roomNumber) == nil then
							renderRoom(roomInstance)
							roomExists = roomNumber
						else
							roomExists = roomNumber
						end
					end
				end
			end)

			if errorMessage then
				warn(errorMessage)
			end
		end

		if isRunning == false then
			break
		end

		task.wait(0.033444816053511704)
	end
end

function module.fire()
	if nextFireTime <= tick() then
		nextFireTime = tick() + 0.5

		loadedAnimations.fire:Play(0.05, 1, 1)

		wait(0.2)

		scannerEnabled = not scannerEnabled

		if scannerEnabled == true then
			startScanner()
			return
		end

		disableScanner()
	end
end

function module.unequip(_tool)
	print("scanner module: tool unequipped!")

	screenUI.Parent = script
	screenUI.Enabled = false

	isRunning = false

	for _, child in pairs(handle:GetChildren()) do
		if child:IsA("Sound") then
			child:Stop()
		end
	end

	tool.Handle.Disable:Play()

	for _, child in pairs(screenUI.ViewNormal:GetChildren()) do
		if child:IsA("Model") then
			child:Destroy()
		end
	end

	loadedAnimations.equip:Stop()
	loadedAnimations.idle:Stop()
end

tool.Equipped:Connect(module.equip)
tool.Unequipped:Connect(module.unequip)
tool.Activated:Connect(module.fire)

return module
