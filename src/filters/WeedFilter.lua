
WeedFilter = Class{}

function WeedFilter:init(params)
    self.multiplier = params.multiplier
    self.sleepPeriod = 5
    self.wakePeriod = 0.5
    self.waitPeriod = 1
    self.isFallingAsleep = true

    self.maxOpacity = 255
    self.minOpacity = 0

    -- Create the filter ellipses
    self.lineWidth = 4
    local screenDiagPixels = math.sqrt( (VIRTUAL_WIDTH/2)^2 + (VIRTUAL_HEIGHT/2)^2)
    local numEllips = math.floor(screenDiagPixels/self.lineWidth) + 1
    self.centerShape = {
            radius = self.lineWidth/2,
            maxOpac = self.maxOpacity,
            minOpac = self.minOpacity,
            curOpac = self.minOpacity
    }
    self.borderShapes = {}
    -- Need to start at least 1 ring outside on level 10, since we need to use
    -- a 'fill' circle instead of a line for that
    local minGradIdx = math.max(((10 - self.multiplier) / 10) * numEllips,1)
    local maxGradIdx = ((10 - self.multiplier + 1) / 10) * numEllips
    local gradOpacFactor = (self.maxOpacity - self.minOpacity) / (numEllips / 10)
    -- This is a hack but I think it'll do for now:
    -- Basically if anything but level 10, leave a gradient in the final
    -- ring, but if its level 10, we won't have a gradient anywhere and the center
    -- shape will be drawn
    if self.multiplier ~= 10 then
        for idx = minGradIdx, maxGradIdx do
            table.insert(self.borderShapes,
                {
                    sleepTime = self.sleepPeriod * ((numEllips - idx) / (numEllips - minGradIdx)),
                    wakeTime = self.wakePeriod * ((numEllips - idx) / (numEllips - minGradIdx)),
                    radius = self.lineWidth * idx,
                    maxOpac = self.maxOpacity * ((idx - minGradIdx)/(maxGradIdx-minGradIdx)),
                    minOpac = self.minOpacity,
                    curOpac = self.minOpacity
                }
            )
        end
    else
        -- Hack the maxGradIdx to work when there is no gradient and there is a middle shape
        maxGradIdx = 0
    end
    for idx = maxGradIdx + 1, numEllips do
        table.insert(self.borderShapes,
            {
                sleepTime = self.sleepPeriod * ((numEllips - idx) / (numEllips - minGradIdx)),
                wakeTime = self.wakePeriod * ((numEllips - idx) / (numEllips - minGradIdx)),
                radius = self.lineWidth * idx,
                maxOpac = self.maxOpacity,
                minOpac = self.minOpacity,
                curOpac = self.minOpacity
            }
        )
    end

    self:tweenFade()
end

function WeedFilter:tweenFade()
    if self.isFallingAsleep then
        Timer.tween(self.sleepPeriod, {
            [self.centerShape] = {curOpac = self.centerShape.maxOpac}
        })
    else
        Timer.tween(self.wakePeriod, {
            [self.centerShape] = {curOpac = self.centerShape.minOpac}
        })
    end
    for _, shape in pairs(self.borderShapes) do
        if self.isFallingAsleep then
            Timer.tween(shape.sleepTime, {
                [shape] = {curOpac = shape.maxOpac}
            })
        else
            Timer.after(self.wakePeriod - shape.wakeTime,
                function()
                    Timer.tween(shape.wakeTime, {
                        [shape] = {curOpac = shape.minOpac}
                    })
                end)
        end
    end

    if self.isFallingAsleep then
        Timer.after(self.sleepPeriod, function() self:flipFade() end)
    else
        Timer.after(self.wakePeriod, function() self:flipFade() end)
    end
end

function WeedFilter:flipFade()
    self.isFallingAsleep = not self.isFallingAsleep
    if self.isFallingAsleep then
        -- Give a couple seconds of uninterrupted awake time
        Timer.after(self.waitPeriod, function() self:tweenFade() end)
    else
        self:tweenFade()
    end
end

function WeedFilter:getMultiplier()
    return self.multiplier
end

function WeedFilter:update(dt)
    -- For filters that will tween their own overlayed graphics
end

function WeedFilter:render()
    -- Render fading shapes simulating closing eyes on top of all the world
    local origLineWidth = love.graphics.getLineWidth()
    love.graphics.setLineWidth(self.lineWidth)
    if self.multiplier == 10 then
        -- If the multiplier isn't 10, then we'll always have at least 1 empty
        -- shape in the middle of the screen
        love.graphics.setColor(0, 0, 0, self.centerShape.curOpac)
        love.graphics.circle('fill', VIRTUAL_WIDTH/2, VIRTUAL_HEIGHT/2, self.centerShape.radius)
    end
    for _, shape in pairs(self.borderShapes) do
        love.graphics.setColor(0, 0, 0, shape.curOpac)
        love.graphics.circle('line', VIRTUAL_WIDTH/2, VIRTUAL_HEIGHT/2, shape.radius)
    end
    love.graphics.setColor(255, 255, 255, 255)
    love.graphics.setLineWidth(origLineWidth)
end

function WeedFilter:drawD(d, x, y, r, sx, sy, ox, oy, kx, ky)
    -- No filter will not adjust any characteristics of world objects
    love.graphics.draw(d, x, y, r, sx, sy, ox, oy, kx, ky)
end

function WeedFilter:drawQ(t, q, x, y, r, sx, sy, ox, oy, kx, ky)
    -- No filter will not adjust any characteristics of world objects
    love.graphics.draw(t, q, x, y, r, sx, sy, ox, oy, kx, ky)
end
