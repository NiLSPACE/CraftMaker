function HandleCraftMakerCommand(a_Split, a_Player)
	if (a_Split[2] == nil) then
		a_Player:SendMessage(cChatColor.Rose .. "Usage: /craftmaker [ItemType/Name] <Count>")
		return true
	end
	
	local Count = 1
	
	if (a_Split[3] ~= nil) then
		if (tonumber(a_Split[3]) == nil) then
			a_Player:SendMessage(cChatColor.Rose .. "Usage: /craftmaker [ItemType/Name] <Count>")
			return true
		end
		
		Count = tonumber(a_Split[3])
	end
			
	
	local ItemType = tonumber(a_Split[2])
	local ItemMeta = 0
	
	-- Maybe it was a string like "stone" or "dirt"
	if (ItemType == nil) then
		local Item = cItem()
		if (not StringToItem(a_Split[2], Item)) then
			local Split = StringSplit(a_Split[2], ":")
			if (#Split == 2) then
				local IsValid = false
				if ((tonumber(Split[1]) == nil) or (tonumber(Split[2]) == nil)) then
					a_Player:SendMessage(cChatColor.Rose .. "Usage: /craftmaker [ItemType/Name] <Count>")
					return true
				else
					IsValid = true
					ItemType = tonumber(Split[1])
					ItemMeta = tonumber(Split[2])
				end
			end
			
			if (not IsValid) then
				a_Player:SendMessage(cChatColor.Rose .. "Usage: /craftmaker [ItemType/Name] <Count>")
				return true
			end
		end
		
		ItemType = Item.m_ItemType
		ItemMeta = Item.m_ItemMeta
	end
		
	local Window = cLuaWindow(cWindow.wtDropSpenser, 3, 3, "CraftMaker")
	
	local OnClosing = function(a_Window, a_Player, a_CanRefuse)
		local Item = cItem(ItemType, 1, ItemMeta)
		local ResultString = ItemToString(Item)
		if (Count ~= 1) then
			ResultString = ResultString .. ", " .. Count
		end
		
		ResultString = ResultString .. " = "
		
		local Items = {}
		for X = 0, 8 do
			local Item = a_Window:GetSlot(a_Player, X)
			local ItemName = ItemToString(Item)
			if (ItemName ~= "-1:0") then
				Items[ItemName] = Items[ItemName] or {}
				local CanAnywhere = Item.m_ItemCount > 1
				table.insert(Items[ItemName], {Item = Item, X = X})
			end
		end
		
		local function GetPlace(a_Pos)
			if (a_Pos == 0) then
				return 1, 1
			elseif (a_Pos == 1) then
				return 2, 1
			elseif (a_Pos == 2) then
				return 3, 1
			elseif (a_Pos == 3) then
				return 1, 2
			elseif (a_Pos == 4) then
				return 2, 2
			elseif (a_Pos == 5) then
				return 3, 2
			elseif (a_Pos == 6) then
				return 1, 3
			elseif (a_Pos == 7) then
				return 2, 3
			elseif (a_Pos == 8) then
				return 3, 3
			end
		end
		
		for ItemName, Places in pairs(Items) do
			ResultString = ResultString .. ItemName
			for Idx, ItemInfo in ipairs(Places) do
				if (ItemInfo.Item.m_ItemCount > 1) then
					ResultString = ResultString .. ", * "
				else
					local X, Y = GetPlace(ItemInfo.X)
					ResultString = ResultString .. ", " .. X .. ":" .. Y
				end
			end
			ResultString = ResultString .. " | "
		end
		
		ResultString = ResultString:sub(1, ResultString:len() - 2)
		
		g_PlayersWithWindows[a_Player:GetName()] = nil
		a_Player:SendMessage("Result in console and a file")
		
		-- Save to file
		do
			local Content = cFile:ReadWholeFile("CraftMaker Results.txt")
			local File = io.open("CraftMaker Results.txt", "w")
			
			if (Content ~= "") then
				File:write(Content .. "\n")
			end
			
			File:write(ResultString)
			File:close()
		end
		
		LOG(ResultString)
	end
	
	Window:SetOnClosing(OnClosing)
	g_PlayersWithWindows[a_Player:GetName()] = true
	a_Player:OpenWindow(Window)
	return true
end



