
DateWLobby = Class{}

function DateWLobby:init()
    -- DateWLobby background image info
    self.bkgrd = gDateWImages['lobby']
    self.bkgrdX = 0
    self.bkgrdY = 20
    self.bkgrdW, self.bkgrdH = self.bkgrd:getDimensions()
    self.bkgrdSX = (VIRTUAL_WIDTH - 2*self.bkgrdX)  / self.bkgrdW
    self.bkgrdSY = (VIRTUAL_HEIGHT) / self.bkgrdH
end

function DateWLobby:render()
    love.graphics.filterDrawD(self.bkgrd, self.bkgrdX, self.bkgrdY, 0,
        self.bkgrdSX, self.bkgrdSY)
end
