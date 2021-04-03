
AptWEnterState = Class{__includes = BaseState}

--local FURNITURE_BUFFER = 8
--local ARMREST_OFFSET = 7
--local TOP_COUCH_OFFSET = 12

function AptWEnterState:init()
    self.player = gGlobalObjs['player']
    -- Entering the Apartment is the point where we can assume we want
    -- stats to start displaying
    self.player.displayStats = true
    self.apartment = Apartment()
end

function AptWEnterState:enter()
    -- Always reset the drug filter whenever coming back to the Apartment
    gGlobalObjs['filter'] = NoFilter()
    -- Set the player entity's scale factors to the correct values
    -- for this scene
    self.player.scaleX = 1.8
    self.player.scaleY = 1.8
    self.player.opacity = 255
    self.player.walkSpeed = 50
    self.player.x = VIRTUAL_WIDTH
    self.player.y = VIRTUAL_HEIGHT * 3/4 - 20
    -- Begin playing the apartment background music
    -- TODO whats the apartment music?
    -- gBarWSounds['exterior']:setLooping(true)
    -- gBarWSounds['exterior']:play()
    -- Setup tween entrance
    self:tweenEnter()
end

function AptWEnterState:tweenEnter()
    -- Setup the tween action to animate the player walking from outside
    -- the apartment to the couch
    local carpetTurnX = VIRTUAL_WIDTH * 3/4 - 30
    local couchTurnY = VIRTUAL_HEIGHT * 1/2
    local couchSeatY = VIRTUAL_HEIGHT * 1/2 - 50

    gSounds['door']:play()
    local doorDuration = gSounds['door']:getDuration()

    Timer.after(doorDuration,
        function()
    gSounds['footsteps']:setLooping(true)
    gSounds['footsteps']:play()

    -- Come in through door and walk to just passed the counter
    local walkPixels = self.player.x - carpetTurnX
    self.player:changeAnimation('walk-left')
    Timer.tween(self.player:getPixelWalkTime(walkPixels), {
        [self.player] = {x = carpetTurnX}
    }):finish(
        function()
    -- Walk up high enough to clear the top part of the coffee table
    walkPixels = self.player.y - couchTurnY
    self.player:changeAnimation('walk-up')
    Timer.tween(self.player:getPixelWalkTime(walkPixels), {
        [self.player] = {y = couchTurnY, scaleX = 1.5, scaleY = 1.5}
    }):finish(
        function()
    gSounds['footsteps']:stop()
    self.player:changeAnimation('idle-down')
    Timer.after(0.5,
        function()
    -- "Hop/Jump" onto the mid table chair facing left after a small wind up
    -- pause for the jump
    gSounds['footsteps']:stop()
    gSounds['jump']:play()
    Timer.tween(0.3, {
        [self.player] = {y = couchSeatY}
    }):finish(
        function()
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
