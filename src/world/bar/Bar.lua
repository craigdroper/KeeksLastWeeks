
local HORZ_CHAIR_TABLE_OFFSET = 5

Bar = Class{}

function Bar:init()
    self.name = 'bar'

    self.floortiles = {}
    self:generateFloorTiles()

    self.furniture = {}
    self:generateFurniture()

    -- TODO generate random bar patrons and the bartender
end

function Bar:generateFloorTiles()
    local floorTileWidth = gFramesInfo[self.name][gBAR_FLOOR_NAME]['width']
    local floorTileHeight = gFramesInfo[self.name][gBAR_FLOOR_NAME]['height']
    local numTilesWide = VIRTUAL_WIDTH / floorTileWidth + 1
    local numTilesHigh = VIRTUAL_HEIGHT / floorTileHeight + 1
    for y = 1, numTilesHigh do
        for x = 1, numTilesWide do
            self.floortiles[y*numTilesWide + x] = {
                gTextures[self.name],
                gFrames[self.name][gBAR_FLOOR_NAME],
                (x - 1) * floorTileWidth,
                (y - 1) * floorTileHeight}
        end
    end
end

function Bar:renderFloorTiles()
    for _, tile in pairs(self.floortiles) do
        love.graphics.draw(tile[1], tile[2], tile[3], tile[4])
    end
end

function Bar:generateFurniture()
    self:generateBarArea()
    self:generateTableArea()
end

function Bar:generateBarArea()
    local TOP_GAP = 5

    -- Anchor the room from the left wall, where we'll start with a small gap
    -- from the top and the bar shelves
    -- Shelves will be rotated 270 degrees (4.71 radians) so will use
    -- an adjusted set of coordinates
    -- May also going to squish the ratio a bit to visually make it
    -- more convincing you're seeing the side
    local glassWidth = gFramesInfo[self.name][gBAR_GLASS_SHELF]['height']
    local glassHeight = gFramesInfo[self.name][gBAR_GLASS_SHELF]['width']
    local glassX = 0
    local adjGlassX = glassX
    local glassY = TOP_GAP
    local adjGlassY = glassY + glassHeight
    local SHELF_SHRINK_RATIO = 0.75
    self.furniture['glass-shelf-1'] = {gTextures[self.name],
        gFrames[self.name][gBAR_GLASS_SHELF],
        adjGlassX, adjGlassY, 4.71, 1, SHELF_SHRINK_RATIO}

    -- Add wine bottle shelf with adjustements for 270 degree rotation
    local wineWidth = gFramesInfo[self.name][gBAR_WINE_SHELF]['height']
    local wineHeight = gFramesInfo[self.name][gBAR_WINE_SHELF]['width']
    local wineX = 0
    local adjWineX = wineX
    local wineY = adjGlassY + glassHeight
    local adjWineY = wineY
    self.furniture['wine-shelf-1'] = {gTextures[self.name],
        gFrames[self.name][gBAR_WINE_SHELF],
        adjWineX, adjWineY, 4.71, 1, SHELF_SHRINK_RATIO}
    adjWineY = adjWineY + wineHeight
    self.furniture['wine-shelf-2'] = {gTextures[self.name],
        gFrames[self.name][gBAR_WINE_SHELF],
        adjWineX, adjWineY, 4.71, 1, SHELF_SHRINK_RATIO}
    adjWineY = adjWineY + wineHeight
    self.furniture['wine-shelf-3'] = {gTextures[self.name],
        gFrames[self.name][gBAR_WINE_SHELF],
        adjWineX, adjWineY, 4.71, 1, SHELF_SHRINK_RATIO}
    adjWineY = adjWineY + wineHeight
    self.furniture['wine-shelf-4'] = {gTextures[self.name],
        gFrames[self.name][gBAR_WINE_SHELF],
        adjWineX, adjWineY, 4.71, 1, SHELF_SHRINK_RATIO}
    adjGlassY = adjWineY + wineHeight
    self.furniture['glass-shelf-2'] = {gTextures[self.name],
        gFrames[self.name][gBAR_GLASS_SHELF],
        adjGlassX, adjGlassY, 4.71, 1, SHELF_SHRINK_RATIO}

    -- Install the bar with a gap from the shelves
    local barBaseWidth = gFramesInfo[self.name][gBAR_BAR_BASE]['width']
    local barBaseHeight = gFramesInfo[self.name][gBAR_BAR_BASE]['height']
    local SHELF_BAR_GAP = 80
    local barBaseX = adjGlassX + (glassWidth * SHELF_SHRINK_RATIO) + SHELF_BAR_GAP
    local barBaseY = VIRTUAL_HEIGHT - barBaseHeight
    self.furniture['bar-base'] = {gTextures[self.name],
        gFrames[self.name][gBAR_BAR_BASE],
        barBaseX, barBaseY}

    -- Extend the bar passed the top of the screen
    local barExtWidth = gFramesInfo[self.name][gBAR_BAR_EXT]['width']
    local barExtHeight = gFramesInfo[self.name][gBAR_BAR_EXT]['height']
    local barExtX = barBaseX
    local numBarExts = barBaseY / barExtHeight + 1
    for i = 1, numBarExts + 1 do
        self.furniture['bar-extension-'..i] = {gTextures[self.name],
            gFrames[self.name][gBAR_BAR_EXT],
            barExtX, barBaseY - (i - 1) * barExtHeight}
    end

    -- Add left facing chairs to bar at even interval
    local BAR_STOOL_GAP = 20
    local stoolWidth = gFramesInfo[self.name][gBAR_LEFT_CHAIR]['width']
    local stoolHeight = gFramesInfo[self.name][gBAR_LEFT_CHAIR]['height']
    local stoolX = barBaseX + barBaseWidth
    local curStoolY = BAR_STOOL_GAP
    local curStoolCounter = 1
    while (curStoolY + stoolHeight) < (barBaseY + barBaseHeight) do
        self.furniture['barstool-'..curStoolCounter] = {gTextures[self.name],
            gFrames[self.name][gBAR_LEFT_CHAIR],
            stoolX, curStoolY}
        curStoolY = curStoolY + stoolHeight + BAR_STOOL_GAP
        curStoolCounter = curStoolCounter + 1
    end
