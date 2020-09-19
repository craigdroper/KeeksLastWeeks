
AptWExitState = Class{__includes = BaseState}

local FURNITURE_BUFFER = 8
local ARMREST_OFFSET = 7
local TOP_COUCH_OFFSET = 12

function AptWExitState:init(params)
    self.player = gGlobalObjs['player']
    self.apartment = params.apartment
    self.nextGameState = params.nextGameState
end

function AptWExitState:enter()
    self:tweenExit()
end

function AptWExitState:tweenExit()
    -- Setup the tween action to animate the player walking from the
    -- couch out of the apartment
    local tableY = self.apartment.furniture['coffee-table'][4]
    local counterX = self.apartment.furniture['vertical-long-counter'][3]
    local chairY = self.apartment.furniture['desk-chair'][4]
    local wallX = VIRTUAL_WIDTH + 10

    gSounds['footsteps']:setLooping(true)
    gSounds['footsteps']:play()

    -- Get off couch and walk to limit of coffee table
    local walkPixels = tableY - self.player.y - self.player.height - FURNITURE_BUFFER
    self.player:changeAnimation('walk-down')
    Timer.tween(walkPixels / PLAYER_WALK_SPEED, {
        [self.player] = {y = tableY - self.player.height - FURNITURE_BUFFER}
    }):finish(
        function()
    walkPixels = counterX - self.player.x - self.player.width - FURNITURE_BUFFER
    self.player:changeAnimation('walk-right')
    Timer.tween(walkPixels / PLAYER_WALK_SPEED, {
        [self.player] = {x = counterX - self.player.width - FURNITURE_BUFFER}
    }):finish(
        function()
    walkPixels = chairY - self.player.y - self.player.height - FURNITURE_BUFFER
    self.player:changeAnimation('walk-down')
    Timer.tween(walkPixels / PLAYER_WALK_SPEED, {
        [self.player] = {y = chairY - self.player.height - FURNITURE_BUFFER}
    }):finish(
        function()
    walkPixels = wallX - self.player.x + self.player.width
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
        end)
end

function AptWExitState:update(dt)
    self.player:update(dt)
end

function AptWExitState:render()
    self.apartment:render()
    if self.player then
        self.player:render()
    end
end
