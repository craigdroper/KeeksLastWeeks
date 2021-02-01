
BarWExterior = Class{}

function BarWExterior:init()
    -- BarWExterior background image info
    self.bkgrd = gBarWImages['exterior']
    self.bkgrdX = 0
    self.bkgrdY = 0
    self.bkgrdW, self.bkgrdH = self.bkgrd:getDimensions()
    self.bkgrdSX = (VIRTUAL_WIDTH) / self.bkgrdW
    self.bkgrdSY = (VIRTUAL_HEIGHT) / self.bkgrdH

    self.npcs = {}
    -- Create bouncer
    bouncer = {
        imgX = 264,
        imgY = 312,
        frame = gCHARACTER_IDLE_RIGHT,
        num = nil,
        name = 'bouncer',
        scale = 1,
    }
    table.insert(self.npcs, bouncer)
end

function BarWExterior:render()
    love.graphics.filterDrawD(self.bkgrd, self.bkgrdX, self.bkgrdY, 0,
        self.bkgrdSX, self.bkgrdSY)
    drawNPC(self.npcs, self.bkgrdSX, self.bkgrdSY)
end
