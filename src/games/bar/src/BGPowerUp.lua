--[[
    GD50
    Breakout Remake

    -- BGPowerUp Class --

    Author: Craig Roper

    Represents a powerup which will drop from the top of the screen,
    and if successfully collected by the Player's padde, will provide
    the player with a power up
]]

BGPowerUp = Class{}

function BGPowerUp:init()
    -- Only specialized BGPowerUp objects should ever be instantiated
    self.powerUpIdx = nil
    self:initPowerUp()
end

function BGPowerUp:initPowerUp()
    self.width = 16
    self.height = 16

    -- Initialize the coordinates of the power up image as just off the screen,
    -- and at a random x coordinate bounded by the sides of the game
    -- Also initialize the velocities so it will descend gradually, but
    -- not move from side to side
    self.x = math.random(0, VIRTUAL_WIDTH - self.width)
    self.y = -self.height
    self.dy = 100
    self.isActive = true
end

function BGPowerUp:update(dt)
    self.y = self.y + self.dy * dt
    -- check if the power up has scrolled completely off screen, and
    -- deactivate it if it has
    if self.y > VIRTUAL_HEIGHT then
        self.isActive = false
    end
end

--[[
    This function will perform two tasks at once:
    1) It will check if the power up image has collided with the paddle
    2) If it has, then BGPowerUp will update the play state game's parameters
    appropriately, and will deactivate itself

    Assumption: BGPowerUps will only be available during play state

    This function requires all of the play state params to allow for
    the BGPowerUp class to implement exactly the changes it needs to the play state
    according to what type of power up was collected by the player
]]

function BGPowerUp:check(playStateParams)
    if not self.isActive then
        return
    end

    local paddle = playStateParams.paddle
    if self.x + self.width < paddle.x or
       self.x > paddle.x + paddle.width or
       self.y > paddle.y + paddle.height or
       self.y + self.height < paddle.y then
       return
    end
    gBGSounds['powerup']:play()
    self:fire(playStateParams)
    -- Deactivate this BGPowerUp
    self.isActive = false
end

function BGPowerUp:render()
    if self.isActive then
        love.graphics.draw(gBGTextures['main'],
                           gBGFrames['powerups'][self.powerUpIdx],
                           self.x,
                           self.y)
    end
end

BGExtraBallsPowerUp = Class{__includes = BGPowerUp}

function BGExtraBallsPowerUp:init()
    -- Index for extra ball power up sprite
    local EXTRA_BALLS_IDX = 9
    self.powerUpIdx = EXTRA_BALLS_IDX
    self:initPowerUp()
end

function BGExtraBallsPowerUp:fire(playStateParams)
    -- Add two new balls to the PlayState's table of balls
    local paddle = playStateParams.paddle
    for i = 1, 2 do
        local newBall = Ball()
        newBall.skin = math.random(7)
        newBall.x = paddle.x + paddle.width/2 - newBall.width/2
        newBall.dx = math.random(-200, 200)
        newBall.y = paddle.y - newBall.height
        newBall.dy = math.random(-50, -60)
        table.insert(playStateParams.balls, newBall)
    end
end

BGKeyPowerUp = Class{__includes = BGPowerUp}

function BGKeyPowerUp:init()
    -- Index for extra ball power up sprite
    local KEY_IDX = 10
    self.powerUpIdx = KEY_IDX
    self:initPowerUp()
end

function BGKeyPowerUp:fire(playStateParams)
    -- Set hasKey parameters to true as the key powerup has been collected
    playStateParams.hasKey.val = true
end
