local STATE_WAITING, STATE_STARTING, STATE_RUNNING, STATE_PAUSED = 1, 2, 3, 4
local TEAM_ONE, TEAM_TWO = 1, 2

local ITEM_GATE = 9532

--- Private vars
pvpArena = {
	teams = nil,
	playersQueue = nil,
	state = STATE_WAITING,
	bcMsg = 0
}

-- Cria uma nova instancia de um scenario PvP
function pvpArena:new()
	local obj = {}
	
	obj.teams = {[TEAM_ONE] = {}, [TEAM_TWO] = {}}
	obj.playersQueue = {}
	setmetatable(obj, self)
	self.__index = self
	return obj
end

----------------------
-- QUEUE HANDLER -----
----------------------

function pvpArena:updateQueue()
	luaGlobal.setVar("pvp_queue", self.playersQueue)
end

function pvpArena:importQueue()
	self.playersQueue = luaGlobal.getVar("pvp_queue")
end

function pvpArena:addToQueue(cid, pos)
	pos = pos or false
	
	if(not pos) then
		table.insert(self.playersQueue, cid)
	else
		table.insert(self.playersQueue, pos, cid)
	end
	
	self:updateQueue()
end

function pvpArena:getFromQueue(pos)
	self:importQueue()
	pos = pos or 1
	return self.playersQueue[pos]
end

function pvpArena:removeFromQueue(pos)
	self:importQueue()
	pos = pos or 1
	table.remove(self.playersQueue, pos)
	self:updateQueue()
end

function pvpArena:getQueueSize()
	self:importQueue()
	return #self.playersQueue
end

----------------------
-- TEAMS HANDLER -----
----------------------
function pvpArena:updateTeams()
	luaGlobal.setVar("pvp_teams", self.teams)
end

function pvpArena:importTeams()
	self.teams = luaGlobal.getVar("pvp_teams")
end

function pvpArena:addToTeam(team, cid)
	self:importTeams()
	local t = {cid = cid, ready = false, oldPos = {}}
	table.insert(self.teams[team], t)
	self:updateTeams()
end

function pvpArena:getTeams()
	self:importTeams()
	return self.teams
end

function pvpArena:clearTeams()
	self.teams = {[TEAM_ONE] = {}, [TEAM_TWO] = {}}
	self:updateTeams()
end

function pvpArena:getPlayerReady(cid)

	local player = self:findPlayer(cid)

	if(player == nil) then
		return nil
	end
	
	return player.ready
end

function pvpArena:getPlayerTeam(cid)

	local team = nil
	for tk,tv in pairs(self:getTeams()) do	
		team = tk
		
		for pk,pv in pairs(tv) do	
			if(pv.cid == cid) then
				return team
			end	
		end
	end
	
	return nil
end

function pvpArena:findPlayer(cid)

	for tk,tv in pairs(self:getTeams()) do	
		for pk,pv in pairs(tv) do	
			if(pv.cid == cid) then
				return pk
			end	
		end
	end
	
	return nil
end

function pvpArena:removePlayer(cid)

	local team, key = nil, nil
	local teams = self:getTeams()

	for tk,tv in pairs(teams) do	
		team = tk
		for pk,pv in pairs(tv) do	
			if(pv.cid == cid) then
				key = pk
			end	
		end
	end
	
	teams[team][key] = nil
	self:updateTeams()
end

function pvpArena:setPlayerIsReady(player)
	player.ready = true
	self:updateTeams()
end

function pvpArena:getPlayerOldPos(player)
	return player.oldPos
end

function pvpArena:setPlayerOldPos(player, pos)
	player.oldPos = pos
	self:updateTeams()
end

----------------------
-- STATE HANDLER -----
----------------------

function pvpArena:updateState()
	luaGlobal.setVar("pvp_state", self.state)
end

function pvpArena:importState()
	self.state = luaGlobal.getVar("pvp_state")
end

function pvpArena:getState()
	self:importState()
	return self.state
end

function pvpArena:setState(state)
	self.state = state
	self:updateState()
end

-------------------------
-- FUNCTIONS SECTOR -----
-------------------------

