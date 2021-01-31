
ClubWEnterState = Class{__includes = BaseState}

function ClubWEnterState:init()
    self.player = gGlobalObjs['player']
    self.club = Club()

    self.playerDanceDir = 'right'
end

function ClubWEnterState:enter()
    -- Set the player entity's scale factors to the correct values
    -- for this room's tile sizes
    self.player.scaleX = 1.4
    self.player.scaleY = 1.4
    self.player.opacity = 255
    self.player.walkSpeed = 30
    -- Explicitly set the player's X & Y coordinates to be centered and just
    -- out of sight on the botto edge of the screen
    local midX = (VIRTUAL_WIDTH - self.player:getWidth()) / 2
    self.player.x = midX
    self.player.y = VIRTUAL_HEIGHT + 10
    -- Setup tween entrance
    self:tweenEnter()
    -- Begin playing the club background music
    gClubSounds['background']:setLooping(true)
    gClubSounds['background']:play()
end

function ClubWEnterState:tweenEnter()
    local APRX_BOOTH_OFFSET = 30
    local insideY = VIRTUAL_HEIGHT - self.player:getHeight()

    gSounds['door']:play()
    local doorDuration = gSounds['door']:getDuration()

    Timer.after(doorDuration,
        function()
    gSounds['footsteps']:setLooping(true)
    gSounds['footsteps']:play()

    -- Come just inside and subtract the door fee
    local walkPixels = self.player.y - insideY
    self.player:changeAnimation('walk-up')
    Timer.tween(self.player:getPixelWalkTime(walkPixels), {
        [self.player] = {y = insideY}
    }):finish(
        function()
    gSounds['footsteps']:stop()
    gStateStack:push(UpdatePlayerStatsState({player = self.player,
        -- Club mini game will reward its own score that can be dropped right in here
        stats = {money = -100}, callback =
        function()
    -- Pop the club Enter State off, and push the player stats
    -- update, and followed by the rest of the enter state
    gStateStack:pop()
    gStateStack:push(ClubWEnterFloorState({club = self.club}))
        end}))
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
