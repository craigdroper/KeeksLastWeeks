
AptWExitState = Class{__includes = BaseState}

--local FURNITURE_BUFFER = 8
--local ARMREST_OFFSET = 7
-- local TOP_COUCH_OFFSET = 12

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
    local carpetTurnX = VIRTUAL_WIDTH * 3/4 - 30
    local couchTurnY = VIRTUAL_HEIGHT * 1/2
    local exitY = VIRTUAL_HEIGHT * 3/4 - 20

    Timer.after(0.5,
        function()
    -- "Hop/Jump" onto the mid table chair facing left after a small wind up
    -- pause for the jump
    -- gSounds['footsteps']:stop()
    gSounds['jump']:play()
    Timer.tween(0.3, {
        [self.player] = {y = couchTurnY}
    }):finish(
        function()
    gSounds['footsteps']:setLooping(true)
    gSounds['footsteps']:play()
    -- Get off couch and walk to limit of coffee table
    local walkPixels = exitY - self.player.y
    self.player:changeAnimation('walk-down')
    Timer.tween(self.player:getPixelWalkTime(walkPixels), {
        [self.player] = {y = exitY, scaleX = 1.8, scaleY = 1.8}
    }):finish(
        function()
    walkPixels = VIRTUAL_WIDTH - self.player.x
    self.player:changeAnimation('walk-right')
    Timer.tween(self.player:getPixelWalkTime(walkPixels), {
        [self.player] = {x = VIRTUAL_WIDTH}
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
