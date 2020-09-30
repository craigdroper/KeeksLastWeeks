
ClubGArrow =  Class{}

function ClubGArrow:init(arrowTarget, level)
    self.inPlay = true
    self.x = arrowTarget.x
    self.y = VIRTUAL_HEIGHT + 1
    self.dir = arrowTarget.dir
    self.width = 30
    self.height = 30
    -- Shift origin to center for consistent image rotation
    self.ox = self.width/2
    self.oy = self.height/2
    -- Account for offset when drawing
    self.offsetX = self.ox
    self.offsetY = self.oy

    -- Speed that this will travel up towards target
    self.dyBase = -60
    self.dyLevel = -30
    -- Arrows get linearly faster with each level
    self.dy = self.dyBase + level * self.dyLevel

    -- The arrows progressively increase the bars available as they get
    -- closer to the arrow target
    self.curColIdx = 1
    self.verticalQuadHeightToTarget = (VIRTUAL_HEIGHT - arrowTarget:getY())/3
    self.nextColY = VIRTUAL_HEIGHT - self.verticalQuadHeightToTarget
    self.colArrowIdx = {2, 3, 4, 1}

    -- Select the correct row, and necessary rotation, of 4 arrows
    if self.dir == 'left' then
        self.rad = 1.5708
        self.rowIdx = 1
    elseif self.dir == 'down' then
        self.rad = 0
        self.rowIdx = 2
    elseif self.dir == 'up' then
        self.rad = 3.14159
        self.rowIdx = 3
    elseif self.dir == 'right' then
        self.rad = 4.7123
        self.rowIdx = 4
    end
end

function ClubGArrow:getX()
    return self.x + self.offsetX
end

function ClubGArrow:getY()
    return self.y + self.offsetY
end

function ClubGArrow:update(dt)
    -- First update the arrow's Y position
    self.y = self.y + self.dy * dt
    -- Check if the arrow has approached a quad closer to the target,
    -- if so, draw the arrow with the extra progress bar
    if self.y < self.nextColY and self.curColIdx < 4 then
        self.curColIdx = self.curColIdx + 1
        self.nextColY = self.nextColY - self.verticalQuadHeightToTarget
    end
end

function ClubGArrow:render()
    if self.inPlay then
        love.graphics.filterDrawQ(
            gClubGTextures['arrows'],
            gClubGFrames['arrows'][4*(self.rowIdx - 1) + (self.colArrowIdx[self.curColIdx])],
            self:getX(), self:getY(), self.rad,
            self.sx, self.sy, self.ox, self.oy)
    end
end
