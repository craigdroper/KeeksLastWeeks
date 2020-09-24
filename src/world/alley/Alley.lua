
local HORZ_CHAIR_TABLE_OFFSET = 5

Alley = Class{}

function Alley:init()
    self.name = 'city'
    self.tWidth = 16
    self.tHeight = 16
    self.numTilesWide = VIRTUAL_WIDTH / self.tWidth + 1
    self.numTilesHigh = VIRTUAL_HEIGHT / self.tHeight + 1

    self.roads = {}
    self:generateRoads()

    self.buildings = {}
    self:generateBuildings()

    self.drugCar = nil
    self:generateDrugCar()
end

function Alley:generateRoads()
    local EMPTY_ROAD_ID = 715
    local TOP_HORZ_DASH_ROAD_ID = 751
    local BOT_HORZ_DASH_ROAD_ID = 714

    for x = 0, self.numTilesWide - 1 do
        -- Build the roads veritically with an empty on the bottom,
        -- the top half of the horizontal dash, the bottom half,
        -- then another empty
        self.roads['empty-bot-main-horz-'..x] = {
            gTextures[self.name],
            gFrames[self.name][EMPTY_ROAD_ID],
            x * self.tWidth,
            VIRTUAL_HEIGHT - self.tHeight}
        self.roads['top-dash-main-horz-'..x] = {
            gTextures[self.name],
            gFrames[self.name][TOP_HORZ_DASH_ROAD_ID],
            x * self.tWidth,
            VIRTUAL_HEIGHT - (self.tHeight*2)}
        self.roads['bot-dash-main-horz-'..x] = {
            gTextures[self.name],
            gFrames[self.name][BOT_HORZ_DASH_ROAD_ID],
            x * self.tWidth,
            VIRTUAL_HEIGHT - (self.tHeight*3)}
        self.roads['empty-top-main-horz-'..x] = {
            gTextures[self.name],
            gFrames[self.name][EMPTY_ROAD_ID],
            x * self.tWidth,
            VIRTUAL_HEIGHT - (self.tHeight*4)}
    end
end

function Alley:renderRoads()
    for _, tile in pairs(self.roads) do
        love.graphics.filterDrawQ(tile[1], tile[2], tile[3], tile[4])
    end
end

function Alley:generateBuildings()
    self:generateApartment(0, 0, 5, 5)
end

function Alley:generateApartment(x, y, numFloors, numApts)
    -- Generate from top down
    -- numApts represents how many columns of window blocks there are
    local aptTiles = {}
    local APT_TILE_WIDTH = 4
    local totMiddleTiles = (numApts - 1) * APT_TILE_WIDTH + APT_TILE_WIDTH - 2
    local APT_TILE_HEIGHT = 2

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
end

function Alley:renderBuildings()
    for buildName, tiles in pairs(self.buildings) do
        for _, tile in pairs(tiles) do
            love.graphics.filterDrawQ(tile[1], tile[2], tile[3], tile[4])
        end
    end
end

function Alley:generateDrugCar()
end

function Alley:renderDrugCar()
end

function Alley:render()
    self:renderRoads()
    self:renderBuildings()
    self:renderDrugCar()
end
