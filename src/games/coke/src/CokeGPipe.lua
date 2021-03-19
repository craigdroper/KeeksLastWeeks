--[[
    Pipe Class
    Author: Colton Ogden
    cogden@cs50.harvard.edu

    The Pipe class represents the pipes that randomly spawn in our game, which act as our primary obstacles.
    The pipes can stick out a random distance from the top or bottom of the screen. When the player collides
    with one of them, it's game over. Rather than our bird actually moving through the screen horizontally,
    the pipes themselves scroll through the game to give the illusion of player movement.
]]

CokeGPipe = Class{}

function CokeGPipe:init(orientation, y)
    self.x = VIRTUAL_WIDTH + 64
    self.y = y

    self.width = COKEG_PIPE_WIDTH
    self.height = COKEG_PIPE_HEIGHT

    self.orientation = orientation
end

function CokeGPipe:update(dt)

end

function CokeGPipe:render()
    love.graphics.filterDrawD(gCokeGImages['cop'], self.x,

        -- shift pipe rendering down by its height if flipped vertically
        (self.orientation == 'top' and self.y + COKEG_PIPE_HEIGHT or self.y),

        -- scaling by -1 on a given axis flips (mirrors) the image on that axis
        0, 1, self.orientation == 'top' and -1 or 1)
end
