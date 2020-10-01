
CasGDealState = Class{__includes = BaseState}

function CasGDealState:init(params)
    self.background = params.background
    self.dealer = params.dealer
    self.tablePlayer = params.tablePlayer
    self.deck = params.deck
    self.dealCardDefs = params.dealCardDefs
    self.curCardDefIdx = 1
    self.nextState = params.nextState

    self:checkDealCard()
end

function CasGDealState:checkDealCard()
    if self.curCardDefIdx > #self.dealCardDefs then
        -- Pop off DealState and Move to the next State
        gStateStack:pop()
        gStateStack:push(self.nextState)
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
    nextCard:setDestCoords(targetX, targetY)
    targetHand:addNewCard(nextCard)
    local aprxPixelDist = targetY - nextCard.y
    Timer.tween(aprxPixelDist / nextCard.speed, {
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
