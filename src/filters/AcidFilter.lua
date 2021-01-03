
AcidFilter = Class{}

function AcidFilter:init(params)
    self.multiplier = params.multiplier
    self.drawPeriod = 5
    -- This is 100x larger than the offset we need, so we will divide by
    -- 100 before applying, just to account for small decimal values
    self.radFactor = 5 * self.multiplier
    -- Also 100x
    self.scaleFactor = 5 * self.multiplier
    self.curRadOffset = 0
    self.curSXOffset = 1
    self.curSYOffset = 1
    self.curYOffset = 0
    self.curXOffset = 0
    self.maxOffset = -50
    self:tweenDrawDistortion()

    self.bkgrd = gAcidFImage['background']
    self.bkPeriod = 15
    local imgw, imgh = self.bkgrd:getDimensions()
    self.bx = VIRTUAL_WIDTH/2
    self.by = VIRTUAL_HEIGHT/2
    self.brad = 0
    self.bminSx = 4*VIRTUAL_WIDTH / imgw
    self.bsx = self.bminSx
    self.bminSy = 4*VIRTUAL_HEIGHT / imgh
    self.bsy = self.bminSx
    self.box = imgw / 2
    self.boy = imgh / 2
    self.bopac = 64
    self:tweenBackground()

    self.monsters = {
        [1] = {img=gAcidFImage['c1'], x=0, y=0, rad=0, sx=1, sy=1, ox=0, oy=0, opac=0},  
        [2] = {img=gAcidFImage['c2'], x=0, y=0, rad=0, sx=1, sy=1, ox=0, oy=0, opac=0},  
        [3] = {img=gAcidFImage['c3'], x=0, y=0, rad=0, sx=1, sy=1, ox=0, oy=0, opac=0},  
        [4] = {img=gAcidFImage['c4'], x=0, y=0, rad=0, sx=1, sy=1, ox=0, oy=0, opac=0},  
        [5] = {img=gAcidFImage['c5'], x=0, y=0, rad=0, sx=1, sy=1, ox=0, oy=0, opac=0},  
        [6] = {img=gAcidFImage['c6'], x=0, y=0, rad=0, sx=1, sy=1, ox=0, oy=0, opac=0},  
        [7] = {img=gAcidFImage['c7'], x=0, y=0, rad=0, sx=1, sy=1, ox=0, oy=0, opac=0},  
        [8] = {img=gAcidFImage['c8'], x=0, y=0, rad=0, sx=1, sy=1, ox=0, oy=0, opac=0},  
        [9] = {img=gAcidFImage['c9'], x=0, y=0, rad=0, sx=1, sy=1, ox=0, oy=0, opac=0},  
        [10] = {img=gAcidFImage['c10'], x=0, y=0, rad=0, sx=1, sy=1, ox=0, oy=0, opac=0},  
    }
    self.monsterFreq = #self.monsters / self.multiplier
    self.monsterPeriod = 10
    self.monsterFade = 1
    -- TODO Dev
    -- self.monsterFreq = 1
    self:tweenMonster()
end

