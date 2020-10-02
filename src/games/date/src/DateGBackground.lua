
DateGBackground = Class{}

function DateGBackground:init()
    self.bkgrd = gDateWImages['table']
    self.bkgrdX = 0
    self.bkgrdY = 0
    self.bkgrdW, self.bkgrdH = self.bkgrd:getDimensions()
    -- Shift the picture up a little and stretch to fit to cut out
    -- some of the more boring ceiling part of the pictures
    self.shiftY = 50
    self.bkgrdY = self.bkgrdY - self.shiftY
    self.bkgrdSX = VIRTUAL_WIDTH / self.bkgrdW
    self.bkgrdSY = (VIRTUAL_HEIGHT + self.shiftY) / self.bkgrdH
end

function DateGBackground:render()
    love.graphics.filterDrawD(self.bkgrd, self.bkgrdX, self.bkgrdY, 0,
        self.bkgrdSX, self.bkgrdSY)
end
