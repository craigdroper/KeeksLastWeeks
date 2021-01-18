--[[
    GD50
    Match-3 Remake

    Author: Colton Ogden
    cogden@cs50.harvard.edu

    - WeedGGameOverState Class-

    State that simply shows us our score when we finally lose.
]]

WeedGGameOverState = Class{__includes = BaseState}

function WeedGGameOverState:init(params)
    self.level = params.level
end

function WeedGGameOverState:enter()
end

function WeedGGameOverState:update(dt)
    if love.keyboard.wasPressed('enter') or love.keyboard.wasPressed('return') then
        -- gAcidGSounds['music']:stop()
        -- Currently the stack is:
        -- 1) AlleyWStationary
        -- 2) WeedGPlayState
        -- 3) WeedGBattleState
        -- 4) WeedGGameOverState
        -- Set the AlleyWStationary game stats
        alleyWStatState = gStateStack:getNPrevState(3)
        alleyWStatState.gameStats = {multiplier = self.level }
        gStateStack:push(FadeInState({r = 255, g = 255, b = 255}, 1,
            function()
            -- pop off all states down to the AlleyWStationary state
            gStateStack:pop()
            gStateStack:pop()
            gStateStack:pop()
            gStateStack:push(FadeOutState({r = 255, g = 255, b = 255}, 1,
            function()
            end))
            end))
    end
end

function WeedGGameOverState:render()
    -- self.bkgrd:render()
    love.graphics.setFont(gFonts['large'])

    love.graphics.setColor(56, 56, 56, 234)
    love.graphics.rectangle('fill', VIRTUAL_WIDTH / 2 - 175, 64, 350, 64, 4)

    love.graphics.setColor(99, 155, 255, 255)
    -- if self.level == 10 then
    love.graphics.printf('SESH OVER', VIRTUAL_WIDTH / 2 - 128, 64, 256, 'center')
    -- else
        --love.graphics.printf('GAME OVER', VIRTUAL_WIDTH / 2 - 128, 64, 256, 'center')
    --end
    love.graphics.setFont(gFonts['medium'])
    -- love.graphics.printf('Your Score: ' .. tostring(self.score), VIRTUAL_WIDTH / 2 - 64, 140, 128, 'center')
    love.graphics.printf('Press Enter', VIRTUAL_WIDTH / 2 - 128, 96, 256, 'center')
end
