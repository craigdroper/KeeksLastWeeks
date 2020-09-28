--[[
    GD50
    Breakout Remake

    -- BarGPlayState Class --

    Author: Colton Ogden
    cogden@cs50.harvard.edu

    Represents the state of the game in which we are actively playing;
    player should control the paddle, with the ball actively bouncing between
    the bricks, walls, and the paddle. If the ball goes below the paddle, then
    the player should lose one point of health and be taken either to the Game
    Over screen if at 0 health or the Serve screen otherwise.
]]

-- Super trivial helper class that's essentially a boolean that will be passed
-- by reference since its a class
BoolRef = Class{}

function BoolRef:init(val)
    self.val = val
end

BarGPlayState = Class{__includes = BaseState}

-- Number of points player needs to score in a given level to earn a larger
-- paddle
local PADDLE_GROW_THRESHOLD = 10000

--[[
    We initialize what's in our BarGPlayState via a state table that we pass between
    states as we go from playing to serving.
]]

function BarGPlayState:init(params)
    self.background = params.background
    self.paddle = params.paddle
    self.bricks = params.bricks
    self.health = params.health
    self.score = params.score
    -- Keep track of score achieved within this given level to see
    -- if threshold has been reached for player to have earned a larger paddle
    self.paddleGrowThreshold = PADDLE_GROW_THRESHOLD
    -- self.highScores = params.highScores
    -- Initialized the balls table to only be tracking the single serve state ball
    self.balls = {}
    table.insert(self.balls, params.ball)
    self.level = params.level

    -- self.recoverPoints = 5000

    -- Initialize the "ball" to not be able to bounce passed the bar
    -- until all bricks are cleared
    self.balls[1].curMinY = self.background:getBarBottomY()
    -- give ball random starting velocity
    self.balls[1].dx = math.random(-200, 200)
    self.balls[1].dy = math.random(-50, -60)

    --[[
    self.powerUp = BarGPowerUp()
    self.powerUp.isActive = false
    self.powerUpAlarm = math.random(15,30)
    --]]
    -- check if the current bricks in this level contain a locked brick
    -- if so the player will need a Unlock power up at some point
    self.isLockedBrick = false
    for _, brick in pairs(self.bricks) do
        self.isLockedBrick = self.isLockedBrick or
            (brick.isLocked and brick.inPlay)
    end
    -- boolean that keeps track if the player has collected the Key BarGPowerUp
    self.hasKey = BoolRef(false)
end

