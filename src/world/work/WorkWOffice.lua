
WorkWOffice = Class{}

function WorkWOffice:init()
    -- WorkWOffice background image info
    self.bkgrd = gWorkImages['office']
    self.bkgrdX = 0
    self.bkgrdY = 0
    self.bkgrdW, self.bkgrdH = self.bkgrd:getDimensions()
    self.bkgrdSX = (VIRTUAL_WIDTH) / self.bkgrdW
    self.bkgrdSY = (VIRTUAL_HEIGHT) / self.bkgrdH

    self.npcs = {}
    local coworker = {
        imgX = 115,
        imgY = 176,
        frame = gCHARACTER_IDLE_DOWN,
        num = nil,
        name = 'coworker',
        scale = 2,
    }
    table.insert(self.npcs, coworker)
end

function WorkWOffice:render()
    love.graphics.filterDrawD(self.bkgrd, self.bkgrdX, self.bkgrdY, 0,
        self.bkgrdSX, self.bkgrdSY)
    drawNPC(self.npcs, self.bkgrdSX, self.bkgrdSY)
end
