local keywordHandler = KeywordHandler:new()
local npcHandler = NpcHandler:new(keywordHandler)
NpcSystem.parseParameters(npcHandler)


function onCreatureAppear(cid)				npcHandler:onCreatureAppear(cid) 			end
function onCreatureDisappear(cid) 			npcHandler:onCreatureDisappear(cid) 		end
function onCreatureSay(cid, type, msg) 		npcHandler:onCreatureSay(cid, type, msg) 	end
function onThink() 							npcHandler:onThink() 						end

local confirmPattern = {'yes', 'sim'}
local negationPattern = {'no', 'não', 'nao'}

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
	npcHandler:say("Então prove o seu valor e retorne quando tiver em posse do solicitado! Boa sorte!", cid)
	
	npcHandler:resetNpc()
end

function finishFirstMissionCallback(cid, message, keywords, parameters, node)

	if(not npcSystemHeader(cid, message, keywords, parameters, node)) then
		return false
	end

	local npcHandler = parameters.npcHandler

	local ITEMS_DEMONIC_ESSENCE = 6500

	if(getPlayerItemCount(cid, ITEMS_DEMONIC_ESSENCE) < 20) then
		npcHandler:say("Que decepção! Você ainda não conseguiu as 20 demonic essences que lhe solicitei! Estou a começando a achar que não conseguira cumprir-la...", cid)		
		npcHandler:resetNpc()
		
		return true
	end	
	
	if(not doPlayerRemoveItem(cid, ITEMS_DEMONIC_ESSENCE, 20)) then
		print('[Warning - ' .. getCreatureName(getNpcId()) .. '] NpcSystem:', 'Inquisition - Can not remove required items. Details:', '{player=' .. getCreatureName(cid) .. ', item_id=' .. ITEMS_DEMONIC_ESSENCE .. ', count=' .. 20 .. '}')
		return false
	end	

	setPlayerStorageValue(cid, QUESTLOG.INQUISITION.MISSION_OUTFIT, 1)
	doPlayerAddOutfitId(cid, 20, 0)
	
	npcHandler:say("Confesso que estou surpreso! Como recompensa eu lhe darei uma nova roupa, a do caçador de demonios! Retorne quando estiver preparado para sua primeira missão!", cid)
	npcHandler:resetNpc()
	
	return true
end

