
Club = Class{}

function Club:init()
    -- Club background image info
    self.bkgrd = gClubWImages['club-background']
    self.bkgrdX = 0
    self.bkgrdY = 0
    self.bkgrdW, self.bkgrdH = self.bkgrd:getDimensions()
    self.bkgrdSX = VIRTUAL_WIDTH / self.bkgrdW
    self.bkgrdSY = VIRTUAL_HEIGHT / self.bkgrdH

    -- Club effects info
    self.curColor = 0
    self.palette = {
        -- Red
        [0] = {r = 255, g = 0, b = 0},
        -- Green
        [1] = {r = 0, g = 255, b = 0},
        -- Blue
        [2] = {r = 0, g = 0, b = 255},
    }
    self:tweenColors()
    self.curBeams = self:genBeams()

    -- TODO generate random patrons and the dj
end

function Club:tweenColors()
    Timer.every(1,
    function()
        self.curColor = (self.curColor + 1) % (#self.palette + 1)
        self.curBeams = self:genBeams()
    end)
end

function Club:genBeams()
    local lSpotX = VIRTUAL_WIDTH/4
    local rSpotX = 3 * VIRTUAL_WIDTH/4
    local tSpotY = -5
    local bSpotY = VIRTUAL_HEIGHT + 5
    -- Generate two rectangular beams per spotlight, and randomly assign them
    -- a rotation within a reasonable range
    local beamOpac = 64

    beams = {}
    -- between 60 to 120 degrees (1.0472 to 2.0944) of rotation
    -- this means the x can vary between +- VIRTUAL_HEIGHT * tangent(30)
    local bSpotXRange = math.tan(.5235) * VIRTUAL_HEIGHT

    local spotXDelta = math.random(-bSpotXRange, bSpotXRange)
    beams[1] = {x1 = lSpotX, y1 = tSpotY, x2 = lSpotX + spotXDelta, y2 = bSpotY,
                opac = beamOpac}
    local spotXDelta = math.random(-bSpotXRange, bSpotXRange)
    beams[2] = {x1 = lSpotX, y1 = tSpotY, x2 = lSpotX + spotXDelta, y2 = bSpotY,
                opac = beamOpac}
    local spotXDelta = math.random(-bSpotXRange, bSpotXRange)
    beams[3] = {x1 = rSpotX, y1 = tSpotY, x2 = rSpotX + spotXDelta, y2 = bSpotY,
                opac = beamOpac}
    local spotXDelta = math.random(-bSpotXRange, bSpotXRange)
    beams[4] = {x1 = rSpotX, y1 = tSpotY, x2 = rSpotX + spotXDelta, y2 = bSpotY,
                opac = beamOpac}
    return beams
end

function Club:renderBase()
    love.graphics.filterDrawD(self.bkgrd, self.bkgrdX, self.bkgrdY, 0,
        self.bkgrdSX, self.bkgrdSY)
end

function Club:renderGradientLight()
    local maxOpacity = 128
    local minOpactiy = 32
    for y = 0, VIRTUAL_HEIGHT do
        local rowOpacity = (VIRTUAL_HEIGHT - y) / VIRTUAL_HEIGHT *
                           (maxOpacity - minOpactiy) + minOpactiy
        love.graphics.setColor(
            self.palette[self.curColor].r,
            self.palette[self.curColor].g,
            self.palette[self.curColor].b,
            rowOpacity)
        love.graphics.rectangle('fill', 0, y, VIRTUAL_WIDTH, 1)
    end
    love.graphics.setColor(255, 255, 255, 255)
end

function Club:renderSpotlights()
    for _, beam in pairs(self.curBeams) do
        love.graphics.setColor(
            self.palette[self.curColor].r,
            self.palette[self.curColor].g,
            self.palette[self.curColor].b,
            beam.opac)
        for i = -5, 5 do
            love.graphics.line(beam.x1 + i, beam.y1, beam.x2 + i, beam.y2)
        end
    end
    love.graphics.setColor(255, 255, 255, 255)
end

function Club:renderEffects()
    self:renderGradientLight()
    self:renderSpotlights()
end
