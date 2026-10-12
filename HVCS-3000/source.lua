warn("Loading")

local ScreenUI = script:WaitForChild("ScreenUI");
local LocalPlayer = game.Players.LocalPlayer;
local script_Parent = script.Parent;
local Handle = script_Parent:WaitForChild("Handle", 1);
local u1 = true;
local u2 = true;
local Camera = Instance.new("Camera");
Camera.Parent = ScreenUI;
Camera.FieldOfView = 50;
local u3 = -1;
local u4 = -1;
local u5 = tick();
local TweenService = game:GetService("TweenService");
ScreenUI:WaitForChild("ViewNormal").CurrentCamera = Camera;
ScreenUI:WaitForChild("ViewSpecial").CurrentCamera = Camera;
local u6 = {};
local v7 = {
	anim = {}
};

local function startup()
	ScreenUI.OffScreen.Visible = false;
	ScreenUI.Static1.ImageTransparency = 0;
	TweenService:Create(ScreenUI.Static1, TweenInfo.new(3, Enum.EasingStyle.Quart, Enum.EasingDirection.InOut), {
		ImageTransparency = 0.9
	}):Play();
	ScreenUI.ViewSpecial.ImageColor3 = Color3.fromRGB(217, 255, 206);
	TweenService:Create(ScreenUI.ViewSpecial, TweenInfo.new(0.2, Enum.EasingStyle.Quart, Enum.EasingDirection.InOut, 10, true), {
		ImageColor3 = Color3.fromRGB(53, 93, 52)
	}):Play();
	Camera.FieldOfView = 1;
	TweenService:Create(Camera, TweenInfo.new(3, Enum.EasingStyle.Quart, Enum.EasingDirection.InOut), {
		FieldOfView = 30
	}):Play();
	script_Parent.Handle.Use:Play();
	script_Parent.Handle.Idle:Play();
end;

local function disable()
	ScreenUI.OffScreen.Visible = true;
	ScreenUI.OffScreen.Frame.Size = UDim2.new(1, 0, 1, 0);
	TweenService:Create(ScreenUI.OffScreen.Frame, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
		Size = UDim2.new(1, 0, 0.1, 0)
	}):Play();
	delay(0.31, function()
		TweenService:Create(ScreenUI.OffScreen.Frame, TweenInfo.new(0.4, Enum.EasingStyle.Quad, Enum.EasingDirection.In, 0), {
			Size = UDim2.new(0, 0, 0.1, 0)
		}):Play();
	end);
	ScreenUI.OffScreen.BackgroundColor3 = Color3.fromRGB(39, 59, 33);
	TweenService:Create(ScreenUI.OffScreen, TweenInfo.new(2, Enum.EasingStyle.Quart, Enum.EasingDirection.Out, 0), {
		BackgroundColor3 = Color3.fromRGB(3, 6, 2)
	}):Play();
	script_Parent.Handle.Disable:Play();
	script_Parent.Handle.Idle:Stop();
end;

local function doroom(p8)
	local Model = Instance.new("Model");
	Model.Name = p8.Name;
	Model.Parent = ScreenUI.ViewNormal;

	for _, descendant in pairs(p8:GetDescendants()) do
		if descendant:IsA("BasePart") and (descendant.Transparency ~= 1 and descendant.Size.Magnitude > 0.2) then
			local u9 = descendant:Clone();
			u9.CanQuery = false;
			u9.Parent = Model;

			if descendant.Anchored == false then
				task.spawn(function()
					while true do
						wait(0.5);

						if not (descendant and descendant.Parent) then
							break;
						end;

						u9.Position = descendant.Position;
					end;

					u9:Destroy();
				end);
			end;
		end;

		if descendant:IsA("Model") and (descendant.Name == "KeyObtain" or (descendant.Name == "LeverForGate" or (descendant.Name == "LiveBreakerPolePickup" or descendant.Name == "LiveHintBook"))) then
			local v10 = script.Star:Clone();
			v10.CFrame = descendant.PrimaryPart.CFrame;
			v10.Parent = ScreenUI.ViewSpecial;
		end;
	end;

	local u13 = p8.DescendantAdded:Connect(function(u11)
		if u11:IsA("BasePart") and (u11.Transparency ~= 1 and (u11.Anchored == true and u11.Size.Magnitude > 0.2)) then
			local u12 = u11:Clone();
			u12.CanQuery = false;
			u12.Parent = Model;

			if u11.Anchored == false then
				task.spawn(function()
					while true do
						wait(0.5);

						if not (u11 and u11.Parent) then
							break;
						end;

						u12.Position = u11.Position;
					end;

					u12:Destroy();
				end);
			end;
		end;
	end);
	Model.AncestryChanged:Connect(function()
		u13:Disconnect();
	end);
