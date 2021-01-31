
Casino = Class{}

function Casino:init()
    -- Casino background image info
    self.bkgrd = gCasWImages['casino-background']
    self.bkgrdX = 0
    self.bkgrdY = 0
    self.bkgrdW, self.bkgrdH = self.bkgrd:getDimensions()
    self.bkgrdSX = VIRTUAL_WIDTH / self.bkgrdW
    self.bkgrdSY = VIRTUAL_HEIGHT / self.bkgrdH

    self.npcs = {}
    self:initNPC()
end

function Casino:initNPC()
    -- Left foreground blackjack table
    createNPC(self.npcs, 120, 439, gCHARACTER_IDLE_LEFT, 1.3)
    -- Center foreground blackjack table (where Keeks goes)
    createNPC(self.npcs, 411, 410, gCHARACTER_IDLE_RIGHT, 1.2)
    createNPC(self.npcs, 495, 420, gCHARACTER_IDLE_UP, 1.1)
    -- Right foreground blackjack table (where Keeks goes)
    createNPC(self.npcs, 905, 370, gCHARACTER_IDLE_UP, 0.8)
    createNPC(self.npcs, 999, 363, gCHARACTER_IDLE_LEFT, 0.8)
    -- Right background table
    createNPC(self.npcs, 669, 330, gCHARACTER_IDLE_DOWN, 0.4)
    createNPC(self.npcs, 595, 337, gCHARACTER_IDLE_RIGHT, 0.4)
    -- Left background table
    createNPC(self.npcs, 70, 355, gCHARACTER_IDLE_LEFT, 1)
end

function Casino:render()
    love.graphics.filterDrawD(self.bkgrd, self.bkgrdX, self.bkgrdY, 0,
        self.bkgrdSX, self.bkgrdSY)
    drawNPC(self.npcs, self.bkgrdSX, self.bkgrdSY)
end
