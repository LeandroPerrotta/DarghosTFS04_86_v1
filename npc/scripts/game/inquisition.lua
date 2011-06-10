local keywordHandler = KeywordHandler:new()
local npcHandler = NpcHandler:new(keywordHandler)
NpcSystem.parseParameters(npcHandler)


function onCreatureAppear(cid)				npcHandler:onCreatureAppear(cid) 			end
function onCreatureDisappear(cid) 			npcHandler:onCreatureDisappear(cid) 		end
function onCreatureSay(cid, type, msg) 		npcHandler:onCreatureSay(cid, type, msg) 	end
function onThink() 							npcHandler:onThink() 						end

local confirmPattern = {'yes', 'sim'}
local negationPattern = {'no', 'n�o', 'nao'}

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
		"Ent�o posso lhe ajudar em algo mais?",
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
	npcHandler:say("Ent�o prove o seu valor e retorne quando tiver em posse do solicitado! Boa sorte!", cid)
	
	npcHandler:resetNpc()
end

function finishFirstMissionCallback(cid, message, keywords, parameters, node)

	if(not npcSystemHeader(cid, message, keywords, parameters, node)) then
		return false
	end

	local npcHandler = parameters.npcHandler

	local ITEMS_DEMONIC_ESSENCE = 6500

	if(getPlayerItemCount(cid, ITEMS_DEMONIC_ESSENCE) < 20) then
		npcHandler:say("Que decep��o! Voc� ainda n�o conseguiu as 20 demonic essences que lhe solicitei! Estou a come�ando a achar que n�o conseguira cumprir-la...", cid)		
		npcHandler:resetNpc()
		
		return true
	end	
	
	if(not doPlayerRemoveItem(cid, ITEMS_DEMONIC_ESSENCE, 20)) then
		print('[Warning - ' .. getCreatureName(getNpcId()) .. '] NpcSystem:', 'Inquisition - Can not remove required items. Details:', '{player=' .. getCreatureName(cid) .. ', item_id=' .. ITEMS_DEMONIC_ESSENCE .. ', count=' .. 20 .. '}')
		return false
	end	

	setPlayerStorageValue(cid, QUESTLOG.INQUISITION.MISSION_OUTFIT, 1)
	doPlayerAddOutfitId(cid, 20, 0)
	
	npcHandler:say("Confesso que estou surpreso! Como recompensa eu lhe darei uma nova roupa, a do ca�ador de demonios! Retorne quando estiver preparado para sua primeira miss�o!", cid)
	npcHandler:resetNpc()
	
	return true
end

function startSecondMissionCallback(cid, message, keywords, parameters, node)

	if(not npcSystemHeader(cid, message, keywords, parameters, node)) then
		return false
	end

	local npcHandler = parameters.npcHandler

	setPlayerStorageValue(cid, QUESTLOG.INQUISITION.MISSION_FIRST_ADDON, 0)
	npcHandler:say("Este demonio � conhecido como Ungreez, h� informa��es que atualmente ele se encontra na caverna ao sul de Aracura. Estarei aguardando a sua volta com a miss�o concluida!", cid)
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
		npcHandler:say("Est� tentando me enganar " .. getCreatureName(cid) .. "? Eu ainda posso sentir que as for�as demoniacas continuam forte! Derrote-o!", cid)
		npcHandler:resetNpc()
		
		return true
	end	

	setPlayerStorageValue(cid, QUESTLOG.INQUISITION.MISSION_FIRST_ADDON, 1)
	doPlayerAddOutfitId(cid, 20, 1)
	
	npcHandler:say("Bom trabalho " .. getCreatureName(cid) .. "! Ja vejo as for�as demoniacas muito mais vulneraveis! Como recompensa lhe concedo alguns infeites para sua roupa! <...>", cid)
	npcHandler:say("Retorne a falar comigo quando estiver preparado para a sua ultima e mais perigosa miss�o!", cid)
	npcHandler:resetNpc()
	
	return true
end

