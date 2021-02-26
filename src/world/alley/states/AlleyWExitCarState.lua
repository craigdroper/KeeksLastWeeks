
AlleyWExitCarState = Class{__includes = BaseState}

function AlleyWExitCarState:init(params)
    self.player = gGlobalObjs['player']
    self.alley = params.alley
end

function AlleyWExitCarState:enter()
    self:tweenExit()
end

function AlleyWExitCarState:tweenExit()
    local STREET_Y = VIRTUAL_HEIGHT *3/4 - 10

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
    gSounds['footsteps']:stop()
    self.player:changeAnimation('idle-down')
    gStateStack:push(AlleyWFunMenuState({alley = self.alley}))
        end)
        end)
end

function AlleyWExitCarState:update(dt)
    self.player:update(dt)
end

function AlleyWExitCarState:render()
    self.alley:render()
    if self.player then
        self.player:render()
    end
end
