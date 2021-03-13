
AlleyWExitHomeState = Class{__includes = BaseState}

function AlleyWExitHomeState:init(params)
    self.player = gGlobalObjs['player']
    self.alley = params.alley
end

function AlleyWExitHomeState:enter()
    self:tweenExit()
end

function AlleyWExitHomeState:tweenExit()
    local STREET_Y = VIRTUAL_HEIGHT *3/4 - 10
    local DOOR_X = VIRTUAL_WIDTH * 2/3 - 5
    local DOOR_Y = VIRTUAL_HEIGHT * 2/3

    gSounds['footsteps']:setLooping(true)
    gSounds['footsteps']:play()
    gSounds['door']:play()
    local walkPixels = 2
    self.player:changeAnimation('walk-right')
    Timer.tween(self.player:getPixelWalkTime(walkPixels), {
        [self.player] = {x=x, opacity = 255}
    }):finish(
        function()
    self.player.walkSpeed = 5
    local walkPixels = STREET_Y - self.player.y
    self.player:changeAnimation('walk-down')
    Timer.tween(self.player:getPixelWalkTime(walkPixels), {
        [self.player] = {y = STREET_Y, scaleX=1, scaleY=1}
    }):finish(
        function()
    self.player.walkSpeed = 50
    local walkPixels = DOOR_X - self.player.x
    self.player:changeAnimation('walk-right')
    Timer.tween(self.player:getPixelWalkTime(walkPixels), {
        [self.player] = {x = DOOR_X}
    }):finish(
        function()
    local walkPixels = self.player.y - DOOR_Y
    self.player.walkSpeed = 20
    self.player:changeAnimation('walk-up')
    Timer.tween(self.player:getPixelWalkTime(walkPixels), {
        [self.player] = {y = DOOR_Y, opacity=0}
    }):finish(
        function()
    -- Pop the Alley Exit off
    gStateStack:pop()
    gStateStack:push(AptWEnterState())
    gStateStack:push(FadeOutState({r = 255, g = 255, b = 255}, 1,
        function()
        end))
        end)
        end)
        end)
        end)
end

function AlleyWExitHomeState:update(dt)
    self.player:update(dt)
end

function AlleyWExitHomeState:render()
    self.alley:render()
    if self.player then
        self.player:render()
    end
end
