
CasGCheckWinnerState = Class{__includes = BaseState}

function CasGCheckWinnerState:init(params)
    self.background = params.background
    self.dealer = params.dealer
    self.tablePlayer = params.tablePlayer
    self.deck = params.deck
end

function CasGCheckWinnerState:enter()
    -- Assuming that both players have completed their turns and neither
    -- have busted
    -- Tie goes to the dealer

    -- Pop this Check Winner state
    gStateStack:pop()
    -- Push a new base clear hand state that won't be updated/activated
    -- until it is the top state on the stack
    gStateStack:push(CasGClearHandState({
                        background = self.background,
                        dealer = self.dealer,
                        tablePlayer = self.tablePlayer,
                        deck = self.deck,
                    }))
    if self.tablePlayer.hand:getBestValue() > self.dealer.hand:getBestValue() then
        -- Push a UpdatePlayerStats state that will give the player
        -- the bet and the winnings back once it is the top state on
        -- the stack
        if self.tablePlayer.hand:isBlackJack() then
            gStateStack:push(UpdatePlayerStatsState({
                                player = self.tablePlayer.player,
                                stats = {money = math.floor(2.5*self.tablePlayer.curBet),
                                         fun = 5*self.tablePlayer.curBet},
                            }))
            gStateStack:push(CasGDispResState({
                                result = 'BLACKJACK WIN',
                                rgb = {r=0, g=255, b=0},
                            }))
        else
            gStateStack:push(UpdatePlayerStatsState({
                                player = self.tablePlayer.player,
                                stats = {money = 2*self.tablePlayer.curBet,
                                         fun = self.tablePlayer.curBet},
                            }))
            gStateStack:push(CasGDispResState({
                                result = 'WIN',
                                rgb = {r=0, g=255, b=0},
                            }))
        end
    else
        gStateStack:push(CasGDispResState({
                            result = 'LOSE',
                            rgb = {r=255, g=0, b=0},
                        }))
    end
end

function CasGCheckWinnerState:render()
    self.background:render()
    self.dealer.hand:render()
    self.tablePlayer.hand:render()
end
