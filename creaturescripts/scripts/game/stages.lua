function onAdvance(cid, type, oldlevel, newlevel)
		
	if(type == LEVEL_EXPERIENCE) then
	
		setRateStage(cid, newlevel)
	else
		setSkillStageOnAdvance(cid, type, newlevel)
	end		
	
	if(canReceivePremiumTest(cid, newlevel)) then
		addPremiumTest(cid)
	end
	
	return LUA_TRUE
end

function addPremiumTest(cid)

	doPlayerAddPremiumDays(cid, 7)
	local account = getPlayerAccount(cid)
	db.executeQuery("INSERT INTO `wb_premiumtest` VALUES ('" .. account .. "', '" .. os.time() .. "');")
	doPlayerSendTextMessage(cid, MESSAGE_STATUS_CONSOLE_ORANGE, "Parabéns! Este é o seu primeiro personagem a atingir o level 100 no Darghos! Como prêmio você acaba de receber uma Conta Premium por uma semana gratuitamente, que irá permitir que você conheça todo o Darghos! Boa sorte!")
	sendEnvolveEffect(cid, CONST_ME_HOLYAREA)
end

function canReceivePremiumTest(cid, newlevel)

	if(newlevel < 100) then
		return false
	end

	if(isPremium(cid)) then
		return false
	end

	local account = getPlayerAccount(cid)
	
	local result = db.getResult("SELECT COUNT(*) as `rowscount` FROM `wb_premiumtest` WHERE `account_id` <= '" .. account .. "';")
	if(result:getID() == -1) then
		--print("[Spoofing] Players list not found.")
		return false
	end

	local rowscount = result:getDataInt("rowscount")
	result:free()		
	
	if(rowscount > 0) then
		return false
	end
	
	return true
end