function onKill(cid, target, damage, flags)
		
	local cName = string.lower(getCreatureName(target))
	
	if(cName == "ghazran") then
	
		onGhazranDie(corpse)
		
	elseif(cName == "lord vankyner") then
	
		onLordVankynerDie()
	
	elseif(cName == "ungreez") then
	
		onUngreezDie(cid, target, damage, flags)
	end
	
	killMissions(cid, target)
	
	return TRUE

end

function killMissions(cid, target)

	local creatures = { 
		["demon"] = { 
			{ task_storage = sid.TASK_KILL_DEMONS,  task_kills = sid.TASK_KILLED_DEMONS, task_need_kills = 6666 }
		} 
	}
	
	local target_name = string.lower(getCreatureName(target))
	
	if(creatures[target_name] ~= nil) then
		for k,v in pairs(creatures[target_name]) do
		
			local task_status = getPlayeStorageValue(cid, v.task_storage)
			if(task_status == 0) then
				local slains = getPlayerStorageValue(cid, v.task_kills) or 0
				slains = slains + 1
				
				if(slains == v.task_need_kills) then
					doPlayerSendTextMessage(cid, MESSAGE_EVENT_DEFAULT, "Voc� concluiu sua tarefa de derrotar " .. task_need_kills .. " " .. target_name .. ".")
				elseif(slains < v.task_need_kills) then
					doPlayerSendTextMessage(cid, MESSAGE_EVENT_DEFAULT, "Voc� precisa ainda derrotar mais " .. v.task_need_kills - slains .. " " .. target_name .. " para concluir sua tarefa.")
				end
			end
		end
	end
end

function onUngreezDie(cid, target, damage, flags)

	setPlayerStorageValue(cid, sid.INQ_KILL_UNGREEZ, 1)
end