local gifscript = getgenv().gifscript

gifscript.onUnload:Fire()
gifscript.pathfinding.toggle(false)

for _,connection in pairs(gifscript.connections) do
	connection:Disconnect()
end

for _,hook in pairs(gifscript.hooks) do
	hook[1][2] = hook[3]
end

gifscript.uiLib:Destroy()
gifscript.onUnload:Destroy()
getgenv().gifscript = nil

warn("Unloaded")
