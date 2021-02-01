
DoctorWRoom = Class{}

function DoctorWRoom:init()
    -- DoctorWRoom background image info
    self.bkgrd = gDoctorImages['room']
    self.bkgrdX = 0
    self.bkgrdY = 0
    self.bkgrdW, self.bkgrdH = self.bkgrd:getDimensions()
    self.bkgrdSX = (VIRTUAL_WIDTH) / self.bkgrdW
    self.bkgrdSY = (VIRTUAL_HEIGHT) / self.bkgrdH

    self.npcs = {}
    local doctor = {
        imgX = 854,
        imgY = 510,
        frame = gCHARACTER_IDLE_LEFT,
        num = nil,
        name = 'doctor',
        scale = 1.5,
    }
    table.insert(self.npcs, doctor)
end

function DoctorWRoom:render()
    love.graphics.filterDrawD(self.bkgrd, self.bkgrdX, self.bkgrdY, 0,
        self.bkgrdSX, self.bkgrdSY)
    drawNPC(self.npcs, self.bkgrdSX, self.bkgrdSY)
end
