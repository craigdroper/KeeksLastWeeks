
ClubGPlayState = Class{__includes = BaseState}

function ClubGPlayState:init(params)
    self.background = params.background
    self.targets = params.targets
    self.health = params.health
    self.score = params.score
    self.level = params.level
    self.song = params.song
    self.songBPM = params.songBPM
    self.songTime = self.song:getDuration('seconds')
    local tmpArrow = ClubGArrow(self.targets['left'], self.level)
    self.timeToClearArrows =
        (VIRTUAL_HEIGHT - self.targets['left']:getY()) / (-tmpArrow.dy) + 1
    self.levelPlayTime = 0
    self.genArrowsTime = self.songTime - self.timeToClearArrows

    self.arrows = {}
    -- Get a frequency that's close to the half beats per second
    self.arrowFreq = self.songBPM / 60 / 4
    self.speedUpTimer = Timer.every(60, function()
        self.arrowFreq  = self.arrowFreq * 0.8
    end)
    -- Find how long to wait before the first arrow based on the bpm
    -- and the 3 second countdown
    self.arrowOffset = 3. % self.arrowFreq + self.arrowFreq
    self.arrowTimer = self.arrowFreq - self.arrowOffset
    self.arrowDirs = {'left', 'down', 'up', 'right'}

    self:setEndOfLevelTimer()
    self.isVictory = false
end

function ClubGPlayState:setEndOfLevelTimer()
    Timer.after(self.songTime,
        function()
            self.isVictory = true
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
        self:loseHealth(2)
    end
end

function ClubGPlayState:update(dt)
    if self.isVictory then
        -- Pop the play state off and move to the level's victory state
        gStateStack:pop()
        self.speedUpTimer:remove()
        gStateStack:push(ClubGVictoryState({
            background = self.background,
            level = self.level,
            score = self.score,
            targets = self.targets,
            health = self.health,
            song = self.song,
            }))
    end

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
        if arrow.inPlay and arrow:getY() < -arrow.height then
            arrow.inPlay = false
            self:loseHealth(2)
        end
    end

    -- Check if all the health is gone, and the player has lost, and we should
    -- transition to the game over state
    if self.health <= 0 then
        self.song:stop()
        -- Pop the current play state and push the game over state
        gStateStack:pop()
        self.speedUpTimer:remove()
        gStateStack:push(ClubGGameOverState({
            background = self.background,
            score = self.score,
            targets = self.targets,
            health = self.health,
        }))
    end

    -- Check if its time to generate a new random arrow
    self.levelPlayTime = self.levelPlayTime + dt
    self.arrowTimer = self.arrowTimer + dt
    if self.arrowTimer > self.arrowFreq and
       self.levelPlayTime < self.genArrowsTime then
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
    -- the candidate that is potentially the closest, but it has to
    -- be within the range of the max "hitable" distance
    -- This treats the line of arrows more like a stack, giving the user a
    -- "need to catch up" feeling if an arrow goes by the target
    local arrowCand = nil
    local bestY = 1e10
    for _, arrow in pairs(self.arrows) do
        if arrow.inPlay and
           arrow.dir == target.dir and
           math.abs(arrow:getY() - target:getY()) < target.maxHitDist then
            if arrow:getY() < bestY then
                arrowCand = arrow
                bestY = arrow:getY()
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
