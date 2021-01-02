--[[
    GD50
    Match-3 Remake

    Author: Colton Ogden
    cogden@cs50.harvard.edu

    - AcidGGameOverState Class-

    State that simply shows us our score when we finally lose.
]]

AcidGGameOverState = Class{__includes = BaseState}

function AcidGGameOverState:init(params)
    self.score = params.score
    self.bkgrd = params.bkgrd
    self.level = params.level
end

function AcidGGameOverState:enter()
end

function AcidGGameOverState:update(dt)
    if love.keyboard.wasPressed('enter') or love.keyboard.wasPressed('return') then
        gAcidGSounds['music']:stop()
        -- Currently the stack is:
        -- 1) AlleyWStationary
        -- 2) AcidGGameOverState
        -- Set the AlleyWStationary game stats
        alleyWStatState = gStateStack:getNPrevState(1)
        alleyWStatState.gameStats = {multiplier = self.level - 1}
        gStateStack:push(FadeInState({r = 255, g = 255, b = 255}, 1,
            function()
            -- pop off the game over state and return to the
            -- stationary state
            gStateStack:pop()
            gStateStack:push(FadeOutState({r = 255, g = 255, b = 255}, 1,
            function()
            end))
            end))
    end
end

function AcidGGameOverState:render()
    self.bkgrd:render()
    love.graphics.setFont(gFonts['large'])

    love.graphics.setColor(56, 56, 56, 234)
    love.graphics.rectangle('fill', VIRTUAL_WIDTH / 2 - 64, 64, 128, 136, 4)

    love.graphics.setColor(99, 155, 255, 255)
    if self.level == 11 then
        love.graphics.printf('YOU WIN', VIRTUAL_WIDTH / 2 - 64, 64, 128, 'center')
    else
        love.graphics.printf('GAME OVER', VIRTUAL_WIDTH / 2 - 64, 64, 128, 'center')
    end
    love.graphics.setFont(gFonts['medium'])
    -- love.graphics.printf('Your Score: ' .. tostring(self.score), VIRTUAL_WIDTH / 2 - 64, 140, 128, 'center')
    love.graphics.printf('Press Enter', VIRTUAL_WIDTH / 2 - 64, 180, 128, 'center')
end
