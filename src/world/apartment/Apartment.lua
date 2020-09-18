--[[
    KLW

    Code for layout of the home base apartment room

    Author: Craig Roper
--]]

Apartment = Class{}

function Apartment:init()
    self.name = 'apartment'

    self.floortiles = {}
    self:generateFloorTiles()

    self.furniture = {}
    self:generateFurniture()
end

function Apartment:generateFloorTiles()
    local floorTileWidth = gFramesInfo[self.name][gAPT_FLOOR_NAME]['width']
    local floorTileHeight = gFramesInfo[self.name][gAPT_FLOOR_NAME]['height']
    local numTilesWide = VIRTUAL_WIDTH / floorTileWidth + 1
    local numTilesHigh = VIRTUAL_HEIGHT / floorTileHeight + 1
    for y = 1, numTilesHigh do
        for x = 1, numTilesWide do
            self.floortiles[y*numTilesWide + x] = {
                gTextures[self.name],
                gFrames[self.name][gAPT_FLOOR_NAME],
                (x - 1) * floorTileWidth,
                (y - 1) * floorTileHeight}
        end
    end
end

function Apartment:renderFloorTiles()
    for _, tile in pairs(self.floortiles) do
        love.graphics.draw(tile[1], tile[2], tile[3], tile[4])
    end
end

