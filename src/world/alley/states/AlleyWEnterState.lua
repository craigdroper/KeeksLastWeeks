
AlleyWEnterState = Class{__includes = BaseState}

local BUFFER = 2

function AlleyWEnterState:init()
    self.player = gGlobalObjs['player']
    self.alley = Alley()
end

function AlleyWEnterState:enter()
    -- Set the player entity's scale factors to the correct values
    -- for this room's tile sizes
    self.player.scaleX = 0.5
    self.player.scaleY = 0.5
    self.player.walkSpeed = 100
    -- Also set the player's opacity to 0, as we will fade him in to simulate
    -- hims stepping outdoors
    self.player.opacity = 0
    -- Explicitly set the player's X & Y coordinates to be centered on the apartment
    -- and just a little above the bottom part of the apartment
    local minX, maxX, minY, maxY, midX, midY = self.alley:getBorderCoords(self.alley.buildings['apartment'])
    self.player.x = midX - self.player:getWidth() / 2
    self.player.y = maxY - self.player:getHeight()
    self:tweenEnter()
end

function AlleyWEnterState:tweenEnter()
    -- Setup the tween action to animate the player walking from outside
    -- the apartment to the couch
    local _, _, _, swMaxY, _, _  = self.alley:getBorderCoords(self.alley.pavements['top'])
    local _, aptMaxX, _, _, _, _ = self.alley:getBorderCoords(self.alley.buildings['apartment'])
    local _, _, carMinY, _, carMidX = self.alley:getBorderCoords(self.alley.vehicles['drug-car'])

    gSounds['door']:play()
    local doorDuration = gSounds['door']:getDuration()

    Timer.after(doorDuration,
        function()
    gSounds['footsteps']:setLooping(true)
    gSounds['footsteps']:play()

    -- Come out through the apartment door onto the sidewalk
    local walkPixels = (swMaxY - BUFFER) - self.player:getY() - self.player:getHeight()
    self.player:changeAnimation('walk-down')
    Timer.tween(self.player:getPixelWalkTime(walkPixels), {
        [self.player] = {y = swMaxY - BUFFER - self.player:getHeight(),
                         opacity = 255}
    }):finish(
        function()
    -- Walk over just far enough to clear the apartment and go into the alley
    walkPixels = (aptMaxX + BUFFER) - self.player:getX()
    self.player:changeAnimation('walk-right')
    Timer.tween(self.player:getPixelWalkTime(walkPixels), {
        [self.player] = {x = aptMaxX + BUFFER}
    }):finish(
        function()
    -- Walk up towards the left side of the car
    walkPixels = self.player.y - carMinY
    self.player:changeAnimation('walk-up')
    Timer.tween(self.player:getPixelWalkTime(walkPixels), {
        [self.player] = {y = carMinY}
    }):finish(
        function()
    -- Turn right and simulate getting into the car by fading back to opacity 0
    walkPixels = (carMidX) - (self.player:getX()) - self.player:getWidth()/2
    self.player:changeAnimation('walk-right')
    Timer.tween(self.player:getPixelWalkTime(walkPixels), {
        [self.player] = {x = carMidX - self.player:getWidth()/2,
                         opacity = 0}
    }):finish(
        function()
    gSounds['footsteps']:stop()
    -- Pop the Apt Enter State off, and push the stationary state
    gStateStack:pop()
    gStateStack:push(AlleyWStationaryState({alley = self.alley}))
        end)
        end)
        end)
        end)
        end)
end

function AlleyWEnterState:update(dt)
    self.player:update(dt)
end

function AlleyWEnterState:render()
    self.alley:render()
    if self.player then
        self.player:render()
    end
end
