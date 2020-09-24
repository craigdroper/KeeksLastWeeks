
local HORZ_CHAIR_TABLE_OFFSET = 5

Alley = Class{}

function Alley:init()
    self.name = 'city'
    self.tWidth = 16
    self.tHeight = 16
    self.numTilesWide = VIRTUAL_WIDTH / self.tWidth + 1
    self.numTilesHigh = VIRTUAL_HEIGHT / self.tHeight + 1

    self.pavements = {}
    self.buildings = {}
    self.vehicles = {}

    self.aptX = 0
    self.aptY = 0
    self.aptNumFloors =  5
    self.aptNumApts = 5
    self.aptTileWidth = 4
    self.aptTileHeight = 2
    -- These will be set by generate apartment and referenced by future generate
    -- functions
    self.aptBotY = nil
    self.aptRightX = nil
    self:generateApartment(self.aptX, self.aptY, self.aptNumFloors, self.aptNumApts)

    self.swTileHeight = 3
    self.alleyTileWidth = 4
    -- This will be set by generate pavements
    self.alleyRightX = nil
    self:generatePavements(self.aptBotY, self.aptRightX)

    self:generateBrickBuilding(self.aptBotY, self.alleyRightX)

    self:generateDrugCar()
end

function Alley:getBorderCoords(tiles)
    local minX = 1e13
    local maxX = 0
    local minY = 1e13
    local maxY = 0
    for _, tile in pairs(tiles) do
        tileWidth = self.tWidth
        tileHeight = self.tHeight
        tileX = tile[3]
        tileY = tile[4]
        minX = (tileX < minX) and tileX or minX
        maxX = (tileX + tileWidth > maxX) and tileX + tileWidth or maxX
        minY = (tileY < minY) and tileY or minY
        maxY = (tileY + tileHeight > maxY) and tileY + tileHeight or maxY
    end

    return minX, maxX, minY, maxY, (maxX - minX)/2 + minX, (maxY - minY)/2 + minY
end

function Alley:generatePavements(aptBotY, aptRightX)
    local SW_ID = 748
    -- Top sidewalk, flush with apartment building
    topTiles = {}
    for i = 0, self.numTilesWide - 1 do
        for j = 0, self.swTileHeight - 1 do
            table.insert(topTiles, {gTextures[self.name], gFrames[self.name][SW_ID],
                i * self.tWidth, aptBotY + j * self.tHeight})
        end
    end
    self.pavements['top'] = topTiles
    local topSwBotY = aptBotY + self.swTileHeight * self.tHeight

    local EMPTY_ROAD_ID = 715
    local TOP_HORZ_DASH_ROAD_ID = 751
    local BOT_HORZ_DASH_ROAD_ID = 714

    -- Horizontal main road
    local horzRoadTiles = {}
    for x = 0, self.numTilesWide - 1 do
        -- Build the roads veritically with an empty on the bottom,
        -- the top half of the horizontal dash, the bottom half,
        -- then another empty
        table.insert(horzRoadTiles, {
            gTextures[self.name],
            gFrames[self.name][EMPTY_ROAD_ID],
            x * self.tWidth,
            topSwBotY})
        table.insert(horzRoadTiles, {
            gTextures[self.name],
            gFrames[self.name][BOT_HORZ_DASH_ROAD_ID],
            x * self.tWidth,
            topSwBotY + self.tHeight})
        table.insert(horzRoadTiles, {
            gTextures[self.name],
            gFrames[self.name][TOP_HORZ_DASH_ROAD_ID],
            x * self.tWidth,
            topSwBotY + 2*self.tHeight})
        table.insert(horzRoadTiles, {
            gTextures[self.name],
            gFrames[self.name][EMPTY_ROAD_ID],
            x * self.tWidth,
            topSwBotY + 3*self.tHeight})
    end
    self.pavements['main-horz'] = horzRoadTiles
    local rdBotY = topSwBotY + 4*self.tHeight

    -- Bottom sidewalk
    botTiles = {}
    for i = 0, self.numTilesWide - 1 do
        for j = 0, self.swTileHeight - 1 do
            table.insert(botTiles, {gTextures[self.name], gFrames[self.name][SW_ID],
                i * self.tWidth, rdBotY + j * self.tHeight})
        end
    end
    self.pavements['bottom'] = botTiles

    -- Side alley, flush with top sidewalk and apartment building
    local ALLEY_ID = 891
    alleyTiles = {}
    local curY = 0
    while curY < self.aptBotY do
        for i = 0, self.alleyTileWidth - 1 do
            table.insert(alleyTiles, {gTextures[self.name], gFrames[self.name][ALLEY_ID],
                aptRightX + i * self.tWidth, curY})
        end
        curY = curY + self.tHeight
    end
    self.pavements['alley'] = alleyTiles
    self.alleyRightX = aptRightX + self.alleyTileWidth * self.tWidth
end

