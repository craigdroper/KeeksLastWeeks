
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

function CasGHand:addNewCard(card)
    table.insert(self.cards, card)
    self:updateNextCardX()
end

function CasGHand:clearCards()
    self.cards = {}
    self.nextCardX = self.firstCardX
end

function CasGHand:getValue()
    local val = 0
    for _, card in pairs(self.cards) do
        val = val + card:getValue()
    end
    return val
end

function CasGHand:getSoftValue()
    local val = 0
    local hasSoftVal = false
    for _, card in pairs(self.cards) do
        if card:getSoftValue() then
            hasSoftVal = true
            val = val + card:getSoftValue()
        else
            val = val + card:getValue()
        end
    end
    return hasSoftVal and val or nil
end

function CasGHand:render()
    for _, card in pairs(self.cards) do
        card:render()
    end
end
