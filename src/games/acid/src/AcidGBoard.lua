--[[
    GD50
    Match-3 Remake

    -- AcidGBoard Class --

    Author: Colton Ogden
    cogden@cs50.harvard.edu

    The AcidGBoard is our arrangement of Tiles with which we must try to find matching
    sets of three horizontally or vertically.
]]

AcidGBoard = Class{}

function AcidGBoard:init(x, y)
    self.x = x
    self.y = y
    self.matches = {}

    self:initializeTiles()
end

function AcidGBoard:isTileShiny()
    return math.random(64) == 1
end

function AcidGBoard:getTileColor()
    local tileOpts = {1, 6, 9, 11, 12, 17}
    return tileOpts[math.random(#tileOpts)]
end

function AcidGBoard:convertToGrid(virtualX, virtualY)
    local tileDim = 32
    return math.floor((virtualX - self.x)/tileDim) + 1,
           math.floor((virtualY - self.y)/tileDim) + 1
end

--[[
    Function that will swap two tiles as they are represented by the board
]]
function AcidGBoard:swapTiles(ltile, rtile)
    if ltile.gridX == rtile.gridX and ltile.gridY == rtile.gridY then
        return
    end
    -- swap grid positions of tiles
    local tempX = ltile.gridX
    local tempY = ltile.gridY

    ltile.gridX = rtile.gridX
    ltile.gridY = rtile.gridY
    rtile.gridX = tempX
    rtile.gridY = tempY

    -- swap tiles in the tiles table
    self.tiles[ltile.gridY][ltile.gridX] =
        ltile

    self.tiles[rtile.gridY][rtile.gridX] = rtile
end

--[[
    Checks to see if at least one match can be created by validly swapping two
    neighboring tiles
    This method assumes the board does not currently contain a match
]]
function AcidGBoard:isValid()
    for y = 1, 8 do
        for x = 1, 8 do
            local curTile = self.tiles[y][x]
            -- check up, down, left, right swaps:
            -- DOWN
            local swapTile = self.tiles[math.min(y+1,8)][x]
            self:swapTiles(curTile, swapTile)
            matches = self:calculateMatches()
            self:swapTiles(curTile, swapTile)
            if matches then
                return true
            end
            -- UP
            swapTile = self.tiles[math.max(y-1,1)][x]
            self:swapTiles(curTile, swapTile)
            matches = self:calculateMatches()
            self:swapTiles(curTile, swapTile)
            if matches then
                return true
            end
            -- RIGHT
            swapTile = self.tiles[y][math.min(x+1,8)]
            self:swapTiles(curTile, swapTile)
            matches = self:calculateMatches()
            self:swapTiles(curTile, swapTile)
            if matches then
                return true
            end
            -- LEFT
            swapTile = self.tiles[y][math.max(x-1,1)]
            self:swapTiles(curTile, swapTile)
            matches = self:calculateMatches()
            self:swapTiles(curTile, swapTile)
            if matches then
                return true
            end
        end
    end
    return false
end

function AcidGBoard:initializeTiles(level)
    self.tiles = {}
    self.level = level and level or 1

    for tileY = 1, 8 do

        -- empty table that will serve as a new row
        table.insert(self.tiles, {})

        for tileX = 1, 8 do

            -- create a new tile at X,Y with a random color and variety
            -- current implementation will limit the variety of tiles that
            -- are availabale according to the current level
            -- On average one tile per board will be shiny
            table.insert(
                self.tiles[tileY],
                AcidGTile(
                    tileX,
                    tileY,
                    self:getTileColor(),
                    math.min(math.random(self.level), ACIDG_MAX_TILE_VARIETY),
                    self:isTileShiny()))
        end
    end

    while self:calculateMatches() do

        -- recursively initialize if matches were returned so we always have
        -- a matchless board on start
        self:initializeTiles(self.level)
    end
end

--[[
    Goes left to right, top to bottom in the board, calculating matches by counting consecutive
    tiles of the same color. Doesn't need to check the last tile in every row or column if the
    last two haven't been a match.
]]
function AcidGBoard:calculateMatches()
    local matches = {}

    -- how many of the same color blocks in a row we've found
    local matchNum = 1

    -- horizontal matches first
    for y = 1, 8 do
        local colorToMatch = self.tiles[y][1].color
        local isShinyMatch = false
        local rowMatches = {}

        matchNum = 1

        -- every horizontal tile
        for x = 2, 8 do

            -- if this is the same color as the one we're trying to match...
            if self.tiles[y][x].color == colorToMatch then
                matchNum = matchNum + 1
            else

                -- set this as the new color we want to watch for
                colorToMatch = self.tiles[y][x].color

                -- if we have a match of 3 or more up to now, add it to our matches table
                if matchNum >= 3 then
                    local match = {}

                    -- go backwards from here by matchNum
                    for x2 = x - 1, x - matchNum, -1 do

                        -- add each tile to the match that's in that match
                        table.insert(match, self.tiles[y][x2])
                        isShinyMatch = isShinyMatch or self.tiles[y][x2].isShiny
                    end

                    -- add this match to our total matches table
                    table.insert(rowMatches, match)
                end

                matchNum = 1

                -- don't need to check last two if they won't be in a match
                if x >= 7 then
                    break
                end
            end
        end

        -- account for the last row ending with a match
        if matchNum >= 3 then
            local match = {}

            -- go backwards from end of last row by matchNum
            for x = 8, 8 - matchNum + 1, -1 do
                table.insert(match, self.tiles[y][x])
                isShinyMatch = isShinyMatch or self.tiles[y][x].isShiny
            end

            table.insert(rowMatches, match)
        end

        -- if we had a shiny row match, insert all tiles in this row as
        -- a "match" that should be removed and scored from the board
        -- if no shiny match, just include the non-shiny matches
        if isShinyMatch then
            local match = {}
            for x = 1, 8 do
                table.insert(match, self.tiles[y][x])
            end
            table.insert(matches, match)
        else
            for _, match in pairs(rowMatches) do
                table.insert(matches, match)
            end
        end
    end

    -- vertical matches
    for x = 1, 8 do
        local colorToMatch = self.tiles[1][x].color
        local isShinyMatch = false
        local colMatches = {}

        matchNum = 1

        -- every vertical tile
        for y = 2, 8 do
            if self.tiles[y][x].color == colorToMatch then
                matchNum = matchNum + 1
            else
                colorToMatch = self.tiles[y][x].color

                if matchNum >= 3 then
                    local match = {}

                    for y2 = y - 1, y - matchNum, -1 do
                        isShinyMatch = isShinyMatch or self.tiles[y2][x].isShiny
                        table.insert(match, self.tiles[y2][x])
                    end

                    table.insert(colMatches, match)
                end

                matchNum = 1

                -- don't need to check last two if they won't be in a match
                if y >= 7 then
                    break
                end
            end
        end

        -- account for the last column ending with a match
        if matchNum >= 3 then
            local match = {}

            -- go backwards from end of last row by matchNum
            for y = 8, 8 - matchNum + 1, -1 do
                isShinyMatch = isShinyMatch or self.tiles[y][x].isShiny
                table.insert(match, self.tiles[y][x])
            end

            table.insert(colMatches, match)
        end

        -- if we had a shiny column match, insert all tiles in this column as
        -- a "match" that should be removed and scored from the board
        -- if no shiny match, just include the non-shiny matches
        if isShinyMatch then
            local match = {}
            for y = 1, 8 do
                table.insert(match, self.tiles[y][x])
            end
            table.insert(matches, match)
        else
            for _, match in pairs(colMatches) do
                table.insert(matches, match)
            end
        end
    end

    -- store matches for later reference
    self.matches = matches

    -- return matches table if > 0, else just return false
    return #self.matches > 0 and self.matches or false
end

--[[
    Called when we want to remove every tile and repopulate the board
    with a brand new board of tiles
]]
function AcidGBoard:clearRepopulate()
    -- remove all tiles from the presumably invalid board
    local matchedTiles = {}
    local fadeTileTweens = {}
    for y = 1, 8 do
        for x = 1, 8 do
            table.insert(matchedTiles, self.tiles[y][x])
            fadeTileTweens[self.tiles[y][x]] = {opacity = 0}
        end
    end

    -- hijack the member matches function so that AcidGBoard:removeMatches removes
    -- every tile from the current board
    table.insert(self.matches, matchedTiles)
    local fadeTime = 4
    Timer.tween(fadeTime, fadeTileTweens):finish(function()
        self:removeMatches()
    end):finish(function()
        self:initializeTiles()
        fadeTileTweens = {}
        for y = 1, 8 do
            for x = 1, 8 do
                -- To fade in
                self.tiles[y][x].opacity = 0
                fadeTileTweens[self.tiles[y][x]] = {opacity = 255}
            end
        end
        Timer.tween(fadeTime, fadeTileTweens)
    end)
end

--[[
    Remove the matches from the AcidGBoard by just setting the Tile slots within
    them to nil, then setting self.matches to nil.
]]
function AcidGBoard:removeMatches()
    for k, match in pairs(self.matches) do
        for k, tile in pairs(match) do
            self.tiles[tile.gridY][tile.gridX] = nil
        end
    end

    self.matches = nil
end

--[[
    Shifts down all of the tiles that now have spaces below them, then returns a table that
    contains tweening information for these new tiles.
]]
function AcidGBoard:getFallingTiles()
    -- tween table, with tiles as keys and their x and y as the to values
    local tweens = {}

    -- for each column, go up tile by tile till we hit a space
    for x = 1, 8 do
        local space = false
        local spaceY = 0

        local y = 8
        while y >= 1 do

            -- if our last tile was a space...
            local tile = self.tiles[y][x]

            if space then

                -- if the current tile is *not* a space, bring this down to the lowest space
                if tile then

                    -- put the tile in the correct spot in the board and fix its grid positions
                    self.tiles[spaceY][x] = tile
                    tile.gridY = spaceY

                    -- set its prior position to nil
                    self.tiles[y][x] = nil

                    -- tween the Y position to 32 x its grid position
                    tweens[tile] = {
                        y = (tile.gridY - 1) * 32
                    }

                    -- set Y to spaceY so we start back from here again
                    space = false
                    y = spaceY

                    -- set this back to 0 so we know we don't have an active space
                    spaceY = 0
                end
            elseif tile == nil then
                space = true

                -- if we haven't assigned a space yet, set this to it
                if spaceY == 0 then
                    spaceY = y
                end
            end

            y = y - 1
        end
    end

    -- create replacement tiles at the top of the screen
    for x = 1, 8 do
        for y = 8, 1, -1 do
            local tile = self.tiles[y][x]

            -- if the tile is nil, we need to add a new one
            if not tile then

                -- new tile with random color and variety
                local tile = AcidGTile(
                    x,
                    y,
                    self:getTileColor(),
                    math.min(math.random(self.level), ACIDG_MAX_TILE_VARIETY),
                    self:isTileShiny())
                tile.y = -32
                self.tiles[y][x] = tile

                -- create a new tween to return for this tile to fall down
                tweens[tile] = {
                    y = (tile.gridY - 1) * 32
                }
            end
        end
    end

    return tweens
end

function AcidGBoard:update(dt)
    for y = 1, #self.tiles do
        for x = 1, #self.tiles[1] do
            self.tiles[y][x]:update(dt)
        end
    end
end

function AcidGBoard:render()
    for y = 1, #self.tiles do
        for x = 1, #self.tiles[1] do
            self.tiles[y][x]:render(self.x, self.y)
        end
    end
end
