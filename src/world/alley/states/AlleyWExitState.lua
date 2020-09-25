
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
    -- Animate the player walking right on the sidewalk out of frame
    local exitX = VIRTUAL_WIDTH + self.player:getWidth() + 1

    gSounds['footsteps']:setLooping(true)
    gSounds['footsteps']:play()

    local walkPixels = exitX - self.player:getX() 
    self.player:changeAnimation('walk-right')
    Timer.tween(walkPixels / PLAYER_WALK_SPEED, {
        [self.player] = {x = exitX}
    }):finish(
        function()
    gSounds['footsteps']:stop()
    -- Pop the Alley Exit State off, and push the next state
    gStateStack:pop()
    gStateStack:push(self.nextState)
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
