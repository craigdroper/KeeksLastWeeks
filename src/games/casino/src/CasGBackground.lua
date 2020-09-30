
CasGBackground = Class{}

function CasGBackground:init()
    self.bkgrd = gCasWImages['table-background']
    self.bkgrdX = 0
    self.bkgrdY = 0
    self.bkgrdW, self.bkgrdH = self.bkgrd:getDimensions()
    self.bkgrdSX = VIRTUAL_WIDTH / self.bkgrdW
    self.bkgrdSY = VIRTUAL_HEIGHT / self.bkgrdH
end

function CasGBackground:render()
    love.graphics.filterDrawD(self.bkgrd, self.bkgrdX, self.bkgrdY, 0,
        self.bkgrdSX, self.bkgrdSY)
end
