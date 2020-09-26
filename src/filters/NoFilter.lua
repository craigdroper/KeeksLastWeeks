
NoFilter = Class{}

function NoFilter:init()
    -- nil values differentiates not having a multiplier with
    -- a filter that does have a multiplier with a value of 1
    self.multiplier = nil
end

function NoFilter:getMultiplier()
    return self.multiplier
end

function NoFilter:update(dt)
    -- For filters that will tween their own overlayed graphics
end

function NoFilter:render()
    -- For filters that will add their own graphics
    -- No filter will not add any of its own additional objects
end

function NoFilter:drawD(d, x, y, r, sx, sy, ox, oy, kx, ky)
    -- No filter will not adjust any characteristics of world objects
    love.graphics.draw(d, x, y, r, sx, sy, ox, oy, kx, ky)
end

function NoFilter:drawQ(t, q, x, y, r, sx, sy, ox, oy, kx, ky)
    -- No filter will not adjust any characteristics of world objects
    love.graphics.draw(t, q, x, y, r, sx, sy, ox, oy, kx, ky)
end
