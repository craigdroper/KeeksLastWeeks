--[[
    GD50
    Breakout Remake

    -- BarGBeerBrick Class --

    Author: Colton Ogden
    cogden@cs50.harvard.edu

    Represents a brick in the world space that the ball can collide with;
    differently colored bricks have different point values. On collision,
    the ball will bounce away depending on the angle of collision. When all
    bricks are cleared in the current map, the player should be taken to a new
    layout of bricks.
]]

BarGBeerBrick = Class{}

-- some of the colors in our palette (to be used with particle systems)
paletteColors = {
    -- gold
    [5] = {
        ['r'] = 251,
        ['g'] = 242,
        ['b'] = 54
    },
}

function BarGBeerBrick:init(x, y)
    self.x = x
    self.y = y
    self.width, self.height = gBGTextures['beer']:getDimensions()
    --[[
    self.sx = 0.05
    self.sy = 0.05
    self.offsetX = 255
    self.offsetY = 0
    self.adjWidth = self.width * self.sx
    self.adjHeight = self.height * self.sy
    self.adjOffsetX = self.offsetX * self.sx
    self.adjOffsetY = self.offsetY * self.sy
    --]]

    -- used to determine whether this brick should be rendered
    self.inPlay = true

    -- used to determine if this brick is a locked brick
    -- a 'locked' state trumps all other states, and requires specific
    -- logic and a hardcoded locked brick graphic
    -- self.isLocked = isLocked
    self.isBeerBrick = true

    -- particle system belonging to the brick, emitted on hit
    self.psystem = love.graphics.newParticleSystem(gBGTextures['particle'], 64)

    -- various behavior-determining functions for the particle system
    -- https://love2d.org/wiki/ParticleSystem

    -- lasts between 0.5-1 seconds seconds
    self.psystem:setParticleLifetime(0.5, 1)

    -- give it an acceleration of anywhere between X1,Y1 and X2,Y2 (0, 0) and (80, 80) here
    -- gives generally downward
    self.psystem:setLinearAcceleration(-15, 0, 15, 80)

    -- spread of particles; normal looks more natural than uniform
    self.psystem:setAreaSpread('normal', 10, 10)
end

--[[
    Triggers a hit on the brick, taking it out of play if at 0 health or
    changing its color otherwise.
]]
function BarGBeerBrick:hit()
    -- set the particle system to interpolate between two colors; in this case, we give
    -- it our self.color but with varying alpha; brighter for higher tiers, fading to 0
    -- over the particle's lifetime (the second color)
    -- Note: For now we're just hardcoding the pallete color to be gold for
    -- simplicity
    local GOLD_COLOR_CODE = 5
    self.psystem:setColors(
        paletteColors[GOLD_COLOR_CODE].r,
        paletteColors[GOLD_COLOR_CODE].g,
        paletteColors[GOLD_COLOR_CODE].b,
        55, -- * (self.tier + 1),
        paletteColors[GOLD_COLOR_CODE].r,
        paletteColors[GOLD_COLOR_CODE].g,
        paletteColors[GOLD_COLOR_CODE].b,
        0
    )
    self.psystem:emit(64)

    -- sound on hit
    gBGSounds['brick-hit-2']:stop()
    gBGSounds['brick-hit-2']:play()

    self.inPlay = false

    -- play a second layer sound if the brick is destroyed
    if not self.inPlay then
        gBGSounds['brick-hit-1']:stop()
        gBGSounds['brick-hit-1']:play()
    end
end

function BarGBeerBrick:update(dt)
    self.psystem:update(dt)
end

function BarGBeerBrick:render()
    if self.inPlay then
        love.graphics.draw(
            gBGTextures['beer'],
            self.x,
            self.y)
    end
end

--[[
    Need a separate render function for our particles so it can be called after all bricks are drawn;
    otherwise, some bricks would render over other bricks' particle systems.
]]
function BarGBeerBrick:renderParticles()
    love.graphics.draw(self.psystem, self.x, self.y)
end
