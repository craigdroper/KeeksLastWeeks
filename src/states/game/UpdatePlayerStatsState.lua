
UpdatePlayerStatsState = Class{__includes = BaseState}

function UpdatePlayerStatsState:init(params)
    -- Expecting stats to be a dict of strings
    self.player = params.player
    self.stats = params.stats
    self.statsKeys = {}
    for key, _ in pairs(self.stats) do
        table.insert(self.statsKeys, key)
    end
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
    -- The mid x and mid y points of a given stat's display in the upper
    -- right hand corner of the screen. This is the target for the tweening
    -- text, and the center point of the particle system
    self.statDispMidX = nil
    self.statDispMidY = nil

    -- Particle system for when the graphic has tweened into the stats area
    -- and the player's stats are actually updated
    self.psystem = love.graphics.newParticleSystem(gBGTextures['particle'], 64)
    self.psystemMinTime = 0.5
    self.psystemMaxTime = 1
    self.psystem:setParticleLifetime(self.psystemMinTime, self.psystemMaxTime)
    -- Emit in all directions approximately equally
    self.psystem:setLinearAcceleration(-15, 15, -15, 15)
    self.psystem:setAreaSpread('normal', 10, 10)


    self:checkStats()
end

function UpdatePlayerStatsState:checkStats()
    if #self.statsKeys > 0 then
        local statName = table.remove(self.statsKeys)
        local statVal = self.stats[statName]
        if statName == TIME_NAME then
            self:tweenTimeUpdate(statVal)
        elseif statName == HEALTH_NAME then
            self:tweenHealthUpdate(statVal)
        elseif statName == MONEY_NAME then
            self:tweenMoneyUpdate(statVal)
        elseif statName == FUN_NAME then
            self:tweenFunUpdate(statVal)
        else
            error('Unhandled stat name: '..statName)
        end
    else
        -- All stats have been updated with the tweened graphics, pop
        -- this state off
        gStateStack:pop()
        self.callback()
    end
end

function UpdatePlayerStatsState:tweenTimeUpdate(val)
    self.fontRGB = TIME_RGB
    self.statDispMidX, self.statDispMidY =
        self.player:getStatMidCoords(TIME_NAME)
    self:tweenUpdate(val, function() self.player.time = self.player.time + val end)
end

function UpdatePlayerStatsState:tweenHealthUpdate(val)
    self.fontRGB = HEALTH_RGB
    self.statDispMidX, self.statDispMidY =
        self.player:getStatMidCoords(HEALTH_NAME)
    self:tweenUpdate(val, function() self.player.health = self.player.health + val end)
end

function UpdatePlayerStatsState:tweenMoneyUpdate(val)
    self.fontRGB = MONEY_RGB
    self.statDispMidX, self.statDispMidY =
        self.player:getStatMidCoords(MONEY_NAME)
    self:tweenUpdate(val, function() self.player.money = self.player.money + val end)
end

function UpdatePlayerStatsState:tweenFunUpdate(val)
    self.fontRGB = FUN_RGB
    self.statDispMidX, self.statDispMidY =
        self.player:getStatMidCoords(FUN_NAME)
    self:tweenUpdate(val, function() self.player.fun = self.player.fun + val end)
end

function UpdatePlayerStatsState:tweenUpdate(val, statUpdFunc)
    self.text = string.format('%s%s', (val<0) and '' or '+', val)
    self.textW = self.font:getWidth(self.text)
    self.textH = self.font:getHeight()
    self.opacity = 0
    self.x = (VIRTUAL_WIDTH - self.textW)/2
    self.y = (VIRTUAL_HEIGHT - self.textH)/2
    self.sx = 1
    self.sy = 1
    self.psystem:setColors(
        self.fontRGB.r, self.fontRGB.g, self.fontRGB.b, 128,
        self.fontRGB.r, self.fontRGB.g, self.fontRGB.b, 0
    )

    Timer.tween(2, {
        [self] = {opacity = 255}
    })
    :finish(function()
        Timer.tween(2, {
        [self] = {x = self.statDispMidX, y = self.statDispMidY, sx = 0, sy = 0}
    })
    :finish(function()
        statUpdFunc()
        self.psystem:emit(64)
        Timer.after(self.psystemMaxTime,
            function()
        -- Timer tween "after" call for check stats to give the particle
        -- system time to render
        self:checkStats()
            end)
            end)
            end)
end

function UpdatePlayerStatsState:update(dt)
    self.psystem:update(dt)
end

function UpdatePlayerStatsState:render()
    love.graphics.setFont(self.font)
    love.graphics.setColor(self.fontRGB.r, self.fontRGB.g, self.fontRGB.b, self.opacity)
    love.graphics.print(self.text, self.x, self.y, 0, self.sx, self.sy)
    love.graphics.setColor(255, 255, 255, 255)

    -- Render psystem after/over any of the text
    love.graphics.filterDrawD(self.psystem, self.statDispMidX, self.statDispMidY)
end
