--[[
    CokeGPlayState Class
    Author: Colton Ogden
    cogden@cs50.harvard.edu

    The CokeGPlayState class is the bulk of the game, where the player actually controls the bird and
    avoids pipes. When the player collides with a pipe, we should go to the GameOver state, where
    we then go back to the main menu.
]]

CokeGPlayState = Class{__includes = BaseState}

function CokeGPlayState:init(params)
    self.bird = CokeGBird()
    self.background = params.background
    self.background:setIsScrolling(true)
    self.pipePairs = {}
    self.pipeAlarm = 0
    self.level = 0
    self.levelPipeCreated = 0
    self.levelPipeScored = 0
    self.pipesPerLevel = 5

    -- initialize our last recorded Y value for a gap placement to base other gaps off of
    self.lastY = -COKEG_PIPE_HEIGHT + math.random(80) + 20
    self.minGap = 100
    self.maxGap = 200
    self.levelGaps = {
        [0] = 190,
        [1] = 180,
        [2] = 170,
        [3] = 160,
        [4] = 150,
        [5] = 140,
        [6] = 130,
        [7] = 120,
        [8] = 110,
        [9] = 100,
        [10] = 90,
    }

    self.groundScroll = 0
end

function CokeGPlayState:update(dt)
    -- update pipeAlarm for pipe spawning
    self.pipeAlarm = self.pipeAlarm - dt

    -- spawn a new pipe pair every second and a half
    if self.pipeAlarm < 0 then
        -- modify the last pipe gap to be close to the last gap, as well as
        -- not less than 60 pixels wide and not more than 150 pixels wide
        -- modify the last Y coordinate we placed so pipe gaps aren't too far apart
        -- no higher than 10 pixels below the top edge of the screen,
        -- and no lower than the gap length
        local gap = math.max(
            self.minGap, math.min(
                self.levelGaps[self.level] + math.random(-20,20), self.maxGap) )
        local y = math.max(-COKEG_PIPE_HEIGHT + 10,
            math.min(self.lastY + math.random(-20, 20), VIRTUAL_HEIGHT - gap - COKEG_PIPE_HEIGHT))
        self.lastY = y

        -- add a new pipe pair at the end of the screen at our new Y
        table.insert(self.pipePairs, CokeGPipePair(y, gap))
        self.levelPipeCreated = self.levelPipeCreated + 1

        if self.levelPipeCreated == self.pipesPerLevel then
            -- set a longer alarm to separate the levels
            if self.level == 9 then
                self.pipeAlarm = 1000000
            else
                self.pipeAlarm = 6
            end
            self.levelPipeCreated = 0
        else
            self.pipeAlarm = 1.5
        end
    end

    -- for every pair of pipes..
    for k, pair in pairs(self.pipePairs) do
        -- score a point if the pipe has gone past the bird to the left all the way
        -- be sure to ignore it if it's already been scored
        if not pair.scored then
            if pair.x + COKEG_PIPE_WIDTH < self.bird.x then
                self.levelPipeScored = self.levelPipeScored + 1
                if self.levelPipeScored == self.pipesPerLevel then
                    gCokeSounds['score']:play()
                    self.level = self.level + 1
                    self.levelPipeScored = 0
                    if self.level == 10 then
                        self.bird:win()
                            gStateStack:pop()
                            gStateStack:push(
                                CokeGScoreState(
                                    {level = self.level,
                                     bird = self.bird,
                                     background = self.background}))
                    end
                end
                pair.scored = true
            end
        end

        -- update position of pair
        pair:update(dt)
    end

    -- we need this second loop, rather than deleting in the previous loop, because
    -- modifying the table in-place without explicit keys will result in skipping the
    -- next pipe, since all implicit keys (numerical indices) are automatically shifted
    -- down after a table removal
    for k, pair in pairs(self.pipePairs) do
        if pair.remove then
            table.remove(self.pipePairs, k)
        end
    end

    -- simple collision between bird and all pipes in pairs
    for k, pair in pairs(self.pipePairs) do
        for l, pipe in pairs(pair.pipes) do
            if self.bird:collides(pipe) then
                self.bird:sneeze()

                gStateStack:pop()
                gStateStack:push(CokeGScoreState({
                    level = self.level, bird = self.bird,
                    background = self.background}))
            end
        end
    end

    -- update bird based on gravity and input
    self.bird:update(dt)

    -- reset if we get to the ground
    if self.bird.y > VIRTUAL_HEIGHT - 15 then
        self.bird:sneeze()

        gStateStack:pop()
        gStateStack:push(CokeGScoreState({level = self.level, bird = self.bird,
            background = self.background}))
    end

    -- Update scrolling parameters
    self.background:update(dt)

end

function CokeGPlayState:render()
    -- Draw scrolling background
    self.background:render()

    for k, pair in pairs(self.pipePairs) do
        pair:render()
    end

    love.graphics.setFont(gFonts['flappy-font'])
    love.graphics.print('Lines: ' .. tostring(self.level), 8, 8)

    self.bird:render()


    -- Finally draw scrolling ground
    love.graphics.filterDrawD(gCokeGImages['ground'], -self.groundScroll, VIRTUAL_HEIGHT - 16)
end

--[[
    Called when this state is transitioned to from another state.
]]
function CokeGPlayState:enter()
    -- if we're coming from death, restart scrolling
    scrolling = true
end

--[[
    Called when this state changes to another state.
]]
function CokeGPlayState:exit()
    -- stop scrolling for the death/score screen
    scrolling = false
end
