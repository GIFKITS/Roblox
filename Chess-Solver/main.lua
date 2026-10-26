local gifscript = getgenv().gifscript

local replicatedStorage = game:GetService("ReplicatedStorage")
local players = game:GetService("Players")

local ui = gifscript.ui
local tabs = ui.tabs

local solverTab = tabs.solver

-- Modules --

local app = require(replicatedStorage:WaitForChild("ChessClient"):WaitForChild("App"))
local session = app.session

-- Gui --

local player = players.LocalPlayer
local playerGui = player.PlayerGui
local chessUI = playerGui:WaitForChild("ChessUI")

local boardFrame = chessUI:WaitForChild("Root"):WaitForChild("Board")
local piecesFrame = boardFrame:WaitForChild("Pieces")

-- Pieces --

local piecesId = {
	["rbxassetid://130108347060797"] = {"Pawn", "white"},
	["rbxassetid://111025513068016"] = {"Knight", "white"},
	["rbxassetid://85269847273836"] = {"Bishop", "white"},
	["rbxassetid://133288029788689"] = {"Rook", "white"},
	["rbxassetid://128494764910602"] = {"Queen", "white"},
	["rbxassetid://108253639129512"] = {"King", "white"},
	["rbxassetid://71167246324478"] = {"Pawn", "black"},
	["rbxassetid://104573159846789"] = {"Knight", "black"},
	["rbxassetid://72796651173850"] = {"Bishop", "black"},
	["rbxassetid://92908975354335"] = {"Rook", "black"},
	["rbxassetid://87797543393819"] = {"Queen", "black"},
	["rbxassetid://99364349373891"] = {"King", "black"},
}

local allPieces = {}
local myPieces = {}
local enemyPieces = {}

local function updatePieces()
	
end

table.insert(gifscript.connections, game:GetService("RunService").Heartbeat:Connect(function()
	warn(session)
end))
