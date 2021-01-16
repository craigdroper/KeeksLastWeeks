--[[
    GD50
    Pokemon

    Author: Colton Ogden
    cogden@cs50.harvard.edu
]]

WeedGLevel = Class{}

function WeedGLevel:init()
    self.tileWidth = 50
    self.tileHeight = 50

    self.baseLayer = WeedGTileMap(self.tileWidth, self.tileHeight)
    self.grassLayer = WeedGTileMap(self.tileWidth, self.tileHeight)
    self.halfGrassLayer = WeedGTileMap(self.tileWidth, self.tileHeight)

    self:createMaps()

    -- Create a local copy so we don't effect the real world player
    self.player = createPlayer()
end

function WeedGLevel:createMaps()

    -- fill the base tiles table with random grass IDs
    for y = 1, self.tileHeight do
        table.insert(self.baseLayer.tiles, {})

        for x = 1, self.tileWidth do
            local id = WEEDG_TILE_IDS['grass'][math.random(#WEEDG_TILE_IDS['grass'])]

            table.insert(self.baseLayer.tiles[y], WeedGTile(x, y, id))
        end
    end

    -- place tall grass in the tall grass layer
    for y = 1, self.tileHeight do
        table.insert(self.grassLayer.tiles, {})
        table.insert(self.halfGrassLayer.tiles, {})

        for x = 1, self.tileWidth do
            local id = y > 10 and WEEDG_TILE_IDS['tall-grass'] or WEEDG_TILE_IDS['empty']

            table.insert(self.grassLayer.tiles[y], WeedGTile(x, y, id))
        end
    end
end

function WeedGLevel:update(dt)
    self.player:update(dt)
end

function WeedGLevel:render()
    self.baseLayer:render()
    self.grassLayer:render()
    self.player:render()
end
