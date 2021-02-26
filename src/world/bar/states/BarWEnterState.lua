
BarWEnterState = Class{__includes = BaseState}

function BarWEnterState:init()
    self.player = gGlobalObjs['player']
    self.bar = BarWInterior()
end

function BarWEnterState:enter()
    -- Set the player entity's scale factors to the correct values
    -- for this room's tile sizes
    self.player.scaleX = 1.5
    self.player.scaleY = 1.5
    self.player.opacity = 255
    self.player.walkSpeed = 50
    -- Explicitly set the player's X & Y coordinates to be off screen, bottom left
    self.player.x = -self.player:getWidth() - 10
    self.player.y = VIRTUAL_HEIGHT - 100
    -- Setup tween entrance
    self:tweenEnter()
    -- Begin playing the street white noise
    gBarWSounds['interior']:setLooping(true)
    gBarWSounds['interior']:play()
end

function BarWEnterState:tweenEnter()
    local ROW_X = VIRTUAL_WIDTH/2 - 100
    local TURN_X = VIRTUAL_WIDTH/2 - 20
    local TURN_Y = VIRTUAL_HEIGHT/2 + 20
    local CHAIR_X = TURN_X - 15
    local CHAIR_Y = TURN_Y - 30

    gSounds['door']:play()
    local doorDuration = gSounds['door']:getDuration()

    Timer.after(doorDuration,
        function()
    gSounds['footsteps']:setLooping(true)
    gSounds['footsteps']:play()

    -- Come just inside and subtract the door fee
    local walkPixels = ROW_X - self.player.x
    self.player:changeAnimation('walk-right')
    Timer.tween(self.player:getPixelWalkTime(walkPixels), {
        [self.player] = {x = ROW_X}
    }):finish(
        function()
    walkPixels = self.player.y - TURN_Y
    self.player:changeAnimation('walk-up')
    Timer.tween(self.player:getPixelWalkTime(walkPixels), {
        [self.player] = {x = TURN_X, y=TURN_Y, scaleX=1, scaleY=1}
    }):finish(
        function()
    self.player:changeAnimation('idle-left')
    Timer.after(0.5,
        function()
    -- "Hop/Jump" onto the mid table chair facing left after a small wind up
    -- pause for the jump
    gSounds['footsteps']:stop()
    gSounds['jump']:play()
    Timer.tween(0.5, {
        [self.player] = {x = CHAIR_X, y = CHAIR_Y}
    }):finish(
        function()
    -- Pop the bar Enter State off, and Push bar stationary state
    gStateStack:pop()
    gStateStack:push(BarWStationaryState({bar = self.bar}))
        end)
        end)
        end)
        end)
        end)
end

function BarWEnterState:update(dt)
    self.player:update(dt)
end

function BarWEnterState:render()
    self.bar:render()
    if self.player then
        self.player:render()
    end
end
