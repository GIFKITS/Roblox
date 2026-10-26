local gifscript = getgenv().gifscript

gifscript.onUnload:Fire()
gifscript.onUnload:Destroy()

for _,connection in pairs(gifscript.connections) do
	connection:Disconnect()
end

gifscript.ui.lib:Destroy()
getgenv().gifscript = nil

warn("Unloaded")