function Apartment:generateFurniture()
    -- Populate furniture
    local GAP_FROM_LEFT_WALL = 10
    local GAP_FROM_TOP_WALL = 10
    local GAP_FROM_BOTTOM_WALL = 10

    -- Draw in couch starting from gaps
    local vertCouchWidth = gFramesInfo[self.name][gAPT_VERT_COUCH_NAME]['width']
    local vertCouchHeight = gFramesInfo[self.name][gAPT_VERT_COUCH_NAME]['height']
    local vertCouchX = GAP_FROM_LEFT_WALL
    local vertCouchY = GAP_FROM_TOP_WALL
    self.furniture['vertical-couch'] = {
        gTextures[self.name],
        gFrames[self.name][gAPT_VERT_COUCH_NAME],
        vertCouchX, vertCouchY}

    -- Attach the horizontal section of the couch to the vertical portion
    local horzCouchWidth = gFramesInfo[self.name][gAPT_HORZ_COUCH_NAME]['width']
    local horzCouchHeight = gFramesInfo[self.name][gAPT_HORZ_COUCH_NAME]['height']
    local horzCouchX = vertCouchX + vertCouchWidth
    local horzCouchY = vertCouchY
    self.furniture['horizontal-couch'] = {gTextures[self.name],
        gFrames[self.name][gAPT_HORZ_COUCH_NAME],
        horzCouchX, horzCouchY}

    -- Center the coffee table on the horizontal portion of the couch and
    -- have the table a static offset off the couch
    -- of the couch
    local tableWidth = gFramesInfo[self.name][gAPT_TABLE_NAME]['width']
    local tableHeight = gFramesInfo[self.name][gAPT_TABLE_NAME]['height']
    local tableX = (horzCouchX + horzCouchWidth/2 - tableWidth/2)
    local COUCH_TABLE_GAP = 40
    local tableY = (horzCouchY + horzCouchHeight) + COUCH_TABLE_GAP
    self.furniture['coffee-table'] = {gTextures[self.name],
        gFrames[self.name][gAPT_TABLE_NAME],
        tableX, tableY}

    -- Center the tv stand on the horizontal portion of the couch, and
    -- the bottom of the room
    local tvWidth = gFramesInfo[self.name][gAPT_TV_NAME]['width']
    local tvHeight = gFramesInfo[self.name][gAPT_TV_NAME]['height']
    local tvX = (horzCouchX + horzCouchWidth/2 - tvWidth/2)
    local tvY = VIRTUAL_HEIGHT - GAP_FROM_BOTTOM_WALL - tvHeight
    self.furniture['tv'] = {gTextures[self.name],
        gFrames[self.name][gAPT_TV_NAME],
        tvX, tvY}

    -- set the corner of the kitchen counter and island a gap from the end of the
    -- couch
    local horzLongCounterWidth = gFramesInfo[self.name][gAPT_LONG_COUNTER_NAME]['width']
    local horzLongCounterHeight = gFramesInfo[self.name][gAPT_LONG_COUNTER_NAME]['height']
    local COUCH_COUNTER_GAP = 100
    local horzLongCounterX = (horzCouchX + horzCouchWidth) + COUCH_COUNTER_GAP
    local horzLongCounterY = horzCouchY
    self.furniture['horizontal-long-counter'] = {gTextures[self.name],
        gFrames[self.name][gAPT_LONG_COUNTER_NAME],
        horzLongCounterX, horzLongCounterY}

    -- Rotate the long counter vertically to form the breakfast bar, since
    -- this is rotating by 270 degrees (4.71 radians), the width and height
    -- values will be switched for the final rendering
    local vertLongCounterWidth = gFramesInfo[self.name][gAPT_LONG_COUNTER_NAME]['height']
    local vertLongCounterHeight = gFramesInfo[self.name][gAPT_LONG_COUNTER_NAME]['width']
    local COUNTER_OVERLAP = 5
    local vertLongCounterX = horzLongCounterX
    local vertLongCounterY = horzLongCounterY + horzLongCounterHeight + vertLongCounterHeight - COUNTER_OVERLAP
    self.furniture['vertical-long-counter'] = {gTextures[self.name],
        gFrames[self.name][gAPT_LONG_COUNTER_NAME],
        vertLongCounterX, vertLongCounterY, 4.71, 1, 1, 0, 0}

    -- Put the sink in flush and to the right of the horizontal long counter
    -- and center it vertically on the counter height
    local sinkWidth = gFramesInfo[self.name][gAPT_SINK_NAME]['width']
    local sinkHeight = gFramesInfo[self.name][gAPT_SINK_NAME]['height']
    local sinkX = horzLongCounterX + horzLongCounterWidth
    local sinkY = (horzLongCounterY + horzLongCounterHeight/2) - sinkHeight/2
    self.furniture['sink'] = {gTextures[self.name],
        gFrames[self.name][gAPT_SINK_NAME],
        sinkX, sinkY}

    -- Put a short counter on the other side of the sink
    local shortCounterWidth = gFramesInfo[self.name][gAPT_SHORT_COUNTER_NAME]['width']
    local shortCounterHeight = gFramesInfo[self.name][gAPT_SHORT_COUNTER_NAME]['height']
    local shortCounterX = sinkX + sinkWidth
    local shortCounterY = horzLongCounterY
    self.furniture['short-counter'] = {gTextures[self.name],
        gFrames[self.name][gAPT_SHORT_COUNTER_NAME],
        shortCounterX, shortCounterY}

    -- Stove comes next on the horizontal kitchen counter space
    -- Have to rotate the stove 90 degrees (1.57 radians)
    -- so flip the width and height values
    local stoveWidth = gFramesInfo[self.name][gAPT_STOVE_NAME]['height']
    local stoveHeight = gFramesInfo[self.name][gAPT_STOVE_NAME]['width']
    local stoveX = shortCounterX + shortCounterWidth
    local stoveY = shortCounterY
    -- offset to account for 90 degree turn
    self.furniture['stove'] = {gTextures[self.name],
        gFrames[self.name][gAPT_STOVE_NAME],
        stoveX, stoveY, 1.57, 1, 1, 0, stoveWidth}

    -- Finish the kitchen with the refrigerator all the way on the right and
    -- centered on the sink Y height
    local fridgeWidth = gFramesInfo[self.name][gAPT_FRIDGE_NAME]['width']
    local fridgeHeight = gFramesInfo[self.name][gAPT_FRIDGE_NAME]['height']
    local fridgeX = stoveX + stoveWidth
    local fridgeY = sinkY
    self.furniture['fridge'] = {gTextures[self.name],
        gFrames[self.name][gAPT_FRIDGE_NAME],
        fridgeX, fridgeY}

    -- Center the desk on the short counter, and put its bottom edge flush
    -- with the TV's bottom edge
    local deskWidth = gFramesInfo[self.name][gAPT_DESK_NAME]['width']
    local deskHeight = gFramesInfo[self.name][gAPT_DESK_NAME]['height']
    local deskX = (shortCounterX + shortCounterWidth/2) - deskWidth/2
    local deskY = (tvY + tvHeight) - deskHeight
    self.furniture['desk'] = {gTextures[self.name],
        gFrames[self.name][gAPT_DESK_NAME],
        deskX, deskY}

    -- Place desk chair flush and centered with the desk
    local chairWidth = gFramesInfo[self.name][gAPT_DESK_CHAIR_NAME]['width']
    local chairHeight = gFramesInfo[self.name][gAPT_DESK_CHAIR_NAME]['width']
    local chairX = (deskX + deskWidth/2) - chairWidth/2
    local chairY = deskY - chairHeight
    self.furniture['desk-chair'] = {gTextures[self.name],
        gFrames[self.name][gAPT_DESK_CHAIR_NAME],
        chairX, chairY}
