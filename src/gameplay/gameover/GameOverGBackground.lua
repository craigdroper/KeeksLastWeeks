
GameOverGBackground = Class{}

function GameOverGBackground:init()
    -- GameOverGBackground background image info
    self.bkgrd = gGameOverImages['church']
    self.bkgrdX = VIRTUAL_WIDTH/2
    self.bkgrdY = VIRTUAL_HEIGHT/2
    self.bkgrdW, self.bkgrdH = self.bkgrd:getDimensions()
    self.finalbkgrdSX = (VIRTUAL_WIDTH) / self.bkgrdW
    self.finalbkgrdSY = (VIRTUAL_HEIGHT) / self.bkgrdH
    self.opac = 0
    self.bkgrdSX = 0
    self.bkgrdSY = 0

    Timer.after(4, function()
    Timer.tween(7, {
            [self] = {
                opac=255,
                bkgrdSX = self.finalbkgrdSX,
                bkgrdSY = self.finalbkgrdSY,
                bkgrdX = 0,
                bkgrdY = 0
            }
        }
    )
    end)
end

function GameOverGBackground:render()
    love.graphics.setColor(255, 255, 255, self.opac)
    love.graphics.filterDrawD(self.bkgrd, self.bkgrdX, self.bkgrdY, 0,
        self.bkgrdSX, self.bkgrdSY
    )
    love.graphics.setColor(255, 255, 255, 255)
end
