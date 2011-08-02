local ITEM_DEMON_OAK_LEFT_ARM = 8289
local ITEM_DEMON_OAK_RIGHT_ARM = 8290
local ITEM_DEMON_OAK_BIRD = 8288
local ITEM_DEMON_OAK_FACE = 8291

local demon_oak_pos = { x = 2051, y = 2128, z = 7 } 

local tries = {
	[ITEM_DEMON_OAK_LEFT_ARM] = 0,
	[ITEM_DEMON_OAK_RIGHT_ARM] = 0,
	[ITEM_DEMON_OAK_BIRD] = 0,
	[ITEM_DEMON_OAK_FACE] = 0
}

local completeTries = 0

local theDemonOak = {
	-- braço da esquerda
	[ITEM_DEMON_OAK_LEFT_ARM] = {
		{
			{ name = "braindeath", count = 3 },
			{ name = "bone beast", count = 1 }
		},
		{
			{ name = "betrayed wraith", count = 2 }
		},
	},
	
	-- braço da direita
	[ITEM_DEMON_OAK_RIGHT_ARM] = {
		{
			{ name = "banshee", count = 3 }
		},
		{
			{ name = "grim reaper", count = 1 }
		},	
	},
	
	-- passaro
	[ITEM_DEMON_OAK_BIRD] = {
		{
			{ name = "lich", count = 3 }
		},
		{
			{ name = "dark torturer", count = 1 },
			{ name = "blightwalker", count = 1 }
		},		
	},
	
	-- frente
	[ITEM_DEMON_OAK_FACE] = {
		{
			{ name = "lich", count = 1 },
			{ name = "giant spider", count = 2 }
		},
		{
			{ name = "undead dragon", count = 1 },
			{ name = "hand of cursed fate", count = 1 }
		},		
	}

}

function onUse(cid, item, frompos, item2, topos)

	if(item.actionid == aid.DEMON_OAK_DEAD_TREE) then
		return useOnDeadTree(cid, item, frompos, item2, topos)
	elseif(theDemonOak[item2.itemid] ~= nil) then
		return useOnDemonOak(cid, item, frompos, item2, topos)
	end
end

function useOnDemonOak(cid, item, frompos, item2, topos)

	tries[item2.itemid] = tries[item2.itemid] + 1
	
	if(tries[item2.itemid] == 5) then
		local respawns = theDemonOak[item2.itemid][1]
		doCreateRespawnArea(respawns, demon_oak_pos, 5)
		
	elseif(tries[item2.itemid] == 10) then
		if(completeTries == 3) then
			local respawns = {{ name = "demon", count = 1}}
			doCreateRespawnArea(respawns, demon_oak_pos, 5)			
		else
			local respawns = theDemonOak[item2.itemid][2]
			doCreateRespawnArea(respawns, demon_oak_pos, 5)	
			completeTries = completeTries + 1		
		end
	elseif(tries[item2.itemid] > 10) then
		doSendMagicEffect(getPlayerPosition(cid), CONST_ME_POFF)
		return true
	else
		if(math.random(1, 100) >= 50) then
			local respawns = {{ name = "bone beast", count = 4}}
			doCreateRespawnArea(respawns, demon_oak_pos, 5)	
		end	
	end
	
	doSendMagicEffect(getPlayerPosition(cid), CONST_ME_BIGPLANTS)
	return true
end

function resetDemonOak()
	completeTries = 0
	
	tries = {
		[ITEM_DEMON_OAK_LEFT_ARM] = 0,
		[ITEM_DEMON_OAK_RIGHT_ARM] = 0,
		[ITEM_DEMON_OAK_BIRD] = 0,
		[ITEM_DEMON_OAK_FACE] = 0
	}	
end

function useOnDeadTree(cid, item, frompos, item2, topos)

	local level = getPlayerLevel(cid)
	if(level < 120) then
		doPlayerSendTextMessage(cid, MESSAGE_EVENT_DEFAULT, "You must be level 120 or higher to across.")
		return true
	end	
	
	local questStatus = getGlobalStorageValue(gid.DEMON_OAK_PLAYER_INSIDE)
	if(questStatus ~= -1) then
		doPlayerSendTextMessage(cid, MESSAGE_EVENT_DEFAULT, "Another player already in there.")
		return true
	end
	
	local taskStatus = getPlayerStorageValue(cid, sid.TASK_KILL_DEMONS) or false
	if(not taskStatus) then
		doPlayerSendTextMessage(cid, MESSAGE_EVENT_DEFAULT, "You need special permission from Oldrak to go inside.")
		return true		
	end
	
	topos.y = topos.y + 1
	
	lockTeleportScroll(cid)
    doTeleportThing(cid, topos, true)
    doSendMagicEffect(topos, CONST_ME_TELEPORT)
    doSendMagicEffect(frompos, CONST_ME_POFF)
    
    setGlobalStorageValue(gid.DEMON_OAK_PLAYER_INSIDE, cid)
    return true
end