end

function Bar:generateTableArea()
    local vertTableWidth = gFramesInfo[self.name][gBAR_VERT_TABLE]['width']
    local vertTableHeight = gFramesInfo[self.name][gBAR_VERT_TABLE]['height']
    local rightChairWidth = gFramesInfo[self.name][gBAR_RIGHT_CHAIR]['width']
    local rightChairHeight = gFramesInfo[self.name][gBAR_RIGHT_CHAIR]['height']
    local leftChairWidth = gFramesInfo[self.name][gBAR_LEFT_CHAIR]['width']
    local leftChairHeight = gFramesInfo[self.name][gBAR_LEFT_CHAIR]['height']
    local totalWidth = vertTableWidth + rightChairWidth + leftChairWidth
    local totalHeight = math.max(vertTableHeight, math.max(rightChairHeight, leftChairHeight))
    local stoolsX = self.furniture['barstool-1'][3] + gFramesInfo[self.name][gBAR_LEFT_CHAIR]['width']

    -- Divide the remaining floor space into a 4 x 4 grid, and place tables
    -- on the intersection points, for a 3x3 table layout
    local tableXInterval = (VIRTUAL_WIDTH - stoolsX) / 4
    local tableYInterval = (VIRTUAL_HEIGHT) / 4
    for y = 1, 3 do
        for x = 1, 3 do
            self:generateSingleTable(
                (y - 1) * 3 + x,
                stoolsX + tableXInterval * x,
                tableYInterval * y )
        end
    end
end

function Bar:generateSingleTable(tableNum, centerX, centerY)
    -- Add one vertical table with 2 chairs
    local vertTableWidth = gFramesInfo[self.name][gBAR_VERT_TABLE]['width']
    local vertTableHeight = gFramesInfo[self.name][gBAR_VERT_TABLE]['height']
    local rightChairWidth = gFramesInfo[self.name][gBAR_RIGHT_CHAIR]['width']
    local leftChairWidth = gFramesInfo[self.name][gBAR_LEFT_CHAIR]['width']

    local vertTableX = centerX - vertTableWidth / 2
    local vertTableY = centerY - vertTableHeight / 2
    self.furniture['vert-table-' .. tableNum] = {gTextures[self.name],
        gFrames[self.name][gBAR_VERT_TABLE],
        vertTableX, vertTableY}

    -- Add 2 chairs
    local rightChairX = vertTableX - rightChairWidth
    local rightChairY = vertTableY + HORZ_CHAIR_TABLE_OFFSET
    self.furniture['right-chair-1-vert-table-' .. tableNum] = {gTextures[self.name],
        gFrames[self.name][gBAR_RIGHT_CHAIR],
        rightChairX, rightChairY}
    local leftChairX = vertTableX + vertTableWidth
    local leftChairY = vertTableY + HORZ_CHAIR_TABLE_OFFSET
    self.furniture['left-chair-1-vert-table-'..tableNum] = {gTextures[self.name],
        gFrames[self.name][gBAR_LEFT_CHAIR],
        leftChairX, leftChairY}
end

function Bar:renderFurniture()
    for name, furniture in pairs(self.furniture) do
        if #furniture == 4 then
            love.graphics.draw(furniture[1], furniture[2], furniture[3], furniture[4])
        elseif #furniture == 7 then
            love.graphics.draw(furniture[1], furniture[2], furniture[3], furniture[4],
                furniture[5], furniture[6], furniture[7])
        elseif #furniture == 9 then
            love.graphics.draw(furniture[1], furniture[2], furniture[3], furniture[4],
                furniture[5], furniture[6], furniture[7], furniture[8], furniture[9])
        else
            print(name)
        end
    end
end

function Bar:render()
    self:renderFloorTiles()
    self:renderFurniture()
end
