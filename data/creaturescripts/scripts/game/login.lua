function onLogin(cid)

	--print("Custom login done!")

	--Register the kill/die event
	registerCreatureEvent(cid, "CustomPlayerDeath")
	registerCreatureEvent(cid, "CustomStages")
	registerCreatureEvent(cid, "Inquisition")
	registerCreatureEvent(cid, "CustomPlayerTarget")
	registerCreatureEvent(cid, "CustomBonartesTasks")
	registerCreatureEvent(cid, "onKill")
	registerCreatureEvent(cid, "autolotgold")
	registerCreatureEvent(cid, "tradeHandler")
	registerCreatureEvent(cid, "lookItem")
	
	--if(tasks.hasStartedTask(cid)) then
		registerCreatureEvent(cid, "CustomTasks")
	--end
	
	registerCreatureEvent(cid, "Hacks")
	registerCreatureEvent(cid, "GainStamina")
	
	playerRecord()
	runPremiumSystem(cid)
	setRateStage(cid, getPlayerLevel(cid))
	setLoginSkillsRateStage(cid)
	checkItemShop(cid)
	OnKillCreatureMission(cid)
	Dungeons.onLogin(cid)
	--defineFirstItems(cid)
	restoreAddon(cid)
	
	-- premium test
	if(canReceivePremiumTest(cid, getPlayerLevel(cid))) then
		addPremiumTest(cid)
	end	
	
	-- island of peace non pvp for TFS via onLogin
	if(darghos_distro == DISTROS_TFS) then
		if(getPlayerTown(cid) == towns.ISLAND_OF_PEACE and getPlayerGroupId(cid) < GROUP_PLAYER_TUTOR) then
			doPlayerSetGroupId(cid, GROUP_PLAYER_NON_PVP)
		end
	end

	if(getPlayerAccess(cid) == groups.GOD) then
		addAllOufits(cid)
	end
	
	--Give basic itens after death
	if getPlayerStorageValue(cid, sid.GIVE_ITEMS_AFTER_DEATH) == 1 then
		if getPlayerSlotItem(cid, CONST_SLOT_BACKPACK).uid == 0 then
			local item_backpack = doCreateItemEx(1988, 1) -- backpack
			
			doAddContainerItem(item_backpack, 2120, 1) -- rope
			doAddContainerItem(item_backpack, 2554, 1) -- shovel
			doAddContainerItem(item_backpack, 2666, 4) -- meat
			doAddContainerItem(item_backpack, CUSTOM_ITEMS.TELEPORT_RUNE, 1) -- teleport rune
			
			doPlayerAddItemEx(cid, item_backpack, FALSE, CONST_SLOT_BACKPACK)
		end
		setPlayerStorageValue(cid, sid.GIVE_ITEMS_AFTER_DEATH, -1)
	end			
	
	setPlayerStorageValue(cid, sid.TRAINING_SHIELD, 0)
	setPlayerStorageValue(cid, sid.TELEPORT_RUNE_STATE, STORAGE_NULL)
	setPlayerStorageValue(cid, sid.HACKS_LIGHT, LIGHT_NONE)
	setPlayerStorageValue(cid, sid.HACKS_DANCE_EVENT, STORAGE_NULL)
	setPlayerStorageValue(cid, sid.HACKS_CASTMANA, STORAGE_NULL)
	setPlayerStorageValue(cid, sid.NEXT_STAMINA_UPDATE, STORAGE_NULL)
	
	return TRUE
end
