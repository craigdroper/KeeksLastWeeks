--[[
    GD50
    Pokemon

    Author: Colton Ogden
    cogden@cs50.harvard.edu
]]

WeedGLevel = Class{}

function WeedGLevel:init()
    self.tileWidth = VIRTUAL_WIDTH / WEEDG_TILE_SIZE + 1
    self.tileHeight = VIRTUAL_HEIGHT / WEEDG_TILE_SIZE + 1

    self.baseLayer = WeedGTileMap(self.tileWidth, self.tileHeight)
    self.grassLayer = WeedGTileMap(self.tileWidth, self.tileHeight)
    self.halfGrassLayer = WeedGTileMap(self.tileWidth, self.tileHeight)

    self:createMaps()

    -- Create a local copy so we don't effect the real world player
    self.player = createPlayer()
    -- Set the player entity's scale factors to the correct values
    -- for this room's tile sizes
    self.player.scaleX = 1
    self.player.scaleY = 1
    self.player.opacity = 255
    self.player.walkSpeed = 100

    -- Also add the expected traits the weedg expects
    self.player.weedGMapX = math.floor(self.tileWidth/2)
    self.player.weedGMapY = math.floor(self.tileHeight/6)
    -- Explicitly set the player's X & Y coordinates to match the map coords
    self.player.x = (self.player.weedGMapX-1) * WEEDG_TILE_SIZE
    self.player.y = (self.player.weedGMapY-1) * WEEDG_TILE_SIZE - 35
    self.player.weedGPokemon = WeedGPokemon(WeedGPokemon.getRandomDef(), 1, true)
    self.player.weedGPokemon.name = 'Keeks'
    -- Right now the player 'walk' state only exists for this Pokemon level,
    -- and its been copy and pasted from the pokemon levels, so just add
    -- the walk animation here and delete it when we exit
    self.player.stateMachine.states['walk'] =
        function() return WeedGPlayerWalkState(self.player, self) end
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