function pvpArena:addPlayer(cid, inFirst)

	inFirst = inFirst or false

	if(hasCondition(cid, CONDITION_INFIGHT)) then
		doPlayerSendTextMessage(cid, MESSAGE_STATUS_CONSOLE_BLUE, "Você está em condição de combate. Fique alguns instantes sem entrar em combate e tente novamente.")
		return
	end	

	if(not inFirst) then
		self:addToQueue(cid)
	else
		self:addToQueue(cid, 1)
	end
	
	doPlayerSendTextMessage(cid, MESSAGE_STATUS_CONSOLE_BLUE, "Você se juntou a fila para um duelo de arena. Agora você deve aguardar até que apareça algum adversário, isto pode levar de alguns segundos a vários minutos.")
	self:prepareGame()
end

function pvpArena:finishGame(winner, looser)

	local tmp_player = self:findPlayer(winner)
	self:teleportPlayerOut(tmp_player)
	doPlayerSendTextMessage(tmp_player.cid, MESSAGE_STATUS_CONSOLE_BLUE, "Parabens! É um verdadeiro vencedor! Você será levado ao local aonde estava em alguns instantes...")
	
	tmp_player = self:findPlayer(looser)
	self:teleportPlayerOut(tmp_player, true)
	doPlayerSendTextMessage(tmp_player.cid, MESSAGE_STATUS_CONSOLE_BLUE, "Mas que pena, não foi desta vez! Você será levado ao local aonde estava em alguns instantes...")
	
	self:clearTeams()
	
	self:setState(STATE_WAITING)
	self:prepareGame()
end

function pvpArena:prepareGame()

	if(self:getQueueSize() < 2 or self:getState() ~= STATE_WAITING) then
		return
	end

	self:setState(STATE_STARTING)

	self:addToTeam(TEAM_ONE, self:getFromQueue(1))
	self:addToTeam(TEAM_TWO, self:getFromQueue(2))
	
	-- duas vezes para remover os dois primeiros
	self:removeFromQueue()
	self:removeFromQueue()
	
	self:addGates()
	self:broadcastMessage()
	addEvent(pvpArena.callBroadcastMessage, 1000 * 30, self)
	addEvent(pvpArena.callBroadcastMessage, 1000 * 45, self)
	addEvent(pvpArena.callBroadcastMessage, 1000 * 55, self)
	addEvent(pvpArena.callRun, 1000 * 60, self)
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
		local thing = getTileItemById(getThingPos(v), ITEM_GATE)
		doRemoveItem(thing.uid)
	end
	
	local teamTwoGates = uid.ARENA_TEAM_TWO_WALLS
	
	for k,v in pairs(teamTwoGates) do
		local thing = getTileItemById(getThingPos(v), ITEM_GATE)
		doRemoveItem(thing.uid)
	end	
end

function pvpArena:onPlayerReady(cid)

	local player = self:findPlayer(cid)
	
	if(player == nil) then
		doPlayerSendTextMessage(cid, MESSAGE_STATUS_CONSOLE_BLUE, "Você ainda não foi chamado para uma arena, por favor, continue aguardando se já estiver em uma fila e se não estiver e deseja participar de uma arena digite '!arena join' e aguarde.")
		return
	end	
	
	if(hasCondition(cid, CONDITION_INFIGHT)) then
		doPlayerSendTextMessage(cid, MESSAGE_STATUS_CONSOLE_BLUE, "Você está em condição de combate. Fique alguns instantes sem entrar em combate e tente novamente.")
		return
	end	
	
	self:setPlayerIsReady(player)
	
	local dest = {}
	local playerTeam = self:getPlayerTeam(cid)
	
	if(playerTeam == TEAM_ONE) then
		dest = getThingPos(uid.ARENA_TEAM_ONE_RESPAWN)
	elseif(playerTeam == TEAM_TWO) then
		dest = getThingPos(uid.ARENA_TEAM_TWO_RESPAWN)
	else
		print("pvpArena:setPlayerReady -> Não foi possivel localizar o time do jogador.")
		return
	end
	
	self:setPlayerOldPos(player, getCreaturePosition(cid))

	doTeleportThing(cid, dest)
	registerCreatureEvent(cid, "pvpArena_onKill")
