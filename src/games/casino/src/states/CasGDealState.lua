
CasGDealState = Class{__includes = BaseState}

function CasGDealState:init(params)
    self.background = params.background
    self.dealer = params.dealer
    self.tablePlayer = params.tablePlayer
    self.deck = params.deck
    self.dealCards = params.dealCards
end

function CasGDealState:render()
    self.background:render()
end
