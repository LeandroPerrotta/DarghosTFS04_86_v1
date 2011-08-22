local keywordHandler = KeywordHandler:new()
local npcHandler = NpcHandler:new(keywordHandler)
NpcSystem.parseParameters(npcHandler)

function onCreatureAppear(cid)                          npcHandler:onCreatureAppear(cid)                        end
function onCreatureDisappear(cid)                       npcHandler:onCreatureDisappear(cid)                     end
function onCreatureSay(cid, type, msg)                  npcHandler:onCreatureSay(cid, type, msg)                end
function onThink()                                      npcHandler:onThink()                                    end

local shopModule = ShopModule:new()
npcHandler:addModule(shopModule)

D_CustomNpcModules.addTradeList(shopModule, "magic_misc")
D_CustomNpcModules.addTradeList(shopModule, "runes")
D_CustomNpcModules.addTradeList(shopModule, "potions")
D_CustomNpcModules.addTradeList(shopModule, "wands")
D_CustomNpcModules.addTradeList(shopModule, "rods")

parseAddonItemModule(keywordHandler, npcHandler)

npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:addModule(FocusModule:new())