--[[
    GD50
    Super Mario Bros. Remake

    -- StartState Class --

    Author: Colton Ogden
    cogden@cs50.harvard.edu

    Helper functions for writing Match-3.
]]

--[[
    Given an "atlas" (a texture with multiple sprites), as well as a
    width and a height for the tiles therein, split the texture into
    all of the quads by simply dividing it evenly.
]]
function GenerateQuads(atlas, tilewidth, tileheight)
    local sheetWidth = atlas:getWidth() / tilewidth
    local sheetHeight = atlas:getHeight() / tileheight

    local sheetCounter = 1
    local spritesheet = {}

    for y = 0, sheetHeight - 1 do
        for x = 0, sheetWidth - 1 do
            spritesheet[sheetCounter] =
                love.graphics.newQuad(x * tilewidth, y * tileheight, tilewidth,
                tileheight, atlas:getDimensions())
            sheetCounter = sheetCounter + 1
        end
    end

    return spritesheet
end

function addAptQuadInfo(atlas, sheet, info, name, x, y, w, h, origen, scale)
    sheet[name] = love.graphics.newQuad(
        x, y, w, h, atlas:getDimensions())
    scale = scale or 1
    origen = origen or 0
    info[name] = {['width'] = w, ['height'] = h,
                  ['origen'] = origen, ['scale'] = scale}
end

function addAptQuadInfoSmart(atlas, sheet, info, name,
        x1, y1, x2, y2, origen, scale)
    w = x2 - x1
    h = y2 - y1
    sheet[name] = love.graphics.newQuad(
        x1, y1, w, h, atlas:getDimensions())
    scale = scale or 1
    origen = origen or 0
    info[name] = {['width'] = w, ['height'] = h,
                  ['origen'] = origen, ['scale'] = scale}
end

--[[
    A very specifically implemented function meant to create quads
    for all of the items from the apartment tileset. Instead of indexing
    but IDs, we index by name of furniture
--]]
function GenerateApartmentQuadsAndInfo(atlas)
    local sheet = {}
    local info = {}

    gAPT_LONG_COUNTER_NAME = 'long_counter'
    addAptQuadInfo(atlas, sheet, info, gAPT_LONG_COUNTER_NAME, 23, 18, 125, 72)

    gAPT_SHORT_COUNTER_NAME = 'short_counter'
    addAptQuadInfo(atlas, sheet, info, gAPT_SHORT_COUNTER_NAME, 179, 17, 78, 74)

    gAPT_VERT_COUCH_NAME = 'vertical_couch'
    addAptQuadInfo(atlas, sheet, info, gAPT_VERT_COUCH_NAME, 282, 18, 66, 124)

    gAPT_HORZ_COUCH_NAME = 'horizontal_couch'
    addAptQuadInfo(atlas, sheet, info, gAPT_HORZ_COUCH_NAME, 348, 18, 147, 66)

    gAPT_TV_NAME = 'television'
    addAptQuadInfo(atlas, sheet, info, gAPT_TV_NAME, 400, 349, 179, 27)

    gAPT_DESK_NAME = 'desk'
    addAptQuadInfo(atlas, sheet, info, gAPT_DESK_NAME, 615, 247, 101, 51)

    gAPT_DESK_CHAIR_NAME = 'desk_chair'
    addAptQuadInfo(atlas, sheet, info, gAPT_DESK_CHAIR_NAME, 460, 209, 46, 35)

    gAPT_SINK_NAME = 'sink'
    -- TODO add origen of 90 degrees
    addAptQuadInfo(atlas, sheet, info, gAPT_SINK_NAME, 199, 271, 61, 39)

    gAPT_FRIDGE_NAME = 'refrigerator'
    addAptQuadInfo(atlas, sheet, info, gAPT_FRIDGE_NAME, 112, 124, 55, 49)

    gAPT_TABLE_NAME = 'coffee_table'
    addAptQuadInfo(atlas, sheet, info, gAPT_TABLE_NAME, 829, 381, 63, 61)

    gAPT_STOVE_NAME = 'stove'
    addAptQuadInfo(atlas, sheet, info, gAPT_STOVE_NAME, 192, 122, 67, 53)

    gAPT_FLOOR_NAME = 'floor'
    addAptQuadInfo(atlas, sheet, info, gAPT_FLOOR_NAME, 783, 222, 208, 34)

    return {['quads'] = sheet, ['info'] = info}
end

function GenerateBarQuadsAndInfo(atlas)
    local sheet = {}
    local info = {}

    gBAR_FLOOR_NAME = 'floor'
    addAptQuadInfoSmart(atlas, sheet, info,
        gBAR_FLOOR_NAME, 221, 161, 254, 179)

    gBAR_HORZ_TABLE = 'horizontal_table'
    addAptQuadInfo(atlas, sheet, info,
        gBAR_HORZ_TABLE, 128, 160, 62, 31)

    gBAR_VERT_TABLE = 'vertical_table'
    addAptQuadInfo(atlas, sheet, info,
        gBAR_VERT_TABLE, 1, 193, 29, 63)

    gBAR_DOWN_CHAIR = 'down_chair'
    addAptQuadInfo(atlas, sheet, info,
        gBAR_DOWN_CHAIR, 4, 19, 23, 37)

    gBAR_UP_CHAIR = 'up_chair'
    addAptQuadInfo(atlas, sheet, info,
        gBAR_UP_CHAIR, 36, 28, 23, 27)

    gBAR_UP_CHAIR = 'up_chair'
    addAptQuadInfo(atlas, sheet, info,
        gBAR_UP_CHAIR, 36, 28, 23, 27)

    gBAR_RIGHT_CHAIR = 'right_chair'
    addAptQuadInfoSmart(atlas, sheet, info,
        gBAR_RIGHT_CHAIR, 66, 18, 91, 57)

    gBAR_LEFT_CHAIR = 'left_chair'
    addAptQuadInfoSmart(atlas, sheet, info,
        gBAR_LEFT_CHAIR, 100, 17, 123, 56)

    gBAR_BAR_BASE = 'bar_base'
    addAptQuadInfoSmart(atlas, sheet, info,
        gBAR_BAR_BASE, 341, 282, 363, 352)

    gBAR_BAR_EXT = 'bar_ext'
    addAptQuadInfoSmart(atlas, sheet, info,
        gBAR_BAR_EXT, 341, 285, 363, 346)

    gBAR_GLASS_SHELF = 'glass_shelf'
    addAptQuadInfoSmart(atlas, sheet, info,
        gBAR_GLASS_SHELF, 64, 384, 128, 448)

    gBAR_WINE_SHELF = 'wine_shelf'
    addAptQuadInfoSmart(atlas, sheet, info,
        gBAR_WINE_SHELF, 128, 448, 192, 512)

    return {['quads'] = sheet, ['info'] = info}
