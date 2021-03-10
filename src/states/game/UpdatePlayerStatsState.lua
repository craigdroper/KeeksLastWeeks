
UpdatePlayerStatsState = Class{__includes = BaseState}

function UpdatePlayerStatsState:init(params)
    -- Expecting stats to be a dict of strings
    self.player = params.player
    self.stats = params.stats
    self.statsKeys = {}
    for key, _ in pairs(self.stats) do
        table.insert(self.statsKeys, key)
    end
    self.hasUpdateStats = true
    if #self.statsKeys == 0 then
        self.hasUpdateStats = false
    end
    self.callback = params.callback and params.callback or function() end
    self.skipGameOver = params.skipGameOver and params.skipGameOver or false

    self.font = gFonts['huge']
    self.fontRGB = {}

    self.tweenTime = 1.5

    self.emptyStat = nil

    -- Stat update text fields
    self.curVal = nil
    self.text = nil
    self.textW = nil
    self.textH = nil
    self.textOpacity = nil
    self.textX = nil
    self.textY = nil
    self.textSX = nil
    self.textSY = nil
    -- Stat multiplier text field
    self.curMult = gGlobalObjs['filter']:getMultiplier()
    self.mult = nil
    self.multW = nil
    self.multH = nil
    self.multOpacity = nil
    self.multX = nil
    self.multY = nil
    self.multSX = nil
    self.multSY = nil
    -- The mid x and mid y points of a given stat's display in the upper
    -- right hand corner of the screen. This is the target for the tweening
    -- text, and the center point of the particle system
    self.statDispMidX = nil
    self.statDispMidY = nil

    -- Particle system for when the graphic has tweened into the stats area
    -- and the player's stats are actually updated
    self.psystem = love.graphics.newParticleSystem(gBGTextures['particle'], 64)
    self.psysX = nil
    self.psysY = nil
    self.psystemMinTime = 0.5
    self.psystemMaxTime = 1
    self.psystem:setParticleLifetime(self.psystemMinTime, self.psystemMaxTime)
    -- Emit in all directions approximately equally
    self.psystem:setLinearAcceleration(-15, 15, -15, 15)
    self.psystem:setAreaSpread('normal', 10, 10)

    self.isStatsChecked = false
end

function UpdatePlayerStatsState:checkStats()
    if #self.statsKeys > 0 then
        local statName = table.remove(self.statsKeys)
        self.curVal = self.stats[statName]
        self.curMult = gGlobalObjs['filter']:getMultiplier()
        if statName == TIME_NAME then
            self:tweenTimeUpdate()
        elseif statName == HEALTH_NAME then
            self:tweenHealthUpdate()
        elseif statName == MONEY_NAME then
            self:tweenMoneyUpdate()
        elseif statName == FUN_NAME then
            self:tweenFunUpdate()
        else
            error('Unhandled stat name: '..statName)
        end
    else
        -- All stats have been updated with the tweened graphics, pop
        -- this state off
        if self.skipGameOver or not self:checkGameOver() then
            gStateStack:pop()
            self.callback()
        end
    end
end

function UpdatePlayerStatsState:checkGameOver()
    if self.player.time <= 0 then
        self.emptyStat = TIME_NAME
    elseif self.player.health <= 0 then
        self.emptyStat = HEALTH_NAME
    elseif self.player.money <= 0 then
        self.emptyStat = MONEY_NAME
    end
    if self.emptyStat then
        self:tweenGameOver()
    end
    return self.emptyStat ~= nil
end

function UpdatePlayerStatsState:tweenGameOver()
    local blipLen = gGameOverSounds['blip']:getDuration() + 1
    local totalLen = 2*blipLen
    local flashTween = nil
    if self.emptyStat == TIME_NAME then
        flashTween = Timer.every(0.2,
            function()
                if self.player.timeOpac == 0 then
                    self.player.timeOpac = 255
                else
                    self.player.timeOpac = 0
                end
            end
        )
    elseif self.emptyStat == HEALTH_NAME then
        flashTween = Timer.every(0.2,
            function()
                if self.player.healthOpac == 0 then
                    self.player.healthOpac = 255
                else
                    self.player.healthOpac = 0
                end
            end
        )
    elseif self.emptyStat == MONEY_NAME then
        flashTween = Timer.every(0.2,
            function()
                if self.player.moneyOpac == 0 then
                    self.player.moneyOpac = 255
                else
                    self.player.moneyOpac = 0
                end
            end
        )
    end

    gGameOverSounds['blip']:play()
    local playTween = Timer.every(blipLen,
        function()
            gGameOverSounds['blip']:play()
        end
    )

    -- Super weird hack where it looks like when there isn't a stat to update
    -- and we just want to check if the stats indicated a game over (with no change
    -- to them) the Timer removal of the flash is messed up so we're just going
    -- to artificially manage this for this one off case
    if not self.hasUpdateStats then
        flashTween:limit(totalLen)
    end

    Timer.after(totalLen + 1,
        function()
            -- See hack comment above
            if self.hasUpdateStats then
                flashTween:remove()
            end
            playTween:remove()
            self.player.timeOpac = 255
            self.player.healthOpac = 255
            self.player.moneyOpac = 255
            gStateStack:push(FadeInState({r = 0, g = 0, b = 0}, 2,
                function()
                    gStateStack:clear()
                    gStateStack:push(GameOverGTitleState({emptyStat = self.emptyStat}))
                end))
    end)
