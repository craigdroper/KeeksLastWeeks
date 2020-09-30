
CasWExitState = Class{__includes = BaseState}

function CasWExitState:init(params)
    self.player = gGlobalObjs['player']
    self.casino = params.casino
    self.nextState = params.nextState
end

function CasWExitState:enter()
    self:tweenExit()
end

function CasWExitState:tweenExit()
    local APRX_MID_TABLE_X = VIRTUAL_WIDTH/2 + 70
    local APRX_MID_TABLE_Y = VIRTUAL_HEIGHT - 130
    local APRX_TOP_TABLE_X = VIRTUAL_WIDTH - 80
    local APRX_DOOR_Y = (VIRTUAL_HEIGHT - self.player:getHeight()) / 2 + 30

    gSounds['footsteps']:setLooping(true)
    gSounds['footsteps']:play()

    -- Jump off from off the chair, and sit still for a second as if recovering
    -- from the landing
    self.player:changeAnimation('idle-right')
    Timer.tween(0.5,{
        [self.player] = {x = APRX_MID_TABLE_X, y = APRX_MID_TABLE_Y}
    }):finish(
        function()
    Timer.after(0.5,
        function()
    local walkPixels = APRX_TOP_TABLE_X - self.player.x
    self.player:changeAnimation('walk-right')
    Timer.tween(self.player:getPixelWalkTime(walkPixels), {
        [self.player] = {x = APRX_TOP_TABLE_X}
    }):finish(
        function()
    local walkPixels = self.player.y - APRX_DOOR_Y
    self.player:changeAnimation('walk-up')
    Timer.tween(self.player:getPixelWalkTime(walkPixels), {
        [self.player] = {y = APRX_DOOR_Y}
    }):finish(
        function()
    local walkPixels = VIRTUAL_WIDTH + 1 - self.player.x
    self.player:changeAnimation('walk-right')
    Timer.tween(self.player:getPixelWalkTime(walkPixels), {
        [self.player] = {x = VIRTUAL_WIDTH + 1}
    }):finish(
        function()
    gSounds['footsteps']:stop()
    gSounds['door']:play()
    gCasSounds['background']:stop()
    gStateStack:push(FadeInState({r = 255, g = 255, b = 255}, 1,
        function()
            -- Pop the CasWExitState off
            gStateStack:pop()
            gStateStack:push(self.nextState)
            gStateStack:push(FadeOutState({r = 255, g = 255, b = 255}, 1,
                function()
                end))
        end))
        end)
        end)
        end)
        end)
        end)
end

function CasWExitState:update(dt)
    self.player:update(dt)
end

function CasWExitState:render()
    self.casino:render()
    self.player:render()
end
