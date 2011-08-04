-----------
-- BOATS
-----------

boatDestiny = {
	pvpChangedList = {}
}

function boatDestiny.addQuendor(keywordHandler, npcHandler, module)

	module = (module == nil) and StdModule.travel or module

	local travelNode = keywordHandler:addKeyword({'quendor'}, StdModule.say, {npcHandler = npcHandler, onlyFocus = true, text = 'Do you want to sail to quendor for 110 gold coins?'})
	travelNode:addChildKeyword({'yes'}, module, {npcHandler = npcHandler, premium = false, level = 0, cost = 110, destination = BOAT_DESTINY_QUENDOR })
	travelNode:addChildKeyword({'no'}, StdModule.say, {npcHandler = npcHandler, onlyFocus = true, reset = true, text = 'Then stay here!'})
end

function boatDestiny.addAracura(keywordHandler, npcHandler, module)

	module = (module == nil) and StdModule.travel or module

	local travelNode = keywordHandler:addKeyword({'aracura'}, StdModule.say, {npcHandler = npcHandler, onlyFocus = true, text = 'Do you want to sail to aracura for 160 gold coins?'})
	travelNode:addChildKeyword({'yes'}, module, {npcHandler = npcHandler, premium = true, level = 0, cost = 160, destination = BOAT_DESTINY_ARACURA })
	travelNode:addChildKeyword({'no'}, StdModule.say, {npcHandler = npcHandler, onlyFocus = true, reset = true, text = 'Then stay here!'})
end

function boatDestiny.addAaragon(keywordHandler, npcHandler, module)

	module = (module == nil) and StdModule.travel or module

	local travelNode = keywordHandler:addKeyword({'aaragon'}, StdModule.say, {npcHandler = npcHandler, onlyFocus = true, text = 'Do you want to sail to aaragon for 130 gold coins?'})
	travelNode:addChildKeyword({'yes'}, module, {npcHandler = npcHandler, premium = true, level = 0, cost = 130, destination = BOAT_DESTINY_AARAGON })
	travelNode:addChildKeyword({'no'}, StdModule.say, {npcHandler = npcHandler, onlyFocus = true, reset = true, text = 'Then stay here!'})
end

function boatDestiny.addSalazart(keywordHandler, npcHandler, module)

	module = (module == nil) and StdModule.travel or module

	local travelNode = keywordHandler:addKeyword({'salazart'}, StdModule.say, {npcHandler = npcHandler, onlyFocus = true, text = 'Do you want to sail to salazart for 130 gold coins?'})
	travelNode:addChildKeyword({'yes'}, module, {npcHandler = npcHandler, premium = true, level = 0, cost = 130, destination = BOAT_DESTINY_SALAZART })
	travelNode:addChildKeyword({'no'}, StdModule.say, {npcHandler = npcHandler, onlyFocus = true, reset = true, text = 'Then stay here!'})
end

function boatDestiny.addNorthrend(keywordHandler, npcHandler, module)

	module = (module == nil) and StdModule.travel or module

	local travelNode = keywordHandler:addKeyword({'northrend'}, StdModule.say, {npcHandler = npcHandler, onlyFocus = true, text = 'Do you want to sail to northrend for 240 gold coins?'})
	travelNode:addChildKeyword({'yes'}, module, {npcHandler = npcHandler, premium = true, level = 0, cost = 240, destination = BOAT_DESTINY_NORTHREND })
	travelNode:addChildKeyword({'no'}, StdModule.say, {npcHandler = npcHandler, onlyFocus = true, reset = true, text = 'Then stay here!'})
end

function boatDestiny.addKashmir(keywordHandler, npcHandler, module)

	module = (module == nil) and StdModule.travel or module

	local travelNode = keywordHandler:addKeyword({'kashmir'}, StdModule.say, {npcHandler = npcHandler, onlyFocus = true, text = 'Do you want to sail to kashmir for 150 gold coins?'})
	travelNode:addChildKeyword({'yes'}, module, {npcHandler = npcHandler, premium = true, level = 0, cost = 150, destination = BOAT_DESTINY_KASHMIR })
	travelNode:addChildKeyword({'no'}, StdModule.say, {npcHandler = npcHandler, onlyFocus = true, reset = true, text = 'Then stay here!'})
