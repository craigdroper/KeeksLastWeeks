
DateWRestaurant = Class{}

function DateWRestaurant:init()
    -- DateWRestaurant background image info
    self.bkgrd = gDateWImages['dining-room']
    self.bkgrdX = 0
    self.bkgrdY = 0
    self.bkgrdW, self.bkgrdH = self.bkgrd:getDimensions()
    self.bkgrdSX = (VIRTUAL_WIDTH) / self.bkgrdW
    self.bkgrdSY = (VIRTUAL_HEIGHT) / self.bkgrdH

    self.npcs = {}
    self:initNPC()
end

function DateWRestaurant:initNPC()
    -- Further Background square table
    createNPC(self.npcs, 1500, 530, gCHARACTER_IDLE_RIGHT, 1, 30)
    createNPC(self.npcs, 1640, 530, gCHARACTER_IDLE_DOWN, 1, 30)
    -- Background square table
    createNPC(self.npcs, 1260, 530, gCHARACTER_IDLE_DOWN, 1.2, 30)
    createNPC(self.npcs, 1030, 530, gCHARACTER_IDLE_RIGHT, 1.1, 20)
    -- Foreground left bench
    createNPC(self.npcs, 650, 500, gCHARACTER_IDLE_RIGHT, 0.9, 20)
    createNPC(self.npcs, 780, 510, gCHARACTER_IDLE_LEFT, 0.9, 10)
    createNPC(self.npcs, 340, 540, gCHARACTER_IDLE_RIGHT, 1.4, 20)
    createNPC(self.npcs, 530, 560, gCHARACTER_IDLE_LEFT, 1.4, 10)
    createNPC(self.npcs, 240, 620, gCHARACTER_IDLE_LEFT, 2, 10)
end

function DateWRestaurant:render()
    love.graphics.filterDrawD(self.bkgrd, self.bkgrdX, self.bkgrdY, 0,
        self.bkgrdSX, self.bkgrdSY)
    drawNPC(self.npcs, self.bkgrdSX, self.bkgrdSY)
end
