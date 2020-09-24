--[[
    CokeGTitleScreenState Class
    Author: Colton Ogden
    cogden@cs50.harvard.edu

    The CokeGTitleScreenState is the starting screen of the game, shown on startup. It should
    display "Press Enter" and also our highest score.
]]

CokeGTitleScreenState = Class{__includes = BaseState}

function CokeGTitleScreenState:update(dt)
    -- transition to countdown when enter/return are pressed
    if love.keyboard.wasPressed('enter') or love.keyboard.wasPressed('return') then
        gStateStack:pop()
        gStateStack:push(CokeGCountdownState())
    end
end

function CokeGTitleScreenState:render()
    -- Draw stationary background
    love.graphics.filterDrawD(gCokeGImages['background'], 0, 0)

    -- simple UI code
    love.graphics.setFont(gFonts['flappy-font'])
    love.graphics.printf('Fifty CokeGBird', 0, 64, VIRTUAL_WIDTH, 'center')

    love.graphics.setFont(gFonts['medium-flappy-font'])
    love.graphics.printf('Press Enter', 0, 100, VIRTUAL_WIDTH, 'center')

    -- Finally draw stationary ground
    love.graphics.filterDrawD(gCokeGImages['ground'], 0, VIRTUAL_HEIGHT - 16)
end
