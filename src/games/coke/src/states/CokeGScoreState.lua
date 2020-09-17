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
function CokeGScoreState:enter(params)
    self.score = params.score
end

function CokeGScoreState:update(dt)
    -- go back to play if enter is pressed
    if love.keyboard.wasPressed('enter') or love.keyboard.wasPressed('return') then
        gStateMachine:change('coke-game-countdown')
    end
end

function CokeGScoreState:render()
    -- Draw stationary background
    love.graphics.draw(gCokeGImages['background'], 0, 0)

    -- simply render the score to the middle of the screen
    love.graphics.setFont(gFonts['flappy-font'])
    local lostMsg = 'Oof! You lost!'
    love.graphics.printf(lostMsg, 0, 64, VIRTUAL_WIDTH, 'center')

    love.graphics.setFont(gFonts['medium-flappy-font'])
    local scoreMsg = 'Score: ' .. tostring(self.score)
    love.graphics.printf(scoreMsg, 0, 100, VIRTUAL_WIDTH, 'center')

    restartMsg = 'Press Enter to Play Again!'
    love.graphics.printf(restartMsg, 0, 200, VIRTUAL_WIDTH, 'center')

    -- Finally draw stationary ground
    love.graphics.draw(gCokeGImages['ground'], 0, VIRTUAL_HEIGHT - 16)
end