end

--[[
    Recursive table printing function.
    https://coronalabs.com/blog/2014/09/02/tutorial-printing-table-contents/
]]
function print_r ( t )
    local print_r_cache={}
    local function sub_print_r(t,indent)
        if (print_r_cache[tostring(t)]) then
            print(indent.."*"..tostring(t))
        else
            print_r_cache[tostring(t)]=true
            if (type(t)=="table") then
                for pos,val in pairs(t) do
                    if (type(val)=="table") then
                        print(indent.."["..pos.."] => "..tostring(t).." {")
                        sub_print_r(val,indent..string.rep(" ",string.len(pos)+8))
                        print(indent..string.rep(" ",string.len(pos)+6).."}")
                    elseif (type(val)=="string") then
                        print(indent.."["..pos..'] => "'..val..'"')
                    else
                        print(indent.."["..pos.."] => "..tostring(val))
                    end
                end
            else
                print(indent..tostring(t))
            end
        end
    end
    if (type(t)=="table") then
        print(tostring(t).." {")
        sub_print_r(t,"  ")
        print("}")
    else
        sub_print_r(t,"  ")
    end
    print()
end

--[[
    Utility function for slicing tables, a la Python.

    https://stackoverflow.com/questions/24821045/does-lua-have-something-like-pythons-slice
]]
function table.slice(tbl, first, last, step)
    local sliced = {}
  
    for i = first or 1, last or #tbl, step or 1 do
      sliced[#sliced+1] = tbl[i]
    end
  
    return sliced
end

--[[
    This function is specifically made to piece out the bricks from the
    sprite sheet. Since the sprite sheet has non-uniform sprites within,
    we have to return a subset of GenerateQuads.
]]
function GenerateQuadsBricks(atlas)
    return table.slice(GenerateQuads(atlas, 32, 16), 1, 21)
end

--[[
    This function is specifically made to piece out the locked brick from the
    sprite sheet. Since the sprite sheet has non-uniform sprites within,
    we have to return a subset of GenerateQuads.
]]
function GenerateQuadsLockBrick(atlas)
    return table.slice(GenerateQuads(atlas, 32, 16), 24, 24)
end

--[[
    This function is specifically made to piece out the powerups from the
    sprite sheet. Since the sprite sheet has non-uniform sprites within,
    we have to return a subset of GenerateQuads.
]]
function GenerateQuadsPowerups(atlas)
    return table.slice(GenerateQuads(atlas, 16, 16), 145, 154)
end

--[[
    This function is specifically made to piece out the paddles from the
    sprite sheet. For this, we have to piece out the paddles a little more
    manually, since they are all different sizes.
]]
function GenerateQuadsPaddles(atlas)
    local x = 0
    local y = 64

    local counter = 1
    local quads = {}

    for i = 0, 3 do
        -- smallest
        quads[counter] = love.graphics.newQuad(x, y, 32, 16,
            atlas:getDimensions())
        counter = counter + 1
        -- medium
        quads[counter] = love.graphics.newQuad(x + 32, y, 64, 16,
            atlas:getDimensions())
        counter = counter + 1
        -- large
        quads[counter] = love.graphics.newQuad(x + 96, y, 96, 16,
            atlas:getDimensions())
        counter = counter + 1
        -- huge
        quads[counter] = love.graphics.newQuad(x, y + 16, 128, 16,
            atlas:getDimensions())
        counter = counter + 1

        -- prepare X and Y for the next set of paddles
        x = 0
        y = y + 32
    end

    return quads
end

--[[
    This function is specifically made to piece out the balls from the
    sprite sheet. For this, we have to piece out the balls a little more
    manually, since they are in an awkward part of the sheet and small.
]]
function GenerateQuadsBalls(atlas)
    local x = 96
    local y = 48

    local counter = 1
    local quads = {}

    for i = 0, 3 do
        quads[counter] = love.graphics.newQuad(x, y, 8, 8, atlas:getDimensions())
        x = x + 8
        counter = counter + 1
    end

    x = 96
    y = 56

    for i = 0, 2 do
        quads[counter] = love.graphics.newQuad(x, y, 8, 8, atlas:getDimensions())
        x = x + 8
        counter = counter + 1
    end

    return quads
end

function renderHealth(health)
    -- XXX stubbed out method for now to bet gar mini game up and running
end

function renderScore(score)
    -- XXX stubbed out method for now to bet gar mini game up and running
end
