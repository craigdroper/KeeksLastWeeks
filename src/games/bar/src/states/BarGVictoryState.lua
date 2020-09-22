--[[
    GD50
    Breakout Remake

    -- StartState Class --

    Author: Colton Ogden
    cogden@cs50.harvard.edu

    Represents the state that the game is in when we've just completed a level.
    Very similar to the ServeState, except here we increment the level
]]

BarGVictoryState = Class{__includes = BaseState}

function BarGVictoryState:init(params)
    self.background = params.background
    self.level = params.level
    self.score = params.score
    -- self.highScores = params.highScores
    self.paddle = params.paddle
    self.health = params.health
    self.ball = params.ball
    self.recoverPoints = params.recoverPoints
    -- init the new ball in the middle of the paddle
    self.ball.x = self.paddle.x + self.paddle.width/2 - self.ball.width/2
    self.ball.y = self.paddle.y - self.ball.height
end

function BarGVictoryState:update(dt)
    self.paddle:update(dt)

    -- have the ball track the player
    self.ball.x = self.paddle.x + self.paddle.width/2 - self.ball.width/2
    self.ball.y = self.paddle.y - self.ball.height

    -- go to play screen if the player presses Enter
    if love.keyboard.wasPressed('enter') or love.keyboard.wasPressed('return') then
        -- Pop off the current victory state, and push
        -- a Serve state with a newly created level
        gStateStack:pop()
        gStateStack:push(BarGServeState({
            background = self.background,
            level = self.level + 1,
            bricks = BarGLevelMaker.createMap(self.level + 1, self.background),
            paddle = self.paddle,
            health = self.health,
            score = self.score,
            -- highScores = self.highScores,
            recoverPoints = self.recoverPoints
        }))
    end
end

function BarGVictoryState:render()
    self.background:render()
    self.paddle:render()
    self.ball:render()

    renderHealth(self.health)
    renderScore(self.score)

    -- level complete text
    love.graphics.setFont(gFonts['large'])
    love.graphics.printf("Level " .. tostring(self.level) .. " complete!",
        0, VIRTUAL_HEIGHT / 4, VIRTUAL_WIDTH, 'center')

    -- instructions text
    love.graphics.setFont(gFonts['medium'])
    love.graphics.printf('Press Enter to serve!', 0, VIRTUAL_HEIGHT / 2,
        VIRTUAL_WIDTH, 'center')
end
