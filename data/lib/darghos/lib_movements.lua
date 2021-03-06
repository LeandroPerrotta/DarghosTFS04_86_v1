function movementTileOnStepIn(cid, item, position, fromPosition)

	if(item.itemid == 11062 or item.itemid == 11063) then
		doUpdateCreatureImpassable(cid)
	end
	
	if(item.actionid ~= nil and item.actionid == aid.INQ_PORTAL) then
		
		local killUngreez = (getPlayerStorageValue(cid, sid.INQ_KILL_UNGREEZ) == 1) and true or false	
		
		if(not killUngreez) then
			doPlayerSendCancel(cid, "Somente os que ajudam a combater as forças demoniacas estão autorizados a atravessar este portal.")
			doTeleportThing(cid, fromPosition, false)
			doSendMagicEffect(position, CONST_ME_MAGIC_BLUE)
		end
	elseif(item.actionid ~= nil and item.actionid == aid.INQ_UNGREEZ_PORTAL) then
		
		local killUngreez = (getPlayerStorageValue(cid, sid.INQ_KILL_UNGREEZ) == 1) and true or false	
		
		if(killUngreez) then
			doPlayerSendCancel(cid, "Você já derrotou o demonio Ungreez.")
			doTeleportThing(cid, fromPosition, false)
			doSendMagicEffect(position, CONST_ME_MAGIC_BLUE)
		end
	end	

	return false
end

function movementTileOnStepOut(cid, item, position, fromPosition)

	-- special depot tile (non walkover)[
	if(item.itemid == 11062 or item.itemid == 11063 ) then
		doUpdateCreaturePassable(cid)
	end
	
	return false
end

function doUpdateCreatureImpassable(cid)
		
	if(getPlayerGroupId(cid) > GROUP_PLAYER_NON_PVP) then
		return
	end
	
	doPlayerSetGroupId(cid, GROUP_PLAYER)
end

function doUpdateCreaturePassable(cid)

	if(getPlayerGroupId(cid) > GROUP_PLAYER_NON_PVP) then
		return
	end	

	local onIsland = (getPlayerStorageValue(cid, sid.IS_ON_TRAINING_ISLAND) == 1) and true or false
	
	if(getPlayerTown(cid) ~= towns.ISLAND_OF_PEACE and not onIsland) then
		return
	end
	
	doPlayerSetGroupId(cid, GROUP_PLAYER_NON_PVP)	
end

function doTeleportBack(cid, backPos)
	
	if(backPos == nil) then
	
		local teleportTo = (getPlayerStorageValue(cid, sid.TELEPORT_BACK_POS) ~= -1) and unpackPosition(getPlayerStorageValue(cid, sid.TELEPORT_BACK_POS)) or false
	
		if(not teleportTo) then
			print("[Darghos Movement] doTeleportBack - Backpos not found on storage value of player " .. getPlayerName(cid) .. ".")
			return false
		end
		
		doTeleportThing(cid, teleportTo)
		doSendMagicEffect(teleportTo, CONST_ME_MAGIC_BLUE)	
		
		setPlayerStorageValue(cid, sid.TELEPORT_BACK_POS, -1)
	else
		setPlayerStorageValue(cid, sid.TELEPORT_BACK_POS, packPosition(backPos))
	end
	
	return true
end