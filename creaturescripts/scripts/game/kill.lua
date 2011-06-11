function onKill(cid, target, damage, flags)
		
	local cName = getCreatureName(target)
	
	if(cName == "Ghazran") then
	
		onGhazranDie(corpse)
		
	elseif(cName == "Lord Vankyner") then
	
		onLordVankynerDie()
	
	elseif(cName == "Ungreez") then
	
		onUngreezDie(cid, target, damage, flags)
	end
	
	return TRUE

end

function onUngreezDie(cid, target, damage, flags)

	setPlayerStorageValue(cid, sid.INQ_KILL_UNGREEZ, 1)
end