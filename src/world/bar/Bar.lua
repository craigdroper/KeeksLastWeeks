
Bar = Class{}

function Bar:init()
    self.name = 'bar'

    self.floortiles = {}
    self:generateFloorTiles()

    self.furniture = {}
    self:generateFurniture()

    -- TODO generate random bar patrons and the bar tender
end

--[[
    Randomly creates an assortment of obstacles for the player to navigate around.
]]
function Bar:generateObjects()
    table.insert(self.objects, GameObject(
        GAME_OBJECT_DEFS['switch'],
        math.random(MAP_RENDER_OFFSET_X + TILE_SIZE,
                    VIRTUAL_WIDTH - TILE_SIZE * 2 - 16),
        math.random(MAP_RENDER_OFFSET_Y + TILE_SIZE,
                    VIRTUAL_HEIGHT - (VIRTUAL_HEIGHT - MAP_HEIGHT * TILE_SIZE) + MAP_RENDER_OFFSET_Y - TILE_SIZE - 16)
    ))

    -- get a reference to the switch
    local switch = self.objects[1]

    -- define a function for the switch that will open all doors in the room
    switch.onCollide = function()
        if switch.state == 'unpressed' then
            switch.state = 'pressed'

            -- open every door in the room if we press the switch
            for k, doorway in pairs(self.doorways) do
                doorway.open = true
            end

            gSounds['door']:play()
        end
    end

    local potObj = GameObject(GAME_OBJECT_DEFS['pot'],
        math.random(MAP_RENDER_OFFSET_X + TILE_SIZE,
                    VIRTUAL_WIDTH - TILE_SIZE * 2 - 16),
        math.random(MAP_RENDER_OFFSET_Y + TILE_SIZE,
                    VIRTUAL_HEIGHT - (VIRTUAL_HEIGHT - MAP_HEIGHT * TILE_SIZE) + MAP_RENDER_OFFSET_Y - TILE_SIZE - 16)
    )
    table.insert(self.objects, potObj)

end

