
local HORZ_CHAIR_TABLE_OFFSET = 5
local SHELF_Y_SHRINK = 0.75
local SHELF_GAP = 10

BarGBackground = Class{}

function BarGBackground:init()
    self.name = 'bar'

    self.floortiles = {}
    self:generateFloorTiles()

    self.furniture = {}
    self:generateFurniture()
end

function BarGBackground:generateFloorTiles()
    -- The Bar mini game background is going to be rotated by 90 degrees on
    -- the world bar, so the width and heights will be switched here
    local floorTileHeight = gFramesInfo[self.name][gBAR_FLOOR_NAME]['width']
    local floorTileWidth = gFramesInfo[self.name][gBAR_FLOOR_NAME]['height']
    local numTilesWide = VIRTUAL_WIDTH / floorTileWidth + 2
    local numTilesHigh = VIRTUAL_HEIGHT / floorTileHeight + 2
    for y = 1, numTilesHigh do
        for x = 1, numTilesWide do
            self.floortiles[y*numTilesWide + x] = {
                gTextures[self.name],
                gFrames[self.name][gBAR_FLOOR_NAME],
                (x - 1) * floorTileWidth,
                (y - 1) * floorTileHeight,
                1.57}
        end
    end
end

function BarGBackground:renderFloorTiles()
    for _, tile in pairs(self.floortiles) do
        love.graphics.filterDrawQ(tile[1], tile[2], tile[3], tile[4], tile[5])
    end
end

function BarGBackground:generateFurniture()
    self:generateBarArea()
end

function BarGBackground:generateBarArea()
    -- Anchor the bar from the shelves we'll put in at the top of the frame,
    -- then leave a gap and build the bar
    -- From this mini game's view, the shelves will not be rotated

    local glassWidth = gFramesInfo[self.name][gBAR_GLASS_SHELF]['width']
    local glassHeight = gFramesInfo[self.name][gBAR_GLASS_SHELF]['height']
    local wineWidth = gFramesInfo[self.name][gBAR_WINE_SHELF]['width']
    local wineHeight = gFramesInfo[self.name][gBAR_WINE_SHELF]['height']

    -- There are 2 glass shelves and 4 wine shelves that should be horizontally
    -- centered
    local totalWidth = 2 * glassWidth + 4 * wineWidth + 5 * SHELF_GAP
    local LEFT_PADDING = (VIRTUAL_WIDTH - totalWidth)/2

    local glassX = LEFT_PADDING
    local glassY = 0
    self.furniture['glass-shelf-1'] = {gTextures[self.name],
        gFrames[self.name][gBAR_GLASS_SHELF],
        glassX, glassY, 0, 1, SHELF_Y_SHRINK}

    -- Add 4 wine bottle shelves
    local wineX = glassX + glassWidth + SHELF_GAP
    local wineY = 0
    self.furniture['wine-shelf-1'] = {gTextures[self.name],
        gFrames[self.name][gBAR_WINE_SHELF],
        wineX, wineY, 0, 1, SHELF_Y_SHRINK}
    wineX = wineX + wineWidth + SHELF_GAP
    self.furniture['wine-shelf-2'] = {gTextures[self.name],
        gFrames[self.name][gBAR_WINE_SHELF],
        wineX, wineY, 0, 1, SHELF_Y_SHRINK}
    wineX = wineX + wineWidth + SHELF_GAP
    self.furniture['wine-shelf-3'] = {gTextures[self.name],
        gFrames[self.name][gBAR_WINE_SHELF],
        wineX, wineY, 0, 1, SHELF_Y_SHRINK}
    wineX = wineX + wineWidth + SHELF_GAP
    self.furniture['wine-shelf-4'] = {gTextures[self.name],
        gFrames[self.name][gBAR_WINE_SHELF],
        wineX, wineY, 0, 1, SHELF_Y_SHRINK}
    glassX = wineX + wineWidth + SHELF_GAP
    self.furniture['glass-shelf-2'] = {gTextures[self.name],
        gFrames[self.name][gBAR_GLASS_SHELF],
        glassX, glassY, 0, 1, SHELF_Y_SHRINK}

    -- Build a bar across the width of the screen, with a gap from the shelves
    local barWidth = gFramesInfo[self.name][gBAR_HORZ_TABLE]['width']
    local barHeight = gFramesInfo[self.name][gBAR_HORZ_TABLE]['height']
    local numBarExts = VIRTUAL_WIDTH / barWidth + 1
    for i = 1, numBarExts + 1 do
        self.furniture['horizontal-table-'..i] = {gTextures[self.name],
            gFrames[self.name][gBAR_HORZ_TABLE],
            (i-1) * barWidth, glassY + glassHeight + SHELF_GAP}
    end

end

function BarGBackground:renderFurniture()
    for name, furniture in pairs(self.furniture) do
        if #furniture == 4 then
            love.graphics.filterDrawQ(furniture[1], furniture[2], furniture[3], furniture[4])
        elseif #furniture == 7 then
            love.graphics.filterDrawQ(furniture[1], furniture[2], furniture[3], furniture[4],
                furniture[5], furniture[6], furniture[7])
        else
            print(name)
        end
    end
end

function BarGBackground:render()
    self:renderFloorTiles()
    self:renderFurniture()
end

function BarGBackground:getBarBottomY()
    return self.furniture['horizontal-table-1'][4] +
        gFramesInfo[self.name][gBAR_HORZ_TABLE]['height']
end

function BarGBackground:getShelfBottomY()
    return self.furniture['wine-shelf-2'][4] +
        gFramesInfo[self.name][gBAR_WINE_SHELF]['height'] * SHELF_Y_SHRINK
end
