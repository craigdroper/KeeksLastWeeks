
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
    self.destX = nil
    self.destY = nil
    self.width = 48
    self.height = 64

    self.val = CARD_VALS[self.valIdx]
    self.hasSoftVal = (self.valIdx == 1)
    self.isFaceUp = false
    self.flipCardY = nil

    self.faceTexture = gCasGTextures['cards']
    self.faceQuad = gCasGFrames['cards'][self.valIdx + (#CARD_VALS * (self.suitIdx - 1))]

    self.backImg = gCasGImages['card-back']
    self.backImgW, self.backImgH = self.backImg:getDimensions()
    self.backImgSX = self.width / self.backImgW
    self.backImgSY = self.height / self.backImgH
end

function CasGCard:getValue()
    return self.val[1]
end

function CasGCard:getSoftValue()
    if #self.val == 2 then
        return self.val[2]
    end
    return nil
end

function CasGCard:setDestCoords(destX, destY)
    self.destX = destX
    self.destY = destY
    self.flipCardY = self.destY/2
end

function CasGCard:render()
    if self.isFaceUp and self.y > self.flipCardY then
        love.graphics.filterDrawQ(
            self.faceTexture, self.faceQuad, self.x, self.y)
    else
        love.graphics.filterDrawD(
            self.backImg, self.x, self.y, 0, self.backImgSX, self.backImgSY)
    end
end
