--[[
    GD50
    Breakout Remake

    -- BarGBall Class --

    Author: Colton Ogden
    cogden@cs50.harvard.edu

    Represents a ball which will bounce back and forth between the sides
    of the world space, the player's paddle, and the bricks laid out above
    the paddle. The ball can have a skin, which is chosen at random, just
    for visual variety.
]]

BarGBall = Class{}

function BarGBall:init(skin)
    -- The graphic for the keeks "ball" is 77 x 77, has a width of 36
    -- and a height of 58, and also has a y offset of 18 and x offset of 20
    -- due to empty space in the sprite sheet
    -- simple positional and dimensional variables
    self.width = 36
    self.height = 58

    -- these variables are for keeping track of our velocity on both the
    -- X and Y axis, since the ball can move in two dimensions
    self.dy = 0
    self.dx = 0

    -- During different phases of the game, we may want to limit the minimum
    -- Y coordinate that the player can reach
    self.curMinY = 0
end

--[[
    Expects an argument with a bounding box, be that a paddle or a brick,
    and returns true if the bounding boxes of this and the argument overlap.
]]
function BarGBall:collides(target)
    -- first, check to see if the left edge of either is farther to the right
    -- than the right edge of the other
    if self.x > target.x + target.width or target.x > self.x + self.width then
        return false
    end

    -- then check to see if the bottom edge of either is higher than the top
    -- edge of the other
    if self.y > target.y + target.height or target.y > self.y + self.height then
        return false
    end

    -- if the above aren't true, they're overlapping
    return true
end

--[[
    Places the ball in the middle of the screen, with no movement.
]]
function BarGBall:reset()
    self.x = VIRTUAL_WIDTH / 2 - 2
    self.y = VIRTUAL_HEIGHT / 2 - 2
    self.dx = 0
    self.dy = 0
end

function BarGBall:update(dt)
    self.x = self.x + self.dx * dt
    self.y = self.y + self.dy * dt

    -- allow ball to bounce off walls
    if self.x <= 0 then
        self.x = 0
        self.dx = -self.dx
        gBGSounds['wall-hit']:play()
    end

    if self.x >= VIRTUAL_WIDTH - self.width then
        self.x = VIRTUAL_WIDTH - self.width
        self.dx = -self.dx
        gBGSounds['wall-hit']:play()
    end

    if self.y <= self.curMinY then
        self.y = self.curMinY
        self.dy = -self.dy
        gBGSounds['wall-hit']:play()
    end
end

function BarGBall:render()
    -- gTexture is our global texture for all blocks
    -- gBGBallFrames is a table of quads mapping to each individual ball skin in the texture
    if self.dy > 0 then
        love.graphics.draw(
            gTextures['keeks-walk'],
            gFrames['keeks-frames'][gKEEKS_IDLE_DOWN],
            self.x, self.y)
    else
        love.graphics.draw(
            gTextures['keeks-walk'],
            gFrames['keeks-frames'][gKEEKS_IDLE_UP],
            self.x, self.y)
    end
end
