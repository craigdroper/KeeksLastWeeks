--[[
    GD50
    Pokemon

    Author: Colton Ogden
    cogden@cs50.harvard.edu
]]

WeedGBattleMenuState = Class{__includes = BaseState}

function WeedGBattleMenuState:init(battleState)
    self.battleState = battleState

    self.battleMenu = Menu {
        x = VIRTUAL_WIDTH - 64,
        y = VIRTUAL_HEIGHT - 64,
        width = 64,
        height = 64,
        items = {
            {
                text = 'Fight',
                onSelect = function()
                    gStateStack:pop()
                    gStateStack:push(WeedGTakeTurnState(self.battleState))
                end
            },
            {
                text = 'Run',
                onSelect = function()
                    gWeedGSounds['run']:play()

                    -- pop battle menu
                    gStateStack:pop()

                    -- show a message saying they successfully ran, then fade in
                    -- and out back to the field automatically
                    gStateStack:push(WeedGBattleMessageState('You fled successfully!',
                        function() end), false)
                    Timer.after(0.5, function()
                        gStateStack:push(FadeInState({
                            r = 255, g = 255, b = 255
                        }, 1,

                        -- pop message and battle state and add a fade to blend in the field
                        function()

                            -- resume field music
                            gWeedGSounds['field-music']:play()

                            -- pop message state
                            gStateStack:pop()

                            -- pop battle state
                            gStateStack:pop()

                            gStateStack:push(FadeOutState({
                                r = 255, g = 255, b = 255
                            }, 1, function()
                                -- do nothing after fade out ends
                            end))
                        end))
                    end)
                end
            }
        }
    }
end

function WeedGBattleMenuState:update(dt)
    self.battleMenu:update(dt)
end

function WeedGBattleMenuState:render()
    self.battleMenu:render()
end