function startThirdMissionCallback(cid, message, keywords, parameters, node)

	if(not npcSystemHeader(cid, message, keywords, parameters, node)) then
		return false
	end

	local npcHandler = parameters.npcHandler

	setPlayerStorageValue(cid, QUESTLOG.INQUISITION.MISSION_SHADOW_NEXUS, 0)
	npcHandler:say("Estarei aguardando a sua volta! Espero que tenha sorte e que os Deuses lhe ajudem!", cid)
	
	npcHandler:resetNpc()
end

function finishThirdMissionCallback(cid, message, keywords, parameters, node)

	if(not npcSystemHeader(cid, message, keywords, parameters, node)) then
		return false
	end

	local npcHandler = parameters.npcHandler
	local wall = (getPlayerStorageValue(cid, sid.INQ_DONE_MWALL) == 1) and true or false

	if(not wall) then
		npcHandler:say("Toda for�a demoniaca continua muito alta e expandindo! N�o parece que voc� tenha concluido sua miss�o! Volte quando tiver a terminado!", cid)
		npcHandler:resetNpc()
		
		return true
	end	

	setPlayerStorageValue(cid, QUESTLOG.INQUISITION.MISSION_SHADOW_NEXUS, 1)
	doPlayerAddOutfitId(cid, 20, 2)
	
	npcHandler:say("Bravo guerreiro! Agora a presen�a demoniaca est� mais controlada! Todo nosso reino lhe agrade�e! <...>", cid)
	npcHandler:say("Como recompensa por sua grande miss�o lhe concedo mais alguns infeites para a sua roupa de ca�ador de demonios! Al�m disto lhe concedo a permiss�o para acessar a sala seguindo o corredor a norte <...>!", cid)
	npcHandler:say("L� voc� encontrar� alguns dos mais poderosos equipamentos e armas conhecidos e poder� escolher uma para voc�! Esteja atento a sua decis�o, pois n�o poder�! Boa sorte!", cid)
	npcHandler:resetNpc()
	
	return true
end

