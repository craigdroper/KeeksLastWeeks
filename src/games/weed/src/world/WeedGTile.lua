--[[
    GD50
    Pokemon

    Author: Colton Ogden
    cogden@cs50.harvard.edu
]]

WeedGTile = Class{}

function WeedGTile:init(x, y, id)
    self.x = x
    self.y = y
    self.id = id
end

function WeedGTile:update(dt)

end

function WeedGTile:render()
    love.graphics.draw(gWeedGTextures['tiles'], gWeedGFrames['tiles'][self.id],
        (self.x - 1) * WEEDG_TILE_SIZE, (self.y - 1) * WEEDG_TILE_SIZE)
end
