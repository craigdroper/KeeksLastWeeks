
CasGBetState = Class{__includes = BaseState}

function CasGBetState:init(params)
    self.background = params.background
    self.dealer = params.dealer
    self.tablePlayer = params.tablePlayer
    self.deck = params.deck
    -- Necessary to retrieve input from UserInputState
    self.userInput = nil
end

function CasGBetState:enter()
    gStateStack:push(DialogueState(
        'Dealer: Players, place your bets',
        function()
            gStateStack:push(UserInputState('$', '%D'))
        end))
end

function CasGBetState:update(dt)
    if self.userInput then
        local bet = tonumber(self.userInput)
        -- Naive protection against negative or 0 bets
        if bet == nil or bet <= 0 then
            self.userInput = {}
            self:enter()
            return
        end
        self.tablePlayer.curBet = bet
        gStateStack:push(UpdatePlayerStatsState({
            player = self.tablePlayer.player,
            stats = {money = -bet},
            callback = function()
                -- Pop off casino bet state, and push on
                -- casino deal state
                gStateStack:pop()
                gStateStack:push(CasGDealState({
                    background = self.background,
                    dealer = self.dealer,
                    tablePlayer = self.tablePlayer,
                    deck = self.deck,
                    dealCardDefs = {
                        [1] = {['dest'] = self.tablePlayer, ['faceUp'] = true},
                        [2] = {['dest'] = self.tablePlayer, ['faceUp'] = true},
                        [3] = {['dest'] = self.dealer, ['faceUp'] = true},
                        [4] = {['dest'] = self.dealer, ['faceUp'] = false},
                    },
                    nextState = CasGActMenuState({
                                    background = self.background,
                                    dealer = self.dealer,
                                    tablePlayer = self.tablePlayer,
                                    deck = self.deck,
                                }),
                }))
            end}))
    end
end

function CasGBetState:render()
    self.background:render()
end