end

function boatDestiny.addThaun(keywordHandler, npcHandler, module)

	module = (module == nil) and StdModule.travel or module

	local travelNode = keywordHandler:addKeyword({'thaun'}, StdModule.say, {npcHandler = npcHandler, onlyFocus = true, text = 'Do you want to sail to island of thaun for 110 gold coins?'})
	travelNode:addChildKeyword({'yes'}, module, {npcHandler = npcHandler, premium = true, level = 0, cost = 110, destination = BOAT_DESTINY_THAUN })
	travelNode:addChildKeyword({'no'}, StdModule.say, {npcHandler = npcHandler, onlyFocus = true, reset = true, text = 'Then stay here!'})
end

function boatDestiny.addTrainers(keywordHandler, npcHandler, module)

	module = (module == nil) and D_CustomNpcModules.travelTrainingIsland or module

	local travelNode = keywordHandler:addKeyword({'trainers'}, StdModule.say, {npcHandler = npcHandler, onlyFocus = true, text = 'Do you want to sail to island of trainers for 190 gold coins?'})
	travelNode:addChildKeyword({'yes'}, module, {npcHandler = npcHandler, premium = false, level = 0, cost = 40, destination = BOAT_DESTINY_TRAINERS, entering = true })
	travelNode:addChildKeyword({'no'}, StdModule.say, {npcHandler = npcHandler, onlyFocus = true, reset = true, text = 'Then stay here!'})
end

function boatDestiny.addIslandOfPeace(keywordHandler, npcHandler)

	local function onAsk(cid, message, keywords, parameters, node)
		local npcHandler = parameters.npcHandler
		if(npcHandler == nil) then
			print('[Warning - ' .. getCreatureName(getNpcId()) .. '] NpcSystem:', 'StdModule.travel - Call without any npcHandler instance.')
			return false
		end
	
		if(not npcHandler:isFocused(cid)) then
			return false
		end	
		
		local level = getPlayerLevel(cid)
		
		if(level < 80) then
			npcHandler:say('Você gostaria de pagar 500 moedas de ouro pela passagem que irá o transformar novamente em morador da tranquilidade de Island of Peace?', cid)
			return true
		else
			local date = os.date("*t")
		
			if(date.wday ~= WEEKDAY.MONDAY) then
				npcHandler:say('Desculpe mas o barco que leva de Quendor a Island of Peace so parte as segunda-feiras.', cid)
				npcHandler:resetNpc()
				return true
			end
			
			npcHandler:say('Oh, hoje é segunda-feira e o barco que leva de volta para Island of Peace esta disponivel! Mas lembre-se que lá reina a paz e a tranquilidade e não é permitido a agressividade <...>', cid)
			npcHandler:say('entre seus moradores. Também saiba que você se transformará em morador da ilha, e você somente poderá pegar o barco de volta para Quendor na proxima segunda-feira <...>', cid)
			npcHandler:say('E então, deseja mesmo se mudar para Island of Peace? A passagem custa 500 moedas de ouro.', cid)
			
			return true
		end
	
	end
	
	local function onAccept(cid, message, keywords, parameters, node)
		local npcHandler = parameters.npcHandler
		if(npcHandler == nil) then
			print('[Warning - ' .. getCreatureName(getNpcId()) .. '] NpcSystem:', 'StdModule.travel - Call without any npcHandler instance.')
			return false
		end
	
		if(not npcHandler:isFocused(cid)) then
			return false
		end	
		
		if(isInArray(boatDestiny.pvpChangedList, cid)) then
			npcHandler:say('Oh, consta que chegou em Quendor hoje, desculpe mas por ordens do Rei você não poderá sair de Quendor até a proxima segunda-feira...', cid)
			npcHandler:resetNpc()
			return true		
		end		
		
		if(not doPlayerRemoveMoney(cid, parameters.cost)) then
			npcHandler:say('Oh, infelizmente você não possui o dinheiro necessario para embarcar...', cid)
			npcHandler:resetNpc()
			return true
		end	
		
		if (getPlayerLevel(cid) >= 80) then	
			table.insert(boatDestiny.pvpChangedList, cid)
		end
		
		npcHandler:say('Seja bem vindo de volta a Island of Peace caro ' .. getPlayerName(cid) .. '!', cid)
		doTeleportThing(cid, parameters.destination, false)
		doSendMagicEffect(parameters.destination, CONST_ME_TELEPORT)
		doPlayerSetTown(cid, towns.ISLAND_OF_PEACE)
		doUpdateCreaturePassable(cid)			
		return true
	end

	local travelNode = keywordHandler:addKeyword({'island of peace', 'isle of peace'}, onAsk, {npcHandler = npcHandler, onlyFocus = true})
	travelNode:addChildKeyword({'yes', 'sim'}, onAccept, {npcHandler = npcHandler, cost = 500, destination = BOAT_DESTINY_ISLAND_OF_PEACE })
	travelNode:addChildKeyword({'no', 'não', 'nao'}, StdModule.say, {npcHandler = npcHandler, onlyFocus = true, reset = true, text = 'Mas que pena... Mas tenha um bom dia!!'})
