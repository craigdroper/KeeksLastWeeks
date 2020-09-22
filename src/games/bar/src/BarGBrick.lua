--[[
    GD50
    Breakout Remake

    -- BarGBrick Class --

    Author: Colton Ogden
    cogden@cs50.harvard.edu

    Represents a brick in the world space that the ball can collide with;
    differently colored bricks have different point values. On collision,
    the ball will bounce away depending on the angle of collision. When all
    bricks are cleared in the current map, the player should be taken to a new
    layout of bricks.
]]

BarGBrick = Class{}

-- some of the colors in our palette (to be used with particle systems)
paletteColors = {
    -- blue
    [1] = {
        ['r'] = 99,
        ['g'] = 155,
        ['b'] = 255
    },
    -- green
    [2] = {
        ['r'] = 106,
        ['g'] = 190,
        ['b'] = 47
    },
    -- red
    [3] = {
        ['r'] = 217,
        ['g'] = 87,
        ['b'] = 99
    },
    -- purple
    [4] = {
        ['r'] = 215,
        ['g'] = 123,
        ['b'] = 186
    },
    -- gold
    [5] = {
        ['r'] = 251,
        ['g'] = 242,
        ['b'] = 54
    },
    -- black (for locked brick)
    [6] = {
        ['r'] = 0,
        ['g'] = 0,
        ['b'] = 0
    },
}

function BarGBrick:init(x, y, isLocked)
    -- used for coloring and score calculation
    self.tier = 0
    self.color = 1
    
    self.x = x
    self.y = y
    self.width = 32
    self.height = 16
    
    -- used to determine whether this brick should be rendered
    self.inPlay = true

    -- used to determine if this brick is a locked brick
    -- a 'locked' state trumps all other states, and requires specific
    -- logic and a hardcoded locked brick graphic
    self.isLocked = isLocked

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
function BarGBrick:hit()
    -- set the particle system to interpolate between two colors; in this case, we give
    -- it our self.color but with varying alpha; brighter for higher tiers, fading to 0
    -- over the particle's lifetime (the second color)
    self.psystem:setColors(
        paletteColors[self.color].r,
        paletteColors[self.color].g,
        paletteColors[self.color].b,
        55 * (self.tier + 1),
        paletteColors[self.color].r,
        paletteColors[self.color].g,
        paletteColors[self.color].b,
        0
    )
    self.psystem:emit(64)

    -- sound on hit
    gBGSounds['brick-hit-2']:stop()
    gBGSounds['brick-hit-2']:play()

    -- if this is a locked brick which has been hit, assume
    -- the play state has already checked that the player has obtained
    -- the key powerup, and immediately remove the brick from play, as
    -- it will only require one hit to break a locked bric
    if self.isLocked then
        self.inPlay = false
    -- if we're at a higher tier than the base, we need to go down a tier
    -- if we're already at the lowest color, else just go down a color
    elseif self.tier > 0 then
        if self.color == 1 then
            self.tier = self.tier - 1
            self.color = 5
        else
            self.color = self.color - 1
        end
    else
        -- if we're in the first tier and the base color, remove brick from play
        if self.color == 1 then
            self.inPlay = false
        else
            self.color = self.color - 1
        end
    end

    -- play a second layer sound if the brick is destroyed
    if not self.inPlay then
        gBGSounds['brick-hit-1']:stop()
        gBGSounds['brick-hit-1']:play()
    end
end

function BarGBrick:update(dt)
    self.psystem:update(dt)
end

function BarGBrick:render()
    if self.inPlay then
        -- check if brick is a lock brick, and if it is, render the lock brick
        -- graphic, do not consider color or tier when rendering the lock brick
        if self.isLocked then
            love.graphics.draw(gBGTextures['main'], 
                gBGFrames['lock_brick'][1],
                self.x, self.y)
        else
            love.graphics.draw(gBGTextures['main'], 
                -- multiply color by 4 (-1) to get our color offset, then add tier to that
                -- to draw the correct tier and color brick onto the screen
                gBGFrames['bricks'][1 + ((self.color - 1) * 4) + self.tier],
                self.x, self.y)
        end
    end
end

--[[
    Need a separate render function for our particles so it can be called after all bricks are drawn;
    otherwise, some bricks would render over other bricks' particle systems.
]]
function BarGBrick:renderParticles()
    love.graphics.draw(self.psystem, self.x + 16, self.y + 8)
end