function Alley:generateApartment(x, y, numFloors, numApts)
    -- Generate from top down
    -- numApts represents how many columns of window blocks there are
    local aptTiles = {}
    local APT_TILE_WIDTH = self.aptTileWidth
    local totMiddleTiles = (numApts - 1) * APT_TILE_WIDTH + APT_TILE_WIDTH - 2
    local APT_TILE_HEIGHT = self.aptTileHeight

    local function genDoubleLayer(layerY, TL_ID, TM_ID, TR_ID, BL_ID, BM_ID, BR_ID)
        local curX = x
        table.insert(aptTiles, {gTextures[self.name], gFrames[self.name][TL_ID],
            curX, layerY})
        table.insert(aptTiles, {gTextures[self.name], gFrames[self.name][BL_ID],
            curX, layerY + self.tHeight})
        curX = curX + self.tWidth
        for i = 1, totMiddleTiles do
            table.insert(aptTiles, {gTextures[self.name], gFrames[self.name][TM_ID],
                curX, layerY})
            table.insert(aptTiles, {gTextures[self.name], gFrames[self.name][BM_ID],
                curX, layerY + self.tHeight})
            curX = curX + self.tWidth
        end
        table.insert(aptTiles, {gTextures[self.name], gFrames[self.name][TR_ID],
            curX, layerY})
        table.insert(aptTiles, {gTextures[self.name], gFrames[self.name][BR_ID],
            curX, layerY + self.tHeight})
    end

    local function genPartDoubleLayer(layerY, TL_ID, TM_ID, TR_ID, BL_ID, BM_ID, BR_ID)
        local curX = x
        for i = 1, numApts do
            table.insert(aptTiles, {gTextures[self.name], gFrames[self.name][TL_ID],
                curX, layerY})
            table.insert(aptTiles, {gTextures[self.name], gFrames[self.name][BL_ID],
                curX, layerY + self.tHeight})
            curX = curX + self.tWidth
            for j = 1, APT_TILE_WIDTH - 2 do
                table.insert(aptTiles, {gTextures[self.name], gFrames[self.name][TM_ID],
                    curX, layerY})
                table.insert(aptTiles, {gTextures[self.name], gFrames[self.name][BM_ID],
                    curX, layerY + self.tHeight})
                curX = curX + self.tWidth
            end
            table.insert(aptTiles, {gTextures[self.name], gFrames[self.name][TR_ID],
                curX, layerY})
            table.insert(aptTiles, {gTextures[self.name], gFrames[self.name][BR_ID],
                curX, layerY + self.tHeight})
            curX = curX + self.tWidth
        end
    end

    local function genPartSingleLayer(layerY, L_ID, M_ID, R_ID)
        local curX = x
        for i = 1, numApts do
            table.insert(aptTiles, {gTextures[self.name], gFrames[self.name][L_ID],
                curX, layerY})
            curX = curX + self.tWidth
            for j = 1, APT_TILE_WIDTH - 2 do
                table.insert(aptTiles, {gTextures[self.name], gFrames[self.name][M_ID],
                    curX, layerY})
                curX = curX + self.tWidth
            end
            table.insert(aptTiles, {gTextures[self.name], gFrames[self.name][R_ID],
                curX, layerY})
            curX = curX + self.tWidth
        end
    end

    local function genSingleLayer(layerY, L_ID, M_ID, R_ID)
        local curX = x
        table.insert(aptTiles, {gTextures[self.name], gFrames[self.name][L_ID],
            curX, layerY})
        curX = curX + self.tWidth
        for i = 1, totMiddleTiles do
            table.insert(aptTiles, {gTextures[self.name], gFrames[self.name][M_ID],
                curX, layerY})
            curX = curX + self.tWidth
        end
        table.insert(aptTiles, {gTextures[self.name], gFrames[self.name][R_ID],
            curX, layerY})
    end

    local function genRoof()
        genDoubleLayer(y, 9, 11, 10, 46, 48, 47)
        return y + self.tHeight * APT_TILE_HEIGHT
    end

    local function genTopEdge(lastLayerY)
        genPartSingleLayer(lastLayerY, 347, 348, 349)
        return lastLayerY + self.tHeight
    end

    local function genBody(lastLayerY)
        for i = 1, numFloors - 1 do
            genPartDoubleLayer(lastLayerY, 350, 351, 352, 347, 348, 349)
            lastLayerY = lastLayerY + self.tHeight * APT_TILE_HEIGHT
        end
        return lastLayerY
    end

    local function genBotEdge(lastLayerY)
        genPartSingleLayer(lastLayerY, 384, 385, 386)
        return lastLayerY + self.tHeight
    end

    local function genDoors(lastLayerY)
        local TL_ID = 912
        local TR_ID = 913
        local BL_ID = 949
        local BR_ID = 950
        local leftDoorX = (APT_TILE_WIDTH * numApts * self.tWidth) / 2 + x - self.tWidth
        local topDoorY = lastLayerY - self.tHeight * 2
        table.insert(aptTiles, {gTextures[self.name], gFrames[self.name][TL_ID],
            leftDoorX, topDoorY})
        table.insert(aptTiles, {gTextures[self.name], gFrames[self.name][TR_ID],
            leftDoorX + self.tWidth, topDoorY})
        table.insert(aptTiles, {gTextures[self.name], gFrames[self.name][BL_ID],
            leftDoorX, topDoorY + self.tHeight})
        table.insert(aptTiles, {gTextures[self.name], gFrames[self.name][BR_ID],
            leftDoorX + self.tWidth, topDoorY + self.tHeight})
    end

    local lastLayerY = genRoof()
    lastLayerY = genTopEdge(lastLayerY)
    lastLayerY = genBody(lastLayerY)
    lastLayerY = genBotEdge(lastLayerY)
    genDoors(lastLayerY)
    self.buildings['apartment'] = aptTiles
    self.aptBotY = y + (numFloors + 1) * self.aptTileHeight * self.tHeight
    print('AptBotY='..self.aptBotY)
    self.aptRightX = x + numApts * self.aptTileWidth * self.tWidth
