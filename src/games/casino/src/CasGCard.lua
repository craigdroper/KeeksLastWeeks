
CasGCard = Class{}

local CARD_VALS = {
    [1] = {1, 11}, -- ACE
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
function CasGCard:init(valIdx, suitIdx, dealerX, dealerY)
    self.x = dealerX
    self.y = dealerY
    self.width = 48
    self.height = 64

    self.valIdx = valIdx
    self.val = CARD_VALS[self.valIdx]
    self.hasSoftVal = (self.valIdx == 1)
    self.isFaceUp = false

    self.faceTexture = gCasGTextures['cards']
    self.faceQuad = gCasGFrames[valIdx + (#CARD_VALS * (suitIdx - 1))]

    self.backImg = gCasGImages['card-back']
    self.backImgW, self.backImgH = self.backImg:getDimensions()
    self.backImgSX = self.backImgW / self.width
    self.backImgSY = self.backImgH / self.height
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

function CasGCard:deal(player, isflipCard)
    -- TODO
    -- Tween the deal, and possibly the flipping action
    -- Implement Player:getNextCardDimensions and use that here
end

function CasGCard:render()
    if self.isFaceUp then
        love.graphics.filterDrawQ(
            self.faceTexture, self.faceQuad, self.x, self.y)
    else
        love.graphics.filterDrawD(
            self.backImg, self.x, self.y, 0, self.backImgSX, self.backImgSY)
    end
end
