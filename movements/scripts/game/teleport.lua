local function pushBack(cid, position, fromPosition, displayMessage)
	doTeleportThing(cid, fromPosition, false)
	doSendMagicEffect(position, CONST_ME_MAGIC_BLUE)
	if(displayMessage) then
		doPlayerSendTextMessage(cid, MESSAGE_INFO_DESCR, "The tile seems to be protected against unwanted intruders.")
	end
end

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
	
	if(item.actionid >= aid.SHRINE_MIN and item.actionid <= aid.SHRINE_MAX) then
		return teleportToShrine(cid, item, position, fromPosition)
	end
	
	if(item.actionid == aid.CALL_TELEPORT_BACK) then
		return doTeleportBack(cid)
	end
	
	if(item.actionid ~= nil and item.actionid == aid.CHURCH_PORTAL) then
	
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
		return TRUE
	end
	
	return TRUE
end

function teleportToShrine(cid, item, position, fromPosition)

	local actionid = item.actionid

	if((actionid == SHRINE_FIRE or actionid == SHRINE_ENERGY) and not isSorcerer(cid)) then
	
		doPlayerSendCancel(cid, "Somente sorcerers podem atravessar o portal para este santuario.")
		pushBack(cid, position, fromPosition)
		return false
	end
	
	if((actionid == SHRINE_EARTH or actionid == SHRINE_ICE) and not isDruid(cid)) then
	
		doPlayerSendCancel(cid, "Somente druids podem atravessar o portal para este santuario.")
		pushBack(cid, position, fromPosition)
		return false
	end
	
	doTeleportBack(cid, fromPosition)
	return true
end
