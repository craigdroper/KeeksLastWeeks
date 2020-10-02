
DateWExitState = Class{__includes = BaseState}

function DateWExitState:init(params)
    self.player = gGlobalObjs['player']
    self.rest = params.rest
end

function DateWExitState:enter()
    self:tweenExit()
end

function DateWExitState:tweenExit()
    local APRX_MID_TABLE_X = VIRTUAL_WIDTH / 3 + 55
    local APRX_MID_TABLE_Y = VIRTUAL_HEIGHT / 2 - 10
    local X_SHIFT = APRX_MID_TABLE_X + 60
    local EXIT_X = -200
    local EXIT_Y = VIRTUAL_HEIGHT + 10

    gSounds['footsteps']:setLooping(true)
    gSounds['footsteps']:play()

    -- Walk to the middle of the restaurant before the shift
    local walkPixels = APRX_MID_TABLE_Y - self.player.y
    self.player:changeAnimation('walk-down')
    Timer.tween(self.player:getPixelWalkTime(walkPixels), {
        [self.player] = {x = X_SHIFT, y = APRX_MID_TABLE_Y,
                         scaleX = 1, scaleY = 1}
    }):finish(
        function()
    self.player.walkSpeed = 40
    local walkPixels = self.player.x - APRX_MID_TABLE_X
    self.player:changeAnimation('walk-left')
    Timer.tween(self.player:getPixelWalkTime(walkPixels), {
        [self.player] = {x = APRX_MID_TABLE_X}
    }):finish(
        function()
    local walkPixels = EXIT_Y - self.player.y
    self.player:changeAnimation('walk-down')
    Timer.tween(self.player:getPixelWalkTime(walkPixels), {
        [self.player] = {x = EXIT_X, y = EXIT_Y,
                         scaleX = 5, scaleY = 5}
    }):finish(
        function()
    gSounds['door']:play()
    gSounds['footsteps']:stop()
    gDateSounds['background']:stop()
    gStateStack:push(FadeInState({r = 255, g = 255, b = 255}, 1,
        function()
            -- Pop the DateWExitState off
            gStateStack:pop()
            gStateStack:push(AptWEnterState())
            gStateStack:push(FadeOutState({r = 255, g = 255, b = 255}, 1,
                function()
                end))
        end))

        end)
        end)
        end)
end

function DateWExitState:update(dt)
    self.player:update(dt)
end

function DateWExitState:render()
    self.rest:render()
    self.player:render()
end