end

function boatDestiny.addQuendorFromIslandOfPeace(keywordHandler, npcHandler)

	local function onAsk(cid, message, keywords, parameters, node)
		local npcHandler = parameters.npcHandler
		if(npcHandler == nil) then
			print('[Warning - ' .. getCreatureName(getNpcId()) .. '] NpcSystem:', 'StdModule.travel - Call without any npcHandler instance.')
			return false
		end
	
		if(not npcHandler:isFocused(cid)) then
			return false
		end	
		
		local level = getPlayerLevel(cid)
		
		if(level < 80) then
			npcHandler:say('Você gostaria de pagar 500 moedas de ouro pela passagem que irá o transformar novamente em morador da perigosa Quendor?', cid)
			return true
		else
			local date = os.date("*t")
		
			if(date.wday ~= WEEKDAY.MONDAY) then
				npcHandler:say('Desculpe mas o barco que leva de Island of Peace a Quendor so parte as segunda-feiras.', cid)
				npcHandler:resetNpc()
				return true
			end
			
			npcHandler:say('Oh, hoje é segunda-feira e o barco que leva de volta para Quendor esta disponivel! Mas você precisa saber que em Quendor é o  local da hostilidade e todos moradores são permitidos de <...>', cid)
			npcHandler:say('se enfrentarem, mesmo até a morte! Também saiba que você se transformará em morador desta perigosa cidade, você somente poderá pegar o barco de volta para <...>', cid)
			npcHandler:say('Island of Peace na proxima segunda-feira. E então, deseja mesmo se mudar para Quendor? A passagem custa 500 moedas de ouro.', cid)
			
			return true
		end
	
	end
	
	local function onAccept(cid, message, keywords, parameters, node)
		local npcHandler = parameters.npcHandler
		if(npcHandler == nil) then
			print('[Warning - ' .. getCreatureName(getNpcId()) .. '] NpcSystem:', 'StdModule.travel - Call without any npcHandler instance.')
			return false
		end
	
		if(not npcHandler:isFocused(cid)) then
			return false
		end	
		
		if(isInArray(boatDestiny.pvpChangedList, cid)) then
			npcHandler:say('Oh, consta que chegou em Island of Peace hoje, desculpe mas por ordens do Rei você não poderá sair da ilha até a proxima segunda-feira...', cid)
			npcHandler:resetNpc()
			return true		
		end		
		
		if(not doPlayerRemoveMoney(cid, parameters.cost)) then
			npcHandler:say('Oh, infelizmente você não possui o dinheiro necessario para embarcar...', cid)
			npcHandler:resetNpc()
			return true
		end	
		
		if(getPlayerLevel(cid) >= 80)then	
			table.insert(boatDestiny.pvpChangedList, cid)
		end
		
		npcHandler:say('Seja bem vindo de volta a Quendor caro ' .. getPlayerName(cid) .. '!', cid)
		doTeleportThing(cid, parameters.destination, false)
		doSendMagicEffect(parameters.destination, CONST_ME_TELEPORT)
		doPlayerSetTown(cid, towns.QUENDOR)
		doUpdateCreatureImpassable(cid)			
		return true
	end

	local travelNode = keywordHandler:addKeyword({'quendor'}, onAsk, {npcHandler = npcHandler, onlyFocus = true})
	travelNode:addChildKeyword({'yes', 'sim'}, onAccept, {npcHandler = npcHandler, cost = 500, destination = BOAT_DESTINY_QUENDOR })
	travelNode:addChildKeyword({'no', 'não', 'nao'}, StdModule.say, {npcHandler = npcHandler, onlyFocus = true, reset = true, text = 'Mas que pena... Mas tenha um bom dia!!'})
