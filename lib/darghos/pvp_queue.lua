ARENA_QUEUE_VAR = "scenarioState_"

--[[ 
	queue struct:

	queue = {
		//arenas 1x1
		[1] = {
			["single"] = 
			{
				{ cid = cid, join = date}, //single exemple
				{ cid = cid, join = date}, //single exemple
				{ cid = cid, join = date} //single exemple
			}
		},
		//arenas 2x2
		[2] = {
			["group"] = {
				{
					{ cid = cid, join = date},
					{ cid = cid, join = date}
				}				
			},
			["single"] = {
				{ cid = cid, join = date}, //single exemple
				{ cid = cid, join = date} //single exemple
			},
 		},
		//arenas 3x3
		[3] = {
			["group"] = {
				{
					{ cid = cid, join = date},
					{ cid = cid, join = date},
					{ cid = cid, join = date}
				}				
			},
			["single"] = {
				{ cid = cid, join = date}, //single exemple
				{ cid = cid, join = date}, //single exemple
				{ cid = cid, join = date} //single exemple
			},
 		}
		//arenas 5x5
		[4] = {
			["group"] = {
				//group exemple
				{
					{ cid = cid, join = date}, //single exemple
					{ cid = cid, join = date}, //single exemple
				}
			}
 		}
	}
--]]


function getArenaQueue()
	return getGlobalValue(ARENA_QUEUE_VAR)
end

function setArenaQueue(queue)
	setGlobalValue(ARENA_QUEUE_VAR, queue)
end

function getPlayerQueue(cid)
	
	return nil
end

function insertPlayersInQueue(queue, players, inFirst)
	inFirst = inFirst or false

	local group = {}

	for k,v in pairs(players) do
		table.insert(group, {cid = v, join = os.time()})
	end
	
	if(#players == 5) then
		table.insert(queue[ARENA_5X5], group)
	elseif(#players == 3) then
		table.insert(queue[ARENA_3X3]["premade"], group)
	elseif(#players == 2) then
		table.insert(queue[ARENA_2X2]["premade"], group)
	elseif(#players == 1) then
		local rand = math.random(ARENA_1X1, ARENA_3X3)
		
		if(rand == ARENA_1X1) then
			table.insert(queue[rand], group)
		else
			table.insert(queue[rand]["random"], group)
		end
	end	
end

-- Private vars
pvpQueue = {
	queue = {},
	loaded = false
}

function pvpQueue.load()

	local value = luaGlobal.getVar("pvp_queue")
	
	if(value == nil) then
		value = {}
	end
	
	pvpQueue.queue = value
	pvpQueue.loaded = true
end

function pvpQueue.save()

	if(#pvpQueue.queue ~= 0) then
		luaGlobal.setVar("pvp_queue", pvpQueue.queue)
	else
		luaGlobal.unsetVar("pvp_queue")
	end
end

function pvpQueue.getQueue()
	if(not pvpQueue.loaded) then
		error("Tentativa de acessar a fila sem sincronia.")
		return
	end

	return pvpQueue.queue
end

function pvpQueue.size()
	if(not pvpQueue.loaded) then
		error("Tentativa de inserir jogador em uma fila não sincronizada.")
		return
	end
	
	return #pvpQueue.queue
end

function pvpQueue.insert(cid)

	if(not pvpQueue.loaded) then
		error("Tentativa de inserir jogador em uma fila não sincronizada.")
		return
	end
	
	table.insert(pvpQueue.queue, cid)
	pvpQueue.save()
end

function pvpQueue.remove(pos)

	if(not pvpQueue.loaded) then
		error("Tentativa de remover jogador em uma fila não sincronizada.")
		return
	end
	
	pos = pos or 1
	
	table.remove(pvpQueue.queue, pos)
	pvpQueue.save()
end

function pvpQueue.getPlayer(pos)
	
	if(not pvpQueue.loaded) then
		error("Tentativa de ler jogador em uma fila não sincronizada.")
		return
	end
	
	pos = pos or 1
	return pvpQueue.queue[pos]
end

function pvpQueue.getPlayerPosByCid(cid)

	if(not pvpQueue.loaded) then
		error("Tentativa de ler jogador em uma fila não sincronizada.")
		return
	end
	
	local pos = table.find(pvpQueue.queue, cid)
	return pos	
end

function pvpQueue.removePlayerByCid(cid)
	local pos = pvpQueue.getPlayerPosByCid(cid)
	table.remove(pvpQueue.queue, pos)
	pvpQueue.save()
end