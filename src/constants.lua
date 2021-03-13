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

DEGREES_TO_RADIANS = 0.0174532925199432957
RADIANS_TO_DEGREES = 57.295779513082320876

-- couple suggested constants for Dialogue and Menu boxes
TEXT_WIDTH = VIRTUAL_WIDTH / 2
TEXT_HEIGHT = 64
TEXT_X = (VIRTUAL_WIDTH - TEXT_WIDTH) / 2
TEXT_Y_PAD = 6
TEXT_Y = (VIRTUAL_HEIGHT - TEXT_HEIGHT - TEXT_Y_PAD)

--
-- entity constants
--

PLAYER_WALK_SPEED_MULT = 1
-- PLAYER_WALK_SPEED_MULT = 5

TIME_RGB = {r=0, g=0, b=255}
TIME_NAME = 'time'
HEALTH_RGB = {r=255, g=0, b=0}
HEALTH_NAME = 'health'
MONEY_RGB = {r=0, g=255, b=0}
MONEY_NAME = 'money'
FUN_RGB = {r=255, g=255, b=0}
FUN_NAME = 'fun'


-- Bar game constants
-- paddle movement speed
BG_PADDLE_SPEED = 200

-- Coke flappy bird game constants
COKEG_PIPE_SPEED = 60
COKEG_PIPE_WIDTH = 70
COKEG_PIPE_HEIGHT = 288
COKEG_BIRD_WIDTH = 38
COKEG_BIRD_HEIGHT = 24
COKEG_GROUND_SCROLL_SPEED = 60

-- Acid game constants
ACIDG_MAX_TILE_VARIETY = 6

-- Doctor game constants
DOCG_MAP_SCROLL_X_SPEED = 100
DOCG_BACKGROUND_SCROLL_X_SPEED = DOCG_MAP_SCROLL_X_SPEED / 2
DOCG_TILE_SIZE = 35
-- TODO should this be DOCG_TILE_SIZE? Is that what's making the alien physics wonky? 
DOCG_ALIEN_SIZE = TILE_SIZE

WEEDG_TILE_SIZE = 16
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
