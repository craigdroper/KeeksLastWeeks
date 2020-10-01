
CasGActMenuState = Class{__includes = BaseState}

function CasGActMenuState:init(params)
    self.background = params.background
    self.dealer = params.dealer
    self.tablePlayer = params.tablePlayer
    self.deck = params.deck

    self.actMenu = Menu {
        items = {
            {
                text = 'Hit',
                onSelect =
                function()
                    -- Pop ActMenu
                    gStateStack:pop()
                    -- Push new deal state
                    gStateStack:push(CasGDealState({
                        background = self.background,
                        dealer = self.dealer,
                        tablePlayer = self.tablePlayer,
                        deck = self.deck,
                        dealCardDefs = {
                            [1] = {['dest'] = self.tablePlayer, ['faceUp'] = true},
                        },
                        nextState = CasGCheckPlayerState({
                                    background = self.background,
                                    dealer = self.dealer,
                                    tablePlayer = self.tablePlayer,
                                    deck = self.deck,
                                    }),
                    }))
                end
            },
            {
                text = 'Stay',
                onSelect =
                function()
                    -- Pop ActMenu
                    gStateStack:pop()
                    -- Push dealer flip state
                    gStateStack:push(CasGDealerFlipState({
                        background = self.background,
                        dealer = self.dealer,
                        tablePlayer = self.tablePlayer,
                        deck = self.deck,
                    }))
                end
            },
        }
    }
end

function CasGActMenuState:update(dt)
    self.actMenu:update(dt)
end

function CasGActMenuState:render()
    self.background:render()
    self.dealer.hand:render()
    self.tablePlayer.hand:render()
    self.actMenu:render()
end
