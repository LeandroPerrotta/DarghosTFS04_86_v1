function onStartup()

	spoofPlayers()
	Dungeons.onServerStart()
	summonLordVankyner()	
	
	local sendPlayerToTemple = getGlobalStorageValue(gid.SEND_PLAYERS_TO_TEMPLE)
	
	if(sendPlayerToTemple == 1) then
		db.executeQuery("UPDATE `players` SET `posx` = '0', `posy` = '0', `posz` = '0';")
		setGlobalStorageValue(gid.SEND_PLAYERS_TO_TEMPLE, 0)
		print("Sending players to temple.")
	end	
	
	local runDbManutention = getGlobalStorageValue(gid.DB_MANUTENTION_STARTUP)
	
	if(runDbManutention == 1) then
		setGlobalStorageValue(gid.DB_MANUTENTION_STARTUP, 0)
		print("Runing db manutention...")		
		dbManutention()
	end
	
	db.executeQuery("UPDATE `players` SET `afk` = 0 WHERE `world_id` = " .. getConfigValue('worldId') .. " AND `afk` > 0;")
	addEvent(autoBroadcast, 1000 * 60 * 30)
	
	return true
end

function autoBroadcast()

	local message = "<Novo Sistema> Você gosta de pvp? duelos? Então mão deixe de conhecer o novo PvP Arena. Para saber mais acesse: http://www.darghos.com.br/index.php?ref=darghopedia.pvp_arenas"
	doBroadcastMessage(message, MESSAGE_TYPES["blue"])
	addEvent(autoBroadcast, 1000 * 60 * 60)
end

function dbManutention()

	local oldCustomItemsStartRange = 13332
	local oldCustomItemsEndRange = 13352
	local newStartRange = 12669
	
	db.executeQuery("UPDATE `player_items` SET `itemtype` = " .. newStartRange .. " + (`itemtype` - " .. oldCustomItemsStartRange .. ") WHERE `itemtype` >= " .. oldCustomItemsStartRange .. " AND `itemtype` <= " .. oldCustomItemsEndRange .. ";")
	db.executeQuery("UPDATE `player_depotitems` SET `itemtype` = " .. newStartRange .. " + (`itemtype` - " .. oldCustomItemsStartRange .. ") WHERE `itemtype` >= " .. oldCustomItemsStartRange .. " AND `itemtype` <= " .. oldCustomItemsEndRange .. ";")
	db.executeQuery("UPDATE `tile_items` SET `itemtype` = " .. newStartRange .. " + (`itemtype` - " .. oldCustomItemsStartRange .. ") WHERE `itemtype` >= " .. oldCustomItemsStartRange .. " AND `itemtype` <= " .. oldCustomItemsEndRange .. ";")
end