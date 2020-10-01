
CasGClearHandState = Class{__includes = BaseState}

function CasGClearHandState:init(params)
    self.background = params.background
    self.dealer = params.dealer
    self.tablePlayer = params.tablePlayer
    self.deck = params.deck

    self.tableCards = #self.dealer.hand.cards + #self.tablePlayer.hand.cards
    self.clearedCards = 0
    self.isCardsTweened = false
end

function CasGClearHandState:tweenCards()
    for _, card in pairs(self.dealer.hand.cards) do
        self:tweenClearCard(card)
    end
    for _, card in pairs(self.tablePlayer.hand.cards) do
        self:tweenClearCard(card)
    end
end

function CasGClearHandState:tweenClearCard(card)
    local aprxPixelDist = math.abs(self.deck.discardY - card:getY())
    Timer.tween(aprxPixelDist / card.speed, {
        [card] = {x = self.deck.discardX, y = self.deck.discardY}
    }):finish(
        function()
            self.clearedCards = self.clearedCards + 1
        end
    )
end

function CasGClearHandState:update(dt)
    if not self.isCardsTweened then
        self:tweenCards()
        self.isCardsTweened = true
    end
    if self.clearedCards == self.tableCards then
        -- Clear the underlying hand objects
        self.dealer.hand:clearCards()
        self.tablePlayer.hand:clearCards()
        -- Pop CasGClearHandState
        gStateStack:pop()
        -- Push the CasGPlayerChoiceMenu
        gStateStack:push(CasGContinueMenuState({
            background = self.background,
            dealer = self.dealer,
            tablePlayer = self.tablePlayer,
            deck = self.deck,
        }))
    end
end

function CasGClearHandState:render()
    self.background:render()
    self.dealer.hand:render()
    self.tablePlayer.hand:render()
end
