
CasWEnterState = Class{__includes = BaseState}

function CasWEnterState:init()
    self.player = gGlobalObjs['player']
    self.casino = Casino()
end

function CasWEnterState:enter()
    -- Set the player entity's scale factors to the correct values
    -- for this room's tile sizes
    self.player.scaleX = 1.
    self.player.scaleY = 1.
    self.player.opacity = 255
    self.player.walkSpeed = 60
    -- Explicitly set the player's X & Y coordinates to be centered vertically
    -- and just out of frame on the right
    local doorY = (VIRTUAL_HEIGHT - self.player:getHeight()) / 2 + 30
    self.player.x = VIRTUAL_WIDTH + 1
    self.player.y = doorY
    -- Setup tween entrance
    self:tweenEnter()
    -- Begin playing the casino background music
    gCasSounds['background']:setLooping(true)
    gCasSounds['background']:play()
end

function CasWEnterState:tweenEnter()
    local APRX_TOP_TABLE_X = VIRTUAL_WIDTH - 80
    local APRX_MID_TABLE_Y = VIRTUAL_HEIGHT - 130
    local APRX_MID_TABLE_RIGHT_X = VIRTUAL_WIDTH/2 + 70
    local APRX_MID_TABLE_CHAIR_X = VIRTUAL_WIDTH/2 + 40
    local APRX_MID_TABLE_CHAIR_Y = VIRTUAL_HEIGHT/2

    gSounds['door']:play()
    local doorDuration = gSounds['door']:getDuration()

    Timer.after(doorDuration,
        function()
    gSounds['footsteps']:setLooping(true)
    gSounds['footsteps']:play()

    -- Come just inside and subtract the door fee
    local walkPixels = self.player.x - APRX_TOP_TABLE_X
    self.player:changeAnimation('walk-left')
    Timer.tween(self.player:getPixelWalkTime(walkPixels), {
        [self.player] = {x = APRX_TOP_TABLE_X}
    }):finish(
        function()
    local walkPixels = APRX_MID_TABLE_Y - self.player.y
    self.player:changeAnimation('walk-down')
    Timer.tween(self.player:getPixelWalkTime(walkPixels), {
        [self.player] = {y = APRX_MID_TABLE_Y}
    }):finish(
        function()
    local walkPixels = self.player.x - APRX_MID_TABLE_RIGHT_X
    self.player:changeAnimation('walk-left')
    Timer.tween(self.player:getPixelWalkTime(walkPixels), {
        [self.player] = {x = APRX_MID_TABLE_RIGHT_X}
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
        [self.player] = {x = APRX_MID_TABLE_CHAIR_X, y = APRX_MID_TABLE_CHAIR_Y}
    }):finish(
        function()
    -- Pop the casino Enter State off, and Push Casino stationary state
    gStateStack:pop()
    gStateStack:push(CasWStationaryState({casino = self.casino}))
        end)
        end)
        end)
        end)
        end)
        end)
end

function CasWEnterState:update(dt)
    self.player:update(dt)
end

function CasWEnterState:render()
    self.casino:render()
    self.player:render()
end
