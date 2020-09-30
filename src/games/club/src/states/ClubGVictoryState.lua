
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
    -- go to play screen if the player presses Enter
    if love.keyboard.wasPressed('enter') or love.keyboard.wasPressed('return') then
        -- Pop off the current victory state, and push
        -- a Serve state with a newly created level
        self.song:stop()
        gStateStack:pop()
        gStateStack:push(ClubGCountdownState({
            background = self.background,
            level = self.level + 1,
            targets = self.targets,
            -- For now reset on every level, since the arrows get faster
            health = 100,
            score = self.score,
        }))
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

    -- level complete text
    love.graphics.setFont(gFonts['large'])
    love.graphics.printf("Level " .. tostring(self.level) .. " complete!",
        0, VIRTUAL_HEIGHT / 4, VIRTUAL_WIDTH, 'center')

    -- instructions text
    love.graphics.setFont(gFonts['medium'])
    love.graphics.printf('Press Enter for next level!', 0, VIRTUAL_HEIGHT / 2,
        VIRTUAL_WIDTH, 'center')
end
