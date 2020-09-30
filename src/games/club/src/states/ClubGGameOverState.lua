
ClubGGameOverState = Class{__includes = BaseState}

function ClubGGameOverState:init(params)
    self.background = params.background
    self.score = params.score
    self.targets = params.targets
    self.health = params.health
end

function ClubGGameOverState:update(dt)
    if love.keyboard.wasPressed('enter') or love.keyboard.wasPressed('return') then
        -- Currently the stack is as follows:
        -- 1) ClubWStationary
        -- 2) ClubGGameOver
        -- Set the ClubWStationary game stats
        barWStatState = gStateStack:getNPrevState(1)
        barWStatState.gameStats = {score = self.score}
        -- pop ClubGGameOverState off to
        -- return to the stationary bar state
        gStateStack:pop()
    end
end

function ClubGGameOverState:render()
    self.background:render()

    ClubGUtils():renderScore(self.score)
    ClubGUtils():renderHealth(self.health)

    for _, target in pairs(self.targets) do
        target:renderImage()
        target:renderParticles()
    end

    love.graphics.setFont(gFonts['large'])
    love.graphics.printf('GAME OVER', 0, VIRTUAL_HEIGHT / 3, VIRTUAL_WIDTH, 'center')
    love.graphics.setFont(gFonts['medium'])
    love.graphics.printf('Final Score: ' .. tostring(self.score), 0, VIRTUAL_HEIGHT / 2,
        VIRTUAL_WIDTH, 'center')
    love.graphics.printf('Press Enter!', 0, VIRTUAL_HEIGHT - VIRTUAL_HEIGHT / 4,
        VIRTUAL_WIDTH, 'center')
end
