local items = {
	[2164] = { sid = sid.EXHAUSTED_ITEM_MIGHT_RING, exhausted = 60},
	[2197] = { sid = sid.EXHAUSTED_ITEM_STONE_SKIN_AMULET, exhausted = 60}
}

function onEquip(cid, item, slot, boolean)

	local item_conf = items[item]

	if(item_conf == nil) then
		return TRUE
	end
	
	local lastEquipDate = getPlayerStorageValue(cid, item_conf.sid) or false
	
	if(not lastEquipDate or os.time() < lastEquipDate + item_conf.exhausted) then
		doPlayerSendTextMessage(cid, MESSAGE_STATUS_CONSOLE_BLUE, "Você deve aguardar " .. item_conf.exhausted .. " segundos para equipar outro item deste tipo.")
		return FALSE
	end
	
	return TRUE
end
