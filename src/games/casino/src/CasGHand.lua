
CasGHand = Class{}

function CasGHand:init(midX, y)
    self.midX = midX
    self.y = y
    self.cards = {}

    local tmpCard = CasGCard(1, 1)
    self.cardW = tmpCard.width
    self.cardH = tmpCard.height

    self.firstCardX = self.midX - self.cardW
    self.nextCardX = self.firstCardX
    self.nextCardY = self.y
end

function CasGHand:updateNextCardX()
    if (#self.cards % 2 == 1) then
        -- Odd numbers, always even it out to the right across the x midline
        local curXOffset = self.midX - self.nextCardX
        self.nextCardX = self.midX + curXOffset - self.cardW
    else
        -- Even numbers, add a new one to the left
        local curXOffset = self.nextCardX + self.cardW - self.midX
        self.nextCardX = self.midX - curXOffset - self.cardW
    end
end

function CasGHand:getFaceDownCard()
    for _, card in pairs(self.cards) do
        if not card:getIsFaceUp() then
            return card
        end
    end
    return nil
end

function CasGHand:isBlackJack()
    if #self.cards ~= 2 then
        return false
    end
    return self:getBestValue() == 21
end

function CasGHand:addNewCard(card)
    table.insert(self.cards, card)
    self:updateNextCardX()
end

function CasGHand:clearCards()
    self.cards = {}
    self.nextCardX = self.firstCardX
end

-- This function will calculate all possible values of the hand,
-- then will choose the highest value that is at or below 21. If
-- all are above 21, then the highest value above 21 will be chosen
function CasGHand:getBestValue()
    local val = 0
    local softDeltas = {}
    for _, card in pairs(self.cards) do
        local cardVals = card:getValue()
        if #cardVals == 2 then
            table.insert(softDeltas, (cardVals[2] - cardVals[1]))
        end
        val = val + cardVals[1]
    end
    local valCombos = {[1] = val}
    for _, delta in pairs(softDeltas) do
        val = val + delta
        table.insert(valCombos, val)
    end
    -- Attempt to find the highest value that is under 21
    local bestValDiff = 21
    local bestVal = nil
    for _, val in pairs(valCombos) do
        if val <= 21 and (21 - val) < bestValDiff then
            bestVal = val
            bestValDiff = 21 - val
        end
    end
    if bestVal then
        return bestVal
    else
        return valCombos[1]
    end
end

function CasGHand:render()
    for _, card in pairs(self.cards) do
        card:render()
    end
end
