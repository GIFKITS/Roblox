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
local viewPly = session and session.viewPly
local moves = session and #session.ucis

-- Gui --

local player = players.LocalPlayer
local playerGui = player.PlayerGui
local chessUI = playerGui:WaitForChild("ChessUI")

local boardFrame = chessUI:WaitForChild("Root"):WaitForChild("Board")
local piecesFrame = boardFrame:WaitForChild("Pieces")

-- Helpers --

local function getPositions()
	return session.positions[session.viewPly]
end

local function isFlipped()
	return app.flipOverride
end

-- UI --

local autoSolvingToggle = solverTab:AddToggle("autoSolvingToggle", {Title = "Auto Solve", Description = "automatically calculates your next best move", Default = false})

-- Pieces --

local allPieces = {}
local myPieces = {}
local enemyPieces = {}

function updatePieces()
	table.clear(allPieces)
	table.clear(myPieces)
	table.clear(enemyPieces)
	
	session = app.session
	viewPly = session and session.viewPly
	moves = session and #session.ucis
	
	for index, id in pairs(getPositions()) do
		local piece = {index = index, square = engine.index64ToAlg(index), id = id}
		table.insert(allPieces, piece)
		if math.sign(id) == session.myColor then table.insert(myPieces, piece) else table.insert(enemyPieces, piece) end
	end
end

function updateMove()
	local currentSession = app.session
	
	if not currentSession or not autoSolvingToggle.Value then return end
	if currentSession == session and currentSession.viewPly == viewPly and #currentSession.ucis == moves then return end
	if session.engine.side ~= session.myColor then return end
	
	updatePieces()
	computeNextMove()
end

-- Solver --

function computeNextMove()
	warn("updated")
end

-- Run --

table.insert(gifscript.connections, RunService.Heartbeat:Connect(function()
	updateMove()
end))
