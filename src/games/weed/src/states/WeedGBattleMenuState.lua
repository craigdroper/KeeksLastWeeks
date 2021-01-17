--[[
    GD50
    Pokemon

    Author: Colton Ogden
    cogden@cs50.harvard.edu
]]

WeedGBattleMenuState = Class{__includes = BaseState}

function WeedGBattleMenuState:init(battleState)
    self.battleState = battleState

    local items = {}
    local playLevel = self.battleState.player.weedGPokemon.level
    for key, attack in pairs(self.battleState.player.weedGPokemon.attacks) do
        if playLevel >= attack.minLevel then
            table.insert(items,
                {
                    text = attack.text,
                    onSelect = function()
                        gStateStack:pop()
                        gStateStack:push(WeedGTakeTurnState(
                                self.battleState,
                                attack.missPercentage,
                                attack.multiplier))
                        end
                }
            )
        end
    end
    self.battleMenu = Menu {
        items = items,
        centerX = VIRTUAL_WIDTH/2,
        centerY = VIRTUAL_HEIGHT/2,
    }
end

function WeedGBattleMenuState:update(dt)
    self.battleMenu:update(dt)
end

function WeedGBattleMenuState:render()
    self.battleMenu:render()
end
