function onLook(cid, thing, position, lookDistance)    

	local item_id = thing.itemid
	
	local ITEM_ADDON_DOLL = 12691
	
	if(item_id == ITEM_ADDON_DOLL) then
		lookingAddonDoll(cid, thing)
	end

	return true
end

function lookingAddonDoll(cid, thing)

	local outfitId = thing.actionid or 0
	local outfitName = {
		[1] = "Citizen",
		[2] = "Hunter",
		[3] = "Mage",
		[4] = "Knight",
		[5] = "Noble",
		[6] = "Summoner",
		[7] = "Warrior",
		[8] = "Barbarian",
		[9] = "Druid",
		[10] = "Wizard",
		[11] = "Oriental",
		[12] = "Pirate",
		[13] = "Assassin",
		[14] = "Beggar",
		[15] = "Shaman",
		[16] = "Norse",
		[17] = "Nightmare",
		[18] = "Jester",
		[19] = "Brotherhood",
		[20] = "Demonhunter",
		[21] = "Yalaharian",
		[22] = "Warmaster",
		[23] = "Wayfarer"
	}

	local tempName = "Unkwnown"

	if(outfitName[outfitId] ~= nil) then
		tempName = outfitName[outfitId]
	end
	
	local desc = ""
	
	if(not canPlayerWearOutfitId(cid, outfitId, 0)) then
		desc = "Use this ticket to purchase the " .. tempName .. " outfit."
	else
		if(canPlayerWearOutfitId(cid, outfitId, 2)) then
			desc = "An player without any part of " .. tempName .. " outfit can purchase it with this ticket."
		elseif(canPlayerWearOutfitId(cid, outfitId, 1)) then
			desc = "Use this ticket to purchase the second addon to " .. tempName .. " outfit."
		else
			desc = "Use this ticket to purchase the first addon to " .. tempName .. " outfit."
		end		
	end	

	doItemSetAttribute(thing.uid, "description", desc)
end