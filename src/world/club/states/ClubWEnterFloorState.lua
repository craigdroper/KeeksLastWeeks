
ClubWEnterFloorState = Class{__includes = BaseState}

function ClubWEnterFloorState:init(params)
    self.player = gGlobalObjs['player']
    self.club = params.club

    self.playerDanceDir = 'right'
end

function ClubWEnterFloorState:enter()
    -- Setup tween entrance
    self:tweenEnter()
end

function ClubWEnterFloorState:tweenEnter()
    -- Since we're not building the background from a tilesheet, we're just
    -- going to approximate and hard code these values
    local APRX_BOOTH_OFFSET = 30
    local boothY = VIRTUAL_HEIGHT / 2 + APRX_BOOTH_OFFSET
    local danceY = (VIRTUAL_HEIGHT - boothY) / 2 + boothY - 50

    gSounds['footsteps']:setLooping(true)
    gSounds['footsteps']:play()

    -- Come in through the door, and walk to halfway through the club and
    -- do a little "dance move" which just toggles between idle right
    -- and idle left moves quickly
    local walkPixels = self.player.y - danceY
    self.player:changeAnimation('walk-up')
    Timer.tween(self.player:getPixelWalkTime(walkPixels), {
        [self.player] = {y = danceY, x=self.player.x+5, scaleY=1.1, scaleX=1.1}
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
        [self.player] = {y = boothY, x=self.player.x+5, scaleY=0.9, scaleX=0.9}
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
end

function ClubWEnterFloorState:update(dt)
    self.player:update(dt)
end

function ClubWEnterFloorState:render()
    self.club:renderBase()
    if self.player then
        self.player:render()
    end
    self.club:renderEffects()
end