end

-----------
-- CARPETS
-----------

carpetDestiny = {}

function carpetDestiny.addAaragon(keywordHandler, npcHandler)

	local travelNode = keywordHandler:addKeyword({'aaragon'}, StdModule.say, {npcHandler = npcHandler, onlyFocus = true, text = 'Do you want to fly in my magic carpet to Aaragon for 60 gold coins?'})
	travelNode:addChildKeyword({'yes'}, StdModule.travel, {npcHandler = npcHandler, premium = true, level = 0, cost = 60, destination = CARPET_DESTINY_AARAGON })
	travelNode:addChildKeyword({'no'}, StdModule.say, {npcHandler = npcHandler, onlyFocus = true, reset = true, text = 'Then stay here!'})
end

function carpetDestiny.addHills(keywordHandler, npcHandler)

	local travelNode = keywordHandler:addKeyword({'hills'}, StdModule.say, {npcHandler = npcHandler, onlyFocus = true, text = 'Do you want to fly in my magic carpet to Hills for 60 gold coins?'})
	travelNode:addChildKeyword({'yes'}, StdModule.travel, {npcHandler = npcHandler, premium = true, level = 0, cost = 60, destination = CARPET_DESTINY_HILLS })
	travelNode:addChildKeyword({'no'}, StdModule.say, {npcHandler = npcHandler, onlyFocus = true, reset = true, text = 'Then stay here!'})
end

function carpetDestiny.addSalazart(keywordHandler, npcHandler)

	local travelNode = keywordHandler:addKeyword({'salazart'}, StdModule.say, {npcHandler = npcHandler, onlyFocus = true, text = 'Do you want to fly in my magic carpet to Salazart for 40 gold coins?'})
	travelNode:addChildKeyword({'yes'}, StdModule.travel, {npcHandler = npcHandler, premium = true, level = 0, cost = 40, destination = CARPET_DESTINY_SALAZART })
	travelNode:addChildKeyword({'no'}, StdModule.say, {npcHandler = npcHandler, onlyFocus = true, reset = true, text = 'Then stay here!'})
end

-----------
-- TRAINS
-----------

trainDestiny = {}

function trainDestiny.addQuendor(keywordHandler, npcHandler)

	local travelNode = keywordHandler:addKeyword({'quendor'}, StdModule.say, {npcHandler = npcHandler, onlyFocus = true, text = 'Do you want to board in this train to Quendor for 330 gold coins?'})
	travelNode:addChildKeyword({'yes'}, StdModule.travel, {npcHandler = npcHandler, premium = true, level = 0, cost = 330, destination = TRAIN_DESTINY_QUENDOR })
	travelNode:addChildKeyword({'no'}, StdModule.say, {npcHandler = npcHandler, onlyFocus = true, reset = true, text = 'Then stay here!'})
end

function trainDestiny.addThorn(keywordHandler, npcHandler)

	local travelNode = keywordHandler:addKeyword({'thorn'}, StdModule.say, {npcHandler = npcHandler, onlyFocus = true, text = 'Do you want to board in this train to Quendor for 270 gold coins?'})
	travelNode:addChildKeyword({'yes'}, StdModule.travel, {npcHandler = npcHandler, premium = true, level = 0, cost = 270, destination = TRAIN_DESTINY_THORN })
	travelNode:addChildKeyword({'no'}, StdModule.say, {npcHandler = npcHandler, onlyFocus = true, reset = true, text = 'Then stay here!'})
end

