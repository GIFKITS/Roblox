local gifscript = getgenv().gifscript

gifscript.onUnload:Fire()
gifscript.onUnload:Destroy()

for _,connection in pairs(gifscript.connections) do
	connection:Disconnect()
end

for _,hook in pairs(gifscript.hooks) do
	if hook[1] == "metamethod" then
		hookmetamethod(hook[2], hook[3], hook[4])
	elseif hook[1] == "reg" then
		hook[2][3] = hook[4]
	end
end

gifscript.ui.lib:Destroy()
getgenv().gifscript = nil

warn("Unloaded")
