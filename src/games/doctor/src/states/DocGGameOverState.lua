
DocGGameOverState = Class{__includes = BaseState}

function DocGGameOverState:init(params)
    self.level = params.level
    self.level.isGameOver = true
    self.level.launchMarker.isGameOver = true
    self.numVirusDestroyed = self.level.totalAliens - #self.level.aliens
end

function DocGGameOverState:update(dt)
    self.level:update(dt)
    if love.keyboard.wasPressed('return') or love.keyboard.wasPressed('enter') then
        gStateStack:push(FadeInState({r = 255, g = 255, b = 255}, 1,
            function()
                -- Pop the GameOver state off
                gStateStack:pop()
                gStateStack:push(DoctorWExitGameState({
                gameStats = {
                    numVirusDestroyed = self.numVirusDestroyed
                    }
                }))
                gStateStack:push(FadeOutState({r = 255, g = 255, b = 255}, 1,
                    function()
                    end))
            end))
    end
end

function DocGGameOverState:render()
    self.level.background:render()
    self.level:render()
    love.graphics.setFont(gFonts['large'])
    love.graphics.setColor(255, 50, 50, 255)
    love.graphics.printf('GAME OVER', 0, VIRTUAL_HEIGHT / 2 - 32, VIRTUAL_WIDTH, 'center')
    love.graphics.setFont(gFonts['medium'])
    -- love.graphics.printf(self.numVirusDestroyed .. ' VIRUS DESTROYED', 0, VIRTUAL_HEIGHT / 2 - 32, VIRTUAL_WIDTH, 'center')
    love.graphics.printf('Press Enter', 0, VIRTUAL_HEIGHT / 2, VIRTUAL_WIDTH, 'center')
    love.graphics.setColor(255, 255, 255, 255)
end