function BarGPlayState:update(dt)

    if self.paused then
        if love.keyboard.wasPressed('space') then
            self.paused = false
            gBGSounds['pause']:play()
            -- prevent paused time to count towards next power up
            self.powerUpAlarm = math.random(15,30)
        else
            return
        end
    elseif love.keyboard.wasPressed('space') then
        self.paused = true
        gBGSounds['pause']:play()
        return
    end

    --[[
    self.powerUpAlarm = self.powerUpAlarm - dt
    -- check if its time to create a BarGPowerUp
    if self.powerUpAlarm < 0 then
        -- BarGPowerUp creation logic will be a combination of random selection
        -- from BarGPowerUps that are appropriate for the current play state
        local powerUpCands = {}
        -- ExtraBallPowerUp always valid
        table.insert(powerUpCands, BGExtraBallsPowerUp())
        -- KeyPowerUp only valid if the current level has a lock brick and
        -- if the player has not already collected a KeyPowerUp
        if self.isLockedBrick and not self.hasKey.val then
            table.insert(powerUpCands, BGKeyPowerUp())
        end
        self.powerUp = powerUpCands[math.random(1,#powerUpCands)]
        self.powerUpAlarm = math.random(15,30)
    end
    if self.powerUp and self.powerUp.isActive then
        self.powerUp:update(dt)
        self.powerUp:check({
            paddle = self.paddle,
            balls = self.balls,
            hasKey = self.hasKey, })
    end
    --]]

    -- update positions based on velocity
    self.paddle:update(dt)
    for k, ball in pairs(self.balls) do
        ball:update(dt)
        self:checkBallPaddleCollision(ball, self.paddle)
    end

    local isBallCollided = false
    -- detect collision across all bricks with the ball
    for i, ball in pairs(self.balls) do
        -- only allow ball colliding with one brick, for corners
        for k, brick in pairs(self.bricks) do
            if not isBallCollided then
                if self:checkBallBrickCollision(ball, brick) then
                    isBallCollided = true
                end
            end
        end
    end

    -- If there has been a collision, inspect all of the bricks, and
    -- if all of them are gone, let the player pass to the bar to retrieve
    -- the victory brick
    if isBallCollided then
        local isBrickInPlay = false
        for k, brick in pairs(self.bricks) do
            if brick.inPlay and not brick.isBeerBrick then
                isBrickInPlay = true
            end
        end
        -- We have not found a brick that's in play, so allow the player
        -- to bounce through the bar to the top of the screen
        if not isBrickInPlay then
            for i, ball in pairs(self.balls) do
                ball.curMinY = 0
            end
        end
    end


    -- If any of the balls goes below bounds, remove it from the table of
    -- balls
    for k = #self.balls, 1, -1 do
        ball = self.balls[k]
        if ball.y >= VIRTUAL_HEIGHT then
            table.remove(self.balls, k)
        end
    end

    -- if ball goes below bounds, revert to serve state and decrease health
    if #self.balls == 0 then
        self.health = self.health - 1
        gBGSounds['hurt']:play()
        -- shrink the paddle when a heart is lost
        self.paddle:shrink()

        if self.health == 0 then
            -- Pop the current Play State and push a Game Over State
            gStateStack:pop()
            gStateStack:push(BarGGameOverState({
                background = self.background,
                score = self.score,
                levelsCleared = self.level - 1,
                -- highScores = self.highScores
            }))
        else
            -- Pop the current Play state and push a serve state using
            -- one of the remaining balls
            gStateStack:pop()
            gStateStack:push(BarGServeState({
                background = self.background,
                paddle = self.paddle,
                bricks = self.bricks,
                health = self.health,
                score = self.score,
                -- highScores = self.highScores,
                level = self.level,
                -- recoverPoints = self.recoverPoints
            }))
        end
    end

    -- for rendering particle systems
    for k, brick in pairs(self.bricks) do
        brick:update(dt)
    end

end

--[[ Helper function that will check if a given
     ball has collided with the paddle, and if it has, update the ball's
     positions and velocities

     Returns true if the ball has collided with a brick, false if no
]]
function BarGPlayState:checkBallPaddleCollision(ball, paddle)
    if ball:collides(paddle) then
        -- raise ball above paddle in case it goes below it, then reverse dy
        ball.y = paddle.y - ball.height
        ball.dy = -ball.dy

        --
        -- tweak angle of bounce based on where it hits the paddle
        --

        -- if we hit the paddle on its left side while moving left...
        if ball.x < paddle.x + (paddle.width / 2) and paddle.dx < 0 then
            ball.dx = -50 + -(8 * (paddle.x + paddle.width / 2 - ball.x))

        -- else if we hit the paddle on its right side while moving right...
        elseif ball.x > paddle.x + (paddle.width / 2) and paddle.dx > 0 then
            ball.dx = 50 + (8 * math.abs(paddle.x + paddle.width / 2 - ball.x))
        end

        gBGSounds['paddle-hit']:play()
    end
end

function BarGPlayState:checkBallBrickCollision(ball, brick)
    -- only check collision if we're in play
    if not brick.inPlay or not ball:collides(brick) then
        return false
    end

    self:updateBallAfterBrickCollision(ball, brick)

    if brick.isLocked and not self.hasKey.val then
        gBGSounds['hurt']:play()
        return false
    end

    -- add to score
    if brick.isLocked then
        brickScore = 50000
    else
        -- TODO some more dynamic scoring
        brickScore = 1000
    end
    self.score = self.score + brickScore
    -- update paddle grow threshold and check if threshold has been reached
    self.paddleGrowThreshold = self.paddleGrowThreshold - brickScore
    if self.paddleGrowThreshold < 0 then
        gBGSounds['powerup']:play()
        self.paddle:grow()
        self.paddleGrowThreshold = PADDLE_GROW_THRESHOLD
    end

    -- trigger the brick's hit function, which removes it from play
    brick:hit()

    -- if we have enough points, recover a point of health
    --[[
    if self.score > self.recoverPoints then
        -- can't go above 3 health
        self.health = math.min(3, self.health + 1)

        -- multiply recover points by 2
        self.recoverPoints = math.min(100000, self.recoverPoints * 2)

        -- play recover sound effect
        gBGSounds['recover']:play()
    end
    --]]

    -- go to our victory screen if there are no more bricks left
    if self:checkVictory() then
        gBGSounds['victory']:play()
        -- Design decision is to keep any changes in the paddle sizes
        -- local to each level, so always reset the paddle before
        -- going onto the next level
        self.paddle:reset()

        -- Pop off the play state and push a victory state with the appropriate
        -- info about the currenct level
        gStateStack:pop()
        gStateStack:push(BarGVictoryState({
            background = self.background,
            level = self.level,
            paddle = self.paddle,
            health = self.health,
            score = self.score,
            -- highScores = self.highScores,
            ball = ball,
            -- recoverPoints = self.recoverPoints
        }))
    end
    return true
end

function BarGPlayState:updateBallAfterBrickCollision(ball, brick)

    --
    -- collision code for bricks
    --
    -- we check to see if the opposite side of our velocity is outside of the brick;
    -- if it is, we trigger a collision on that side. else we're within the X + width of
    -- the brick and should check to see if the top or bottom edge is outside of the brick,
    -- colliding on the top or bottom accordingly
    --

    -- left edge; only check if we're moving right, and offset the check by a couple of pixels
    -- so that flush corner hits register as Y flips, not X flips
    if ball.x + 2 < brick.x and ball.dx > 0 then

        -- flip x velocity and reset position outside of brick
        ball.dx = -ball.dx
        ball.x = brick.x - 8

    -- right edge; only check if we're moving left, , and offset the check by a couple of pixels
    -- so that flush corner hits register as Y flips, not X flips
    elseif ball.x + 6 > brick.x + brick.width and ball.dx < 0 then

        -- flip x velocity and reset position outside of brick
        ball.dx = -ball.dx
        ball.x = brick.x + 32

    -- top edge if no X collisions, always check
    elseif ball.y < brick.y then

        -- flip y velocity and reset position outside of brick
        ball.dy = -ball.dy
        ball.y = brick.y - 8

    -- bottom edge if no X collisions or top collision, last possibility
    else

        -- flip y velocity and reset position outside of brick
        ball.dy = -ball.dy
        ball.y = brick.y + 16
    end
    -- slightly scale the y velocity to speed up the game, capping at +- 150
    if math.abs(ball.dy) < 150 then
        ball.dy = ball.dy * 1.02
    end
end

function BarGPlayState:render()
    self.background:render()

    -- render bricks
    for k, brick in pairs(self.bricks) do
        brick:render()
    end

    -- render all particle systems
    for k, brick in pairs(self.bricks) do
        brick:renderParticles()
    end

    self.paddle:render()
    for _, ball in pairs(self.balls) do
        ball:render()
    end

    renderScore(self.score)
    renderHealth(self.health)

    -- check if power up is active and if it should be rendered
    if self.powerUp and self.powerUp.isActive then
        self.powerUp:render()
    end

    -- pause text, if paused
    if self.paused then
        love.graphics.setFont(gFonts['large'])
        love.graphics.printf("PAUSED", 0, VIRTUAL_HEIGHT / 2 - 16, VIRTUAL_WIDTH, 'center')
    end
end

function BarGPlayState:checkVictory()
    for k, brick in pairs(self.bricks) do
        if brick.inPlay then
            return false
        end
    end

    return true
end
