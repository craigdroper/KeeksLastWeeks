
ClubWEnterState = Class{__includes = BaseState}

function ClubWEnterState:init()
    self.player = gGlobalObjs['player']
    self.club = Club()

    self.playerDanceDir = 'right'
end

function ClubWEnterState:enter()
    -- Set the player entity's scale factors to the correct values
    -- for this room's tile sizes
    self.player.scaleX = 0.75
    self.player.scaleY = 0.75
    self.player.opacity = 255
    self.player.walkSpeed = 30
    -- Explicitly set the player's X & Y coordinates to be centered and just
    -- out of sight on the botto edge of the screen
    local midX = (VIRTUAL_WIDTH - self.player:getWidth()) / 2
    self.player.x = midX
    self.player.y = VIRTUAL_HEIGHT + 1
    -- Setup tween entrance
    self:tweenEnter()
    -- Begin playing the club background music
    gClubSounds['background']:setLooping(true)
    gClubSounds['background']:play()
end

function ClubWEnterState:tweenEnter()
    -- Since we're not building the background from a tilesheet, we're just
    -- going to approximate and hard code these values
    local APRX_BOOTH_OFFSET = 30
    local boothY = VIRTUAL_HEIGHT / 2 + APRX_BOOTH_OFFSET
    local danceY = (VIRTUAL_HEIGHT - boothY) / 2 + boothY

    gSounds['door']:play()
    local doorDuration = gSounds['door']:getDuration()

    Timer.after(doorDuration,
        function()
    gSounds['footsteps']:setLooping(true)
    gSounds['footsteps']:play()

    -- Come in through the door, and walk to halfway through the club and
    -- do a little "dance move" which just toggles between idle right
    -- and idle left moves quickly
    local walkPixels = self.player.y - danceY
    self.player:changeAnimation('walk-up')
    Timer.tween(self.player:getPixelWalkTime(walkPixels), {
        [self.player] = {y = danceY}
    }):finish(
        function()
    -- Tween together a couple little dance moves
    self.player:changeAnimation('idle-up')
    Timer.every(0.5,
        function()
    if self.playerDanceDir == 'right' then
        self.player:changeAnimation('idle-left')
        self.playerDanceDir = 'left'
    else
        self.player:changeAnimation('idle-right')
        self.playerDanceDir = 'right'
    end
        end):limit(8)
    :finish(
        function()
    -- Walk the rest of the way to the DJ booth
    walkPixels = self.player.y - boothY
    self.player:changeAnimation('walk-up')
    Timer.tween(self.player:getPixelWalkTime(walkPixels), {
        [self.player] = {y = boothY}
    }):finish(
        function()
    gSounds['footsteps']:stop()
    self.player:changeAnimation('idle-up')
    -- Pop the club Enter State off, and push the stationary state
    gStateStack:pop()
    gStateStack:push(ClubWStationaryState({club = self.club}))
        end)
        end)
        end)
        end)
end

function ClubWEnterState:update(dt)
    self.player:update(dt)
end

function ClubWEnterState:render()
    self.club:renderBase()
    if self.player then
        self.player:render()
    end
    self.club:renderEffects()
end