function startSecondMissionCallback(cid, message, keywords, parameters, node)

	if(not npcSystemHeader(cid, message, keywords, parameters, node)) then
		return false
	end

	local npcHandler = parameters.npcHandler

	setPlayerStorageValue(cid, QUESTLOG.INQUISITION.MISSION_FIRST_ADDON, 0)
	npcHandler:say("Este demonio é conhecido como Ungreez, há informações que atualmente ele se encontra na caverna ao sul de Aracura. Estarei aguardando a sua volta com a missão concluida!", cid)
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
		npcHandler:say("Está tentando me enganar " .. getCreatureName(cid) .. "? Eu ainda posso sentir que as forças demoniacas continuam forte! Derrote-o!", cid)
		npcHandler:resetNpc()
		
		return true
	end	

	setPlayerStorageValue(cid, QUESTLOG.INQUISITION.MISSION_FIRST_ADDON, 1)
	doPlayerAddOutfitId(cid, 20, 1)
	
	npcHandler:say("Bom trabalho " .. getCreatureName(cid) .. "! Ja vejo as forças demoniacas muito mais vulneraveis! Como recompensa lhe concedo alguns infeites para sua roupa! <...>", cid)
	npcHandler:say("Retorne a falar comigo quando estiver preparado para a sua ultima e mais perigosa missão!", cid)
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
		npcHandler:say("Toda força demoniaca continua muito alta e expandindo! Não parece que você tenha concluido sua missão! Volte quando tiver a terminado!", cid)
		npcHandler:resetNpc()
		
		return true
	end	

	setPlayerStorageValue(cid, QUESTLOG.INQUISITION.MISSION_SHADOW_NEXUS, 1)
	doPlayerAddOutfitId(cid, 20, 2)
	
	npcHandler:say("Bravo guerreiro! Agora a presença demoniaca está mais controlada! Todo nosso reino lhe agradeçe! <...>", cid)
	npcHandler:say("Como recompensa por sua grande missão lhe concedo mais alguns infeites para a sua roupa de caçador de demonios! Além disto lhe concedo a permissão para acessar a sala seguindo o corredor a norte <...>!", cid)
	npcHandler:say("Lá você encontrará¡ alguns dos mais poderosos equipamentos e armas conhecidos e poderá escolher uma para você! Esteja atento a sua decisão, pois não poderá! Boa sorte!", cid)
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
		npcHandler:say("Nós estamos dando uma grande investida contra as forças demoniacas que assombram este mundo, e sim, precisamos de ajuda. Mas antes de receber a sua primeira missão você devera provar o seu valor e tambem o seu comprometimento conosco nesta guerra <...>", cid)
		npcHandler:say("Para provar isto, você precisará derrotar algumas criaturas demoniacas e obter 20 demonic essences e então me trazer-los. Assim irei lhe passar a sua primeira brava missão, além de lhe dar uma recompensa. E então, o que me diz?", cid)
		D_CustomNpcModules.addChildKeyword(confirmPattern, node, startFirstMissionCallback, {npcHandler = npcHandler, onlyFocus = true})
		D_CustomNpcModules.addChildKeyword(negationPattern, node, noCallback, {npcHandler = npcHandler, onlyFocus = true})
		
		return true
	elseif(questStatus == 0) then
		npcHandler:say("E então, algum progresso em seu teste?", cid)
		D_CustomNpcModules.addChildKeyword(confirmPattern, node, finishFirstMissionCallback, {npcHandler = npcHandler, onlyFocus = true})
		D_CustomNpcModules.addChildKeyword(negationPattern, node, noCallback, {npcHandler = npcHandler, onlyFocus = true})			
		
		return true
	end
	
	questStatus = getPlayerStorageValue(cid, QUESTLOG.INQUISITION.MISSION_FIRST_ADDON)
	
	if(questStatus == -1) then
		npcHandler:say("As essencias demoniacas que você me trouxe em seu teste serão uteis na criação de uma arma que nos ajudará a combater toda força demoniaca. Mas para que tudo dê certo precisamos enfraquecer esta força primeiro <...>", cid)
		npcHandler:say("Para isto será necessario viajar até o continente de Aracura e partir para uma caverna ao sul da cidade, em algum lugar nela reside um antigo demonio chamado Ungreez. <...>", cid)
		npcHandler:say("Apos encontrar-lo você irá derrotar-lo e então as forças demoniacas estarão significativame mais vulneraveis. Gostaria de cumprir esta perigosa missão?", cid)
		D_CustomNpcModules.addChildKeyword(confirmPattern, node, startSecondMissionCallback, {npcHandler = npcHandler, onlyFocus = true})
		D_CustomNpcModules.addChildKeyword(negationPattern, node, noCallback, {npcHandler = npcHandler, onlyFocus = true})			
		
		return true	
	elseif(questStatus == 0) then
		npcHandler:say("E então, o velho demonio Ungreez já¡ foi derrotado?", cid)
		D_CustomNpcModules.addChildKeyword(confirmPattern, node, finishSecondMissionCallback, {npcHandler = npcHandler, onlyFocus = true})
		D_CustomNpcModules.addChildKeyword(negationPattern, node, noCallback, {npcHandler = npcHandler, onlyFocus = true})						
		
		return true		
	end
	
	questStatus = getPlayerStorageValue(cid, QUESTLOG.INQUISITION.MISSION_SHADOW_NEXUS)
	
	if(questStatus == -1) then
		npcHandler:say("A sua ultima missão será a mais dificil e mais arriscada " .. getCreatureName(cid) .. " e creio que você irá precisar de muita ajuda para concluir-la. Se lembra da arma que falei para você certa vez? <...>", cid)
		npcHandler:say("Pois bem, é um flasco que contem uma pequena porÃ§Ã£o do mais divino liquido, extraido de toda essencia demoniaca. Em sua ultima missão você terÃ¡ de ir ao local onde se origina todas forÃ§as demoniacas <...> ", cid)
		npcHandler:say("Este lugar fica no coração de onde nascem os demonios, nas profundezas de caverna no continente da cidade de Aaragon e é conhecido como nexo das sombras. Entretanto seu desafio irá começar muito antes de chegar lá <...> ", cid)
		npcHandler:say("Para chegar lá você irá precisar enfrentar antigos e tremendamente poderosos demonios guardiões, já nesta parte de sua missão você irá precisar de toda ajuda possivel <...> ", cid)
		npcHandler:say("Quando você conseguir chegar no nexo das sombras irá precisar derramar o liquido divino em uma barreira magica na qual é a fonte de toda força demoniaca <...> ", cid)
		npcHandler:say("Ela inicialmente irá enfraquecer porem voltará a se fortalecer e você irá precisar enfraquecer-la novamente. Seu objetivo é enfraquecer-la três vezes <...>", cid)
		npcHandler:say("Fique preparado pois os demonios não deixarão você atacar a fonte de sua existencia passivamente. Eles irão atacar sem piedade você e seus companheiros <...>", cid)
		npcHandler:say("E então, está preparado para sua ultima missão?", cid)
		D_CustomNpcModules.addChildKeyword(confirmPattern, node, startThirdMissionCallback, {npcHandler = npcHandler, onlyFocus = true})
		D_CustomNpcModules.addChildKeyword(negationPattern, node, noCallback, {npcHandler = npcHandler, onlyFocus = true})			
		
		return true	
	elseif(questStatus == 0) then
		npcHandler:say("É bom lhe ver " .. getCreatureName(cid) .. "! Conseguiu completar a sua missão?", cid)
		D_CustomNpcModules.addChildKeyword(confirmPattern, node, finishSecondMissionCallback, {npcHandler = npcHandler, onlyFocus = true})
		D_CustomNpcModules.addChildKeyword(negationPattern, node, noCallback, {npcHandler = npcHandler, onlyFocus = true})			
		
		return true		
	end	
	
	return true
end

local nodes = D_CustomNpcModules.addKeyword({'mission', 'missão', 'missao'}, keywordHandler, missionCallback, {npcHandler = npcHandler, onlyFocus = true})

npcHandler:addModule(FocusModule:new())