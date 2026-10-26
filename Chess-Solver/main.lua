local gifscript = getgenv().gifscript

local replicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local players = game:GetService("Players")

local ui = gifscript.ui
local lib = ui.lib
local tabs = ui.tabs

local solverTab = tabs.solver

-- Modules --

local app = require(replicatedStorage:WaitForChild("ChessClient"):WaitForChild("App"))
local engine = require(replicatedStorage:WaitForChild("Chess"):WaitForChild("Engine"))
local bot = require(replicatedStorage:WaitForChild("Chess"):WaitForChild("VortexBot"))

local solveToken = 0
local thinkingThread = nil

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

local autoPlayingToggle = solverTab:AddToggle("autoPlayingToggle", {Title = "Auto Solve And Play", Description = "automatically calculates your next best move and makes it", Default = false, Callback = function(value)
	if value then updateMove(true) end
end})

local highlightNextMove = solverTab:AddToggle("highlightNextMove", {Title = "Auto Solve And Highlight", Description = "automatically calculates your next best move and highlights it", Default = false, Callback = function(value)
	if value then updateMove(true) end
	if not value then app.board:setArrow("highlight", nil) end
end})

-- Pieces --

function updateMove(updateExist: boolean)
	local currentSession = app.session
	
	if not currentSession then return end
	if not updateExist and currentSession == session and currentSession.viewPly == viewPly and #currentSession.ucis == moves then return end
	if currentSession.engine.side ~= currentSession.myColor then return end
	
	session = app.session
	viewPly = session and session.viewPly
	moves = session and #session.ucis
	
	if not autoPlayingToggle.Value and not highlightNextMove.Value then return end
	
	computeNextMove(function(from, to, promotion)
		if autoPlayingToggle.Value then
			app.onBoardMove(engine.algToIndex64(from), engine.algToIndex64(to), promotion or 0, false)
		end
		if highlightNextMove.Value then
			app.board:setArrow("highlight", engine.algToIndex64(from), engine.algToIndex64(to), Color3.fromRGB(114, 85, 231), 0.15)
		end
	end)
end

-- Solver --

function computeNextMove(callback)
	if not session or session.over then return end
	
	if thinkingThread and coroutine.status(thinkingThread) ~= "dead" then
		pcall(task.cancel, thinkingThread)
	end
	
	solveToken += 1
	local token = solveToken
	
	lib:Notify({Title = "Thinking", Content = "The bot is thinking", Duration = 2})

	thinkingThread = task.spawn(function()
		local success, result = pcall(function()
			return bot.analyse(session.startFen, table.clone(session.ucis), 2, 24)
		end)
		if not success then return end
		if token ~= solveToken or app.session ~= session or session.over or session.engine.side ~= session.myColor then return end

		local best = result and result.best
		if type(best) ~= "string" or #best < 4 then return end

		local promotion = ({q = 5, r = 4, b = 3, n = 2})[best:sub(5, 5)] or 0
		if callback then callback(best:sub(1, 2), best:sub(3, 4), promotion) end
	end)
end

-- Unload --

gifscript.onUnload.Event:Once(function()
	app.board:setArrow("highlight", nil)
end)

-- Run --

table.insert(gifscript.connections, RunService.Heartbeat:Connect(function()
	updateMove()
end))
