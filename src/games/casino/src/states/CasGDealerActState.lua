
CasGDealerActState = Class{__includes = BaseState}

function CasGDealerActState:init(params)
    self.background = params.background
    self.dealer = params.dealer
    self.tablePlayer = params.tablePlayer
    self.deck = params.deck
    self.actDelay = params.delay

    self.stayThresh = 16
    self.actTimer = 0
end

function CasGDealerActState:update(dt)
    self.actTimer = self.actTimer + dt
    if self.actTimer > self.actDelay then
        self:act()
    end
end

function CasGDealerActState:act()
    -- CasGDealer assumes that CheckDealer has been called before it,
    -- where a bust would've been hit, so this Act state either needs to
    -- choose to hit or stay
    if self.dealer.hand:getBestValue() <= self.stayThresh then
        -- Pop this act state and hit another card
        gStateStack:pop()
        gStateStack:push(CasGDealState({
            background = self.background,
            dealer = self.dealer,
            tablePlayer = self.tablePlayer,
            deck = self.deck,
            dealCardDefs = {
                [1] = {['dest'] = self.dealer, ['faceUp'] = true},
            },
            nextState = CasGCheckDealerState({
                background = self.background,
                dealer = self.dealer,
                tablePlayer = self.tablePlayer,
                deck = self.deck,
            }),
        }))
    else
        -- Otherwise the dealer will stay and we should compare
        -- the dealer and table player's hands
        -- Pop this act state and hit another card
        gStateStack:pop()
        gStateStack:push(CasGCheckWinnerState({
                background = self.background,
                dealer = self.dealer,
                tablePlayer = self.tablePlayer,
                deck = self.deck
            }))
    end
end

function CasGDealerActState:render()
    self.background:render()
    self.dealer.hand:render()
    self.tablePlayer.hand:render()
end
