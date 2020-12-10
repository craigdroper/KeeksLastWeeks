
WorkWEnterOfficeState = Class{__includes = BaseState}

function WorkWEnterOfficeState:init()
    self.player = gGlobalObjs['player']
    self.office = WorkWOffice()
end

function WorkWEnterOfficeState:enter()
    -- Set the player entity's scale factors to the correct values
    -- for this room's tile sizes
    self.player.scaleX = 2
    self.player.scaleY = 2
    self.player.opacity = 255
    self.player.walkSpeed = 50
    -- Explicitly set the player's X & Y coordinates to be vertically
    -- and just out of frame on the left
    self.player.x = 0
    self.player.y = VIRTUAL_HEIGHT + self.player:getHeight()
    -- Setup tween entrance
    self:tweenEnter()
    -- Begin playing the casino background music
    gDateSounds['background']:setLooping(true)
    gDateSounds['background']:play()
end

function WorkWEnterOfficeState:tweenEnter()
    local APRX_TURN_X = VIRTUAL_WIDTH/2 - 30
    local DESK_Y = VIRTUAL_HEIGHT*2/4 + 25
    local DESK_X = VIRTUAL_WIDTH *3/4 - 45
    local START_HOP_X = DESK_X - 40
    local MID_HOP_X = (DESK_X + START_HOP_X)/2
    local HOP_Y = DESK_Y - 40

    gSounds['door']:play()
    local doorDuration = gSounds['door']:getDuration()

    Timer.after(doorDuration,
        function()
    gSounds['footsteps']:setLooping(true)
    gSounds['footsteps']:play()

    local walkPixels = self.player.y - DESK_Y
    self.player:changeAnimation('walk-up')
    Timer.tween(self.player:getPixelWalkTime(walkPixels), {
        [self.player] = {x = APRX_TURN_X, y = DESK_Y,
                         scaleX = 2, scaleY = 2}
    }):finish(
        function()
    local walkPixels = START_HOP_X - self.player.x
    self.player:changeAnimation('walk-right')
    Timer.tween(self.player:getPixelWalkTime(walkPixels), {
        [self.player] = {x = START_HOP_X}
    }):finish(
        function()
    -- Hop/jump into the desk chair
    self.player:changeAnimation('idle-right')
    gSounds['footsteps']:stop()
    gSounds['jump']:play()
    Timer.tween(0.2, {
        [self.player] = {x = MID_HOP_X, y = HOP_Y}
    }):finish(
        function()
    Timer.tween(0.2, {
        [self.player] = {x = DESK_X, y = DESK_Y}
    }):finish(
        function()
        self.player:changeAnimation('idle-right')
        gSounds['footsteps']:stop()
        -- Pop the work Enter State off, and Push WorkWEnterMeeting
        gStateStack:pop()
        gStateStack:push(WorkWEnterMeetingState({office = self.office}))
        end)
        end)
        end)
        end)
        end)
end

function WorkWEnterOfficeState:update(dt)
    self.player:update(dt)
end

function WorkWEnterOfficeState:render()
    self.office:render()
    self.player:render()
end
