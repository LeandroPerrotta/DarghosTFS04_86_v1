local keywordHandler = KeywordHandler:new()
local npcHandler = NpcHandler:new(keywordHandler)
NpcSystem.parseParameters(npcHandler)


function onCreatureAppear(cid)				npcHandler:onCreatureAppear(cid) 			end
function onCreatureDisappear(cid) 			npcHandler:onCreatureDisappear(cid) 		end
function onCreatureSay(cid, type, msg) 		npcHandler:onCreatureSay(cid, type, msg) 	end
function onThink() 							npcHandler:onThink() 						end

function npcSystemHeader(cid, message, keywords, parameters, node)

	local npcHandler = parameters.npcHandler
	
	if(npcHandler == nil) then
		print('[Warning - ' .. getCreatureName(getNpcId()) .. '] NpcSystem:', 'StdModule.travel - Call without any npcHandler instance.')
		return false
	end

	if(not npcHandler:isFocused(cid)) then
		return false
	end
	
	return true
end

function noCallback()

	local messages = {
		"Se mudar de ideia estarei aqui!",
		"Sem problemas...",
		"Então posso lhe ajudar em algo mais?",
		"Argh! Droga!"
	}

	local rand = math.random(1, #messages)
	local npcHandler = parameters.npcHandler
	npcHandler:say(messages[rand], cid)
	npcHandler:resetNpc()
end

function startFirstMissionCallback(cid, message, keywords, parameters, node)

	if(not npcSystemHeader(cid, message, keywords, parameters, node)) then
		return false
	end

	local npcHandler = parameters.npcHandler

	setPlayerStorageValue(cid, QUESTLOG.INQUISITION.MISSION_OUTFIT, 0)
	npcHandler:say("Otimo! Volte quando conseguir-las!", cid)
	
	npcHandler:resetNpc()
end

function finishFirstMissionCallback(cid, message, keywords, parameters, node)

	if(not npcSystemHeader(cid, message, keywords, parameters, node)) then
		return false
	end

	local npcHandler = parameters.npcHandler

	local ITEMS_DEMONIC_ESSENCE = 6500

	if(getPlayerItemCount(cid, ITEMS_DEMONIC_ESSENCE) < 20) then
		npcHandler:say("Que decepção! Você ainda não conseguiu as 20 demonic essences que lhe solicitei! Seja rápido em conseguir-las! Não há muito tempo!!", cid)
		npcHandler:resetNpc()
		
		return true
	end	
	
	if(not doPlayerRemoveItem(cid, ITEMS_DEMONIC_ESSENCE, 20)) then
		print('[Warning - ' .. getCreatureName(getNpcId()) .. '] NpcSystem:', 'Inquisition - Can not remove required items. Details:', '{player=' .. getCreatureName(cid) .. ', item_id=' .. ITEMS_DEMONIC_ESSENCE .. ', count=' .. 20 .. '}')
		return false
	end	

	setPlayerStorageValue(cid, QUESTLOG.INQUISITION.MISSION_OUTFIT, 1)
	doPlayerAddOutfitId(cid, 20, 0)
	
	npcHandler:say("Perfeito! Agora conseguirei concluir meu trabalho! Como recompensa por me ajudar nesta batalha conta os seres demoniacos lhe concedo a roupa do caçador de demonios!", cid)
	npcHandler:resetNpc()
	
	return true
end

function startSecondMissionCallback(cid, message, keywords, parameters, node)

	if(not npcSystemHeader(cid, message, keywords, parameters, node)) then
		return false
	end

	local npcHandler = parameters.npcHandler

	setPlayerStorageValue(cid, QUESTLOG.INQUISITION.MISSION_FIRST_ADDON, 0)
	npcHandler:say("Este demonio é conhecido como Ungreez, há informações que atualmente ele está na caverna ao sul de Aracura. Estarei aguardando a sua volta com a missão concluida!", cid)
	
	npcHandler:resetNpc()
end

function finishSecondMissionCallback(cid, message, keywords, parameters, node)

	if(not npcSystemHeader(cid, message, keywords, parameters, node)) then
		return false
	end

	local npcHandler = parameters.npcHandler
	local killUngreez = (getPlayerStorageValue(cid, sid.INQ_KILL_UNGREEZ) == 1) and true or false

	local ITEMS_DEMONIC_ESSENCE = 6500

	if(not killUngreez) then
		npcHandler:say("Hmm, ainda sinto a presença maligna meu caro...Seja rapido, ou toda a força demoniaca continuará se espalhando!", cid)
		npcHandler:resetNpc()
		
		return true
	end	

	setPlayerStorageValue(cid, QUESTLOG.INQUISITION.MISSION_FIRST_ADDON, 1)
	doPlayerAddOutfitId(cid, 20, 1)
	
	npcHandler:say("Perfeito!" .. getCreatureName(cid) .. "! Agora será possivel concluir o ritual sagrado! Como recompensa pelo seu feito lhe concedo o primeiro addon para sua roupa!", cid)
	npcHandler:resetNpc()
	
	return true
end

function startThirdMissionCallback(cid, message, keywords, parameters, node)

	if(not npcSystemHeader(cid, message, keywords, parameters, node)) then
		return false
	end

	local npcHandler = parameters.npcHandler

	setPlayerStorageValue(cid, QUESTLOG.INQUISITION.MISSION_FIRST_ADDON, 0)
	npcHandler:say("Você deve ir longe, aonde nascem os demonios, um lugar conhecido como nexo das sombras, em algum lugar nas profundezas de Aaragon, jogue esta agua sagrada em uma barreira de energia, cada vez isto irá torna-la mais fraca. Isto deverá deixar os demonios furiosos, então se prepare. No caminho você enfrentará os demonios guardiões. Que os deuses lhe acompanhem!", cid)
	
	npcHandler:resetNpc()
end

function finishThirdMissionCallback(cid, message, keywords, parameters, node)

	if(not npcSystemHeader(cid, message, keywords, parameters, node)) then
		return false
	end

	local npcHandler = parameters.npcHandler
	local killUngreez = (getPlayerStorageValue(cid, sid.INQ_KILL_UNGREEZ) == 1) and true or false

	local ITEMS_DEMONIC_ESSENCE = 6500

	if(not killUngreez) then
		npcHandler:say("Hmm, ainda sinto a presença maligna meu caro...Seja rapido, ou toda a força demoniaca continuará se espalhando!", cid)
		npcHandler:resetNpc()
		
		return true
	end	

	setPlayerStorageValue(cid, QUESTLOG.INQUISITION.MISSION_FIRST_ADDON, 1)
	doPlayerAddOutfitId(cid, 20, 1)
	
	npcHandler:say("Perfeito!" .. getCreatureName(cid) .. "! Agora será possivel concluir o ritual sagrado! Como recompensa pelo seu feito lhe concedo o primeiro addon para sua roupa!", cid)
	npcHandler:resetNpc()
	
	return true
end

function missionCallback(cid, message, keywords, parameters, node)

	if(not npcSystemHeader(cid, message, keywords, parameters, node)) then
		return false
	end
	
	local npcHandler = parameters.npcHandler
	local confirmPattern = {'yes', 'sim'}
	local negationPattern = {'no', 'não', 'nao'}

	local questStatus = getPlayerStorageValue(cid, QUESTLOG.INQUISITION.MISSION_OUTFIT)
	
	if(questStatus == -1) then
		npcHandler:say("Estou buscando algo para por fim a toda força demoniaca, e preciso de sua ajuda. Você poderia derrotar algumas destas criaturas e trazer-me 20 demonic essences? <...>", cid)
		npcHandler:say("Como recompensa lhe darei uma nova roupa!", cid)
		node:addChildKeyword(confirmPattern, startFirstMissionCallback, {npcHandler = npcHandler, onlyFocus = true})
		node:addChildKeyword(negationPattern, noCallback, {npcHandler = npcHandler, onlyFocus = true})
		
		return true
	elseif(questStatus == 0) then
		npcHandler:say("Estava ancioso por sua volta! E então, conseguiu o que te pedi?", cid)
		node:addChildKeyword(confirmPattern, finishFirstMissionCallback, {npcHandler = npcHandler, onlyFocus = true})
		node:addChildKeyword(negationPattern, noCallback, {npcHandler = npcHandler, onlyFocus = true})		
		
		return true
	end
	
	questStatus = getPlayerStorageValue(cid, QUESTLOG.INQUISITION.MISSION_FIRST_ADDON)
	
	if(questStatus == -1) then
		npcHandler:say("Quer uma novam missão? Oh, eu tenho uma. A presença de um maligno demonio impede que certos rituais sagrados sejam feitos com sucesso, preciso que você o elimine para que possamos continuar o trabalho, aceita?", cid)
		node:addChildKeyword(confirmPattern, startSecondMissionCallback, {npcHandler = npcHandler, onlyFocus = true})
		node:addChildKeyword(negationPattern, noCallback, {npcHandler = npcHandler, onlyFocus = true})
		
		return true	
	elseif(questStatus == 0) then
		npcHandler:say("E então, o demonio Ungreez já foi derrotado?", cid)
		node:addChildKeyword(confirmPattern, finishSecond.MissionCallback, {npcHandler = npcHandler, onlyFocus = true})
		node:addChildKeyword(negationPattern, noCallback, {npcHandler = npcHandler, onlyFocus = true})		
		
		return true		
	end
	
	questStatus = getPlayerStorageValue(cid, QUESTLOG.INQUISITION.MISSION_SHADOW_NEXUS)
	
	if(questStatus == -1) then
		npcHandler:say("Que bom lhe encontrar " .. getCreatureName(cid) .. "! Pois tenho uma ultima missão para você! Com os ingredientes foi possivel criar uma poção de agua sagrada na qual poderá ser usada para ajudar no combate a força demoniaca. <...>", cid)
		npcHandler:say("Gostaria de aceitar-la?", cid)
		node:addChildKeyword(confirmPattern, startThirdMissionCallback, {npcHandler = npcHandler, onlyFocus = true})
		node:addChildKeyword(negationPattern, noCallback, {npcHandler = npcHandler, onlyFocus = true})
		
		return true	
	elseif(questStatus == 0) then
		npcHandler:say("E então, o demonio Ungreez já foi derrotado?", cid)
		node:addChildKeyword(confirmPattern, finishSecond.MissionCallback, {npcHandler = npcHandler, onlyFocus = true})
		node:addChildKeyword(negationPattern, noCallback, {npcHandler = npcHandler, onlyFocus = true})		
		
		return true		
	end	
	
	return true
end

local node = keywordHandler:addKeyword({'mission,missão,missao'}, missionCallback, {npcHandler = npcHandler, onlyFocus = true, text = 'Estou fazendo trabalhando em algo que pode por fim a toda força demoniaca. Para isto preciso de sua ajuda. Pode me trazer 20 demonic essences?!'})
	node:addChildKeyword({'yes'}, StdModule.bless, {npcHandler = npcHandler, number = 1, premium = false, baseCost = 2000, levelCost = 200, startLevel = 30, endLevel = 120})
	node:addChildKeyword({'no'}, StdModule.say, {npcHandler = npcHandler, onlyFocus = true, reset = true, text = 'Too expensive, eh?'})

npcHandler:addModule(FocusModule:new())