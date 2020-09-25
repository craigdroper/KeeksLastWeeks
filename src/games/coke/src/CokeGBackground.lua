
CokeGBackground = Class{}

function CokeGBackground:init()
    self.isScrolling = false
    self.backgroundScrollSpeed = 30
    self.backgroundShift = 0
    self.backgroundScroll = 0
    -- Don't begin looping until the initial image has scrolled out of frame
    -- (which is checked in update)
    self.backgroundLoopPoint = 1e13

    self.initImg = gCokeGImages['background-base']
    self.initImgW, self.initImgH = self.initImg:getDimensions()
    -- Shrink the image to screen
    self.initImgSX = VIRTUAL_WIDTH / self.initImgW
    self.initImgSY = VIRTUAL_HEIGHT / self.initImgH
    self.initImgAdjW = self.initImgW * self.initImgSX

    self.extImg = gCokeGImages['background-ext']
    self.extImgW, self.extImgH = self.extImg:getDimensions()
    self.extImgOffsetY = (VIRTUAL_HEIGHT - self.extImgH) / 2
    -- Choosing not to expand and lose resolution on the extended background image
end

function CokeGBackground:setIsScrolling(isScrolling)
    self.isScrolling = isScrolling
end

function CokeGBackground:update(dt)
    if self.isScrolling then
        self.backgroundScroll =
        (self.backgroundScroll + self.backgroundScrollSpeed * dt)
        % self.backgroundLoopPoint
    end
    -- The initial image has scrolled out of frame
    if self.backgroundScroll > self.initImgAdjW then
        self.backgroundShift = self.initImgAdjW
        self.backgroundScroll = 0
        self.backgroundLoopPoint = VIRTUAL_WIDTH
    end
end

function CokeGBackground:render()
    love.graphics.setColor(0, 0, 0, 255)
    love.graphics.rectangle('fill', 0, 0, VIRTUAL_WIDTH, VIRTUAL_HEIGHT)
    love.graphics.setColor(255, 255, 255, 255)

    love.graphics.filterDrawD(self.initImg,
        -self.backgroundScroll - self.backgroundShift,
        0,
        0,
        self.initImgSX, self.initImgSY)
    love.graphics.filterDrawD(self.extImg,
        -self.backgroundScroll - self.backgroundShift + self.initImgAdjW,
        self.extImgOffsetY)
    love.graphics.filterDrawD(self.extImg,
        -self.backgroundScroll - self.backgroundShift + self.extImgW + self.initImgAdjW,
        self.extImgOffsetY)
    love.graphics.filterDrawD(self.extImg,
        -self.backgroundScroll - self.backgroundShift + 2*self.extImgW + self.initImgAdjW,
        self.extImgOffsetY)
end
