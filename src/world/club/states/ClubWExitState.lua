
ClubWExitState = Class{__includes = BaseState}

local FURNITURE_BUFFER = 8

function ClubWExitState:init(params)
    self.player = gGlobalObjs['player']
    self.club = params.club
    self.nextState = params.nextState
end

function ClubWExitState:enter()
    self:tweenExit()
end

function ClubWExitState:tweenExit()
    local botY = VIRTUAL_HEIGHT + 1

    gSounds['footsteps']:setLooping(true)
    gSounds['footsteps']:play()

    local walkPixels = botY - self.player:getY()
    self.player:changeAnimation('walk-down')
    Timer.tween(self.player:getPixelWalkTime(walkPixels), {
        [self.player] = {y = botY}
    }):finish(
        function()
    gSounds['footsteps']:stop()
    gSounds['door']:play()
    gClubSounds['background']:stop()
    gStateStack:push(FadeInState({r = 255, g = 255, b = 255}, 1,
        function()
            -- Pop the ClubWExitState off
            gStateStack:pop()
            gStateStack:push(self.nextState)
            gStateStack:push(FadeOutState({r = 255, g = 255, b = 255}, 1,
                function()
                end))
        end))
        end)
end

function ClubWExitState:update(dt)
    self.player:update(dt)
end

function ClubWExitState:render()
    self.club:renderBase()
    if self.player then
        self.player:render()
    end
    self.club:renderEffects()
end
