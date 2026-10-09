local module = {}

function module.updateAction(self)
	local actions = {}

	for _,action in self.actions do
		table.insert(actions, action)
	end

	table.sort(actions, function(a, b)
		return a.priority > b.priority
	end)

	for _,action in actions do
		if not action.callback then continue end
		local targetVector, params = action.callback()

		if not targetVector then continue end
		action.params = params
		self.currentAction = action
		self.targetVector = targetVector
		return
	end
	
	self.currentAction = nil
	self.targetVector = nil
end

function module.createAction(self, name, priority, callback)
	local action = {}

	action.name = name
	action.priority = priority
	action.callback = callback

	action.pathCompletedEvent = Instance.new("BindableEvent")
	action.pathCompleted = action.pathCompletedEvent.Event

	action.destroy = function()
		action.pathCompletedEvent:Destroy()
		self.actions[name] = nil
		
		if self.currentAction ~= action then return end
		self.currentAction = nil
		self.targetVector = nil
		self.prevVector = nil
		self.resetPath(true)
	end

	self.actions[name] = action
	return action
end

return module
