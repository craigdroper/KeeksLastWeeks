
CasGDeck = Class{}

function CasGDeck:init(numDecks)
    self.numDecks = numDecks and numDecks or 1

    -- Coordinates where cards will go to and from
    self.deckX = VIRTUAL_WIDTH / 2
    self.deckY = -64
    self.discardX = VIRTUAL_WIDTH / 4
    self.discardY = -64
    
    self.cards = {}
    self:reset()
end

function CasGDeck:reset()
    self.cards = {}
    for d = 1, self.numDecks do
        for v = 1, 13 do
            for s = 1, 4 do
                table.insert(self.cards, CasGCard(v, s, self.deckX, self.deckY))
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

