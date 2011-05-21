-- Consts
SCENARIO_TYPE_CAPTURE_THE_FLAG = 0

-- Private vars
pvpScenario = {
	type = nil,
	duration = nil,
	preparation = 60 * 2,
	queues = nil,
	games = 0,
	currentGame = nil
}

-- Cria uma nova instancia de um scenario PvP
function pvpScenario:new(type, duration, preparation)
	local obj = {}
	
	obj.type = type
	obj.duration = duration or 60 * 10
	obj.preparation = preparation or 60 * 2
	obj.queues = {}
	obj.currentGame = {}
	setmetatable(obj, self)
	self.__index = self
	return obj
end

function pvpScenario:run()

	self:prepareGame()
end

function pvpScenario:addQueue(queue)
	table.insert(self.queues, queue)
end

function pvpScenario:prepareGame()
	
	local gameQueue = nil
	local isFull = false
	
	for k,v in pairs(self.queues) do
		local queue = v
		
		if(queue:isFull()) then
			if(gameQueue == nil) then
				gameQueue = queue
				isFull = true
			else
				if(queue:getFullIn() < gameQeue.getFullIn()) then
					gameQueue = queue
				end
			end
		else
			if(gameQueue ~= nil) then
				if(not isFull) then
					if(queue:getPlayersCount() > gameQueue:getPlayersCount()) then
						gameQueue = queue
					end
				end
			else
				gameQueue = queue
			end
		end
	end
	
	self.currentGame = gameQueue
	
	gameQueue:broadcastGameStart()
	
	addEvent("self:startGame", 1000 * self.preparation)
end

function pvpScenario:startGame()
	
	addEvent("self:endGame", 1000 * self.duration)
end

function pvpScenario:endGame()
	
	self:prepareGame()
end