
BarWExitState = Class{__includes = BaseState}

local FURNITURE_BUFFER = 8

function BarWExitState:init(params)
    self.player = gGlobalObjs['player']
    self.bar = params.bar
    self.nextState = params.nextGameState
end

function BarWExitState:enter()
    self:tweenExit()
end

function BarWExitState:tweenExit()
    local ROW_X = VIRTUAL_WIDTH/2 - 100
    local TURN_X = VIRTUAL_WIDTH/2 - 20
    local TURN_Y = VIRTUAL_HEIGHT/2 + 20
    local CHAIR_X = TURN_X - 15
    local CHAIR_Y = TURN_Y - 30
    local DOOR_X = -20
    local DOOR_Y = VIRTUAL_HEIGHT - 100

    gSounds['footsteps']:setLooping(true)
    gSounds['footsteps']:play()

    -- Jump off from off the chair, and sit still for a second as if recovering
    -- from the landing
    self.player:changeAnimation('idle-right')
    Timer.tween(0.5,{
        [self.player] = {x = TURN_X, y = TURN_Y}
    }):finish(
        function()
    Timer.after(0.5,
        function()
    local walkPixels = DOOR_Y - self.player.y
    self.player:changeAnimation('walk-down')
    Timer.tween(self.player:getPixelWalkTime(walkPixels), {
        [self.player] = {x = ROW_X, y=DOOR_Y, scaleX=1.5, scaleY=1.5}
    }):finish(
        function()
    local walkPixels = self.player.x - DOOR_X
    self.player:changeAnimation('walk-left')
    Timer.tween(self.player:getPixelWalkTime(walkPixels), {
        [self.player] = {x = DOOR_X}
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
