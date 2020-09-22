--[[
    CokeGPlayState Class
    Author: Colton Ogden
    cogden@cs50.harvard.edu

    The CokeGPlayState class is the bulk of the game, where the player actually controls the bird and
    avoids pipes. When the player collides with a pipe, we should go to the GameOver state, where
    we then go back to the main menu.
]]

CokeGPlayState = Class{__includes = BaseState}

function CokeGPlayState:init()
    self.bird = CokeGBird()
    self.pipePairs = {}
    self.pipeAlarm = 0
    self.score = 0

    -- initialize our last recorded Y value for a gap placement to base other gaps off of
    self.lastY = -COKEG_PIPE_HEIGHT + math.random(80) + 20
    self.lastGap = 90

    -- XXX For now commenting out pause functionality
    -- self.isPaused = false
    -- self.pauseImage = gCokeGImages['pause']

    self.backgroundScroll = 0
    self.groundScroll = 0
end

function CokeGPlayState:update(dt)
    -- check if there has been any change in pause state
    --[[
    if love.keyboard.wasPressed('p') then
        gCokeSounds['pause']:play()
        if self.isPaused then
            gCokeSounds['music']:play()
        else
            gCokeSounds['music']:stop()
        end
        gIsScrolling = not gIsScrolling
        self.isPaused = not self.isPaused
    end
    -- don't update any of the pipes or the bird when paused
    if self.isPaused then
        return
    end
    --]]

    -- update pipeAlarm for pipe spawning
    self.pipeAlarm = self.pipeAlarm - dt

    -- spawn a new pipe pair every second and a half
    if self.pipeAlarm < 0 then
        -- modify the last pipe gap to be close to the last gap, as well as
        -- not less than 60 pixels wide and not more than 150 pixels wide
        -- modify the last Y coordinate we placed so pipe gaps aren't too far apart
        -- no higher than 10 pixels below the top edge of the screen,
        -- and no lower than the gap length
        local gap = math.max(50, math.min(self.lastGap + math.random(-20,20), 150))
        -- print('Set pipe gap to ' .. tostring(gap) .. ' pixels')
        local y = math.max(-COKEG_PIPE_HEIGHT + 10, 
            math.min(self.lastY + math.random(-20, 20), VIRTUAL_HEIGHT - gap - COKEG_PIPE_HEIGHT))
        self.lastGap = gap
        self.lastY = y

        -- add a new pipe pair at the end of the screen at our new Y
        table.insert(self.pipePairs, CokeGPipePair(y, gap))

        -- reset pipeAlarm to be some random time between 1.5 and 2.5 second
        self.pipeAlarm = 1.5 + math.random()
        -- print('Set next pipe alarm for ' .. tostring(self.pipeAlarm) .. ' seconds')
    end

    -- for every pair of pipes..
    for k, pair in pairs(self.pipePairs) do
        -- score a point if the pipe has gone past the bird to the left all the way
        -- be sure to ignore it if it's already been scored
        if not pair.scored then
            if pair.x + COKEG_PIPE_WIDTH < self.bird.x then
                self.score = self.score + 1
                pair.scored = true
                gCokeSounds['score']:play()
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
                gCokeSounds['explosion']:play()
                gCokeSounds['hurt']:play()

                gStateMachine:change('coke-game-score', {
                    score = self.score
                })
            end
        end
    end

    -- update bird based on gravity and input
    self.bird:update(dt)

    -- reset if we get to the ground
    if self.bird.y > VIRTUAL_HEIGHT - 15 then
        gCokeSounds['explosion']:play()
        gCokeSounds['hurt']:play()

        gStateMachine:change('coke-game-score', {
            score = self.score
        })
    end

    -- Update scrolling parameters
    self.backgroundScroll = (self.backgroundScroll + COKEG_BACKGROUND_SCROLL_SPEED * dt) % COKEG_BACKGROUND_LOOPING_POINT

end

function CokeGPlayState:render()
    -- Draw scrolling background
    love.graphics.filterDrawD(gCokeGImages['background'], -self.backgroundScroll, 0)

    for k, pair in pairs(self.pipePairs) do
        pair:render()
    end

    love.graphics.setFont(gFonts['flappy-font'])
    love.graphics.print('Score: ' .. tostring(self.score), 8, 8)

    self.bird:render()

    -- if the play state is currently paused, display the pause image
    --[[
    if self.isPaused then
        love.graphics.filterDrawD(
            self.pauseImage,
            VIRTUAL_WIDTH/2 - self.pauseImage:getWidth()/2,
            VIRTUAL_HEIGHT/2 - self.pauseImage:getHeight()/2)
    end
    --]]

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
