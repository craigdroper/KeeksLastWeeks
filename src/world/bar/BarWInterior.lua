
BarWInterior = Class{}

function BarWInterior:init()
    -- BarWInterior background image info
    self.bkgrd = gBarWImages['interior']
    self.bkgrdX = 0
    self.bkgrdY = 0
    self.bkgrdW, self.bkgrdH = self.bkgrd:getDimensions()
    self.bkgrdSX = (VIRTUAL_WIDTH) / self.bkgrdW
    self.bkgrdSY = (VIRTUAL_HEIGHT) / self.bkgrdH
    self.npcs = {}
    self:initNPC()
end

function BarWInterior:initNPC()
    -- Front center table characters
    createNPC(self.npcs, 1071, 766, gCHARACTER_IDLE_RIGHT, 1.5)
    createNPC(self.npcs, 1240, 790, gCHARACTER_IDLE_UP, 1.5)
    createNPC(self.npcs, 1400, 755, gCHARACTER_IDLE_LEFT, 1.5)
    -- Stools with bar top on right side
    createNPC(self.npcs, 1819, 685, gCHARACTER_IDLE_RIGHT)
    createNPC(self.npcs, 1748, 651, gCHARACTER_IDLE_RIGHT, 0.9)
    createNPC(self.npcs, 1686, 639, gCHARACTER_IDLE_RIGHT, 0.8)
    -- Main bar on left
    createNPC(self.npcs, 720, 650, gCHARACTER_IDLE_LEFT, 1.5)
    createNPC(self.npcs, 575, 660, gCHARACTER_IDLE_LEFT, 1.5)
    createNPC(self.npcs, 1169, 650, gCHARACTER_IDLE_LEFT, 0.8)
    createNPC(self.npcs, 1200, 650, gCHARACTER_IDLE_LEFT, 0.8)
end

function BarWInterior:render()
    love.graphics.filterDrawD(self.bkgrd, self.bkgrdX, self.bkgrdY, 0,
        self.bkgrdSX, self.bkgrdSY)
    drawNPC(self.npcs, self.bkgrdSX, self.bkgrdSY)
end
