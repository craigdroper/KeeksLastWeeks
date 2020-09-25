
UpdatePlayerStatsState = Class{__includes = BaseState}

function UpdatePlayerStatsState:init(params)
    -- Expecting stats to be a dict of strings
    self.player = params.player
    self.stats = params.stats
    self.callback = params.callback

    self.font = gFonts['huge']
    self.fontRGB = {}

    -- Stat update text fields
    self.text = nil
    self.textW = nil
    self.textH = nil
    self.opacity = nil
    self.x = nil
    self.y = nil
    self.sx = nil
    self.sy = nil

    self:checkStats()
end

function UpdatePlayerStatsState:checkStats()
    for statName, val in pairs(self.stats) do
        if statName == 'time' then
            -- Assuming pairs iterates from head to tail
            table.remove(self.stats, 1)
            self:tweenTimeUpdate(val)
        else
            error('Unhandled stat name: '..statName)
        end
        -- NOTE: Early return here, only if there are no items left in
        -- the stats table do we not return early
        return
    end
    -- All stats have been updated with the tweened graphics, pop
    -- this state off
    gStateStack:pop()
    self.callback()
end

function UpdatePlayerStatsState:tweenTimeUpdate(val)
    self.fontRGB = TIME_RGB
    self.text = string.format('%s%s', (val<0) and '' or '+', val)
    self.textW = self.font:getWidth(self.text)
    self.textH = self.font:getHeight()
    self.opacity = 0
    self.x = (VIRTUAL_WIDTH - self.textW)/2
    self.y = (VIRTUAL_HEIGHT - self.textH)/2
    self.sx = 1
    self.sy = 1

    Timer.tween(2, {
        [self] = {opacity = 255}
    })
    :finish(function()
        Timer.tween(2, {
        [self] = {x = VIRTUAL_WIDTH, y = 0, sx = 0, sy = 0}
    })
    :finish(function()
        self.player.time = self.player.time + val
        -- TODO particle system
        -- Timer tween "after" call for check stats to give the particle
        -- system time to render
        self:checkStats()
            end)
            end)
end

function UpdatePlayerStatsState:render()
    love.graphics.setFont(self.font)
    love.graphics.setColor(self.fontRGB.r, self.fontRGB.g, self.fontRGB.b, self.opacity)
    love.graphics.print(self.text, self.x, self.y, 0, self.sx, self.sy)
    love.graphics.setColor(255, 255, 255, 255)
end
