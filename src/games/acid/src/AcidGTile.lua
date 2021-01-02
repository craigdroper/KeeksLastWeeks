--[[
    GD50
    Match-3 Remake

    -- AcidGTile Class --

    Author: Colton Ogden
    cogden@cs50.harvard.edu

    The individual tiles that make up our game board. Each AcidGTile can have a
    color and a variety, with the varietes adding extra points to the matches.
]]

AcidGTile = Class{}

function AcidGTile:init(x, y, color, variety, isShiny)

    -- board positions
    self.gridX = x
    self.gridY = y

    -- coordinate positions
    self.x = (self.gridX - 1) * 32
    self.y = (self.gridY - 1) * 32

    -- tile appearance/points
    self.color = color
    self.variety = variety
    self.opacity = 255
    self.isShiny = isShiny
    if self.isShiny then
        self.psys = love.graphics.newParticleSystem(gAcidGTextures['particle'], 10)
        self.psys:setParticleLifetime(0.5, 1)
        self.psys:setEmissionRate(10)
        self.psys:setLinearAcceleration(-8, 8, -8, 8)
        self.psys:setAreaSpread('normal', 8, 8)
        self.psys:setColors(255, 255, 255, 200, 255, 255, 255, 0)
    end
end

function AcidGTile:update(dt)
    if not self.isShiny then
        return
    end
    self.psys:emit(1)
    self.psys:update(dt)
end

function AcidGTile:render(x, y)

    -- draw shadow
    love.graphics.setColor(34, 32, 52, 255)
    love.graphics.draw(gAcidGTextures['main'], gAcidGFrames['tiles'][self.color][self.variety],
        self.x + x + 2, self.y + y + 2)

    -- draw tile itself
    love.graphics.setColor(255, 255, 255, self.opacity)
    love.graphics.draw(gAcidGTextures['main'], gAcidGFrames['tiles'][self.color][self.variety],
        self.x + x, self.y + y)

    if self.isShiny then
        love.graphics.draw(self.psys, self.x + x + 16, self.y + y + 16)
    end
end
