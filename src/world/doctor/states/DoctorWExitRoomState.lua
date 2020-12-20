
DoctorWExitRoomState = Class{__includes = BaseState}

function DoctorWExitRoomState:init(params)
    self.player = gGlobalObjs['player']
    self.room = DoctorWRoom()
    self.nextGameState = params.nextGameState
end

function DoctorWExitRoomState:enter()
    self:tweenExit()
end

function DoctorWExitRoomState:tweenExit()
    local START_Y = VIRTUAL_HEIGHT  - self.player.height * self.player.scaleY
    local BED_BASE_X = VIRTUAL_WIDTH * 2/3
    local BED_BASE_Y = VIRTUAL_HEIGHT * 2/3
    local BED_TOP_X = VIRTUAL_WIDTH/2 + 60
    local BED_TOP_Y = VIRTUAL_HEIGHT/2 - 10

    self.player:changeAnimation('idle-right')
    Timer.after(0.5,
        function()
    gSounds['jump']:play()
    Timer.tween(0.5, {
        [self.player] = {x = BED_BASE_X, y = BED_BASE_Y}
    }):finish(
        function()
    gSounds['footsteps']:setLooping(true)
    gSounds['footsteps']:play()
    -- Walk up to get vertically level with the bed
    local walkPixels = START_Y - self.player.y
    self.player:changeAnimation('walk-down')
    Timer.tween(self.player:getPixelWalkTime(walkPixels), {
        [self.player] = {y = START_Y}
    }):finish(
        function()
    local walkPixels = VIRTUAL_WIDTH - self.player.x
    self.player:changeAnimation('walk-right')
    Timer.tween(self.player:getPixelWalkTime(walkPixels), {
        [self.player] = {x = VIRTUAL_WIDTH}
    }):finish(
        function()
    gSounds['footsteps']:stop()
    gSounds['door']:play()
    gStateStack:push(FadeInState({r = 255, g = 255, b = 255}, 1,
        function()
            -- Pop the DoctorWExit off
            gDoctorSounds['background']:stop()
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

function DoctorWExitRoomState:update(dt)
    self.player:update(dt)
end

function DoctorWExitRoomState:render()
    self.room:render()
    self.player:render()
end
