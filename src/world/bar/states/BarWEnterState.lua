
BarWEnterState = Class{__includes = BaseState}

local FURNITURE_BUFFER = 8

function BarWEnterState:init()
    self.player = gGlobalObjs['player']
    self.bar = Bar()
end

function BarWEnterState:enter()
    -- Set the player entity's scale factors to the correct values
    -- for this room's tile sizes
    self.player.scaleX = 0.75
    self.player.scaleY = 0.75
    -- Explicitly set the player's X & Y coordinates to be just outside
    -- of the right frame in line to walk into the bar withouth
    -- hitting any of the tables
    local botTableY = self.bar.furniture['vert-table-9'][4]
    local vertTableHeight = gFramesInfo['bar'][gBAR_VERT_TABLE]['height']
    self.player.x = VIRTUAL_WIDTH + 10
    self.player.y = botTableY + vertTableHeight + FURNITURE_BUFFER
    -- Setup tween entrance
    self:tweenEnter()
end

function BarWEnterState:tweenEnter()
    local stoolX = self.bar.furniture['barstool-3'][3]
    local stoolWidth = gFramesInfo['bar'][gBAR_LEFT_CHAIR]['width']
    local stoolY = self.bar.furniture['barstool-3'][4]
    local barX = self.bar.furniture['bar-base'][3]
    local barWidth = gFramesInfo['bar'][gBAR_BAR_EXT]['width']

    gSounds['door']:play()
    local doorDuration = gSounds['door']:getDuration()

    Timer.after(doorDuration,
        function()
    gSounds['footsteps']:setLooping(true)
    gSounds['footsteps']:play()

    -- Come in through the door, walk just under the lowest tables to
    -- the bar portion
    local walkPixels = self.player.x - (stoolX + stoolWidth + FURNITURE_BUFFER)
    self.player:changeAnimation('walk-left')
    Timer.tween(walkPixels / PLAYER_WALK_SPEED, {
        [self.player] = {x = stoolX + stoolWidth + FURNITURE_BUFFER}
    }):finish(
        function()
    -- Walk high enough to be in line with the target barstool
    walkPixels = self.player.y - stoolY
    self.player:changeAnimation('walk-up')
    Timer.tween(walkPixels / PLAYER_WALK_SPEED, {
        [self.player] = {y = stoolY}
    }):finish(
        function()
    -- Walk over "into" the chair, flush on the right side of the bar
    walkPixels = self.player.x - barX + barWidth
    self.player:changeAnimation('walk-left')
    Timer.tween(walkPixels / PLAYER_WALK_SPEED, {
        [self.player] = {x = barX + barWidth}
    }):finish(
        function()
    gSounds['footsteps']:stop()
    self.player:changeAnimation('idle-left')
    -- Pop the Bar Enter State off, and push the stationary state
    gStateStack:pop()
    gStateStack:push(BarWStationaryState({bar = self.bar}))
        end)
        end)
        end)
        end)
end

function BarWEnterState:update(dt)
    self.player:update(dt)
end

function BarWEnterState:render()
    self.bar:render()
    if self.player then
        self.player:render()
    end
end
