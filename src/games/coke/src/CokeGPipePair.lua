--[[
    CokeGPipePair Class

    Author: Colton Ogden
    cogden@cs50.harvard.edu

    Used to represent a pair of pipes that stick together as they scroll, providing an opening
    for the player to jump through in order to score a point.
]]

CokeGPipePair = Class{}

-- size of the gap between pipes
local GAP_HEIGHT = 90

function CokeGPipePair:init(y, gap)
    -- flag to hold whether this pair has been scored (jumped through)
    self.scored = false

    -- initialize pipes past the end of the screen
    self.x = VIRTUAL_WIDTH + 32

    -- y value is for the topmost pipe; gap is a vertical shift of the second lower pipe
    self.y = y
    -- gap value is the gap in pixels between the top edge of the bottom pipe and
    -- the bottom edge of the top pipe
    self.gap = gap

    -- instantiate two pipes that belong to this pair
    self.pipes = {
        ['upper'] = CokeGPipe('top', self.y),
        ['lower'] = CokeGPipe('bottom', self.y + COKEG_PIPE_HEIGHT + self.gap)
    }

    -- whether this pipe pair is ready to be removed from the scene
    self.remove = false
end

function CokeGPipePair:update(dt)
    -- remove the pipe from the scene if it's beyond the left edge of the screen,
    -- else move it from right to left
    if self.x > -COKEG_PIPE_WIDTH then
        self.x = self.x - COKEG_PIPE_SPEED * dt
        self.pipes['lower'].x = self.x
        self.pipes['upper'].x = self.x
    else
        self.remove = true
    end
end

function CokeGPipePair:render()
    for l, pipe in pairs(self.pipes) do
        pipe:render()
    end
end
