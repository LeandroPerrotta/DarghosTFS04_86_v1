function onTime(time)

	local date = os.date("*t")
	local SUNDAY = 1
	
	if(date.wday ~= SUNDAY) then
		return true
	end

	local message = "O evento #NOME# está para começar em 10 minutos."
	doBroadcastMessage(message, MESSAGE_TYPES["blue"])
	
	addEvent(eventStart, 1000 * 60 *  10)
	
	return true
end

function eventStart()

	setGlobalStorageValue(gid.EVENT_MINI_GAME_STATE, 1)
	
	local message = "O evento #NOME# foi iniciado!"
	doBroadcastMessage(message, MESSAGE_TYPES["blue"])	
	
	local boss_pos = getThingPosition(uid.MINI_GAME_BOSS)
	local boss = doSummonCreature("boss", boss_pos)	
	
	registerCreatureEvent(boss, "minigameOnBossDeath")
end