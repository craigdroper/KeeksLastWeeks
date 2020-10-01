
CasGCard = Class{}

local CARD_VALS = {
    [1] = {11, 1}, -- ACE
    [2] = {2},
    [3] = {3},
    [4] = {4},
    [5] = {5},
    [6] = {6},
    [7] = {7},
    [8] = {8},
    [9] = {9},
    [10] = {10},
    [11] = {10}, -- JACK
    [12] = {10}, -- QUEEN
    [13] = {10}, -- KING
}

--[[
    Suit Indexes relate as follows:
    1 - Clubs
j   2 - Spades
    3 - Hearts
    4 - Diamonds
--]]
function CasGCard:init(valIdx, suitIdx, x, y)
    self.valIdx = valIdx
    self.suitIdx = suitIdx
    self.x = x
    self.y = y
    self.o = 0
    self.sx = 1
    self.sy = 1
    self.destX = nil
    self.destY = nil
    self.width = 48
    self.height = 64
    self.ox = self.width/2
    self.oy = self.height/2
    self.offsetX = self.width/2
    self.offsetY = self.height/2

    self.sxMult = 1
    self.syMult = 1

    -- How fast it moves across the table
    self.speed = 200

    self.val = CARD_VALS[self.valIdx]
    self.isAce = (self.valIdx == 1)
    self.isFaceUp = false
    self.flipCardY = nil

    self.faceTexture = gCasGTextures['cards']
    self.faceQuad = gCasGFrames['cards'][self.valIdx + (#CARD_VALS * (self.suitIdx - 1))]
    self.backImg = gCasGImages['card-back']
    local testW, testH = self.backImg:getDimensions()
    if testW ~= self.width or testH ~= self.height then
        error('Class written under assumption card face and back images will '..
            'be the same dimensions')
    end
end

function CasGCard:getX()
    return self.x + self.offsetX
end

function CasGCard:getY()
    return self.y + self.offsetY
end

function CasGCard:getSX()
    return self.sx * self.sxMult
end

function CasGCard:getSY()
    return self.sy * self.syMult
end

function CasGCard:getOffsetX()
    local curSX = nil
    if self.isFaceUp then
        curSX = self.sx * self.sxMult
    else
        curSX = self.backImgSX * self.sxMult
    end
    return self.width/2/curSX
end

function CasGCard:getOffsetY()
    local curSY = nil
    if self.isFaceUp then
        curSY = self.sy * self.syMult
    else
        curSY = self.backImgSY * self.syMult
    end
    return self.height/2/curSY
end

function CasGCard:getIsFaceUp()
    return self.isFaceUp
end

function CasGCard:getValue()
    return self.val
end

function CasGCard:setDestCoords(destX, destY)
    self.destX = destX
    self.destY = destY
    self.flipCardY = self.destY/2
end

function CasGCard:render()
    if self.isFaceUp and self.y > self.flipCardY then
        love.graphics.filterDrawQ(
            self.faceTexture, self.faceQuad, self:getX(), self:getY(),
            self.o, self:getSX(), self:getSY(),
            self.ox, self.oy)
    else
        love.graphics.filterDrawD(
            self.backImg, self:getX(), self:getY(),
            self.o, self:getSX(), self:getSY(),
            self.ox, self.oy)
    end
end
