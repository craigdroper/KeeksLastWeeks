
DoctorWEnterRoomState = Class{__includes = BaseState}

function DoctorWEnterRoomState:init()
    self.player = gGlobalObjs['player']
    self.room = DoctorWRoom()
end

function DoctorWEnterRoomState:enter()
    -- Set the player entity's scale factors to the correct values
    -- for this room's tile sizes
    self.player.scaleX = 1.5
    self.player.scaleY = 1.5
    self.player.opacity = 255
    self.player.walkSpeed = 50
    -- Explicitly set the player's X & Y coordinates to be off screen to
    -- the right and a little off the bottom of the scene
    self.player.x = VIRTUAL_WIDTH + 2
    self.player.y = VIRTUAL_HEIGHT  - self.player.height * self.player.scaleY
    -- Setup tween entrance
    self:tweenEnter()
    -- Begin playing the work background music
    gDoctorSounds['background']:setLooping(true)
    gDoctorSounds['background']:play()
end

function DoctorWEnterRoomState:tweenEnter()
    local START_Y = VIRTUAL_HEIGHT  - self.player.height * self.player.scaleY
    local BED_BASE_X = VIRTUAL_WIDTH * 2/3
    local BED_BASE_Y = VIRTUAL_HEIGHT * 2/3
    local BED_TOP_X = VIRTUAL_WIDTH/2 + 60
    local BED_TOP_Y = VIRTUAL_HEIGHT/2 - 10

    gSounds['door']:play()
    local doorDuration = gSounds['door']:getDuration()

    Timer.after(doorDuration,
        function()
    gSounds['footsteps']:setLooping(true)
    gSounds['footsteps']:play()

    local walkPixels = self.player.x - BED_BASE_X
    self.player:changeAnimation('walk-left')
    Timer.tween(self.player:getPixelWalkTime(walkPixels), {
        [self.player] = {x = BED_BASE_X}
    }):finish(
        function()
    -- Walk up to get vertically level with the bed
    walkPixels = self.player.y - BED_BASE_Y 
    self.player:changeAnimation('walk-up')
    Timer.tween(self.player:getPixelWalkTime(walkPixels), {
        [self.player] = {y = BED_BASE_Y}
    }):finish(
        function()
    -- Hop/jump onto the exam bed
    self.player:changeAnimation('idle-left')
    gSounds['footsteps']:stop()
    Timer.after(0.5,
        function()
    gSounds['jump']:play()
    Timer.tween(0.2, {
        [self.player] = {x = BED_TOP_X, y = BED_TOP_Y}
    }):finish(
        function()
        self.player:changeAnimation('idle-down')
        -- Pop the work Enter State off, and Push WorkWEnterGame
        gStateStack:pop()
        gStateStack:push(DoctorWEnterGameState({room = self.room}))
        end)
        end)
        end)
        end)
        end)
end

function DoctorWEnterRoomState:update(dt)
    self.player:update(dt)
end

function DoctorWEnterRoomState:render()
    self.room:render()
    self.player:render()
end
