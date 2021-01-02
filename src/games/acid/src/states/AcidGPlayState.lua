--[[
    GD50
    Match-3 Remake

    -- AcidGPlayState Class --

    Author: Colton Ogden
    cogden@cs50.harvard.edu

    State in which we can actually play, moving around a grid cursor that
    can swap two tiles; when two tiles make a legal swap (a swap that results
    in a valid match), perform the swap and destroy all matched tiles, adding
    their values to the player's point score. The player can continue playing
    until they exceed the number of points needed to get to the next level
    or until the time runs out, at which point they are brought back to the
    main menu or the score entry menu if they made the top 10.
]]

AcidGPlayState = Class{__includes = BaseState}

function AcidGPlayState:init(params)
    self.bkgrd = params.bkgrd

    -- grab level # from the params we're passed
    self.level = params.level

    -- spawn a board and place it toward the right
    self.board = params.board or AcidGBoard(VIRTUAL_WIDTH - 272, 16)

    -- grab score from params if it was passed
    self.score = params.score or 0

    -- start our transition alpha at full, so we fade in
    self.transitionAlpha = 255

    -- position in the grid which we're highlighting
    self.boardHighlightX = 0
    self.boardHighlightY = 0

    -- timer used to switch the highlight rect's color
    self.rectHighlighted = false

    -- flag to show whether we're able to process input (not swapping or clearing)
    self.canInput = true

    -- tile we're currently highlighting (preparing to swap)
    self.highlightedTile = nil

    self.score = 0
    self.timer = 30
    -- flag that indicates if we're resetting an impossible board
    self.isResetting = false
    self.resetMsgAlpha = 255

    self.timers = {}
    -- set our Timer class to turn cursor highlight on and off
    table.insert( self.timers, Timer.every(0.5, function()
        self.rectHighlighted = not self.rectHighlighted
    end) )

    -- subtract 1 from timer every second
    table.insert( self.timers, Timer.every(1, function()
        self.timer = self.timer - 1

        -- play warning sound on timer if we get low
        if self.timer <= 5 then
            gAcidGSounds['clock']:play()
        end
    end))
end

function AcidGPlayState:enter()

    -- score we have to reach to get to the next level
    self.scoreGoal = self.level * 1.5 * 1000
end

