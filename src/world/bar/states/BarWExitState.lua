
BarWExitState = Class{__includes = BaseState}

local FURNITURE_BUFFER = 8

function BarWExitState:init(params)
    self.player = gGlobalObjs['player']
    self.bar = params.bar
    self.nextGameState = params.nextGameState
end

function BarWExitState:enter()
    self:tweenExit()
end

function BarWExitState:tweenExit()
    local stoolX = self.bar.furniture['barstool-3'][3]
    local stoolWidth = gFramesInfo['bar'][gBAR_LEFT_CHAIR]['width']
    local botTableY = self.bar.furniture['vert-table-9'][4]
    local vertTableHeight = gFramesInfo['bar'][gBAR_VERT_TABLE]['height']
    local stoolY = botTableY + vertTableHeight + FURNITURE_BUFFER
    local wallX = VIRTUAL_WIDTH + 10

    gSounds['footsteps']:setLooping(true)
    gSounds['footsteps']:play()

    local walkPixels = (stoolX + stoolWidth) - self.player.x
    self.player:changeAnimation('walk-right')
    Timer.tween(walkPixels / PLAYER_WALK_SPEED, {
        [self.player] = {x = stoolX + stoolWidth + FURNITURE_BUFFER}
    }):finish(
        function()
    walkPixels = stoolY - self.player.y
    self.player:changeAnimation('walk-down')
    Timer.tween(walkPixels / PLAYER_WALK_SPEED, {
        [self.player] = {y = stoolY}
    }):finish(
        function()
    walkPixels = wallX - self.player.x
    self.player:changeAnimation('walk-right')
    Timer.tween(walkPixels / PLAYER_WALK_SPEED, {
        [self.player] = {x = wallX}
    }):finish(
        function()
    gSounds['footsteps']:stop()
    gSounds['door']:play()
    gStateStack:push(FadeInState({r = 255, g = 255, b = 255}, 1,
        function()
            -- Pop the AptWExitState off
            gStateStack:pop()
            gStateStack:push(self.nextGameState)
            gStateStack:push(FadeOutState({r = 255, g = 255, b = 255}, 1,
                function()
                end))
        end))
        end)
        end)
        end)
end

function BarWExitState:update(dt)
    self.player:update(dt)
end

function BarWExitState:render()
    self.bar:render()
    if self.player then
        self.player:render()
    end
end