end

function pvpArena:teleportPlayerOut(player, instant)

	instant = (instant ~= nil) and instant or false
	
	if(instant) then
		addEvent(doTeleportThing, 1000 * 2, player.cid, player.oldPos)
	else
		doTeleportThing(player.cid, player.oldPos)
	end
end

function pvpArena:run()

	local teams = self.getTeams()
	local team_one, team_two = teams[TEAM_ONE], teams[TEAM_TWO]

	if(not team_one[1].ready and team_two[1].ready) then
		-- o segundo jogador estava pronto, enquanto o primeiro não...
		doPlayerSendTextMessage(team_one[1].cid, MESSAGE_STATUS_CONSOLE_BLUE, "Você não compareceu a batalha... Assim ela foi cancelada.")
		
		local temp_cid = team_two[1].cid
		doPlayerSendTextMessage(temp_cid, MESSAGE_STATUS_CONSOLE_BLUE, "O seu adversário não compareceu a batalha... Aguarde outro adversário.")
		self:teleportPlayerOut(team_two[1])
		
		self:clearTeams()
		self:addPlayer(temp_cid, true)
		
		self:setState(STATE_WAITING)
		self.bcMsg = 0
		return false
	end
	
	if(team_one[1].ready and not team_two[1].ready) then
		-- o primeiro jogador estava pronto, enquanto o segundo não...
		doPlayerSendTextMessage(team_two[1].cid, MESSAGE_STATUS_CONSOLE_BLUE, "Você não compareceu a batalha... Assim ela foi cancelada.")
		
		local temp_cid = team_one[1].cid
		doPlayerSendTextMessage(temp_cid, MESSAGE_STATUS_CONSOLE_BLUE, "O seu adversário não compareceu a batalha... Aguarde outro adversário.")		
		self:teleportPlayerOut(team_one[1])
		
		self:clearTeams()
		self:addPlayer(temp_cid, true)		
		
		self:setState(STATE_WAITING)
		self.bcMsg = 0		
		return false
	end

	if(not team_one[1].ready and not team_two[1].ready) then
		-- nenhum dos dois jogadores estavam prontos...
		doPlayerSendTextMessage(team_one[1].cid, MESSAGE_STATUS_CONSOLE_BLUE, "Você não compareceu a batalha... Assim ela foi cancelada.")
		doPlayerSendTextMessage(team_two[1].cid, MESSAGE_STATUS_CONSOLE_BLUE, "Você não compareceu a batalha... Assim ela foi cancelada.")
		self:clearTeams()
		
		self:setState(STATE_WAITING)
		self.bcMsg = 0		
		return false
	end	
	
	self:setState(STATE_RUNNING)
	self:removeGates()	
	self:broadcastMessage()
	
	return true
end

function pvpArena:broadcastTeams(text, mustBeReady)

	for tk,tv in pairs(self:getTeams()) do	
		for pk,pv in pairs(tv) do
			if(not mustBeReady or (mustBeReady and pv.ready)) then
				local cid = v.cid
				doPlayerSendTextMessage(pv.cid, MESSAGE_STATUS_CONSOLE_BLUE, text)
			end			
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
	elseif(self.bcMsg == 2) then
		text = "A batalha irá começar em 15 segundos."		
	elseif(self.bcMsg == 3) then
		text = "A batalha irá começar em 5 segundos."		
	elseif(self.bcMsg == 4) then
		text = "A batalha foi iniciada. Boa sorte!"					
	end
	
	self.bcMsg = self.bcMsg + 1
	
	self:broadcastTeams(text, mustBeReady)
end

-------------------------
-- EVENT CALLERS 	-----
-- isso é um hack!! -----
-------------------------

function pvpArena.callRun(instance)
	instance:run()
end

function pvpArena.callBroadcastMessage(instance)
	instance:broadcastMessage()
end

-------------------------
-- SINGLETON INSTANCE ---
-------------------------
instancePvpArena = pvpArena:new()