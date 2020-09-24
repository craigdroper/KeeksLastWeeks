
CokeFilter = Class{}

function CokeFilter:init(params)
    self.multiplier = params.multiplier
    self.isShakeUp = true
    self.maxOffset = self.multiplier
    self.offsetY = -self.maxOffset
    self.shakeHalfPeriod = -0.0025 * self.multiplier + 0.05

    -- Initialize a tween to begin shaking the offsetY
    self:tweenShake()
end

function CokeFilter:update(dt)
    -- For filters that will tween their own overlaid graphics
    -- Coke filter will not be adding its own overlaid graphics
end

function CokeFilter:render()
    -- For filters that will add their own graphics
    -- Coke filter will not add any of its own additional objects,
    -- it only translates existing objects up and down to appear like
    -- they're shaking
end

function CokeFilter:tweenShake()
    Timer.tween(self.shakeHalfPeriod, {
        [self] = {offsetY = self.isShakeUp and self.maxOffset or -self.maxOffset}
    }):finish(function()
        self:flipShake()
    end)
end

function CokeFilter:flipShake()
    self.isShakeUp = not self.isShakeUp
    self:tweenShake()
end

function CokeFilter:drawD(d, x, y, r, sx, sy, ox, oy, kx, ky)
    -- Coke filter will apply its current y offset to all drawn
    -- graphics to make it look like its shaking up and down
    love.graphics.draw(d, x, y + self.offsetY, r, sx, sy, ox, oy, kx, ky)
end

function CokeFilter:drawQ(t, q, x, y, r, sx, sy, ox, oy, kx, ky)
    -- Coke filter will apply its current y offset to all drawn
    -- graphics to make it look like its shaking up and down
    love.graphics.draw(t, q, x, y + self.offsetY, r, sx, sy, ox, oy, kx, ky)
end