end

function Apartment:renderFurniture()
    for name, furniture in pairs(self.furniture) do
        if #furniture == 4 then
            love.graphics.draw(furniture[1], furniture[2], furniture[3], furniture[4])
        elseif #furniture == 9 then
            love.graphics.draw(furniture[1], furniture[2], furniture[3], furniture[4],
                furniture[5], furniture[6], furniture[7], furniture[8], furniture[9])
        else
            print(name)
        end
    end
end

function Apartment:render()
    self:renderFloorTiles()
    self:renderFurniture()
end
    --[[
    -- Populate furniture
    local GAP_FROM_LEFT_WALL = 10
    local GAP_FROM_TOP_WALL = 10
    -- Draw in couch starting from gaps
    local vertCouchWidth = gFramesInfo[self.name][gAPT_VERT_COUCH_NAME]['width']
    local vertCouchHeight = gFramesInfo[self.name][gAPT_VERT_COUCH_NAME]['height']
    local vertCouchX = GAP_FROM_LEFT_WALL
    local vertCouchY = GAP_FROM_TOP_WALL
    love.graphics.draw(gTextures[self.name],
        gFrames[self.name][gAPT_VERT_COUCH_NAME],
        vertCouchX, vertCouchY)
    -- Attach the horizontal section of the couch to the vertical portion
    local horzCouchWidth = gFramesInfo[self.name][gAPT_HORZ_COUCH_NAME]['width']
    local horzCouchHeight = gFramesInfo[self.name][gAPT_HORZ_COUCH_NAME]['height']
    local horzCouchX = vertCouchX + vertCouchWidth
    local horzCouchY = vertCouchY
    love.graphics.draw(gTextures[self.name],
        gFrames[self.name][gAPT_HORZ_COUCH_NAME],
        horzCouchX, horzCouchY)
    -- Center the coffee table on the horizontal portion of the couch and
    -- have the table a static offset off the couch
    -- of the couch
    local tableWidth = gFramesInfo[self.name][gAPT_TABLE_NAME]['width']
    local tableHeight = gFramesInfo[self.name][gAPT_TABLE_NAME]['height']
    local tableX = (horzCouchX + horzCouchWidth/2 - tableWidth/2)
    local COUCH_TABLE_GAP = 40
    local tableY = (horzCouchY + horzCouchHeight) + COUCH_TABLE_GAP
    love.graphics.draw(gTextures[self.name],
        gFrames[self.name][gAPT_TABLE_NAME],
        tableX, tableY)
    -- Center the tv stand on the horizontal portion of the couch, and
    -- give it a reasonable gap from the coffee table
    local tvWidth = gFramesInfo[self.name][gAPT_TV_NAME]['width']
    local tvHeight = gFramesInfo[self.name][gAPT_TV_NAME]['height']
    local tvX = (horzCouchX + horzCouchWidth/2 - tvWidth/2)
    local TABLE_TV_GAP = 100
    local tvY = (tableY + tableHeight) + TABLE_TV_GAP
    love.graphics.draw(gTextures[self.name],
        gFrames[self.name][gAPT_TV_NAME],
        tvX, tvY)
    -- set the corner of the kitchen counter and island a gap from the end of the
    -- couch
    local horzLongCounterWidth = gFramesInfo[self.name][gAPT_LONG_COUNTER_NAME]['width']
    local horzLongCounterHeight = gFramesInfo[self.name][gAPT_LONG_COUNTER_NAME]['height']
    local COUCH_COUNTER_GAP = 100
    local horzLongCounterX = (horzCouchX + horzCouchWidth) + COUCH_COUNTER_GAP
    local horzLongCounterY = horzCouchY
    love.graphics.draw(gTextures[self.name],
        gFrames[self.name][gAPT_LONG_COUNTER_NAME],
        horzLongCounterX, horzLongCounterY)
    -- Rotate the long counter vertically to form the breakfast bar, since
    -- this is rotating by 270 degrees (4.71 radians), the width and height
    -- values will be switched for the final rendering
    local vertLongCounterWidth = gFramesInfo[self.name][gAPT_LONG_COUNTER_NAME]['height']
    local vertLongCounterHeight = gFramesInfo[self.name][gAPT_LONG_COUNTER_NAME]['width']
    local COUNTER_OVERLAP = 5
    local vertLongCounterX = horzLongCounterX
    local vertLongCounterY = horzLongCounterY + horzLongCounterHeight + vertLongCounterHeight - COUNTER_OVERLAP
    love.graphics.draw(gTextures[self.name],
        gFrames[self.name][gAPT_LONG_COUNTER_NAME],
        vertLongCounterX, vertLongCounterY, 4.71)
    -- Put the sink in flush and to the right of the horizontal long counter
    -- and center it vertically on the counter height
    local sinkWidth = gFramesInfo[self.name][gAPT_SINK_NAME]['width']
    local sinkHeight = gFramesInfo[self.name][gAPT_SINK_NAME]['height']
    local sinkX = horzLongCounterX + horzLongCounterWidth
    local sinkY = (horzLongCounterY + horzLongCounterHeight/2) - sinkHeight/2
    love.graphics.draw(gTextures[self.name],
        gFrames[self.name][gAPT_SINK_NAME],
        sinkX, sinkY)
    -- Put a short counter on the other side of the sink
    local shortCounterWidth = gFramesInfo[self.name][gAPT_SHORT_COUNTER_NAME]['width']
    local shortCounterHeight = gFramesInfo[self.name][gAPT_SHORT_COUNTER_NAME]['height']
    local shortCounterX = sinkX + sinkWidth
    local shortCounterY = horzLongCounterY
    love.graphics.draw(gTextures[self.name],
        gFrames[self.name][gAPT_SHORT_COUNTER_NAME],
        shortCounterX, shortCounterY)
    -- Stove comes next on the horizontal kitchen counter space
    -- Have to rotate the stove 90 degrees (1.57 radians)
    -- so flip the width and height values
    local stoveWidth = gFramesInfo[self.name][gAPT_STOVE_NAME]['height']
    local stoveHeight = gFramesInfo[self.name][gAPT_STOVE_NAME]['width']
    local stoveX = shortCounterX + shortCounterWidth
    local stoveY = shortCounterY
    -- offset to account for 90 degree turn
    love.graphics.draw(gTextures[self.name],
        gFrames[self.name][gAPT_STOVE_NAME],
        stoveX, stoveY, 1.57, 1, 1, 0, stoveWidth)
    -- Finish the kitchen with the refrigerator all the way on the right and
    -- centered on the sink Y height
    local fridgeWidth = gFramesInfo[self.name][gAPT_FRIDGE_NAME]['width']
    local fridgeHeight = gFramesInfo[self.name][gAPT_FRIDGE_NAME]['height']
    local fridgeX = stoveX + stoveWidth
    local fridgeY = sinkY
    love.graphics.draw(gTextures[self.name],
        gFrames[self.name][gAPT_FRIDGE_NAME],
        fridgeX, fridgeY)
    -- Center the desk on the short counter, and put its bottom edge flush
    -- with the TV's bottom edge
    local deskWidth = gFramesInfo[self.name][gAPT_DESK_NAME]['width']
    local deskHeight = gFramesInfo[self.name][gAPT_DESK_NAME]['height']
    local deskX = (shortCounterX + shortCounterWidth/2) - deskWidth/2
    local deskY = (tvY + tvHeight) - deskHeight
    love.graphics.draw(gTextures[self.name],
        gFrames[self.name][gAPT_DESK_NAME],
        deskX, deskY)
    -- Place desk chair flush and centered with the desk
    local chairWidth = gFramesInfo[self.name][gAPT_DESK_CHAIR_NAME]['width']
    local chairHeight = gFramesInfo[self.name][gAPT_DESK_CHAIR_NAME]['width']
    local chairX = (deskX + deskWidth/2) - chairWidth/2
    local chairY = deskY - chairHeight
    love.graphics.draw(gTextures[self.name],
        gFrames[self.name][gAPT_DESK_CHAIR_NAME],
        chairX, chairY) 
    
end
    --]]