end

function UpdatePlayerStatsState:tweenTimeUpdate()
    -- Time stats will never be affected by any drug multipliers
    self.curMult = nil
    self.fontRGB = TIME_RGB
    self.statDispMidX, self.statDispMidY =
        self.player:getStatMidCoords(TIME_NAME)
    self:tweenUpdate(function() self.player.time = self.player.time + self.totVal end)
end

function UpdatePlayerStatsState:tweenHealthUpdate()
    self.fontRGB = HEALTH_RGB
    self.statDispMidX, self.statDispMidY =
        self.player:getStatMidCoords(HEALTH_NAME)
    self:tweenUpdate(function() self.player.health = self.player.health + self.totVal end)
end

function UpdatePlayerStatsState:tweenMoneyUpdate()
    -- Money stats will never be affected by any drug multipliers
    self.curMult = nil
    self.fontRGB = MONEY_RGB
    self.statDispMidX, self.statDispMidY =
        self.player:getStatMidCoords(MONEY_NAME)
    self:tweenUpdate(function() self.player.money = self.player.money + self.totVal end)
end

function UpdatePlayerStatsState:tweenFunUpdate()
    self.fontRGB = FUN_RGB
    self.statDispMidX, self.statDispMidY =
        self.player:getStatMidCoords(FUN_NAME)
    self:tweenUpdate(function() self.player.fun = self.player.fun + self.totVal end)
end

function UpdatePlayerStatsState:setTextMembers(val)
    self.text = string.format('%s%d', (val<0) and '' or '+', val)
    self.textW = self.font:getWidth(self.text)
    self.textH = self.font:getHeight()
    self.textX = (VIRTUAL_WIDTH - self.textW)/2
    self.textY = (VIRTUAL_HEIGHT - self.textH)/2
end

function UpdatePlayerStatsState:tweenUpdate(statUpdFunc)
    self:setTextMembers(self.curVal)
    self.textOpacity = 0
    self.textSX = 1
    self.textSY = 1
    self.psystem:setColors(
        self.fontRGB.r, self.fontRGB.g, self.fontRGB.b, 128,
        self.fontRGB.r, self.fontRGB.g, self.fontRGB.b, 0
    )

    if self.curMult ~= nil then
        self.mult = string.format('x%d', self.curMult)
        self.multW = self.font:getWidth(self.mult)
        self.multH = self.font:getHeight()
        self.multOpacity = 0
        self.multX = (VIRTUAL_WIDTH - self.multW)/2
        self.multY = self.textY + self.textH
        self.multSX = 1
        self.multSY = 1
    else
        -- To satisfy print call in render
        self.mult = ''
    end
    self.totVal = self.curVal * (self.curMult ~= nil and self.curMult or 1)

    self:tweenStatDisp(
    function()
        if self.curMult ~= nil then
            self:tweenMultDisp(function() self:tweenStatUpd(statUpdFunc) end)
        else
            self:tweenStatUpd(statUpdFunc)
        end
    end)
end

function UpdatePlayerStatsState:tweenStatDisp(callback)
    Timer.tween(self.tweenTime, {
        [self] = {textOpacity = 255}
    }):finish(function() callback() end)
end

function UpdatePlayerStatsState:tweenMultDisp(callback)
    Timer.tween(self.tweenTime, {
        [self] = {multOpacity = 255}
    }):finish(
    function()
        Timer.tween(self.tweenTime/2, {
            [self] = {multY = self.textY}
    }):finish(
    function()
        self.multOpacity = 0
        self:setTextMembers(self.totVal)
        self.psysX = self.textX + self.textW/2
        self.psysY = self.textY + self.textH/2
        self.psystem:emit(64)
        Timer.after(self.psystemMaxTime,
    function()
        callback()
    end)
    end)
    end)
end

function UpdatePlayerStatsState:tweenStatUpd(statUpdFunc)
    Timer.tween(self.tweenTime, {
        [self] = {textX = self.statDispMidX,
                  textY = self.statDispMidY,
                  textSX = 0,
                  textSY = 0}
    })
    :finish(function()
        statUpdFunc()
        self.psysX = self.statDispMidX
        self.psysY = self.statDispMidY
        self.psystem:emit(64)
        Timer.after(self.psystemMaxTime,
            function()
        -- Timer tween "after" call for check stats to give the particle
        -- system time to render
        self:checkStats()
            end)
            end)
end

function UpdatePlayerStatsState:update(dt)
    if not self.isStatsChecked then
        self:checkStats()
        self.isStatsChecked = true
    end
    self.psystem:update(dt)
end

function UpdatePlayerStatsState:render()
    if self.isStatsChecked and self.hasUpdateStats then
        love.graphics.setFont(self.font)

        love.graphics.setColor(self.fontRGB.r, self.fontRGB.g, self.fontRGB.b, self.textOpacity)
        love.graphics.print(self.text, self.textX, self.textY, 0, self.textSX, self.textSY)

        -- Multiplier will always be black
        love.graphics.setColor(0, 0, 0, self.multOpacity)
        love.graphics.print(self.mult, self.multX, self.multY, 0, self.multSX, self.multSY)

        love.graphics.setColor(255, 255, 255, 255)

        -- Render psystem after/over any of the text
        love.graphics.filterDrawD(self.psystem, self.psysX, self.psysY)
    end
end
