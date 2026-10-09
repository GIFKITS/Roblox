local gifscript = getgenv().gifscript
if not gifscript or gifscript.unloaded then return end

gifscript.unloaded = true
gifscript.onUnload:Fire()

gifscript.pathfinding.toggle(false)
gifscript.char.collisionEnabled = true
gifscript.char.frictionEnabled = false

for _,connection in pairs(gifscript.connections) do
	connection:Disconnect()
end

for _,hook in pairs(gifscript.hooks) do
	hook[1][2] = hook[3]
end

gifscript.ui.lib:Destroy()
gifscript.onUnload:Destroy()
getgenv().gifscript = nil

warn("Unloaded")