end

function Alley:generateBrickBuilding(aptBotY, alleyRightX)

    local totTileWidth = (VIRTUAL_WIDTH - alleyRightX) / self.tWidth + 1
    local totTileHeight = (aptBotY) / self.tHeight
    local roofHeight = totTileHeight / 2

    local tiles = {}

    local function genSingleLayer(layerY, L_ID, M_ID)
        local curX = alleyRightX
        table.insert(tiles, {gTextures[self.name], gFrames[self.name][L_ID],
            curX, layerY})
        curX = curX + self.tWidth
        for i = 1, totTileWidth do
            table.insert(tiles, {gTextures[self.name], gFrames[self.name][M_ID],
                curX, layerY})
            curX = curX + self.tWidth
        end
    end

    -- Generate the bottom brick layer
    curY = aptBotY - self.tHeight
    genSingleLayer(curY, 445, 299)
    curY = curY - self.tHeight
    -- Fill in body of building until top layer
    for i = 0, totTileHeight - roofHeight do 
        genSingleLayer(curY, 408, 188)
        curY = curY - self.tHeight
    end
    -- Top layer of the building
    -- genSingleLayer(curY, 335, 336)
    -- curY = curY - self.tHeight
    -- Bottom layer of the roof
    genSingleLayer(curY, 38, 40)
    curY = curY - self.tHeight
    -- Fill out the rest of the roof
    for i = 0, roofHeight do
        genSingleLayer(curY, 4, 7)
        curY = curY - self.tHeight
    end

    -- add doors
    local DOOR_ID = 1021
    local thirdX = (VIRTUAL_WIDTH - alleyRightX) / 3
    for i = 1, 2 do
        table.insert(tiles, {gTextures[self.name], gFrames[self.name][DOOR_ID],
            i * thirdX + alleyRightX, aptBotY - self.tHeight})
    end
    -- add windows
    local windowsWide = 5
    local wideGridSize = (VIRTUAL_WIDTH - alleyRightX) / (windowsWide + 1) 
    local windowsTall = 4
    local heightGridSize = (aptBotY) / (windowsTall + 1)
    local WINDOW_ID = 620
    for y = 1, windowsTall - 1 do
        for x = 1, windowsWide do
            table.insert(tiles, {gTextures[self.name], gFrames[self.name][WINDOW_ID],
                alleyRightX + x * wideGridSize, aptBotY - y * heightGridSize})
        end
    end

    self.buildings['brick'] = tiles
end

function Alley:standardRender(renderDict)
    for name, tiles in pairs(renderDict) do
        for _, tile in pairs(tiles) do
            love.graphics.filterDrawQ(tile[1], tile[2], tile[3], tile[4])
        end
    end
end

function Alley:generateDrugCar()
    local alleyMidX = self.aptRightX + (self.alleyRightX - self.aptRightX) / 2
    local TOP_ALLEY_GAP = 50
    tiles = {}
    local TL_ID = 700
    local TR_ID = 701
    local BL_ID = 737
    local BR_ID = 738
    table.insert(tiles, {gTextures[self.name], gFrames[self.name][TL_ID],
        alleyMidX - self.tWidth, TOP_ALLEY_GAP})
    table.insert(tiles, {gTextures[self.name], gFrames[self.name][TR_ID],
        alleyMidX, TOP_ALLEY_GAP})
    table.insert(tiles, {gTextures[self.name], gFrames[self.name][BL_ID],
        alleyMidX - self.tWidth, TOP_ALLEY_GAP + self.tHeight})
    table.insert(tiles, {gTextures[self.name], gFrames[self.name][BR_ID],
        alleyMidX, TOP_ALLEY_GAP + self.tHeight})

    self.vehicles['drug-car'] = tiles
end

function Alley:render()
    self:standardRender(self.pavements)
    self:standardRender(self.buildings)
    self:standardRender(self.vehicles)
end