function missionCallback(cid, message, keywords, parameters, node)

	if(not npcSystemHeader(cid, message, keywords, parameters, node)) then
		return false
	end
	
	local npcHandler = parameters.npcHandler

	local questStatus = getPlayerStorageValue(cid, QUESTLOG.INQUISITION.MISSION_OUTFIT)
	
	if(questStatus == -1) then
		npcHandler:say("N�s estamos dando uma grande investida contra as for�as demoniacas que assombram este mundo, e sim, precisamos de ajuda. Mas antes de receber a sua primeira miss�o voc� devera provar o seu valor e tambem o seu comprometimento conosco nesta guerra <...>", cid)
		npcHandler:say("Para provar isto, voc� precisar� derrotar algumas criaturas demoniacas e obter 20 demonic essences e ent�o me trazer-los. Assim irei lhe passar a sua primeira brava miss�o, al�m de lhe dar uma recompensa. E ent�o, o que me diz?", cid)
		D_CustomNpcModules.addChildKeyword(confirmPattern, node, startFirstMissionCallback, {npcHandler = npcHandler, onlyFocus = true})
		D_CustomNpcModules.addChildKeyword(negationPattern, node, noCallback, {npcHandler = npcHandler, onlyFocus = true})
		
		return true
	elseif(questStatus == 0) then
		npcHandler:say("E ent�o, algum progresso em seu teste?", cid)
		D_CustomNpcModules.addChildKeyword(confirmPattern, node, finishFirstMissionCallback, {npcHandler = npcHandler, onlyFocus = true})
		D_CustomNpcModules.addChildKeyword(negationPattern, node, noCallback, {npcHandler = npcHandler, onlyFocus = true})			
		
		return true
	end
	
	questStatus = getPlayerStorageValue(cid, QUESTLOG.INQUISITION.MISSION_FIRST_ADDON)
	
	if(questStatus == -1) then
		npcHandler:say("As essencias demoniacas que voc� me trouxe em seu teste ser�o uteis na cria��o de uma arma que nos ajudar� a combater toda for�a demoniaca. Mas para que tudo d� certo precisamos enfraquecer esta for�a primeiro <...>", cid)
		npcHandler:say("Para isto ser� necessario viajar at� o continente de Aracura e partir para uma caverna ao sul da cidade, em algum lugar nela reside um antigo demonio chamado Ungreez. <...>", cid)
		npcHandler:say("Apos encontrar-lo voc� ir� derrotar-lo e ent�o as for�as demoniacas estar�o significativame mais vulneraveis. Gostaria de cumprir esta perigosa miss�o?", cid)
		D_CustomNpcModules.addChildKeyword(confirmPattern, node, startSecondMissionCallback, {npcHandler = npcHandler, onlyFocus = true})
		D_CustomNpcModules.addChildKeyword(negationPattern, node, noCallback, {npcHandler = npcHandler, onlyFocus = true})			
		
		return true	
	elseif(questStatus == 0) then
		npcHandler:say("E ent�o, o velho demonio Ungreez j� foi derrotado?", cid)
		D_CustomNpcModules.addChildKeyword(confirmPattern, node, finishSecondMissionCallback, {npcHandler = npcHandler, onlyFocus = true})
		D_CustomNpcModules.addChildKeyword(negationPattern, node, noCallback, {npcHandler = npcHandler, onlyFocus = true})						
		
		return true		
	end
	
	questStatus = getPlayerStorageValue(cid, QUESTLOG.INQUISITION.MISSION_SHADOW_NEXUS)
	
	if(questStatus == -1) then
		npcHandler:say("A sua ultima miss�o ser� a mais dificil e mais arriscada " .. getCreatureName(cid) .. " e creio que voc� ir� precisar de muita ajuda para concluir-la. Se lembra da arma que falei para voc� certa vez? <...>", cid)
		npcHandler:say("Pois bem, � um flasco que contem uma pequena porção do mais divino liquido, extraido de toda essencia demoniaca. Em sua ultima miss�o voc� terá de ir ao local onde se origina todas forças demoniacas <...> ", cid)
		npcHandler:say("Este lugar fica no cora��o de onde nascem os demonios, nas profundezas de caverna no continente da cidade de Aaragon e � conhecido como nexo das sombras. Entretanto seu desafio ir� come�ar muito antes de chegar l� <...> ", cid)
		npcHandler:say("Para chegar l� voc� ir� precisar enfrentar antigos e tremendamente poderosos demonios guardi�es, j� nesta parte de sua miss�o voc� ir� precisar de toda ajuda possivel <...> ", cid)
		npcHandler:say("Quando voc� conseguir chegar no nexo das sombras ir� precisar derramar o liquido divino em uma barreira magica na qual � a fonte de toda for�a demoniaca <...> ", cid)
		npcHandler:say("Ela inicialmente ir� enfraquecer porem voltar� a se fortalecer e voc� ir� precisar enfraquecer-la novamente. Seu objetivo � enfraquecer-la tr�s vezes <...>", cid)
		npcHandler:say("Fique preparado pois os demonios n�o deixar�o voc� atacar a fonte de sua existencia passivamente. Eles ir�o atacar sem piedade voc� e seus companheiros <...>", cid)
		npcHandler:say("E ent�o, est� preparado para sua ultima miss�o?", cid)
		D_CustomNpcModules.addChildKeyword(confirmPattern, node, startThirdMissionCallback, {npcHandler = npcHandler, onlyFocus = true})
		D_CustomNpcModules.addChildKeyword(negationPattern, node, noCallback, {npcHandler = npcHandler, onlyFocus = true})			
		
		return true	
	elseif(questStatus == 0) then
		npcHandler:say("� bom lhe ver " .. getCreatureName(cid) .. "! Conseguiu completar a sua miss�o?", cid)
		D_CustomNpcModules.addChildKeyword(confirmPattern, node, finishSecondMissionCallback, {npcHandler = npcHandler, onlyFocus = true})
		D_CustomNpcModules.addChildKeyword(negationPattern, node, noCallback, {npcHandler = npcHandler, onlyFocus = true})			
		
		return true		
	end	
	
	return true
end

local nodes = D_CustomNpcModules.addKeyword({'mission', 'miss�o', 'missao'}, keywordHandler, missionCallback, {npcHandler = npcHandler, onlyFocus = true})

npcHandler:addModule(FocusModule:new())