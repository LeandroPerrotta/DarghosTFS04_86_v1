function onStepIn(cid, item, position, fromPosition)

	if(item.actionid >= 30020 and item.actionid < 30100) then
	
		local city = getTownNameById(item.actionid - 30020)
		doPlayerSetTown(cid, item.actionid - 30020)
		doPlayerSendTextMessage(cid, MESSAGE_STATUS_DEFAULT,"Now you are a citizen of "..city..".")
		
		return TRUE
	elseif(item.actionid > 30100 and item.actionid < 30200) then
	
		local town_id = item.actionid - 30100
		local town_name = getTownNameById(town_id)
		doTeleportThing(cid, getTownTemplePosition(town_id))
		doPlayerSendTextMessage(cid, MESSAGE_STATUS_DEFAULT,"Bem vindo a cidade de ".. town_name .."!")
		
		return TRUE
	end
	
	if(item.actionid == aid.CHURCH_PORTAL) then
	
		local destPos = getThingPos(uid.CHURCH_PORTAL_DEST)
	
		local chamberTemptation = getPlayerStorageValue(cid, QUESTLOG.DIVINE_ANKH.CHAMBER_TEMPTATION)
		
		if(chamberTemptation == 3) then
			doTeleportThing(cid, destPos)
			doSendMagicEffect(destPos, CONST_ME_MAGIC_BLUE)
			return TRUE
		end
		
		--print("Church portal")
		
		destPos = getThingPos(uid.CHURCH_PORTAL_FAIL)
		
		doTeleportThing(cid, destPos)
		doSendMagicEffect(destPos, CONST_ME_MAGIC_BLUE)	
		
		doPlayerSendCancel(cid, "Você não pode passar por aqui.")
	end
	
	return TRUE
end
