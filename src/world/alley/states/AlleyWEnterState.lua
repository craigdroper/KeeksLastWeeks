
AlleyWEnterState = Class{__includes = BaseState}

function AlleyWEnterState:init()
    self.player = gGlobalObjs['player']
    self.alley = Alley()
end

function AlleyWEnterState:enter()
    -- Set the player entity's scale factors to the correct values
    -- for this room's tile sizes
    self.player.scaleX = 1.0
    self.player.scaleY = 1.0
    self.player.opacity = 0
    self.player.walkSpeed = 20
    -- Explicitly set the player's X & Y coordinates to be off screen, bottom left
    self.player.x = VIRTUAL_WIDTH * 2/3 - 5
    self.player.y = VIRTUAL_HEIGHT * 2/3
    -- Begin playing the casino background music
    gBarWSounds['exterior']:setLooping(true)
    gBarWSounds['exterior']:play()
    -- Setup tween entrance
    self:tweenEnter()
end

function AlleyWEnterState:tweenEnter()
    local STREET_Y = VIRTUAL_HEIGHT *3/4 - 10
    local ALLEY_X = 160
    local CAR_Y = STREET_Y - 5

    gSounds['door']:play()
    local doorDuration = gSounds['door']:getDuration()

    Timer.after(doorDuration,
        function()
    gSounds['footsteps']:setLooping(true)
    gSounds['footsteps']:play()

    local walkPixels = STREET_Y - self.player.y
    self.player:changeAnimation('walk-down')
    Timer.tween(self.player:getPixelWalkTime(walkPixels), {
        [self.player] = {y = STREET_Y, opacity = 255}
    }):finish(
        function()
    self.player.walkSpeed = 50
    local walkPixels = self.player.x - ALLEY_X
    self.player:changeAnimation('walk-left')
    Timer.tween(self.player:getPixelWalkTime(walkPixels), {
        [self.player] = {x = ALLEY_X}
    }):finish(
        function()
    self.player.walkSpeed = 5
    local walkPixels = self.player.y - CAR_Y
    self.player:changeAnimation('walk-up')
    Timer.tween(self.player:getPixelWalkTime(walkPixels), {
        [self.player] = {y = CAR_Y, scaleX = .75, scaleY = .75}
    }):finish(
        function()
    self.player.walkSpeed = 1
    local walkPixels = 2
    self.player:changeAnimation('walk-left')
    gSounds['door']:play()
    Timer.tween(self.player:getPixelWalkTime(walkPixels), {
        [self.player] = {opacity = 0}
    }):finish(
        function()
    gSounds['footsteps']:stop()
    -- Pop the Alley Enter State off, and push the stationary state
    gStateStack:pop()
    gStateStack:push(AlleyWStationaryState({alley = self.alley}))
        end)
        end)
        end)
        end)
        end)
end

function AlleyWEnterState:update(dt)
    self.player:update(dt)
end

function AlleyWEnterState:render()
    self.alley:render()
    if self.player then
        self.player:render()
    end
end
