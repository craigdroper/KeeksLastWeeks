
ClubGPlayState = Class{__includes = BaseState}

function ClubGPlayState:init(params)
    self.background = params.background
    self.targets = params.targets
    self.health = params.health
    self.score = params.score
    self.level = params.level
    self.song = params.song
    self.songTime = self.song:getDuration('seconds')
    self.timeToClearArrows = 5
    self.levelPlayTime = 0
    self.genArrowsTime = self.songTime - self.timeToClearArrows

    self.arrows = {}
    self.arrowFreq = 0.5
    self.arrowTimer = 0
    self.arrowDirs = {'left', 'down', 'up', 'right'}

    self:setEndOfLevelTimer()
end

function ClubGPlayState:setEndOfLevelTimer()
    Timer.after(self.songTime - self.timeToClearArrows,
        function()
    -- Pop the play state off and move to the level's victory state
    gStateStack:pop()
    gStateStack:push(ClubGVictoryState({
        background = self.background,
        level = self.level,
        score = self.score,
        targets = self.targets,
        health = self.health,
        }))
        end)
end


function ClubGPlayState:loseHealth(health)
    gClubSounds['miss']:play()
    self.health = self.health - health
end

function ClubGPlayState:checkForHitTarget(dir)
    local target = self.targets[dir]
    local closestArrow = self:getClosestArrow(target)
    if target:checkIsHit(closestArrow) then
        self.score = self.score + target:calcScore(closestArrow)
        target:hit(closestArrow)
        closestArrow.inPlay = false
    else
        self:loseHealth(5)
    end
end

function ClubGPlayState:update(dt)
    -- Update the arrows position
    for _, arrow in pairs(self.arrows) do
        arrow:update(dt)
    end

    -- Update the arrow targets so they can forward the update call to their
    -- particle systems
    for _, target in pairs(self.targets) do
        target:update(dt)
    end

    -- Check if any keys have been pressed, and if so, check if it was hit when
    -- an arrow was close to the target.
    if love.keyboard.wasPressed('left') then
        self:checkForHitTarget('left')
    elseif love.keyboard.wasPressed('up') then
        self:checkForHitTarget('up')
    elseif love.keyboard.wasPressed('down') then
        self:checkForHitTarget('down')
    elseif love.keyboard.wasPressed('right') then
        self:checkForHitTarget('right')
    end

    -- Check if any in play arrows have passed outside the screen and should
    -- be counted against health
    for _, arrow in pairs(self.arrows) do
        if arrow.inPlay and arrow:getY() < -arrow.width then
            arrow.inPlay = false
            self:loseHealth(5)
        end
    end

    -- Check if all the health is gone, and the player has lost, and we should
    -- transition to the game over state
    if self.health <= 0 then
        self.song:stop()
        -- Pop the current play state and push the game over state
        gStateStack:pop()
        gStateStack:push(ClubGGameOverState({
            background = self.background,
            score = self.score,
            targets = self.targets,
            health = self.health
        }))
    end

    -- Check if its time to generate a new random arrow
    self.levelPlayTime = self.levelPlayTime + dt
    self.arrowTimer = self.arrowTimer + dt
    if self.arrowTimer > self.arrowFreq and self.levelPlayTime < self.genArrowsTime then
        table.insert(self.arrows, ClubGArrow(
            self.targets[self.arrowDirs[math.random(#self.arrowDirs)]], self.level))
        self.arrowTimer = 0
    end

    -- Clean up all out of play arrows from the table
    for i = #self.arrows, 1, -1 do
        if not self.arrows[i].inPlay then
            table.remove(self.arrows, i)
        end
    end
end

function ClubGPlayState:getClosestArrow(target)
    -- Prioritize the arrow with the lowest Y (furthest up) in the lane as
    -- the candidate that is potentially the closest
    -- This treats the line of arrows more like a stack, giving the user a
    -- "need to catch up" feeling if an arrow goes by the target
    local arrowCand = nil
    local bestY = 1e10
    for _, arrow in pairs(self.arrows) do
        if arrow.inPlay and arrow.dir == target.dir then
            local candY = arrow:getY()
            if candY < bestY then 
                arrowCand = arrow
                bestY = candY
            end
        end
    end
    return arrowCand
end

function ClubGPlayState:render()
    self.background:render()

    for _, target in pairs(self.targets) do
        target:renderImage()
    end

    for _, arrow in pairs(self.arrows) do
        arrow:render()
    end

    for _, target in pairs(self.targets) do
        target:renderParticles()
    end

    ClubGUtils():renderScore(self.score)
    ClubGUtils():renderHealth(self.health)

end
