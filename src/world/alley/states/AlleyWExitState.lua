
AlleyWExitState = Class{__includes = BaseState}

local BUFFER = 2

function AlleyWExitState:init(params)
    self.player = gGlobalObjs['player']
    self.alley = params.alley
    self.nextState = params.nextState
end

function AlleyWExitState:enter()
    self:tweenExit()
end

function AlleyWExitState:tweenExit()
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
    Timer.tween(walkPixels / PLAYER_WALK_SPEED, {
        [self.player] = {x = brickMinX - BUFFER - self.player:getWidth(),
                         opacity = 255}
    }):finish(
        function()
    walkPixels = swMaxY - BUFFER - self.player:getHeight() - self.player:getY()
    self.player:changeAnimation('walk-down')
    Timer.tween(walkPixels / PLAYER_WALK_SPEED, {
        [self.player] = {y = swMaxY - BUFFER - self.player:getHeight()}
    }):finish(
        function()
    walkPixels = exitX - self.player:getX() 
    self.player:changeAnimation('walk-right')
    Timer.tween(walkPixels / PLAYER_WALK_SPEED, {
        [self.player] = {x = exitX}
    }):finish(
        function()
    gSounds['footsteps']:stop()
    -- Pop the Apt Enter State off, and push the stationary state
    gStateStack:pop()
    gStateStack:push(self.nextState)
        end)
        end)
        end)
        end)
end

function AlleyWExitState:update(dt)
    self.player:update(dt)
end

function AlleyWExitState:render()
    self.alley:render()
    if self.player then
        self.player:render()
    end
end
