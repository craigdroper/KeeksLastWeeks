
ClubGArrowTarget =  Class{}

function ClubGArrowTarget:init(x, y, dir)
    self.x = x
    self.y = y
    self.dir = dir
    self.rad = nil -- to be set at end of init
    self.img = gClubGImages['arrow-outline']
    self.width, self.height = self.img:getDimensions()
    -- Shift origin to center for consistent image rotation
    self.ox = self.width/2
    self.oy = self.height/2
    -- Account for offset when drawing
    self.offsetX = self.ox
    self.offsetY = self.oy

    self.grades = {[1] = 'perfect', [2] = 'great', [3] = 'good'}

    -- Particle system to be triggered when an arrow is hit on or
    -- close enough to the targe
    self.psystem = love.graphics.newParticleSystem(gBGTextures['particle'], 64)
    self.psystem:setParticleLifetime(0.9, 1.0)
    self.psystem:setLinearAcceleration(-15, 15, -15, 15)
    self.psystem:setAreaSpread('normal', 10, 10)
    -- Particle system for 3 levels of target, perfect will be gold,
    -- great will be green, good will be blue
    self.palette = {
        ['perfect'] = {r=225, g=223, b=0},
        ['great'] = {r=57, g=255, b=20},
        ['good'] = {r=70, g=102, b=255},
    }

    self.absDist = {
        ['perfect'] = 3,
        ['great'] = 6,
        ['good'] = 10,
    }
    self.maxHitDist = self.absDist['good']

    self.hitScores = {
        ['perfect'] = 4,
        ['great'] = 2,
        ['good'] = 1,
    }

    -- Set direction specific values
    if self.dir == 'left' then
        self.rad = 1.5708
    elseif self.dir == 'down' then
        self.rad = 0
    elseif self.dir == 'up' then
        self.rad = 3.14159
    elseif self.dir == 'right' then
        self.rad = 4.7123
    end
end

function ClubGArrowTarget:getX()
    return self.x + self.offsetX
end

function ClubGArrowTarget:getY()
    return self.y + self.offsetY
end

function ClubGArrowTarget:checkIsHit(arrow)
    if arrow == nil then
        return false
    end
    return math.abs(self:getY() - arrow:getY()) < self.maxHitDist
end

function ClubGArrowTarget:calcGrade(arrow)
    local dist = math.abs(self:getY() - arrow:getY())
    for _, gradeName in pairs(self.grades) do
        if dist < self.absDist[gradeName] then
            return gradeName
        end
    end
    error('We shoud not hit this if calcGrade is only called after checkIsHit')
end

function ClubGArrowTarget:calcScore(arrow)
    return self.hitScores[self:calcGrade(arrow)]
end

function ClubGArrowTarget:hit(arrow)
    local grade = self:calcGrade(arrow)
    rgbDict = self.palette[grade]
    self.psystem:setColors(
        rgbDict.r, rgbDict.g, rgbDict.b, 128,
        rgbDict.r, rgbDict.g, rgbDict.b, 32)
    self.psystem:emit(32)
    gClubSounds['hit']:play()
end

function ClubGArrowTarget:update(dt)
    self.psystem:update(dt)
end

function ClubGArrowTarget:renderImage()
    love.graphics.filterDrawD(self.img,
        self:getX(), self:getY(),
        self.rad, self.sx, self.sy, self.ox, self.oy)
end

function ClubGArrowTarget:renderParticles()
    love.graphics.filterDrawD(self.psystem,
        self:getX() + self.width/2,
        self:getY() + self.height/2)
end
