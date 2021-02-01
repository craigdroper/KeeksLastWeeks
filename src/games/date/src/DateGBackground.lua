
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

    self.npcs = {}
    local date = {
        imgX = 450,
        imgY = 376,
        frame = gCHARACTER_IDLE_DOWN,
        num = nil,
        name = 'date',
        scale = 1.25,
        hshift = 18,
    }
    table.insert(self.npcs, date)
end

function DateGBackground:render()
    love.graphics.filterDrawD(self.bkgrd, self.bkgrdX, self.bkgrdY, 0,
        self.bkgrdSX, self.bkgrdSY)
    drawNPC(self.npcs, self.bkgrdSX, self.bkgrdSY)
end
