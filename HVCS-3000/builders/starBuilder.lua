local AssetService = game:GetService("AssetService")

local function createStar(parent: Instance): MeshPart
	local star = AssetService:CreateMeshPartAsync("rbxassetid://2546401234")
	star.Name = "Star"
	star.Color = Color3.fromRGB(165, 137, 121)
	star.Material = Enum.Material.Neon
	star.Transparency = 1
	star.Size = Vector3.new(3, 3, 0.5)
	star.Anchored = true
	star.CanCollide = false
	star.CanQuery = false
	star.CanTouch = false
	star.Parent = parent
	return star
end

return createStar
