local gifscript = getgenv().gifscript
local char = gifscript.char

local ui = gifscript.ui
local tabs = ui.tabs
local playerTab = tabs.player

playerTab:AddParagraph({Title = char.checkCharacter() and char.humanoid.DisplayName, Content = string.format("@%s", char.player.Name)})
