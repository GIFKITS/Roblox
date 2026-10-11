local AssetService = game:GetService("AssetService")

local function weld(p0: BasePart, p1: BasePart, c0: CFrame, c1: CFrame)
	local manualWeld = Instance.new("ManualWeld")
	manualWeld.Name = "ManualWeld"
	manualWeld.Part0 = p0
	manualWeld.Part1 = p1
	manualWeld.C0 = c0
	manualWeld.C1 = c1
	manualWeld.Parent = p0
end

local function newSound(parent: Instance, name: string, soundId: string, looped: boolean)
	local sound = Instance.new("Sound")
	sound.Name = name
	sound.SoundId = soundId
	sound.Looped = looped
	sound.PlaybackSpeed = 1.08
	sound.Volume = 0.4
	sound.Parent = parent
end

local function newAnimation(parent: Instance, name: string, animationId: string)
	local animation = Instance.new("Animation")
	animation.Name = name
	animation.AnimationId = animationId
	animation.Parent = parent
end

local function createScannerBase(parent: Instance): Part
	local handle = Instance.new("Part")
	handle.Name = "Handle"
	handle.Color = Color3.fromRGB(117, 117, 122)
	handle.Material = Enum.Material.Neon
	handle.Transparency = 1
	handle.Size = Vector3.one
	handle.CanCollide = false
	handle.Parent = parent

	local base = AssetService:CreateMeshPartAsync("rbxassetid://11336908652")
	base.Name = "Meshes/Scanner"
	base.Color = Color3.fromRGB(73, 80, 74)
	base.Material = Enum.Material.Metal
	base.Size = Vector3.new(1.653, 1.052, 0.289)
	base.Massless = true
	base.CanCollide = false
	base.CanQuery = false
	base.CanTouch = false
	base.Parent = handle
	weld(base, handle, CFrame.Angles(0, math.rad(180), 0), CFrame.new(-0.004, 0.005, 0) * CFrame.Angles(0, math.rad(180), 0))

	local screen = Instance.new("Part")
	screen.Name = "Screen"
	screen.Color = Color3.fromRGB(43, 43, 44)
	screen.Material = Enum.Material.Plastic
	screen.Size = Vector3.new(1.117, 0.794, 0.125)
	screen.Massless = true
	screen.CanCollide = false
	screen.CanQuery = false
	screen.CanTouch = false
	screen.Parent = handle
	weld(screen, handle, CFrame.Angles(0, math.rad(180), 0), CFrame.new(0.147, -0.013, -0.063) * CFrame.Angles(0, math.rad(180), 0))

	local animationsFolder = Instance.new("Folder")
	animationsFolder.Name = "Animations"
	animationsFolder.Parent = parent

	newAnimation(animationsFolder, "equip", "rbxassetid://8683347070")
	newAnimation(animationsFolder, "fire", "rbxassetid://8683147284")
	newAnimation(animationsFolder, "idle", "rbxassetid://8683041690")

	newSound(handle, "Disable", "rbxassetid://8690667956", false)
	newSound(handle, "Idle", "rbxassetid://8689839904", true)
	newSound(handle, "Use", "rbxassetid://8689839379", false)

	return handle
end

return createScannerBase