--[[
    Generates the walls and floors of the room, randomizing the various varieties
    of said tiles for visual variety.
]]
function Bar:generateWallsAndFloors()
    for y = 1, self.height do
        table.insert(self.tiles, {})

        for x = 1, self.width do
            local id = TILE_EMPTY

            if x == 1 and y == 1 then
                id = TILE_TOP_LEFT_CORNER
            elseif x == 1 and y == self.height then
                id = TILE_BOTTOM_LEFT_CORNER
            elseif x == self.width and y == 1 then
                id = TILE_TOP_RIGHT_CORNER
            elseif x == self.width and y == self.height then
                id = TILE_BOTTOM_RIGHT_CORNER

            -- random left-hand walls, right walls, top, bottom, and floors
            elseif x == 1 then
                id = TILE_LEFT_WALLS[math.random(#TILE_LEFT_WALLS)]
            elseif x == self.width then
                id = TILE_RIGHT_WALLS[math.random(#TILE_RIGHT_WALLS)]
            elseif y == 1 then
                id = TILE_TOP_WALLS[math.random(#TILE_TOP_WALLS)]
            elseif y == self.height then
                id = TILE_BOTTOM_WALLS[math.random(#TILE_BOTTOM_WALLS)]
            else
                id = TILE_FLOORS[math.random(#TILE_FLOORS)]
            end

            table.insert(self.tiles[y], {
                id = id
            })
        end
    end
end

function Bar:update(dt)
    -- don't update anything if we are sliding to another room (we have offsets)
    -- if self.adjacentOffsetX ~= 0 or self.adjacentOffsetY ~= 0 then return end

    self.player:update(dt)

    --[[
    for i = #self.entities, 1, -1 do
        local entity = self.entities[i]

        -- remove entity from the table if health is <= 0
        -- (this removal will be done once all processing has completed for
        -- the entity in this for loop)
        if entity.health <= 0 then
            local newDeath = not entity.dead
            entity.dead = true
            -- randomly have the dead entity drop some bonus health
            if newDeath then
                if math.random(4) == 1 then
                    healthObj = GameObject(GAME_OBJECT_DEFS['bonus-health'],
                                           entity.x, entity.y)
                    healthObj.onCollide = function()
                        gSounds['powerup']:play()
                        self.player.health = math.min(self.player.health + 2, 6)
                        local rmIdx = 0
                        for idx, obj in pairs(self.objects) do
                            if obj == healthObj then
                                rmIdx = idx
                                break
                            end
                        end
                        table.remove(self.objects, rmIdx)
                    end
                    table.insert(self.objects, healthObj)
                end
            end

        elseif not entity.dead then
            entity:processAI({room = self}, dt)
            entity:update(dt)
        end

        -- collision between the player and entities in the room
        if not entity.dead and self.player:collides(entity) and not self.player.invulnerable then
            gSounds['hit-player']:play()
            self.player:damage(1)
            self.player:goInvulnerable(1.5)

            if self.player.health == 0 then
                gStateMachine:change('game-over')
            end
        end
    end

    for k, object in pairs(self.objects) do
        object:update(dt)

        -- trigger collision callback on object
        if self.player:collides(object) then
            if object.solid then
                self.player:adjustSolidCollision(object, dt)
            end
            object:onCollide()
        end
    end
        --]]
end

function Bar:render()
    --[[
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

    --]]
    --
    -- TODO more testing for the Bar room, which will be broken out into
    -- its own class
    -- First fill out the flooring, then put furniture on top of it
    local BAR_NAME = 'bar'
    local floorTileWidth = gFramesInfo[BAR_NAME][gBAR_FLOOR_NAME]['width']
    local floorTileHeight = gFramesInfo[BAR_NAME][gBAR_FLOOR_NAME]['height']
    local numTilesWide = VIRTUAL_WIDTH / floorTileWidth + 1
    local numTilesHigh = VIRTUAL_HEIGHT / floorTileHeight + 1
    for y = 1, numTilesHigh do
        for x = 1, numTilesWide do
            love.graphics.draw(
                gTextures[BAR_NAME],
                gFrames[BAR_NAME][gBAR_FLOOR_NAME],
                (x - 1) * floorTileWidth,
                (y - 1) * floorTileHeight)
        end
    end
    -- Anchor the room from the left wall, where we'll start with a small gap
    -- from the top and the bar shelves
    -- Shelves will be rotated 270 degrees (4.71 radians) so will use
    -- an adjusted set of coordinates
    -- May also going to squish the ratio a bit to visually make it
    -- more convincing you're seeing the side
    local TOP_GAP = 10
    local glassWidth = gFramesInfo[BAR_NAME][gBAR_GLASS_SHELF]['height']
    local glassHeight = gFramesInfo[BAR_NAME][gBAR_GLASS_SHELF]['width']
    local glassX = 0
    local adjGlassX = glassX
    local glassY = TOP_GAP
    local adjGlassY = glassY + glassHeight
    local SHELF_SHRINK_RATIO = 0.75
    love.graphics.draw(gTextures[BAR_NAME],
        gFrames[BAR_NAME][gBAR_GLASS_SHELF],
        adjGlassX, adjGlassY, 4.71, 1, SHELF_SHRINK_RATIO)
    -- Add wine bottle shelf with adjustements for 270 degree rotation
    local wineWidth = gFramesInfo[BAR_NAME][gBAR_WINE_SHELF]['height']
    local wineHeight = gFramesInfo[BAR_NAME][gBAR_WINE_SHELF]['width']
    local wineX = 0
    local adjWineX = wineX
    local wineY = adjGlassY + glassHeight
    local adjWineY = wineY
    love.graphics.draw(gTextures[BAR_NAME],
        gFrames[BAR_NAME][gBAR_WINE_SHELF],
        adjWineX, adjWineY, 4.71, 1, SHELF_SHRINK_RATIO)
    -- Install the bar with a gap from the shelves
    -- TODO the Y coordinate for the bar base will be adjusted once the frame
    -- of the whole scene is set
    local barBaseWidth = gFramesInfo[BAR_NAME][gBAR_BAR_BASE]['width']
    local barBaseHeight = gFramesInfo[BAR_NAME][gBAR_BAR_BASE]['height']
    local SHELF_BAR_GAP = 80
    local barBaseX = adjGlassX + (glassWidth * SHELF_SHRINK_RATIO) + SHELF_BAR_GAP
    local barBaseY = (VIRTUAL_HEIGHT / 2) - barBaseHeight
    love.graphics.draw(gTextures[BAR_NAME],
        gFrames[BAR_NAME][gBAR_BAR_BASE],
        barBaseX, barBaseY)
    -- Extend the bar passed the top of the screen
    local barExtWidth = gFramesInfo[BAR_NAME][gBAR_BAR_EXT]['width']
    local barExtHeight = gFramesInfo[BAR_NAME][gBAR_BAR_EXT]['height']
    local barExtX = barBaseX
    local numBarExts = barBaseY / barExtHeight + 1
    for i = 1, numBarExts + 1 do
        love.graphics.draw(gTextures[BAR_NAME],
            gFrames[BAR_NAME][gBAR_BAR_EXT],
            barExtX, barBaseY - (i - 1) * barExtHeight)
    end

    -- Add left facing chairs to bar at even interval
    local BAR_STOOL_GAP = 20
    local stoolWidth = gFramesInfo[BAR_NAME][gBAR_LEFT_CHAIR]['width']
    local stoolHeight = gFramesInfo[BAR_NAME][gBAR_LEFT_CHAIR]['height']
    local stoolX = barBaseX + barBaseWidth
    local curStoolY = BAR_STOOL_GAP
    while (curStoolY + stoolHeight) < (barBaseY + barBaseHeight) do
        love.graphics.draw(gTextures[BAR_NAME],
            gFrames[BAR_NAME][gBAR_LEFT_CHAIR],
            stoolX, curStoolY)
        curStoolY = curStoolY + stoolHeight + BAR_STOOL_GAP
    end
    -- Add one vertical table with 2 chairs
    local vertTableWidth = gFramesInfo[BAR_NAME][gBAR_VERT_TABLE]['width']
    local vertTableHeight = gFramesInfo[BAR_NAME][gBAR_VERT_TABLE]['height']
    local BAR_TABLE_GAP = 100
    local TOP_TABLE_GAP = 60
    local vertTableX = stoolX + BAR_TABLE_GAP
    local vertTableY = TOP_TABLE_GAP
    love.graphics.draw(gTextures[BAR_NAME],
        gFrames[BAR_NAME][gBAR_VERT_TABLE],
        vertTableX, vertTableY)
    -- Add 2 chairs
    local HORZ_CHAIR_TABLE_OFFSET = 5
    local rightChairWidth = gFramesInfo[BAR_NAME][gBAR_RIGHT_CHAIR]['width']
    local rightChairHeight = gFramesInfo[BAR_NAME][gBAR_RIGHT_CHAIR]['height']
    local rightChairX = vertTableX - rightChairWidth
    local rightChairY = vertTableY + HORZ_CHAIR_TABLE_OFFSET
    love.graphics.draw(gTextures[BAR_NAME],
        gFrames[BAR_NAME][gBAR_RIGHT_CHAIR],
        rightChairX, rightChairY)
    local leftChairWidth = gFramesInfo[BAR_NAME][gBAR_LEFT_CHAIR]['width']
    local leftChairHeight = gFramesInfo[BAR_NAME][gBAR_LEFT_CHAIR]['height']
    local leftChairX = vertTableX + vertTableWidth
    local leftChairY = vertTableY + HORZ_CHAIR_TABLE_OFFSET
    love.graphics.draw(gTextures[BAR_NAME],
        gFrames[BAR_NAME][gBAR_LEFT_CHAIR],
        leftChairX, leftChairY)

    if self.player then
        self.player:render()
    end
end
