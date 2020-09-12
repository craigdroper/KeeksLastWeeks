--[[
    KLW

    Code for layout of the home base apartment room

    Author: Craig Roper
--]]

Apartment = Class{}

function Apartment:init(player)
    self.width = MAP_WIDTH
    self.height = MAP_HEIGHT

    self.tiles = {}
    self:generateWallsAndFloors()

    self.furniture = {}
    self:generateFurniture()

    self.player = player
end

--[[
    Generates the floors for the apartment layout
--]]
-- TODO likely still store these objects as Apartment attributes or in
-- the furniture dictionary so we can do things like check for collisions,
-- but this is just a copy so I don't lose this work for now
function Apartment:render()
    -- XXX This is a test commenting for rendering apartment furniture just
    -- to check that the quads are being created correctly, this will be moved
    -- into the dedicated Apartment class
    -- First fill out the flooring, then put furniture on top of it
    local APT_NAME = 'apartment'
    local floorTileWidth = gFramesInfo[APT_NAME][gAPT_FLOOR_NAME]['width']
    local floorTileHeight = gFramesInfo[APT_NAME][gAPT_FLOOR_NAME]['height']
    local numTilesWide = VIRTUAL_WIDTH / floorTileWidth + 1
    local numTilesHigh = VIRTUAL_HEIGHT / floorTileHeight + 1
    for y = 1, numTilesHigh do
        for x = 1, numTilesWide do
            love.graphics.draw(
                gTextures[APT_NAME],
                gFrames[APT_NAME][gAPT_FLOOR_NAME],
                (x - 1) * floorTileWidth,
                (y - 1) * floorTileHeight)
        end
    end
    -- Populate furniture
    local GAP_FROM_LEFT_WALL = 10
    local GAP_FROM_TOP_WALL = 10
    -- Draw in couch starting from gaps
    local vertCouchWidth = gFramesInfo[APT_NAME][gAPT_VERT_COUCH_NAME]['width']
    local vertCouchHeight = gFramesInfo[APT_NAME][gAPT_VERT_COUCH_NAME]['height']
    local vertCouchX = GAP_FROM_LEFT_WALL
    local vertCouchY = GAP_FROM_TOP_WALL
    love.graphics.draw(gTextures[APT_NAME],
        gFrames[APT_NAME][gAPT_VERT_COUCH_NAME],
        vertCouchX, vertCouchY)
    -- Attach the horizontal section of the couch to the vertical portion
    local horzCouchWidth = gFramesInfo[APT_NAME][gAPT_HORZ_COUCH_NAME]['width']
    local horzCouchHeight = gFramesInfo[APT_NAME][gAPT_HORZ_COUCH_NAME]['height']
    local horzCouchX = vertCouchX + vertCouchWidth
    local horzCouchY = vertCouchY
    love.graphics.draw(gTextures[APT_NAME],
        gFrames[APT_NAME][gAPT_HORZ_COUCH_NAME],
        horzCouchX, horzCouchY)
    -- Center the coffee table on the horizontal portion of the couch and
    -- have the table a static offset off the couch
    -- of the couch
    local tableWidth = gFramesInfo[APT_NAME][gAPT_TABLE_NAME]['width']
    local tableHeight = gFramesInfo[APT_NAME][gAPT_TABLE_NAME]['height']
    local tableX = (horzCouchX + horzCouchWidth/2 - tableWidth/2)
    local COUCH_TABLE_GAP = 40
    local tableY = (horzCouchY + horzCouchHeight) + COUCH_TABLE_GAP
    love.graphics.draw(gTextures[APT_NAME],
        gFrames[APT_NAME][gAPT_TABLE_NAME],
        tableX, tableY)
    -- Center the tv stand on the horizontal portion of the couch, and
    -- give it a reasonable gap from the coffee table
    local tvWidth = gFramesInfo[APT_NAME][gAPT_TV_NAME]['width']
    local tvHeight = gFramesInfo[APT_NAME][gAPT_TV_NAME]['height']
    local tvX = (horzCouchX + horzCouchWidth/2 - tvWidth/2)
    local TABLE_TV_GAP = 100
    local tvY = (tableY + tableHeight) + TABLE_TV_GAP
    love.graphics.draw(gTextures[APT_NAME],
        gFrames[APT_NAME][gAPT_TV_NAME],
        tvX, tvY)
    -- set the corner of the kitchen counter and island a gap from the end of the
    -- couch
    local horzLongCounterWidth = gFramesInfo[APT_NAME][gAPT_LONG_COUNTER_NAME]['width']
    local horzLongCounterHeight = gFramesInfo[APT_NAME][gAPT_LONG_COUNTER_NAME]['height']
    local COUCH_COUNTER_GAP = 100
    local horzLongCounterX = (horzCouchX + horzCouchWidth) + COUCH_COUNTER_GAP
    local horzLongCounterY = horzCouchY
    love.graphics.draw(gTextures[APT_NAME],
        gFrames[APT_NAME][gAPT_LONG_COUNTER_NAME],
        horzLongCounterX, horzLongCounterY)
    -- Rotate the long counter vertically to form the breakfast bar, since
    -- this is rotating by 270 degrees (4.71 radians), the width and height
    -- values will be switched for the final rendering
    local vertLongCounterWidth = gFramesInfo[APT_NAME][gAPT_LONG_COUNTER_NAME]['height']
    local vertLongCounterHeight = gFramesInfo[APT_NAME][gAPT_LONG_COUNTER_NAME]['width']
    local COUNTER_OVERLAP = 5
    local vertLongCounterX = horzLongCounterX
    local vertLongCounterY = horzLongCounterY + horzLongCounterHeight + vertLongCounterHeight - COUNTER_OVERLAP
    love.graphics.draw(gTextures[APT_NAME],
        gFrames[APT_NAME][gAPT_LONG_COUNTER_NAME],
        vertLongCounterX, vertLongCounterY, 4.71)
    -- Put the sink in flush and to the right of the horizontal long counter
    -- and center it vertically on the counter height
    local sinkWidth = gFramesInfo[APT_NAME][gAPT_SINK_NAME]['width']
    local sinkHeight = gFramesInfo[APT_NAME][gAPT_SINK_NAME]['height']
    local sinkX = horzLongCounterX + horzLongCounterWidth
    local sinkY = (horzLongCounterY + horzLongCounterHeight/2) - sinkHeight/2
    love.graphics.draw(gTextures[APT_NAME],
        gFrames[APT_NAME][gAPT_SINK_NAME],
        sinkX, sinkY)
    -- Put a short counter on the other side of the sink
    local shortCounterWidth = gFramesInfo[APT_NAME][gAPT_SHORT_COUNTER_NAME]['width']
    local shortCounterHeight = gFramesInfo[APT_NAME][gAPT_SHORT_COUNTER_NAME]['height']
    local shortCounterX = sinkX + sinkWidth
    local shortCounterY = horzLongCounterY
    love.graphics.draw(gTextures[APT_NAME],
        gFrames[APT_NAME][gAPT_SHORT_COUNTER_NAME],
        shortCounterX, shortCounterY)
    -- Stove comes next on the horizontal kitchen counter space
    -- Have to rotate the stove 90 degrees (1.57 radians)
    -- so flip the width and height values
    local stoveWidth = gFramesInfo[APT_NAME][gAPT_STOVE_NAME]['height']
    local stoveHeight = gFramesInfo[APT_NAME][gAPT_STOVE_NAME]['width']
    local stoveX = shortCounterX + shortCounterWidth
    local stoveY = shortCounterY
    -- offset to account for 90 degree turn
    love.graphics.draw(gTextures[APT_NAME],
        gFrames[APT_NAME][gAPT_STOVE_NAME],
        stoveX, stoveY, 1.57, 1, 1, 0, stoveWidth)
    -- Finish the kitchen with the refrigerator all the way on the right and
    -- centered on the sink Y height
    local fridgeWidth = gFramesInfo[APT_NAME][gAPT_FRIDGE_NAME]['width']
    local fridgeHeight = gFramesInfo[APT_NAME][gAPT_FRIDGE_NAME]['height']
    local fridgeX = stoveX + stoveWidth
    local fridgeY = sinkY
    love.graphics.draw(gTextures[APT_NAME],
        gFrames[APT_NAME][gAPT_FRIDGE_NAME],
        fridgeX, fridgeY)
    -- Center the desk on the short counter, and put its bottom edge flush
    -- with the TV's bottom edge
    local deskWidth = gFramesInfo[APT_NAME][gAPT_DESK_NAME]['width']
    local deskHeight = gFramesInfo[APT_NAME][gAPT_DESK_NAME]['height']
    local deskX = (shortCounterX + shortCounterWidth/2) - deskWidth/2
    local deskY = (tvY + tvHeight) - deskHeight
    love.graphics.draw(gTextures[APT_NAME],
        gFrames[APT_NAME][gAPT_DESK_NAME],
        deskX, deskY)
    -- Place desk chair flush and centered with the desk
    local chairWidth = gFramesInfo[APT_NAME][gAPT_DESK_CHAIR_NAME]['width']
    local chairHeight = gFramesInfo[APT_NAME][gAPT_DESK_CHAIR_NAME]['width']
    local chairX = (deskX + deskWidth/2) - chairWidth/2
    local chairY = deskY - chairHeight
    love.graphics.draw(gTextures[APT_NAME],
        gFrames[APT_NAME][gAPT_DESK_CHAIR_NAME],
        chairX, chairY) 
    --[[ XXX commented out for testing
    for y = 1, self.height do
        for x = 1, self.width do
            local tile = self.tiles[y][x]
            love.graphics.draw(gTextures['tiles'], gFrames['tiles'][tile.id],
                (x - 1) * TILE_SIZE + self.renderOffsetX + self.adjacentOffsetX,
                (y - 1) * TILE_SIZE + self.renderOffsetY + self.adjacentOffsetY)
        end
    end

    -- render doorways; stencils are placed where the arches are after so the player can
    -- move through them convincingly
    for k, doorway in pairs(self.doorways) do
        doorway:render(self.adjacentOffsetX, self.adjacentOffsetY)
    end

    for k, object in pairs(self.objects) do
        object:render(self.adjacentOffsetX, self.adjacentOffsetY)
    end

    for k, entity in pairs(self.entities) do
        if not entity.dead then entity:render(self.adjacentOffsetX, self.adjacentOffsetY) end
    end

    -- stencil out the door arches so it looks like the player is going through
    love.graphics.stencil(function()
        -- left
        love.graphics.rectangle('fill', -TILE_SIZE - 6, MAP_RENDER_OFFSET_Y + (MAP_HEIGHT / 2) * TILE_SIZE - TILE_SIZE,
            TILE_SIZE * 2 + 6, TILE_SIZE * 2)

        -- right
        love.graphics.rectangle('fill', MAP_RENDER_OFFSET_X + (MAP_WIDTH * TILE_SIZE) - 6,
            MAP_RENDER_OFFSET_Y + (MAP_HEIGHT / 2) * TILE_SIZE - TILE_SIZE, TILE_SIZE * 2 + 6, TILE_SIZE * 2)

        -- top
        love.graphics.rectangle('fill', MAP_RENDER_OFFSET_X + (MAP_WIDTH / 2) * TILE_SIZE - TILE_SIZE,
            -TILE_SIZE - 6, TILE_SIZE * 2, TILE_SIZE * 2 + 12)

        --bottom
        love.graphics.rectangle('fill', MAP_RENDER_OFFSET_X + (MAP_WIDTH / 2) * TILE_SIZE - TILE_SIZE,
            VIRTUAL_HEIGHT - TILE_SIZE - 6, TILE_SIZE * 2, TILE_SIZE * 2 + 12)
    end, 'replace', 1)

    love.graphics.setStencilTest('less', 1)

    if self.player then
        self.player:render()
    end

    love.graphics.setStencilTest()
    --]]
end
