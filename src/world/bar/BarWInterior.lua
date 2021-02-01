
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
    local bartender = {
        imgX = 800,
        imgY = 600,
        frame = gCHARACTER_IDLE_RIGHT,
        num = nil,
        name = 'bartender',
        scale = 1,
        hshift = 20,
    }
    table.insert(self.npcs, bartender)
end

function BarWInterior:initNPC()
    -- Front center table characters
    createNPC(self.npcs, 1071, 730, gCHARACTER_IDLE_RIGHT, 1.5, 10)
    createNPC(self.npcs, 1240, 760, gCHARACTER_IDLE_UP, 1.5, 12)
    createNPC(self.npcs, 1400, 725, gCHARACTER_IDLE_LEFT, 1.5, 10)
    -- Stools with bar top on right side
    createNPC(self.npcs, 1819, 685, gCHARACTER_IDLE_RIGHT, 1, 10)
    createNPC(self.npcs, 1748, 651, gCHARACTER_IDLE_RIGHT, 0.9, 10)
    createNPC(self.npcs, 1686, 639, gCHARACTER_IDLE_RIGHT, 0.8, 10)
    -- Main bar on left
    createNPC(self.npcs, 700, 650, gCHARACTER_IDLE_LEFT, 1.3, 10)
    createNPC(self.npcs, 575, 660, gCHARACTER_IDLE_LEFT, 1.3, 10)
    createNPC(self.npcs, 1169, 650, gCHARACTER_IDLE_LEFT, 0.8, 15)
    createNPC(self.npcs, 1200, 650, gCHARACTER_IDLE_LEFT, 0.8, 15)
end

function BarWInterior:render()
    love.graphics.filterDrawD(self.bkgrd, self.bkgrdX, self.bkgrdY, 0,
        self.bkgrdSX, self.bkgrdSY)
    drawNPC(self.npcs, self.bkgrdSX, self.bkgrdSY)
end
