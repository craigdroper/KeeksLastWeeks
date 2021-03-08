--[[
    GD50
    Breakout Remake

    -- BarGLevelMaker Class --

    Author: Colton Ogden
    cogden@cs50.harvard.edu

    Creates randomized levels for our Breakout game. Returns a table of
    bricks that the game can render, based on the current level we're at
    in the game.
]]

-- global patterns (used to make the entire map a certain shape)
NONE = 1
SINGLE_PYRAMID = 2
MULTI_PYRAMID = 3

-- per-row patterns
-- SOLID = 1           -- all colors the same in this row
-- ALTERNATE = 2       -- alternate colors
SKIP = 3            -- skip every other block
NONE = 4            -- no blocks this row

BarGLevelMaker = Class{}

--[[
    Creates a table of BarGBricks to be returned to the main game, with different
    possible ways of randomizing rows and columns of bricks. Calculates the
    brick colors and tiers to choose based on the level passed in.
]]
function BarGLevelMaker.createMap(level, barBackground)
    local bricks = {}

    -- create a temporary brick to retrieve its width and height
    local tmpBrick = BarGBrick(0, 0, 1)
    local brickWidth = tmpBrick.width
    local brickHeight = tmpBrick.height

    -- create a temporary brick to retrieve its width and height
    local tmpBeerBrick = BarGBeerBrick(0, 0)
    local beerBrickWidth = tmpBeerBrick.width
    local beerBrickHeight = tmpBeerBrick.height
    local beerBrick = BarGBeerBrick(
        (VIRTUAL_WIDTH - beerBrickWidth) / 2,
        0)

    table.insert(bricks, beerBrick)

    local BRICK_PADDING = 4

    -- randomly choose the number of rows
    local barBottomY = barBackground:getBarBottomY()
    local maxRows = ((VIRTUAL_HEIGHT/2) - barBottomY - BRICK_PADDING) /
        (brickHeight + BRICK_PADDING)
    local numRows = math.random(1, math.floor(maxRows * level / 10) + 1 )

    -- randomly choose the number of columns, ensuring odd
    local maxCols = (VIRTUAL_WIDTH - BRICK_PADDING) / (brickWidth + BRICK_PADDING)
    local numCols = math.random(6, math.max(math.floor(maxCols * level / 10), 8))
    numCols = numCols % 2 == 0 and (numCols + 1) or numCols
    local colBrickOffset = (VIRTUAL_WIDTH - (brickWidth * numCols)) / (numCols + 1)

    -- lay out bricks such that they touch each other and fill the space
    for y = 1, numRows do
        -- whether we want to enable skipping for this row
        local skipPattern = math.random(1, 2) == 1 and true or false

        -- used only when we want to skip a block, for skip pattern
        local skipFlag = math.random(2) == 1 and true or false

        for x = 1, numCols do
            -- local isLockBrick = y == lockBrickRow and x == lockBrickCol
            -- if skipping is turned on and we're on a skip iteration...
            if skipPattern and skipFlag then -- and not isLockBrick then
                -- turn skipping off for the next iteration
                skipFlag = not skipFlag

                -- Lua doesn't have a continue statement, so this is the workaround
                goto continue
            else
                -- flip the flag to true on an iteration we don't use it
                skipFlag = not skipFlag
            end

            b = BarGBrick(

                -- x-coordinate
                (x-1)                   -- decrement x by 1 because tables are 1-indexed, coords are 0
                * (tmpBrick.width + colBrickOffset)       -- multiply by the brick width and the padding
                + colBrickOffset,         -- Add the starting offset according to the number of columns selected

                -- y-coordinate
                (y - 1)                 -- decrement y by 1 because tables are 1-indexed, coords are 0
                * (tmpBrick.height + BRICK_PADDING)       -- multiply by the brick height and padding
                + barBottomY,        -- Add bar offset

                -- Randomly generate a character skin for this "brick"
                math.random(gTOTAL_CHAR_COUNT)
            )

            table.insert(bricks, b)

            -- Lua's version of the 'continue' statement
            ::continue::
        end
    end

    -- in the event we didn't generate any bricks, try again
    if #bricks == 0 then
        return self.createMap(level, barBackground)
    else
        return bricks
    end
end
