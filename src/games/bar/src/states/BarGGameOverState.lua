--[[
    GD50
    Breakout Remake

    -- BarGGameOverState Class --

    Author: Colton Ogden
    cogden@cs50.harvard.edu

    The state in which we've lost all of our health and get our score displayed to us. Should
    transition to the EnterHighScore state if we exceeded one of our stored high scores, else back
    to the StartState.
]]

BarGGameOverState = Class{__includes = BaseState}

function BarGGameOverState:init(params)
    self.score = params.score
    -- self.highScores = params.highScores
end

function BarGGameOverState:update(dt)
    if love.keyboard.wasPressed('enter') or love.keyboard.wasPressed('return') then
        -- see if score is higher than any in the high scores table
        local highScore = false
        
        -- keep track of what high score ours overwrites, if any
        local scoreIndex = 11

        --[[ Commenting out concept of high scores from mini game for now
        for i = 10, 1, -1 do
            local score = self.highScores[i].score or 0
            if self.score > score then
                highScoreIndex = i
                highScore = true
            end
        end

        if highScore then
            gSounds['high-score']:play()
            gStateMachine:change('enter-high-score', {
                highScores = self.highScores,
                score = self.score,
                scoreIndex = highScoreIndex
            }) 
        else 
        --]]
        -- Set the BarWStationary isGamePlayed flag to true 
        barWStatState = gStateStack:getNPrevState(1)
        barWStatState.isGamePlayed = true
        -- pop BarGGameOverState off to return to the stationary
        -- bar state
        gStateStack:pop()
        -- TODO we will also push an "update Player's scores" state here
        -- which takes the mini game player's stats and updates the world
        -- game player's stats appropriately
    end
end

function BarGGameOverState:render()
    love.graphics.setFont(gFonts['large'])
    love.graphics.printf('GAME OVER', 0, VIRTUAL_HEIGHT / 3, VIRTUAL_WIDTH, 'center')
    love.graphics.setFont(gFonts['medium'])
    love.graphics.printf('Final Score: ' .. tostring(self.score), 0, VIRTUAL_HEIGHT / 2,
        VIRTUAL_WIDTH, 'center')
    love.graphics.printf('Press Enter!', 0, VIRTUAL_HEIGHT - VIRTUAL_HEIGHT / 4,
        VIRTUAL_WIDTH, 'center')
end
