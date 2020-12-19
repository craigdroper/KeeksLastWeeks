
WorkWExitOfficeState = Class{__includes = BaseState}

function WorkWExitOfficeState:init(params)
    self.player = gGlobalObjs['player']
    self.office = WorkWOffice()
    self.nextGameState = params.nextGameState
end

function WorkWExitOfficeState:enter()
    self:tweenExit()
end

function WorkWExitOfficeState:tweenExit()
    local APRX_TURN_X = VIRTUAL_WIDTH/2 + 20
    local DESK_Y = VIRTUAL_HEIGHT*2/4 + 25
    local DESK_X = VIRTUAL_WIDTH *3/4 - 45
    local START_HOP_X = DESK_X - 40
    local MID_HOP_X = (DESK_X + START_HOP_X)/2
    local HOP_Y = DESK_Y - 40
    local MEETING_Y = VIRTUAL_HEIGHT/2  - 40
    local ANNOUNCEMENT_X = APRX_TURN_X + 25
    local ANNOUNCEMENT_Y = MEETING_Y + 20

    gSounds['footsteps']:setLooping(true)
    gSounds['footsteps']:play()

    local walkPixels = DESK_Y - self.player.y
    self.player:changeAnimation('walk-down')
    Timer.tween(self.player:getPixelWalkTime(walkPixels), {
        [self.player] = {y = DESK_Y,
                         scaleX = 2, scaleY = 2}
    }):finish(
        function()
    local walkPixels = VIRTUAL_HEIGHT - self.player.y
    Timer.tween(self.player:getPixelWalkTime(walkPixels), {
        [self.player] = {x = 0, y = VIRTUAL_HEIGHT + 4}
    }):finish(
        function()
    gSounds['footsteps']:stop()
    gSounds['door']:play()
    gStateStack:push(FadeInState({r = 255, g = 255, b = 255}, 1,
        function()
            -- Pop the WorkWExit off
            gWorkSounds['background']:stop()
            gStateStack:pop()
            gStateStack:push(self.nextGameState)
            gStateStack:push(FadeOutState({r = 255, g = 255, b = 255}, 1,
                function()
                end))
        end))
        end)
        end)
end

function WorkWExitOfficeState:update(dt)
    self.player:update(dt)
end

function WorkWExitOfficeState:render()
    self.office:render()
    self.player:render()
end
