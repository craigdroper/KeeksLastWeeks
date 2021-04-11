--[[
    CokeGScoreState Class
    Author: Colton Ogden
    cogden@cs50.harvard.edu

    A simple state used to display the player's score before they
    transition back into the play state. Transitioned to from the
    CokeGPlayState when they collide with a Pipe.
]]

CokeGScoreState = Class{__includes = BaseState}

--[[
    When we enter the score state, we expect to receive the score
    from the play state so we know what to render to the State.
]]
function CokeGScoreState:init(params)
    self.level = params.level
    self.bird = params.bird
    self.background = params.background
    self.background:setIsScrolling(false)
end

function CokeGScoreState:update(dt)
    -- update bird (mainly for its sneeze)
    self.bird:update(dt)

    -- go back to play if enter is pressed
    if love.keyboard.wasPressed('enter') or love.keyboard.wasPressed('return') then
        -- Currently the stack is:
        -- 1) AlleyWStationary
        -- 2) CokeGScoreState
        -- Set the AlleyWStationary game stats
        alleyWStatState = gStateStack:getNPrevState(1)
        alleyWStatState.gameStats = {multiplier = self.level}
        gStateStack:push(FadeInState({r = 255, g = 255, b = 255}, 1,
            function()
            -- pop off the coke game score state and return to the
            -- stationary state
            gGlobalObjs['music']:stopSong()
            gStateStack:pop()
            gStateStack:push(FadeOutState({r = 255, g = 255, b = 255}, 1,
            function()
            end))
            end))
    end
end

function CokeGScoreState:render()
    -- Draw stationary background
    self.background:render()

    -- Keep the nose in for its sneeze particle system effect
    self.bird:render()

    -- simply render the score to the middle of the screen
    love.graphics.setFont(gFonts['flappy-font'])
    local msg = nil
    if self.level == 10 then
        msg = 'You sniffed it all!'
    else
        msg = 'Busted!'
    end
    love.graphics.printf(msg, 0, 64, VIRTUAL_WIDTH, 'center')

    love.graphics.setFont(gFonts['medium-flappy-font'])
    local scoreMsg = 'Lines: ' .. tostring(self.level)
    love.graphics.printf(scoreMsg, 0, 100, VIRTUAL_WIDTH, 'center')

    restartMsg = 'Press Enter to End the Game'
    love.graphics.printf(restartMsg, 0, VIRTUAL_HEIGHT - 100, VIRTUAL_WIDTH, 'center')

    -- Finally draw stationary ground
    love.graphics.filterDrawD(gCokeGImages['ground'], 0, VIRTUAL_HEIGHT - 16)
end
