--[[
    GD50 2018
    Pong Remake

    -- WorkGPaddle Class --

    Author: Colton Ogden
    cogden@cs50.harvard.edu

    Represents a paddle that can move up and down. Used in the main
    program to deflect the ball back toward the opponent.
]]

WorkGPaddle = Class{}

--[[
    The `init` function on our class is called just once, when the object
    is first created. Used to set up all variables in the class and get it
    ready for use.

    Our WorkGPaddle should take an X and a Y, for positioning, as well as a width
    and height for its dimensions.

    Note that `self` is a reference to *this* object, whichever object is
    instantiated at the time this function is called. Different objects can
    have their own x, y, width, and height values, thus serving as containers
    for data. In this sense, they're very similar to structs in C.
]]
function WorkGPaddle:init(x, y, textName, frameName, charFrame)
    self.x = x
    self.y = y
    self.textName = textName
    self.frameName = frameName
    self.charFrame = charFrame
    self.width = gFramesInfo[self.frameName][self.charFrame]['width']
    self.height = gFramesInfo[self.frameName][self.charFrame]['height']
    self.score = 9
    self.renderScore = false
    if charFrame == gKEEKS_IDLE_RIGHT then
        self.scoreX = VIRTUAL_WIDTH / 2 - 50
    else
        self.scoreX = VIRTUAL_WIDTH / 2 + 30
    end
    self.scoreY = VIRTUAL_HEIGHT / 3 
end

function WorkGPaddle:update(dt)
    -- math.max here ensures that we're the greater of 0 or the player's
    -- current calculated Y position when pressing up so that we don't
    -- go into the negatives; the movement calculation is simply our
    -- previously-defined paddle speed scaled by dt
    if self.dy < 0 then
        self.y = math.max(0, self.y + self.dy * dt)
    -- similar to before, this time we use math.min to ensure we don't
    -- go any farther than the bottom of the screen minus the paddle's
    -- height (or else it will go partially below, since position is
    -- based on its top left corner)
    else
        self.y = math.min(VIRTUAL_HEIGHT - self.height, self.y + self.dy * dt)
    end
end

--[[
    To be called by our main function in `love.draw`, ideally. Uses
    LÖVE2D's `rectangle` function, which takes in a draw mode as the first
    argument as well as the position and dimensions for the rectangle. To
    change the color, one must call `love.graphics.setColor`. As of the
    newest version of LÖVE2D, you can even draw rounded rectangles!
]]
function WorkGPaddle:render()
    love.graphics.filterDrawQ(
        gTextures[self.textName],
        gFrames[self.frameName][self.charFrame],
        self.x, self.y)
    if self.renderScore then
        love.graphics.print(tostring(self.score), self.scoreX, self.scoreY)
    end
end
