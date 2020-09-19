
AptWEnterState = Class{__includes = BaseState}

function AptWEnterState:init()
    self.player = gGlobalObjs['player']
    self.apartment = Apartment()
end

function AptWEnterState:enter()
    -- Explicitly set the player's X & Y coordinates to be just outside
    -- of the right frame in line to walk into the apartment
    local chairY = self.apartment.furniture['desk-chair'][4]
    self.player.x = VIRTUAL_WIDTH + 1
    self.player.y = chairY - self.player.height
    self:tweenEnter()
end

function AptWEnterState:tweenEnter()
    -- Setup the tween action to animate the player walking from outside
    -- the apartment to the couch
    local counterX = self.apartment.furniture['vertical-long-counter'][3]
    local tableY = self.apartment.furniture['coffee-table'][4]
    local horzCouchX = self.apartment.furniture['horizontal-couch'][3]
    local horzCouchY = self.apartment.furniture['horizontal-couch'][4]
    local horzCouchWidth = gFramesInfo['apartment'][gAPT_HORZ_COUCH_NAME]['width']
    local ARMREST_OFFSET = 7

    gSounds['door']:play()
    local doorDuration = gSounds['door']:getDuration()

    Timer.after(doorDuration,
        function()
    gSounds['footsteps']:setLooping(true)
    gSounds['footsteps']:play()

    -- Come in through door and walk to just passed the counter
    local walkPixels = self.player.x - counterX - self.player.width
    self.player:changeAnimation('walk-left')
    Timer.tween(walkPixels / PLAYER_WALK_SPEED, {
        [self.player] = {x = counterX - self.player.width}
    }):finish(
        function()
    walkPixels = self.player.y - tableY + self.player.height
    self.player:changeAnimation('walk-up')
    Timer.tween(walkPixels / PLAYER_WALK_SPEED, {
        [self.player] = {y = tableY - self.player.height}
    }):finish(
        function()
    local couchXTarget = (horzCouchX + horzCouchWidth/2) - self.player.width/2 - ARMREST_OFFSET
    walkPixels = self.player.x - couchXTarget
    self.player:changeAnimation('walk-left')
    Timer.tween(walkPixels / PLAYER_WALK_SPEED, {
        [self.player] = {x = couchXTarget}
    }):finish(
        function()
    walkPixels = self.player.y - horzCouchY
    self.player:changeAnimation('walk-up')
    Timer.tween(walkPixels / PLAYER_WALK_SPEED, {
        [self.player] = {y = horzCouchY}
    }):finish(
        function()
    gSounds['footsteps']:stop()
    self.player:changeAnimation('idle-down')
    -- Pop the Apt Enter State off, and push the stationary state
    gStateStack:pop()
    gStateStack:push(AptWStationaryState({apartment = self.apartment}))
        end)
        end)
        end)
        end)
        end)
end

function AptWEnterState:update(dt)
    self.player:update(dt)
end

function AptWEnterState:render()
    self.apartment:render()
    if self.player then
        self.player:render()
    end
end
