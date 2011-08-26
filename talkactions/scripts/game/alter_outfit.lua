function onSay(cid, words, param)
	if(param == "") then
		doPlayerSendTextMessage(cid, MESSAGE_STATUS_CONSOLE_BLUE, "You need to type the parameter.")
		doSendMagicEffect(playerPos, CONST_ME_POFF)
		return FALSE
	end
	
	param = string.explode(param, ",")
	
	local target = param[1]
	local outfit_id = param[2]
	local addon = param[3]
	local action = "add"
	
	if(param[4] ~= nil and isInArray({"del", "rem"}, param[4])) then
		action = "del"
	end	
	
	local pid = getPlayerByNameWildcard(target)
	if(not pid) then
		doPlayerSendTextMessage(cid, MESSAGE_STATUS_CONSOLE_BLUE, "Player " .. target .. " not found.")
		return true
	end	
	
	if(action == "del") then
		doPlayerRemoveOutfitId(pid, outfit_id, addon)
	else
		doPlayerAddOutfitId(pid, outfit_id, addon)
	end

	return TRUE
end
