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


    if self.level == 11 then
        love.graphics.setColor(56, 56, 56, 234)
        love.graphics.rectangle('fill', VIRTUAL_WIDTH / 2 - 128, 64, 256, 96, 4)

        love.graphics.setColor(99, 155, 255, 255)
        love.graphics.printf('WELCOME TO THE', VIRTUAL_WIDTH / 2 - 128, 64, 256, 'center')
        love.graphics.printf('HIGHEST LEVEL!', VIRTUAL_WIDTH / 2 - 128, 96, 256, 'center')

        love.graphics.setFont(gFonts['medium'])
        love.graphics.printf('Press Enter', VIRTUAL_WIDTH / 2 - 128, 128, 256, 'center')
    else
        love.graphics.setColor(56, 56, 56, 234)
        love.graphics.rectangle('fill', VIRTUAL_WIDTH / 2 - 128, 64, 256, 64, 4)

        love.graphics.setColor(99, 155, 255, 255)
        love.graphics.printf('GAME OVER', VIRTUAL_WIDTH / 2 - 128, 64, 256, 'center')

        love.graphics.setFont(gFonts['medium'])
        love.graphics.printf('Press Enter', VIRTUAL_WIDTH / 2 - 128, 96, 256, 'center')
    end
end
