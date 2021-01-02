
AcidGBackground = Class{}

function AcidGBackground:init()
    self.scrollDist = 20
    self.bkgrdTime = 10
    self.transitionTime = 2
    self.bkgrds = {
        [1] = self:initImage('background1'),
        [2] = self:initImage('background2'),
        [3] = self:initImage('background3'),
        [4] = self:initImage('background4'),
        [5] = self:initImage('background5'),
    }
    self.idx = 1
    self.curBkgrd = self.bkgrds[self.idx]
    self.nextBkgrd = nil
end

function AcidGBackground:initImage(imgName)
    local image = gAcidGTextures[imgName]
    local bkgrdW, bkgrdH = image:getDimensions()
    local sx = (VIRTUAL_WIDTH + 2*self.scrollDist) / bkgrdW
    local sy = (VIRTUAL_HEIGHT + 2*self.scrollDist) / bkgrdH
    return {image = image, sx = sx, sy = sy, x = 0, y = 0, opac = 255}
end

function AcidGBackground:beginTransitioning()
    self.isFirstBkgrd = true
    self:tweenBkgrd(self.curBkgrd)
    -- Don't want the first background to fade in
    self.curBkgrd.opac = 255
    Timer.after(self.bkgrdTime - self.transitionTime,
        function()
            self:transition()
        end
    )
end

function AcidGBackground:tweenBkgrd(bkgrd)
    -- 1 up, 2 right, etc
    local curDir = math.random(4)
    if curDir == 1 then
        bkgrd.x = -self.scrollDist
        bkgrd.y = 0
        Timer.tween(self.bkgrdTime, {[bkgrd] = {y = -self.scrollDist * 2}})
    elseif curDir == 2 then
        bkgrd.x = -2*self.scrollDist
        bkgrd.y = -self.scrollDist
        Timer.tween(self.bkgrdTime, {[bkgrd] = {x = 0}})
    elseif curDir == 3 then
        bkgrd.x = -self.scrollDist
        bkgrd.y = -2*self.scrollDist
        Timer.tween(self.bkgrdTime, {[bkgrd] = {y = 0}})
    elseif curDir == 4 then
        bkgrd.x = 0
        bkgrd.y = -self.scrollDist
        Timer.tween(self.bkgrdTime, {[bkgrd] = {x = -2*self.scrollDist}})
    end

    if not self.isFirstBkgrd then
        bkgrd.opac = 0
        Timer.tween(self.transitionTime, {[bkgrd] = {opac = 255}})
    end
    Timer.after(self.bkgrdTime - self.transitionTime,
        function()
            Timer.tween(self.transitionTime, {[bkgrd] = {opac = 0}})
        end)

    self.isFirstBkgrd = false
end

function AcidGBackground:transition()
    self.idx = (self.idx + 1) % (5+1)
    if self.idx == 0 then
        self.idx = 1
    end
    self.nextBkgrd = self.bkgrds[self.idx]
    self:tweenBkgrd(self.nextBkgrd)

    Timer.after(self.transitionTime,
        function()
            self.curBkgrd = self.nextBkgrd
            self.nextBkgrd = nil
        end
    )
    Timer.after(self.bkgrdTime - self.transitionTime,
        function()
            self:transition()
        end)
end

function AcidGBackground:render()
    love.graphics.setColor(255, 255, 255, self.curBkgrd.opac)
    love.graphics.filterDrawD(
        self.curBkgrd.image,
        self.curBkgrd.x,
        self.curBkgrd.y,
        0,
        self.curBkgrd.sx,
        self.curBkgrd.sy)
    if self.nextBkgrd ~= nil then
        love.graphics.setColor(255, 255, 255, self.nextBkgrd.opac)
        love.graphics.filterDrawD(
            self.nextBkgrd.image,
            self.nextBkgrd.x,
            self.nextBkgrd.y,
            0,
            self.nextBkgrd.sx,
            self.nextBkgrd.sy)
    end
    love.graphics.setColor(255, 255, 255, 255)
end
