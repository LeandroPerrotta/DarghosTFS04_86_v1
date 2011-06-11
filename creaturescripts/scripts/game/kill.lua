function onKill(cid, target, damage, flags)
		
	local cName = string.lower(getCreatureName(target))
	
	if(cName == "ghazran") then
	
		onGhazranDie(corpse)
		
	elseif(cName == "lord vankyner") then
	
		onLordVankynerDie()
	
	elseif(cName == "ungreez") then
	
		onUngreezDie(cid, target, damage, flags)
	end
	
	return TRUE

end

function onUngreezDie(cid, target, damage, flags)

	setPlayerStorageValue(cid, sid.INQ_KILL_UNGREEZ, 1)
end