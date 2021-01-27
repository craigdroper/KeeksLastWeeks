
BarWEnterExteriorState = Class{__includes = BaseState}

function BarWEnterExteriorState:init()
    self.player = gGlobalObjs['player']
    self.exterior = BarWExterior()
end

function BarWEnterExteriorState:enter()
    -- Set the player entity's scale factors to the correct values
    -- for this room's tile sizes
    self.player.scaleX = 2
    self.player.scaleY = 2
    self.player.opacity = 255
    self.player.walkSpeed = 20
    -- Explicitly set the player's X & Y coordinates to be the horizontally
    -- in the middle of the screen, but out of frame to the bottom of the screen
    self.player.x = VIRTUAL_WIDTH/2 - self.player:getWidth()/2 + 50
    self.player.y = VIRTUAL_HEIGHT + 1
    -- Setup tween entrance
    self:tweenEnter()
    -- Begin playing the casino background music
    gBarWSounds['exterior']:setLooping(true)
    gBarWSounds['exterior']:play()
end

function BarWEnterExteriorState:tweenEnter()
    local DOOR_Y = VIRTUAL_HEIGHT/2 + 70
    local BOUNCER_X = VIRTUAL_WIDTH/2 - 20

    gSounds['footsteps']:setLooping(true)
    gSounds['footsteps']:play()

    -- Come just inside and subtract the door fee
    local walkPixels = self.player.y - DOOR_Y
    self.player:changeAnimation('walk-up')
    Timer.tween(self.player:getPixelWalkTime(walkPixels), {
        [self.player] = {y = DOOR_Y, scaleX=1, scaleY=1}
    }):finish(
        function()
    local walkPixels = self.player.x - BOUNCER_X
    self.player:changeAnimation('walk-left')
    Timer.tween(self.player:getPixelWalkTime(walkPixels), {
        [self.player] = {x = BOUNCER_X}
    }):finish(
        function()
    self.player:changeAnimation('idle-left')
    gSounds['footsteps']:stop()
    -- Pop the date Enter State off, and Push Host Welcome state
    gStateStack:pop()
    gStateStack:push(BarWBouncerState({exterior = self.exterior}))
        end)
        end)
end

function BarWEnterExteriorState:update(dt)
    self.player:update(dt)
end

function BarWEnterExteriorState:render()
    self.exterior:render()
    self.player:render()
end
