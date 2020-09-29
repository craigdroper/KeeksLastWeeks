
AlleyWExitCarState = Class{__includes = BaseState}

local BUFFER = 2

function AlleyWExitCarState:init(params)
    self.player = gGlobalObjs['player']
    self.alley = params.alley
end

function AlleyWExitCarState:enter()
    self:tweenExit()
end

function AlleyWExitCarState:tweenExit()
    -- Setup the tween action to animate the player walking from the car
    -- out of frame on the right hand side of the sidewalk
    local brickMinX, _, _, _, _, _ = self.alley:getBorderCoords(self.alley.buildings['brick'])
    local _, _, _, swMaxY, _, _  = self.alley:getBorderCoords(self.alley.pavements['top'])
    local exitX = VIRTUAL_WIDTH + self.player:getWidth() + 1

    gSounds['door']:play()
    local doorDuration = gSounds['door']:getDuration()

    Timer.after(doorDuration,
        function()
    gSounds['footsteps']:setLooping(true)
    gSounds['footsteps']:play()

    -- Come out through the apartment door onto the sidewalk
    local walkPixels = (brickMinX + BUFFER - self.player:getWidth()) - self.player:getX()
    self.player:changeAnimation('walk-right')
    Timer.tween(self.player:getPixelWalkTime(walkPixels), {
        [self.player] = {x = brickMinX - BUFFER - self.player:getWidth(),
                         opacity = 255}
    }):finish(
        function()
    walkPixels = swMaxY - BUFFER - self.player:getHeight() - self.player:getY()
    self.player:changeAnimation('walk-down')
    Timer.tween(self.player:getPixelWalkTime(walkPixels), {
        [self.player] = {y = swMaxY - BUFFER - self.player:getHeight()}
    }):finish(
        function()
    gSounds['footsteps']:stop()
    self.player:changeAnimation('idle-down')
    gStateStack:push(AlleyWFunMenuState({alley = self.alley}))
        end)
        end)
        end)
end

function AlleyWExitCarState:update(dt)
    self.player:update(dt)
end

function AlleyWExitCarState:render()
    self.alley:render()
    if self.player then
        self.player:render()
    end
end
