
ClubGVictoryState = Class{__includes = BaseState}

function ClubGVictoryState:init(params)
    self.background = params.background
    self.level = params.level
    self.score = params.score
    self.targets = params.targets
    self.health = params.health
    self.song = params.song
end

function ClubGVictoryState:update(dt)
    if love.keyboard.wasPressed('enter') or love.keyboard.wasPressed('return') then
        -- Currently the stack is as follows:
        -- 1) ClubWStationary
        -- 2) ClubGGameOver
        -- Set the ClubWStationary game stats
        clubWStatState = gStateStack:getNPrevState(1)
        clubWStatState.gameStats = {score = 2*self.score}
        -- pop ClubGGameOverState off to
        -- return to the stationary bar state
        gStateStack:push(FadeInState({r = 255, g = 255, b = 255}, 1,
            function()
            -- Pop GameOverState
            gStateStack:pop()
            gStateStack:push(FadeOutState({r = 255, g = 255, b = 255}, 1,
            function()
            end))
            end))
    end
end

function ClubGVictoryState:render()
    self.background:render()
    for _, target in pairs(self.targets) do
        target:renderImage()
        target:renderParticles()
    end

    ClubGUtils():renderScore(self.score)
    ClubGUtils():renderHealth(self.health)

    love.graphics.setFont(gFonts['large'])
    love.graphics.printf('VICTORY', 0, VIRTUAL_HEIGHT / 3, VIRTUAL_WIDTH, 'center')
    love.graphics.setFont(gFonts['medium'])
    love.graphics.printf('Final Score: ' .. tostring(self.score), 0, VIRTUAL_HEIGHT / 2,
        VIRTUAL_WIDTH, 'center')
    love.graphics.printf('Press Enter!', 0, VIRTUAL_HEIGHT - VIRTUAL_HEIGHT / 4,
        VIRTUAL_WIDTH, 'center')
end
