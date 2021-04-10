
Alley = Class{}

function Alley:init()
    -- Alley background image info
    self.bkgrd = gAlleyImages['background']
    self.bkgrdX = 0
    self.bkgrdY = 0
    self.bkgrdW, self.bkgrdH = self.bkgrd:getDimensions()
    self.bkgrdSX = (VIRTUAL_WIDTH) / self.bkgrdW
    self.bkgrdSY = (VIRTUAL_HEIGHT) / self.bkgrdH

    self.car = gAlleyImages['car']
    self.carX = VIRTUAL_WIDTH * 1/6 - 30
    self.carY = VIRTUAL_HEIGHT * 3/4 - 28
    self.carSX = 0.18
    self.carSY = 0.18
end

function Alley:render()
    love.graphics.filterDrawD(self.bkgrd, self.bkgrdX, self.bkgrdY, 0,
        self.bkgrdSX, self.bkgrdSY)
    love.graphics.filterDrawD(self.car, self.carX, self.carY, 0,
        self.carSX, self.carSY)
end
