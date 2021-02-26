
AlleyWExitState = Class{__includes = BaseState}

local BUFFER = 2

function AlleyWExitState:init(params)
    self.player = gGlobalObjs['player']
    self.alley = params.alley
    self.nextState = params.nextState
end

function AlleyWExitState:enter()
    self:tweenExit()
end

function AlleyWExitState:tweenExit()
    -- Animate the player walking right on the sidewalk out of frame
    local EXIT_X = -self.player:getWidth() - 1

    gSounds['footsteps']:setLooping(true)
    gSounds['footsteps']:play()

    self.player.walkSpeed = 50
    local walkPixels = self.player:getX()  - EXIT_X
    self.player:changeAnimation('walk-left')
    Timer.tween(self.player:getPixelWalkTime(walkPixels), {
        [self.player] = {x = EXIT_X}
    }):finish(
        function()
    gSounds['footsteps']:stop()
    gStateStack:push(FadeInState({r = 255, g = 255, b = 255}, 1,
        function()
            -- Pop the Alley Exist off
            gStateStack:pop()
            gStateStack:push(self.nextState)
            gStateStack:push(FadeOutState({r = 255, g = 255, b = 255}, 1,
                function()
                end))
        end))
        end)
end

function AlleyWExitState:update(dt)
    self.player:update(dt)
end

function AlleyWExitState:render()
    self.alley:render()
    if self.player then
        self.player:render()
    end
end