function AcidGPlayState:update(dt)
    -- go back to start if time runs out
    if self.timer <= 0 then

        -- clear timers from prior AcidGPlayStates
        for _, timer in pairs(self.timers) do
            timer:remove()
        end

        gAcidGSounds['game-over']:play()

        gStateStack:pop()
        gStateStack:push(AcidGGameOverState({
            bkgrd = self.bkgrd,
            score = self.score,
            level = self.level,
        }))
    end

    -- go to next level if we surpass score goal
    if self.score >= self.scoreGoal then

        -- clear timers from prior AcidGPlayStates
        -- always clear before you change state, else next state's timers
        -- will also clear!
        for _, timer in pairs(self.timers) do
            timer:remove()
        end

        gAcidGSounds['next-level']:play()

        if self.level == 10 then
            gStateStack:pop()
            gStateStack:push(AcidGGameOverState({
                bkgrd = self.bkgrd,
                score = self.score,
                level = self.level + 1,
            }))
        else
            -- change to begin game state with new level (incremented)
            gStateStack:pop()
            gStateStack:push(AcidGBeginGameState( {
                bkgrd = self.bkgrd,
                level = self.level + 1,
                score = self.score
            }))
        end
    end

    if self.canInput and not self.isResetting then

        -- check if the board has at least one valid move in it, if it
        -- doesn't, reset the board
        if not self.board:isValid() then
            self.board:clearRepopulate()
            self.isResetting = true
            self.resetMsgAlpha = 0
            resetTime = 8
            Timer.tween(resetTime, {[self] = {resetMsgAlpha = 255}})
            Timer.after(resetTime, function() self.isResetting = false end)
        end

        --[[
            Old arrow key based interaction with the gameboard, we now
            favor the mouse approach
        -- move cursor around based on bounds of grid, playing sounds
        if love.keyboard.wasPressed('up') then
            self.boardHighlightY = math.max(0, self.boardHighlightY - 1)
            gAcidGSounds['select']:play()
        elseif love.keyboard.wasPressed('down') then
            self.boardHighlightY = math.min(7, self.boardHighlightY + 1)
            gAcidGSounds['select']:play()
        elseif love.keyboard.wasPressed('left') then
            self.boardHighlightX = math.max(0, self.boardHighlightX - 1)
            gAcidGSounds['select']:play()
        elseif love.keyboard.wasPressed('right') then
            self.boardHighlightX = math.min(7, self.boardHighlightX + 1)
            gAcidGSounds['select']:play()
        end

        -- if we've pressed enter, to select or deselect a tile...
        if love.keyboard.wasPressed('enter') or love.keyboard.wasPressed('return') then
        --]]

        if #love.mouse.mouseClicks > 0 then
            -- Only consider the most recently pressed mouse spot for highlighting
            lastClickCoords = love.mouse.mouseClicks[#love.mouse.mouseClicks]
            clickX, clickY = lastClickCoords.x, lastClickCoords.y
            gridX, gridY = self.board:convertToGrid(clickX, clickY)
            -- if mouse has clicked outside of the boundaries of the board,
            -- do not update the highlighted cell
            if gridX < 1 or gridX > 8 or gridY < 1 or gridY > 8 then
                -- LUA hack to emulate traditional continue behavior
                goto continue
            end
            -- self boardHighlight X and Y are 0 based, but most of the other
            -- structures for this game (and Lua) are 1 based
            self.boardHighlightX = gridX - 1
            self.boardHighlightY = gridY - 1

            -- if same tile as currently highlighted, deselect
            local x = self.boardHighlightX + 1
            local y = self.boardHighlightY + 1

            -- if nothing is highlighted, highlight current tile
            if not self.highlightedTile then
                self.highlightedTile = self.board.tiles[y][x]

            -- if we select the position already highlighted, remove highlight
            elseif self.highlightedTile == self.board.tiles[y][x] then
                self.highlightedTile = nil

            -- if the difference between X and Y combined of this highlighted tile
            -- vs the previous is not equal to 1, also remove highlight
            elseif math.abs(self.highlightedTile.gridX - x) + math.abs(self.highlightedTile.gridY - y) > 1 then
                gAcidGSounds['error']:play()
                self.highlightedTile = nil
            else
                -- check if swapping the tiles will result in a match by
                -- temporarily switching the tiles (but not finalizing this switch
                -- to the player by tweening it) and checking if there are matches
                -- If there are matches, swap and tween. If there are not do not
                -- swap, indicate the swap failed, and unhighlight the highlighted tile
                local ltile = self.highlightedTile
                local rtile = self.board.tiles[y][x]
                self.board:swapTiles(ltile, rtile)
                local matches = self.board:calculateMatches()
                self.board:swapTiles(ltile, rtile)
                if matches then
                    self.board:swapTiles(self.highlightedTile, self.board.tiles[y][x])
                    -- tween coordinates between the two so they swap
                    Timer.tween(0.1, {
                        [ltile] = {x = rtile.x, y = rtile.y},
                        [rtile] = {x = ltile.x, y = ltile.y}
                    })

                    -- once the swap is finished, we can tween falling blocks as needed
                    :finish(function()
                        self:calculateMatches()
                    end)
                else
                    gAcidGSounds['error']:play()
                    self.highlightedTile = nil
                end
            end
            ::continue::
        end
    end

    self.board:update(dt)
end

--[[
    Calculates whether any matches were found on the board and tweens the needed
    tiles to their new destinations if so. Also removes tiles from the board that
    have matched and replaces them with new randomized tiles, deferring most of this
    to the Board class.
]]
function AcidGPlayState:calculateMatches()
    self.highlightedTile = nil

    -- if we have any matches, remove them and tween the falling blocks that result
    local matches = self.board:calculateMatches()

    if matches then
        gAcidGSounds['match']:stop()
        gAcidGSounds['match']:play()

        -- add score for each match
        -- and add a bonus second timer for every block cleared
        for k, match in pairs(matches) do
            self.timer = self.timer + 1
            for _, tile in pairs(match) do
                self.score = self.score + 50 * tile.variety
            end
        end

        -- remove any tiles that matched from the board, making empty spaces
        self.board:removeMatches()

        -- gets a table with tween values for tiles that should now fall
        local tilesToFall = self.board:getFallingTiles()

        -- tween new tiles that spawn from the ceiling over 0.25s to fill in
        -- the new upper gaps that exist
        Timer.tween(0.25, tilesToFall):finish(function()

            -- recursively call function in case new matches have been created
            -- as a result of falling blocks once new blocks have finished falling
            self:calculateMatches()
        end)

    -- if no matches, we can continue playing
    else
        self.canInput = true
    end
end

function AcidGPlayState:render()
    self.bkgrd:render()
    -- render board of tiles
    self.board:render()

    -- render highlighted tile if it exists
    if self.highlightedTile then

        -- multiply so drawing white rect makes it brighter
        love.graphics.setBlendMode('add')

        love.graphics.setColor(255, 255, 255, 96)
        love.graphics.rectangle('fill', (self.highlightedTile.gridX - 1) * 32 + self.board.x,
            (self.highlightedTile.gridY - 1) * 32 + self.board.y, 32, 32, 4)

        -- back to alpha
        love.graphics.setBlendMode('alpha')
    end

    -- render highlight rect color based on timer
    if self.rectHighlighted then
        love.graphics.setColor(217, 87, 99, 255)
    else
        love.graphics.setColor(172, 50, 50, 255)
    end

    -- draw actual cursor rect
    love.graphics.setLineWidth(4)
    love.graphics.rectangle('line', self.boardHighlightX * 32 + self.board.x,
        self.boardHighlightY * 32 + self.board.y, 32, 32, 4)

    -- GUI text
    love.graphics.setColor(56, 56, 56, 234)
    local guix = VIRTUAL_WIDTH/2 + 16
    local guiy = VIRTUAL_HEIGHT/2 - 64
    love.graphics.rectangle('fill', guix, guiy, 186, 116, 4)

    love.graphics.setColor(99, 155, 255, 255)
    love.graphics.setFont(gFonts['medium'])
    love.graphics.printf('Level: ' .. tostring(self.level),
        guix + 4, 
        guiy + 8, 182, 'center')
    love.graphics.printf('Score: ' .. tostring(self.score),
        guix + 4, guiy + 36, 182, 'center')
    love.graphics.printf('Goal : ' .. tostring(self.scoreGoal),
        guix + 4,
        guiy + 64, 182, 'center')
    love.graphics.printf('Timer: ' .. tostring(self.timer),
        guix + 4,
        guiy + 92, 182, 'center')

    -- Possible Reset Board Message
    if self.isResetting then
        love.graphics.setColor(255, 255, 255, self.resetMsgAlpha)
        love.graphics.setFont(gFonts['large'])
        love.graphics.printf('Reset Invalid Board',
            VIRTUAL_WIDTH - 272 + 3*16, 5*16, 182, 'center')
        love.graphics.setColor(255, 255, 255, 255)
    end
end
