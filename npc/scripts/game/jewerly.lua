local keywordHandler = KeywordHandler:new()
local npcHandler = NpcHandler:new(keywordHandler)
NpcSystem.parseParameters(npcHandler)

function onCreatureAppear(cid)                          npcHandler:onCreatureAppear(cid)                        end
function onCreatureDisappear(cid)                       npcHandler:onCreatureDisappear(cid)                     end
function onCreatureSay(cid, type, msg)                  npcHandler:onCreatureSay(cid, type, msg)                end
function onThink()                                      npcHandler:onThink()                                    end

local shopModule = ShopModule:new()
npcHandler:addModule(shopModule)

shopModule:addSellableItem({'black pearl'}, 2144, 420, 1, 'black pearl')
shopModule:addSellableItem({'small amethyst'}, 2150, 270, 1, 'small amethyst')
shopModule:addSellableItem({'small diamond'}, 2145, 100, 1, 'small diamond')
shopModule:addSellableItem({'small sapphire'}, 2146, 375, 1, 'small sapphire')
shopModule:addSellableItem({'white pearl'}, 2143, 300, 1, 'white pearl')
shopModule:addSellableItem({'small ruby'}, 2147, 352, 1, 'small ruby')
shopModule:addSellableItem({'small emerald'}, 2149, 352, 1, 'small emerald')

shopModule:addBuyableItem({'black pearl'}, 2144, 560, 1, 'black pearl')
shopModule:addBuyableItem({'small amethyst'}, 2150, 400, 1, 'small amethyst')
shopModule:addBuyableItem({'small diamond'}, 2145, 600, 1, 'small diamond')
shopModule:addBuyableItem({'small sapphire'}, 2146, 500, 1, 'small sapphire')
shopModule:addBuyableItem({'white pearl'}, 2143, 320, 1, 'white pearl')
shopModule:addBuyableItem({'small ruby'}, 2147, 500, 1, 'small ruby')
shopModule:addBuyableItem({'small emerald'}, 2149, 500, 1, 'small emerald')

shopModule:addBuyableItem({'golden amulet'}, 2130, 6600, 1, 'golden amulet')
shopModule:addBuyableItem({'ruby necklace'}, 2133, 3560, 1, 'ruby necklace')
shopModule:addBuyableItem({'wedding ring'}, 2121, 990, 1, 'wedding ring')
shopModule:addBuyableItem({'bronze goblet'}, 5807, 2000, 1, 'bronze goblet')
shopModule:addBuyableItem({'golden goblet'}, 5805, 5000, 1, 'golden goblet')
shopModule:addBuyableItem({'silver goblet'}, 5806, 3000, 1, 'silver goblet')

npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:addModule(FocusModule:new())