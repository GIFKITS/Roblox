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
local bot = require(replicatedStorage:WaitForChild("Chess"):WaitForChild("VortexBot"))

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

local function moveTo(from, to, transform)
	warn("move")
	app.onBoardMove(engine.algToIndex64(from), engine.algToIndex64(to), transform or 0, false)
end

local function getPositions()
	return session.positions[session.viewPly]
end

local function isFlipped()
	return app.flipOverride
end

-- UI --

local autoSolvingToggle = solverTab:AddToggle("autoSolvingToggle", {Title = "Auto Solve", Description = "automatically calculates your next best move", Default = false, Callback = function()
	updateMove(true)
end})

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
		if id == 0 then continue end
		local piece = {index = index, square = engine.index64ToAlg(index), id = id}
		table.insert(allPieces, piece)
		if math.sign(id) == session.myColor then table.insert(myPieces, piece) else table.insert(enemyPieces, piece) end
	end
end

function updateMove(updateExist: boolean)
	local currentSession = app.session
	
	if not currentSession or not autoSolvingToggle.Value then return end
	if not updateExist and currentSession == session and currentSession.viewPly == viewPly and #currentSession.ucis == moves then return end
	if currentSession.engine.side ~= currentSession.myColor then return end
	
	updatePieces()
	computeNextMove()
end

-- Solver --

local solveToken = 0

function computeNextMove()
	local current = app.session
	if not current or current.over or not autoSolvingToggle.Value or current.engine.side ~= current.myColor then return end

	solveToken += 1
	local token = solveToken

	task.spawn(function()
		local success, result = pcall(function()
			return bot.analyse(current.startFen, table.clone(current.ucis), 2, 24)
		end)

		if not success then
			warn("[Solver] Analysis failed:", result)
			return
		end

		if token ~= solveToken or not autoSolvingToggle.Value or app.session ~= current or current.over or current.engine.side ~= current.myColor then return end

		local best = result and result.best
		if type(best) ~= "string" or #best < 4 then return end

		local promotion = ({q = 5, r = 4, b = 3, n = 2})[best:sub(5, 5)] or 0
		moveTo(best:sub(1, 2), best:sub(3, 4), promotion)
	end)
end

-- Run --

table.insert(gifscript.connections, RunService.Heartbeat:Connect(function()
	updateMove()
end))
