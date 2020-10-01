
CasGDealerFlipState = Class{__includes = BaseState}

function CasGDealerFlipState:init(params)
    self.background = params.background
    self.dealer = params.dealer
    self.tablePlayer = params.tablePlayer
    self.deck = params.deck

    self.flipDur = 2
end

function CasGDealerFlipState:enter()
    local flipCard = self.dealer.hand:getFaceDownCard()
    Timer.tween(self.flipDur/2, {
        [flipCard] = {sxMult = 0}
    }):
    finish(
        function()
            flipCard.isFaceUp = true
            Timer.tween(self.flipDur/2, {
                [flipCard] = {sxMult = 1}
            }):
    finish(
        function()
        end
    )
        end
    )

end

function CasGDealerFlipState:render()
    self.background:render()
    self.dealer.hand:render()
    self.tablePlayer.hand:render()
end
