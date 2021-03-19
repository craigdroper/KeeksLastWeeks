--[[
    CokeGTitleScreenState Class
    Author: Colton Ogden
    cogden@cs50.harvard.edu

    The CokeGTitleScreenState is the starting screen of the game, shown on startup. It should
    display "Press Enter" and also our highest score.
]]

CokeGTitleScreenState = Class{__includes = BaseState}

function CokeGTitleScreenState:init()
    self.background = CokeGBackground()

    gCokeSounds['music']:setLooping(true)
    gCokeSounds['music']:play()
end

function CokeGTitleScreenState:enter()
    self.startMenu = Menu {
        items = {
            {
                text = 'Play',
                onSelect =
                    function()
                        -- Pop off CokeGStartState
                        gStateStack:pop()
                        gStateStack:push(CokeGCountdownState({background = self.background}))
                    end
            },
            {
                text = 'Instructions',
                onSelect =
                    function()
                        gStateStack:push(CokeGInstructionsState())
                    end
            },
        }
    }
end

function CokeGTitleScreenState:update(dt)
    self.startMenu:update(dt)
end

function CokeGTitleScreenState:render()
    -- Draw stationary background
    self.background:render()

    -- simple UI code
    love.graphics.setFont(gFonts['flappy-font'])
    love.graphics.printf('SniffyBird', 0, 64, VIRTUAL_WIDTH, 'center')

    love.graphics.setFont(gFonts['medium-flappy-font'])
    love.graphics.printf('Press Enter', 0, 100, VIRTUAL_WIDTH, 'center')

    -- Finally draw stationary ground
    love.graphics.filterDrawD(gCokeGImages['ground'], 0, VIRTUAL_HEIGHT - 16)

    self.startMenu:render()
end
