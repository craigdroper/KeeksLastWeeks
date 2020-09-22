--[[
    GD50
    Breakout Remake

    -- BarGPaddle Class --

    Author: Colton Ogden
    cogden@cs50.harvard.edu

    Represents a paddle that can move left and right. Used in the main
    program to deflect the ball toward the bricks; if the ball passes
    the paddle, the player loses one heart. The BarGPaddle can have a skin,
    which the player gets to choose upon starting the game.
]]

BarGPaddle = Class{}

--[[
    Our BarGPaddle will initialize at the same spot every time, in the middle
    of the world horizontally, toward the bottom.
]]
function BarGPaddle:init(skin)
    -- starting dimensions
    --[[
    self.sizeWidths = {32, 64, 96, 128}
    ]]
    -- Only have 1 width for now
    self.width = gFramesInfo['bar'][gBAR_VERTICAL_BENCH]['width']
    self.height = gFramesInfo['bar'][gBAR_VERTICAL_BENCH]['height']
    self:reset()
end

function BarGPaddle:changeSize(deltaSize)
    local prevSize = self.size
    local prevWidth = self.width
    self.size = math.max(1, math.min(self.size + deltaSize, 4))
    self.width = self.sizeWidths[self.size]
    -- readjust the current x value to account for the change
    local deltaWidth = prevWidth - self.width
    local deltaX = deltaWidth/2
    self.x = math.max(0, math.min(self.x + deltaX, VIRTUAL_WIDTH - self.width))
end

function BarGPaddle:grow()
    -- self:changeSize(1)
end

function BarGPaddle:shrink()
    -- self:changeSize(-1)
end

function BarGPaddle:reset(skin)
    -- x is placed in the middle
    self.x = (VIRTUAL_WIDTH - self.width) / 2

    -- y is placed a little above the bottom edge of the screen
    local BOTTOM_BENCH_PAD = 2
    self.y = VIRTUAL_HEIGHT - self.height - BOTTOM_BENCH_PAD

    -- start us off with no velocity
    self.dx = 0

    --[[
    -- the variant is which of the four paddle sizes we currently are; 2
    -- is the starting size, as the smallest is too tough to start with
    self.size = 2

    self.width = self.sizeWidths[self.size]
    -- height will always be the same for all paddles
    self.height = 16

    -- the skin only has the effect of changing our color, used to offset us
    -- into the gBGPaddleSkins table later
    self.skin = skin and skin or 2
    --]]
end

function BarGPaddle:update(dt)
    -- keyboard input
    if love.keyboard.isDown('left') then
        self.dx = -BG_PADDLE_SPEED
    elseif love.keyboard.isDown('right') then
        self.dx = BG_PADDLE_SPEED
    else
        self.dx = 0
    end

    -- math.max here ensures that we're the greater of 0 or the player's
    -- current calculated Y position when pressing up so that we don't
    -- go into the negatives; the movement calculation is simply our
    -- previously-defined paddle speed scaled by dt
    if self.dx < 0 then
        self.x = math.max(0, self.x + self.dx * dt)
    -- similar to before, this time we use math.min to ensure we don't
    -- go any farther than the bottom of the screen minus the paddle's
    -- height (or else it will go partially below, since position is
    -- based on its top left corner)
    else
        self.x = math.min(VIRTUAL_WIDTH - self.width, self.x + self.dx * dt)
    end
end

--[[
    Render the paddle by drawing the main texture, passing in the quad
    that corresponds to the proper skin and size.
]]
function BarGPaddle:render()
    love.graphics.filterDrawQ(gTextures['bar'], gFrames['bar'][gBAR_VERTICAL_BENCH],
        self.x, self.y)
end
