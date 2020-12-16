--[[
    GD50 2018
    Pong Remake

    -- WorkGBall Class --

    Author: Colton Ogden
    cogden@cs50.harvard.edu

    Represents a ball which will bounce back and forth between paddles
    and walls until it passes a left or right boundary of the screen,
    scoring a point for the opponent.
]]

WorkGBall = Class{}

function WorkGBall:init(x, y)
    self.x = x
    self.y = y
    self.image = gWorkImages['report']
    local width, height = self.image:getDimensions()
    self.width = 20
    self.height = 20
    self.sx = self.width / width
    self.sy = self.height / height

    -- these variables are for keeping track of our velocity on both the
    -- X and Y axis, since the ball can move in two dimensions
    self.dy = 0
    self.dx = 0
end

--[[
    Expects a paddle as an argument and returns true or false, depending
    on whether their rectangles overlap.
]]
function WorkGBall:collides(paddle)
    -- first, check to see if the left edge of either is farther to the right
    -- than the right edge of the other
    if self.x > paddle.x + paddle.width or paddle.x > self.x + self.width then
        return false
    end

    -- then check to see if the bottom edge of either is higher than the top
    -- edge of the other
    if self.y > paddle.y + paddle.height or paddle.y > self.y + self.height then
        return false
    end

    -- if the above aren't true, they're overlapping
    return true
end

--[[
    Places the ball in the middle of the screen, with no movement.
]]
function WorkGBall:reset()
    self.x = VIRTUAL_WIDTH / 2 - 2
    self.y = VIRTUAL_HEIGHT / 2 - 2
    self.dx = 0
    self.dy = 0
end

function WorkGBall:update(dt)
    self.x = self.x + self.dx * dt
    self.y = self.y + self.dy * dt
end

function WorkGBall:render()
    love.graphics.filterDrawD(self.image, self.x, self.y, 0,
        self.sx, self.sy)
end
