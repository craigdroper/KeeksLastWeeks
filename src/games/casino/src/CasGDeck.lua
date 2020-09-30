
CasGDeck = Class{}

function CasGDeck:init(numDecks)
    self.numDecks = numDecks and numDecks or 1
    self.cards = {}
    self:reset()
end

function CasGDeck:reset()
    self.cards = {}
    for d = 1, self.numDecks do
        for v = 1, 13 do
            for s = 1, 4 do
                table.insert(self.cards, CasGCard(v, s))
            end
        end
    end
    self:shuffle()
end

function CasGDeck:shuffle()
    for i = 1, 4 do
        for j = 1, #self.cards do
            local swapAIdx = math.random(#self.cards)
            local swapBIdx = math.random(#self.cards)
            local tmpCard = self.cards[swapAIdx]
            self.cards[swapAIdx] = self.cards[swapBIdx]
            self.cards[swapBIdx] = tmpCard
        end
    end
end

function CasGDeck:popTopCard()
    return table.remove(self.cards)
end

function CasGDeck:isAlmostEmpty()
    return #self.cards < 20
end

