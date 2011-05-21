-- Private vars
pvpQueue = {
	minLevel = nil,
	maxPlayers = nil,
	fullIn = 0,
	teamOne = {},
	teamTwo = {}
}

-- Cria uma nova instancia de fila para Scenarios PvP
function pvpQueue:new(minLevel, maxPlayers)
	local obj = {}
	
	obj.minLevel = minLevel
	obj.maxPlayers = maxPlayers
	setmetatable(obj, self)
	self.__index = self
	return obj
end

function pvpQueue:isFull()

	local teamOneCount = #self.teamOne
	local teamTwoCount = #self.teamTwo
	
	if(teamOneCount == self.maxPlayers and teamTwoCount == self.maxPlayers) then
		-- the game are full
		return true
	end
	
	return false
end

function pvpQueue:getFullIn()
	return self.fullIn
end

function pvpQueue:getPlayerCount()
	return #self.teamOne + #self.teamTwo
end

function pvpQueue:addPlayer(cid)

	local data = {
		cid = cid,
		join_in = os.time()
	}
	
	if(not self:isFull()) then
		return false
	end

	local teamOneCount = #self.teamOne
	local teamTwoCount = #self.teamTwo	

	if(teamOneCount > teamTwoCount) then
		table.insert(self.teamTwo, data)
	else
		table.insert(self.teamOne, data)
	end
	
	if(self:isFull()) then
		self.fullIn = os.time()
	end
	
	return true
end

function pvpQueue:broadcastTeam(team, text)

	for k,v in pairs(team) do
		local cid = v.cid
		doPlayerSendTextMessage(cid, MESSAGE_STATUS_CONSOLE_BLUE, text)
	end
end

function pvpQueue:broadcastGameStart()
	
	local text = "A luta pela bandeira está para começar, seus companheiros já o aguardam! Quando estiver pronto digite \"/pvp pronto\" para ser enviado ao campo de batalha! Boa sorte!"
	
	self:broadcastTeam(self.teamOne, text)
	self:broadcastTeam(self.teamTwo, text)
end