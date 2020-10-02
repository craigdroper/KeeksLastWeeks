
DateWEnterLobbyState = Class{__includes = BaseState}

function DateWEnterLobbyState:init()
    self.player = gGlobalObjs['player']
    self.lobby = DateWLobby()
end

function DateWEnterLobbyState:enter()
    -- Set the player entity's scale factors to the correct values
    -- for this room's tile sizes
    self.player.scaleX = 1.5
    self.player.scaleY = 1.5
    self.player.opacity = 255
    self.player.walkSpeed = 100
    -- Explicitly set the player's X & Y coordinates to be vertically at the
    -- bottom of the screen
    -- and just out of frame on the right
    self.player.x = VIRTUAL_WIDTH + 1
    self.player.y = VIRTUAL_HEIGHT - self.player:getHeight() - 5
    -- Setup tween entrance
    self:tweenEnter()
    -- Begin playing the casino background music
    gDateSounds['background']:setLooping(true)
    gDateSounds['background']:play()
end

function DateWEnterLobbyState:tweenEnter()
    local APRX_HOST_X = VIRTUAL_WIDTH/4 - 4

    gSounds['door']:play()
    local doorDuration = gSounds['door']:getDuration()

    Timer.after(doorDuration,
        function()
    gSounds['footsteps']:setLooping(true)
    gSounds['footsteps']:play()

    -- Come just inside and subtract the door fee
    local walkPixels = self.player.x - APRX_HOST_X
    self.player:changeAnimation('walk-left')
    Timer.tween(self.player:getPixelWalkTime(walkPixels), {
        [self.player] = {x = APRX_HOST_X}
    }):finish(
        function()
        self.player:changeAnimation('idle-up')
        gSounds['footsteps']:stop()
        -- Pop the date Enter State off, and Push Host Welcome state
        gStateStack:pop()
        gStateStack:push(DateWHostWelcomeState({lobby = self.lobby}))
        end)
        end)
end

function DateWEnterLobbyState:update(dt)
    self.player:update(dt)
end

function DateWEnterLobbyState:render()
    self.lobby:render()
    self.player:render()
end
