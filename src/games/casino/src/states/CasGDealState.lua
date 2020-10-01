
CasGDealState = Class{__includes = BaseState}

function CasGDealState:init(params)
    self.background = params.background
    self.dealer = params.dealer
    self.tablePlayer = params.tablePlayer
    self.deck = params.deck
    self.dealCardDefs = params.dealCardDefs
    self.curCardDefIdx = 1

    -- Deal specific member parameters
    self.dealtCardSpeed = 200

    self:checkDealCard()
end

function CasGDealState:checkDealCard()
    if self.curCardDefIdx > #self.dealCardDefs then
        -- Pop off DealState and Move to the Player Action State
        gStateStack:pop()
        gStateStack:push(CasGPlayerActState({
            background = self.background,
            dealer = self.dealer,
            tablePlayer = self.tablePlayer,
            deck = self.deck,
        }))
        return
    end
    local cardDef = self.dealCardDefs[self.curCardDefIdx]
    self.curCardDefIdx = self.curCardDefIdx + 1
    local nextCard = self.deck:popTopCard()
    nextCard.isFaceUp = cardDef.faceUp
    -- Add this card to the target person's hand, and then tween the card
    -- to their pile
    local targetHand = cardDef.dest.hand
    local targetX = targetHand.nextCardX
    local targetY = targetHand.nextCardY
    targetHand:addNewCard(nextCard)
    local aprxPixelDist = targetY - nextCard.y
    Timer.tween(aprxPixelDist / self.dealtCardSpeed, {
        [nextCard] = {x = targetX, y = targetY}
    }):finish(
        function()
    self:checkDealCard()
        end)
end

function CasGDealState:render()
    self.background:render()
    self.dealer.hand:render()
    self.tablePlayer.hand:render()
end
