--[[
    GD50
    Legend of Zelda

    -- constants --

    Author: Colton Ogden
    cogden@cs50.harvard.edu
]]

--[[ Test text on scaling
VIRTUAL_WIDTH = 384
VIRTUAL_HEIGHT = 216

XXX I think I'm going to keep the screen scaled as is, then play around
with draw scales since I think it'll give me more flexibility when playing
around with such a wide variety of tilesets with different base tile sizes
--]]
VIRTUAL_WIDTH = 700
VIRTUAL_HEIGHT = 394

WINDOW_WIDTH = 1280
WINDOW_HEIGHT = 720

TILE_SIZE = 16

--
-- entity constants
--
PLAYER_WALK_SPEED = 60

-- Bar game constants
-- paddle movement speed
BG_PADDLE_SPEED = 200

-- Coke flappy bird game constants
COKEG_PIPE_SPEED = 60
COKEG_PIPE_WIDTH = 70
COKEG_PIPE_HEIGHT = 288
COKEG_BIRD_WIDTH = 38
COKEG_BIRD_HEIGHT = 24
COKEG_BACKGROUND_SCROLL_SPEED = 30
COKEG_BACKGROUND_LOOPING_POINT = 413
COKEG_GROUND_SCROLL_SPEED = 60

--
-- map constants
--
MAP_WIDTH = VIRTUAL_WIDTH / TILE_SIZE - 2
MAP_HEIGHT = math.floor(VIRTUAL_HEIGHT / TILE_SIZE) - 2

MAP_RENDER_OFFSET_X = (VIRTUAL_WIDTH - (MAP_WIDTH * TILE_SIZE)) / 2
MAP_RENDER_OFFSET_Y = (VIRTUAL_HEIGHT - (MAP_HEIGHT * TILE_SIZE)) / 2

--
-- tile IDs
--
TILE_TOP_LEFT_CORNER = 4
TILE_TOP_RIGHT_CORNER = 5
TILE_BOTTOM_LEFT_CORNER = 23
TILE_BOTTOM_RIGHT_CORNER = 24

TILE_EMPTY = 19

TILE_FLOORS = {
    7, 8, 9, 10, 11, 12, 13,
    26, 27, 28, 29, 30, 31, 32,
    45, 46, 47, 48, 49, 50, 51,
    64, 65, 66, 67, 68, 69, 70,
    88, 89, 107, 108
}

TILE_TOP_WALLS = {58, 59, 60}
TILE_BOTTOM_WALLS = {79, 80, 81}
TILE_LEFT_WALLS = {77, 96, 115}
TILE_RIGHT_WALLS = {78, 97, 116}
