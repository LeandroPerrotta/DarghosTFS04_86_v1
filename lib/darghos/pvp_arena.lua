local STATE_WAITING, STATE_STARTING, STATE_RUNNING, STATE_PAUSED = 1, 2, 3, 4

local ITEM_GATE = 9532

--- Private vars
pvpArena = {
	teamOne = nil,
	teamTwo = nil,
	playersQueue = nil,
	state = nil,
	bcMsg = nil
}

-- Cria uma nova instancia de um scenario PvP
function pvpArena:new()
	local obj = {}
	
	obj.teamOne = {}
	obj.teamTwo = {}
	obj.playersQueue = {}
	obj.state = STATE_WAITING
	obj.bcMsg = 0
	setmetatable(obj, self)
	self.__index = self
	return obj
end

function pvpArena:addPlayer(cid, inFirst)

	inFirst = inFirst or false

	if(hasCondition(cid, CONDITION_INFIGHT)) then
		doPlayerSendTextMessage(cid, MESSAGE_STATUS_CONSOLE_BLUE, "Você está em condição de combate. Fique alguns instantes sem entrar em combate e tente novamente.")
		return
	end	

	if(not inFirst) then
		table.insert(self.playersQueue, cid)
	else
		table.insert(self.playersQueue, 1, cid)
	end

	doPlayerSendTextMessage(cid, MESSAGE_STATUS_CONSOLE_BLUE, "Você se juntou a fila para um duelo de arena. Agora você deve aguardar até que apareça algum adversário, isto pode levar de alguns segundos a vários minutos.")

	if(#self.playersQueue >= 2 and self.state == STATE_WAITING) then
		self:prepareGame()
	end
end

function pvpArena:getState()
	return self.state
end

function pvpArena:prepareGame()

	self.state = STATE_STARTING

	table.insert(self.teamOne, {cid = self.playersQueue[1], ready = false})
	table.insert(self.teamTwo, {cid = self.playersQueue[2], ready = false})
	
	table.remove(self.playersQueue, 1)
	table.remove(self.playersQueue, 2)
	
	pvpArena:addGates()
	pvpArena:broadcastMessage()
	addEvent(pvpArena.callBroadcastMessage, 1000 * 30, self)
	addEvent(pvpArena.callBroadcastMessage, 1000 * 45, self)
	addEvent(pvpArena.callBroadcastMessage, 1000 * 55, self)
	addEvent(pvpArena.callRun, 1000 * 60, self)
end

function pvpArena.callRun(pvpArena)
	pvpArena:run()
end

function pvpArena.callBroadcastMessage(pvpArena)
	pvpArena:broadcastMessage()
end

function pvpArena:addGates()

	local teamOneGates = uid.ARENA_TEAM_ONE_WALLS
	
	for k,v in pairs(teamOneGates) do
		local pos = getThingPos(v)
		doCreateItem(ITEM_GATE, pos)
	end
	
	local teamTwoGates = uid.ARENA_TEAM_TWO_WALLS
	
	for k,v in pairs(teamTwoGates) do
		local pos = getThingPos(v)
		doCreateItem(ITEM_GATE, pos)
	end	
end

function pvpArena:removeGates()

	local teamOneGates = uid.ARENA_TEAM_ONE_WALLS
	
	for k,v in pairs(teamOneGates) do
		local pos = getThingPos(v)
		doRemoveItem(getTileItemById(ITEM_GATE, pos))
	end
	
	local teamOneGates = uid.ARENA_TEAM_TWO_WALLS
	
	for k,v in pairs(teamTwoGates) do
		local pos = getThingPos(v)
		doRemoveItem(getTileItemById(ITEM_GATE, pos))
	end	
end

function pvpArena:setPlayerReady(cid)

	local player = self:findPlayer(cid)
	
	if(player == nil) then
		doPlayerSendTextMessage(cid, MESSAGE_STATUS_CONSOLE_BLUE, "Você ainda não foi chamado para uma arena, por favor, continue aguardando se já estiver em uma fila e se não estiver e deseja participar de uma arena digite '!arena join' e aguarde.")
		return
	end	
	
	if(hasCondition(cid, CONDITION_INFIGHT)) then
		doPlayerSendTextMessage(cid, MESSAGE_STATUS_CONSOLE_BLUE, "Você está em condição de combate. Fique alguns instantes sem entrar em combate e tente novamente.")
		return
	end	
	
	player.ready = true
	
	local dest = nil
	local playerTeam = self:getPlayerTeam(getPlayerTeam)
	
	if(playerTeam == 1) then
		dest = getThingPos(uid.AREAN_TEAM_ONE_RESPAWN)
	elseif(playerTeam == 2) then
		dest = getThingPos(uid.AREAN_TEAM_TWO_RESPAWN)
	else
		-- algum alerta?
	end
	
	player.oldPos = getCreaturePosition(cid)
	doTeleportThing(cid, dest)
	registerCreatureEvent(cid, "pvpArena_onKill")
end

function pvpArena:getPlayerReady(cid)

	local player = self:findPlayer(cid)

	if(player == nil) then
		return nil
	end
	
	return player.ready
end

function pvpArena:run()

	if(not self.teamOne[1].ready and self.teamTwo[1].ready) then
		-- o segundo jogador estava pronto, enquanto o primeiro não...
		doPlayerSendTextMessage(self.teamOne[1].cid, MESSAGE_STATUS_CONSOLE_BLUE, "Você não compareceu a batalha... Assim ela foi cancelada.")
		self.teamOne[1] = nil
		
		doPlayerSendTextMessage(self.teamTwo[1].cid, MESSAGE_STATUS_CONSOLE_BLUE, "O seu adversário não compareceu a batalha... Aguarde outro adversário.")
		self:addPlayer(self.teamTwo[1].cid, true)
		self.teamTwo[1] = nil
		
		self.state = STATE_WAITING
		self.bcMsg = 0
		return false
	end
	
	if(self.teamOne[1].ready and not self.teamTwo[1].ready) then
		-- o primeiro jogador estava pronto, enquanto o segundo não...
		doPlayerSendTextMessage(self.teamTwo[1].cid, MESSAGE_STATUS_CONSOLE_BLUE, "Você não compareceu a batalha... Assim ela foi cancelada.")
		self.teamTwo[1] = nil
		
		doPlayerSendTextMessage(self.teamOne[1].cid, MESSAGE_STATUS_CONSOLE_BLUE, "O seu adversário não compareceu a batalha... Aguarde outro adversário.")		
		self:addPlayer(self.teamOne[1].cid, true)
		self.teamOne[1] = nil
		
		self.state = STATE_WAITING
		self.bcMsg = 0		
		return false
	end

	if(not self.teamOne[1].ready and not self.teamTwo[1].ready) then
		-- nenhum dos dois jogadores estavam prontos...
		doPlayerSendTextMessage(self.teamOne[1].cid, MESSAGE_STATUS_CONSOLE_BLUE, "Você não compareceu a batalha... Assim ela foi cancelada.")
		self.teamOne[1] = nil
		
		doPlayerSendTextMessage(self.teamTwo[1].cid, MESSAGE_STATUS_CONSOLE_BLUE, "Você não compareceu a batalha... Assim ela foi cancelada.")
		self.teamTwo[1] = nil
		
		self.state = STATE_WAITING
		self.bcMsg = 0		
		return false
	end	
	
	self.state = GAME_RUNNING
	self:removeGates()	
	pvpArena:broadcastMessage()
	
	return true
end

function pvpArena:getPlayerTeam(cid)
	if(self.teamOne[1].cid == cid) then
		return 1
	end
	
	if(self.teamTwo[1].cid == cid) then
		return 2
	end		
	
	return nil
end

function pvpArena:findPlayer(cid)
	if(self.teamOne[1].cid == cid) then
		return self.teamOne[1]
	end
	
	if(self.teamTwo[1].cid == cid) then
		return self.teamTwo[1]
	end	
	
	return nil
end

function pvpArena:broadcastTeam(team, text, mustBeReady)

	for k,v in pairs(team) do
		if(not mustBeReady or (mustBeReady and v.ready)) then
			local cid = v.cid
			doPlayerSendTextMessage(cid, MESSAGE_STATUS_CONSOLE_BLUE, text)
		end
	end
end

function pvpArena:broadcastMessage()
	
	local text = nil
	local mustBeReady = true
	
	if(self.bcMsg == 0) then
		text = "Você agora está liberado para participar da arena. A batalha iniciará em 60 segundos, digite '!arena ready' quando estiver pronto para ser levado para a arena! Boa sorte!"
		mustBeReady = false
	elseif(self.bcMsg == 1) then
		text = "A batalha irá começar em 30 segundos."
	elseif(self.bcMsg == 3) then
		text = "A batalha irá começar em 15 segundos."		
	elseif(self.bcMsg == 4) then
		text = "A batalha irá começar em 5 segundos."		
	elseif(self.bcMsg == 5) then
		text = "A batalha foi iniciada. Boa sorte!"					
	end
	
	self.bcMsg = self.bcMsg + 1
	
	self:broadcastTeam(self.teamOne, text, mustBeReady)
	self:broadcastTeam(self.teamTwo, text, mustBeReady)
end

instancePvpArena = pvpArena:new()