function AcidFilter:tweenMonster()
    -- Imply if a monster is currently being drawn by its opacity value
    local curIdx = math.random(#self.monsters)
    local tryCount = 0
    while( self.monsters[curIdx].opac ~= 0 and tryCount < 50) do
        curIdx = math.random(#self.monsters)
        tryCount = tryCount + 1
    end
    if self.monsters[curIdx].opac == 0 then
        local animation = math.random(5)
        if animation == 5 then
            self:tweenSpiralMonster(curIdx)
        else
            self:tweenPanMonster(curIdx, animation)
        end
    end
    Timer.after(self.monsterFreq, function() self:tweenMonster() end)
end

function AcidFilter:tweenPanMonster(mIdx, mDir)
    local mins = 200
    local maxs = 400
    local m = self.monsters[mIdx]
    m.rad = 0
    local imgw, imgh = m.img:getDimensions()
    m.sx = math.random(mins,maxs) / imgw
    m.sy = math.random(mins,maxs) / imgh
    m.ox = imgw/2
    m.oy = imgh/2
    m.opac = 64
    local destx = 0
    local desty = 0
    if mDir == 1 then
        -- top to bottom
        m.x = math.random(VIRTUAL_WIDTH)
        destx = math.random(VIRTUAL_WIDTH)
        m.y = -imgh
        desty = VIRTUAL_HEIGHT + imgh
    elseif mDir == 2 then
        -- left to right
        m.x = -imgw
        destx = VIRTUAL_WIDTH + imgw
        m.y = math.random(VIRTUAL_HEIGHT)
        desty = math.random(VIRTUAL_HEIGHT)
    elseif mDir == 3 then
        -- bottom to top
        m.x = math.random(VIRTUAL_WIDTH)
        destx = math.random(VIRTUAL_WIDTH)
        m.y = VIRTUAL_HEIGHT + imgh
        desty = -imgh
    elseif mDir == 4 then
        -- right to left
        m.x = VIRTUAL_WIDTH + imgw
        destx = -imgw
        m.y = math.random(VIRTUAL_HEIGHT)
        desty = math.random(VIRTUAL_HEIGHT)
    end
    Timer.tween(self.monsterPeriod, {[m] = {
        x = destx, y = desty, rad = math.random(-300,300)/100. *6.24,
        sx = math.random(mins,maxs) / imgw,
        sy = math.random(mins,maxs) / imgh,
    }})
    Timer.tween(self.monsterPeriod - self.monsterFade, {[m] = {
        opac = math.random(12*self.multiplier, 24*self.multiplier),
    }}):finish(function()
    Timer.tween(self.monsterFade, {[m] = {
        opac = 0
    }})
    end)
end

function AcidFilter:tweenSpiralMonster(mIdx)
    self.monsters[mIdx].x = VIRTUAL_WIDTH/2
    self.monsters[mIdx].y = VIRTUAL_HEIGHT/2
    self.monsters[mIdx].rad = 0
    local imgw, imgh = self.monsters[mIdx].img:getDimensions()
    self.monsters[mIdx].sx = 10. / imgw
    self.monsters[mIdx].sy = 10. / imgh
    self.monsters[mIdx].ox = imgw/2
    self.monsters[mIdx].oy = imgh/2
    self.monsters[mIdx].opac = 64
    Timer.tween(self.monsterPeriod, {[self.monsters[mIdx]] = {
        x = VIRTUAL_WIDTH/2 + math.random(-VIRTUAL_WIDTH,VIRTUAL_WIDTH), 
        y = VIRTUAL_HEIGHT/2 + math.random(-VIRTUAL_HEIGHT,VIRTUAL_HEIGHT), 
        rad = 6.24 * math.random(-300,300)/100.,
        sx = math.random(400,800) / imgw,
        sy = math.random(400,800) / imgh,
    }})
    Timer.tween(self.monsterPeriod - self.monsterFade, {[self.monsters[mIdx]] = {
        opac = math.random(20*self.multiplier, 24*self.multiplier)
    }}):finish(function()
        Timer.tween(self.monsterFade, {[self.monsters[mIdx]] = {
            opac = 0
        }})
    end)
end

function AcidFilter:tweenBackground()
    Timer.tween( self.bkPeriod, {[self] = {
        bx = VIRTUAL_WIDTH/2 + math.random(-50,50), 
        by = VIRTUAL_HEIGHT/2 + math.random(-50,50), 
        brad = self.brad + 6.24, -- one full rotation
        bsx = math.random(math.floor(self.bminSx*100), math.floor(self.bminSx*400))/100.,
        bsy = math.random(math.floor(self.bminSy*100), math.floor(self.bminSy*400))/100.,
        bopac = math.random(12*self.multiplier,18*self.multiplier),
    }}):finish(function()
        self:tweenBackground()
    end)
end

function AcidFilter:tweenDrawDistortion()
    local sxOffset = math.random(self.scaleFactor)/100.
    local syOffset = math.random(self.scaleFactor)/100.
    Timer.tween(self.drawPeriod, { [self] = {
        -- Don't think radian distortion will work too well since most things
        -- are being drawn from the top left corner
        -- curRadOffset = math.random(-self.radFactor,self.radFactor)/100.,
        curSXOffset = 1 + sxOffset,
        curSYOffset = 1 + syOffset,
        curXOffset = self.maxOffset * sxOffset,
        curYOffset = self.maxOffset * syOffset,
    }}):finish(function()
        self:tweenDrawDistortion()
    end)
end

function AcidFilter:getMultiplier()
    return self.multiplier
end

function AcidFilter:update(dt)
    -- For filters that will tween their own overlayed graphics
end

function AcidFilter:render()
    love.graphics.setColor(255, 255, 255, self.bopac)
    love.graphics.draw(
        self.bkgrd,
        self.bx,
        self.by,
        self.brad,
        self.bsx,
        self.bsy,
        self.box,
        self.boy)
    -- TODO, can also fade opacity on the real world and sub in a monsters world
    for _, mster in pairs(self.monsters) do
        love.graphics.setColor(255, 255, 255, mster.opac)
        love.graphics.draw(mster.img, mster.x, mster.y, mster.rad,
            mster.sx, mster.sy, mster.ox, mster.oy)
    end
    love.graphics.setColor(255, 255, 255, 255)
end

function AcidFilter:drawD(d, x, y, r, sx, sy, ox, oy, kx, ky)
    local lsx = sx
    if lsx ~= nil then
        lsx = lsx * self.curSXOffset
    else
        lsx = self.curSXOffset
    end
    local lsy = sy
    if lsy ~= nil then
        lsy = lsy * self.curSYOffset
    else
        lsy = self.curSYOffset
    end
    love.graphics.draw(
        d, x + self.curXOffset, y + self.curYOffset,
        r, lsx, lsy, ox, oy, kx, ky)
end

function AcidFilter:drawQ(t, q, x, y, r, sx, sy, ox, oy, kx, ky)
    local lsx = sx
    if lsx ~= nil then
        lsx = lsx * self.curSXOffset
    else
        lsx = self.curSXOffset
    end
    local lsy = sy
    if lsy ~= nil then
        lsy = lsy * self.curSYOffset
    else
        lsy = self.curSYOffset
    end
    love.graphics.draw(
        t, q, x + self.curXOffset, y + self.curYOffset,
        r, lsx, lsy, ox, oy, kx, ky)
end
