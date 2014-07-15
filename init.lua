

-- Contains all the players who have an cLuaWindow open.
g_PlayersWithWindows = {}





function Initialize(a_Plugin)
	a_Plugin:SetName("CraftMaker")
	a_Plugin:SetVersion(1)
	
	-- Load the InfoReg shared library:
	dofile(cPluginManager:GetPluginsPath() .. "/InfoReg.lua")

	-- Bind all the commands:
	RegisterPluginInfoCommands();
	
	LOG("Initialized CraftMaker")
	return true
end





function OnDisable()
	for PlayerName, _ in pairs(g_PlayersWithWindows) do
		cRoot:Get():FindAndDoWithPlayer(PlayerName,
			function(a_Player)
				a_Player:CloseWindow(false)
				a_Player:SendMessage(cChatColor.Rose .. "Closing window due to a reload")
			end
		)
	end
end




