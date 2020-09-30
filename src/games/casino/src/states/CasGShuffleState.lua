
CasGShuffleState = Class{__includes = BaseState}

function CasGShuffleState:init(params)
    self.background = params.background
    self.dealer = params.dealer
    self.tablePlayer = params.tablePlayer
    self.deck = params.deck
end

function CasGShuffleState:enter()
    self.deck:reset()
    gStateStack:pop()
    gStateStack:push(CasGBetState({
        background = self.background,
        dealer = self.dealer,
        tablePlayer = self.tablePlayer,
        deck = self.deck,
        }))
end

function CasGStartState:update(dt)
end

function CasGStartState:render()
    self.background:render()
end