end;

function v7.equip(p14)
	print("scanner module: tool equipped!");

	for _, child in pairs(script_Parent:WaitForChild("Animations"):GetChildren()) do
		u6[child.Name] = LocalPlayer.Character.Humanoid:LoadAnimation(child);
	end;

	u6.equip:Play();
	u6.idle:Play();
	ScreenUI.Parent = LocalPlayer.PlayerGui;
	ScreenUI.Enabled = true;
	ScreenUI.Adornee = script_Parent:WaitForChild("Handle"):WaitForChild("Screen");
	u4 = LocalPlayer:GetAttribute("CurrentRoom");
	u3 = u4;

	for i = u4, u4 do
		local v15 = workspace.CurrentRooms:FindFirstChild(i);
		local v16;

		if v15 and ScreenUI.ViewNormal:FindFirstChild(i) == nil then
			doroom(v15);
			v16 = i;
		else
			v16 = i;
		end;
	end;

	wait(0.2);
	u1 = true;
	u2 = true;
	startup();

	while u1 do
		if u2 == true then
			local _, result = pcall(function()
				Camera.CFrame = script_Parent.Handle.Screen.CFrame * CFrame.Angles(0, 3.141592653589793, 0);
				ScreenUI.ViewNormal.LightDirection = Camera.CFrame.LookVector - Vector3.new(0, 1, 0);
				ScreenUI.Static1.Position = UDim2.new(0.5, math.random(-28, 28) * 6, 0.5, math.random(-18, 18) * 6);
				ScreenUI.Static1.Image = math.random(1, 2) == 2 and "rbxassetid://8681113666" or "rbxassetid://8681113503";
				u4 = LocalPlayer:GetAttribute("CurrentRoom");

				for _, child in pairs(ScreenUI.ViewSpecial:GetChildren()) do
					if child:IsA("BasePart") then
						child.CFrame = CFrame.new(child.Position, Camera.CFrame.p);
					end;
				end;

				if u4 ~= u3 then
					u3 = u4;
					startup();

					for _, child in pairs(ScreenUI.ViewNormal:GetChildren()) do
						if child:IsA("Model") then
							child:Destroy();
						end;
					end;

					for _, child in pairs(ScreenUI.ViewSpecial:GetChildren()) do
						if child:IsA("BasePart") then
							child:Destroy();
						end;
					end;

					for i = u4, u4 do
						local v17 = workspace.CurrentRooms:FindFirstChild(i);
						local v18;

						if v17 and ScreenUI.ViewNormal:FindFirstChild(i) == nil then
							doroom(v17);
							v18 = i;
						else
							v18 = i;
						end;
					end;
				end;
			end);

			if result then
				warn(result);
			end;
		end;

		if u1 == false then
			break;
		end;

		task.wait(0.033444816053511704);
	end;
end;

function v7.fire()
	if u5 <= tick() then
		u5 = tick() + 0.5;
		u6.fire:Play(0.05, 1, 1);
		wait(0.2);
		u2 = not u2;

		if u2 == true then
			startup();

			return;
		end;

		disable();
	end;
end;

function v7.unequip(p19)
	print("scanner module: tool unequipped!");
	ScreenUI.Parent = script;
	ScreenUI.Enabled = false;
	u1 = false;

	for _, child in pairs(Handle:GetChildren()) do
		if child:IsA("Sound") then
			child:Stop();
		end;
	end;

	script_Parent.Handle.Disable:Play();

	for _, child in pairs(ScreenUI.ViewNormal:GetChildren()) do
		if child:IsA("Model") then
			child:Destroy();
		end;
	end;

	u6.equip:Stop();
	u6.idle:Stop();
end;

warn("Loaded1")

script_Parent.Equipped:Connect(v7.equip);
script_Parent.Unequipped:Connect(v7.unequip);
script_Parent.Activated:Connect(v7.fire)

warn("Loaded2")

return v7;
