local gifscript = getgenv().gifscript

local replicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local players = game:GetService("Players")

local ui = gifscript.ui
local tabs = ui.tabs

local solverTab = tabs.solver

-- Modules --

local app = require(replicatedStorage:WaitForChild("ChessClient"):WaitForChild("App"))
local engine = require(replicatedStorage:WaitForChild("Chess"):WaitForChild("Engine"))

local session = app.session
local myColor = session and session.myColor

-- Gui --

local player = players.LocalPlayer
local playerGui = player.PlayerGui
local chessUI = playerGui:WaitForChild("ChessUI")

local boardFrame = chessUI:WaitForChild("Root"):WaitForChild("Board")
local piecesFrame = boardFrame:WaitForChild("Pieces")

-- Func --

local function getPositions()
	return session.positions[session.viewPly]
end

-- Pieces --

local allPieces = {}
local myPieces = {}
local enemyPieces = {}

local function updatePieces()
	table.clear(allPieces)
	table.clear(myPieces)
	table.clear(enemyPieces)
	
	session = app.session
	myColor = session and session.myColor
	
	for index, id in pairs(getPositions()) do
		local piece = {index = index, square = engine.index64ToAlg(index), id = id}
		table.insert(allPieces, piece)
		if math.sign(id) == myColor then table.insert(myPieces, piece) else table.insert(enemyPieces, piece) end
	end
	
	warn("updated")
end

updatePieces()

-- Run --

table.insert(gifscript.connections, RunService.Heartbeat:Connect(function()
	if app.session ~= session or (session and session.myColor) ~= myColor then updatePieces() end
end))
