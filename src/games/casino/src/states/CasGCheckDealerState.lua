
CasGCheckDealerState = Class{__includes = BaseState}

function CasGCheckDealerState:init(params)
    self.background = params.background
    self.dealer = params.dealer
    self.tablePlayer = params.tablePlayer
    self.deck = params.deck
end

function CasGCheckDealerState:isBust(dealVal, dealSoftVal)
    if dealSoftVal == nil then
        return dealVal > 21
    else
        return dealVal > 21 and dealSoftVal > 21
    end
end

function CasGCheckDealerState:enter()
    if self.dealer.hand:getBestValue() > 21 then
        -- Player wins, and should be awarded the original bet
        -- and the winnings
        -- Pop this base check dealer state
        gStateStack:pop()
        -- Push a new base clear hand state that won't be updated/activated
        -- until it is the top state on the stack
        gStateStack:push(CasGClearHandState({
                            background = self.background,
                            dealer = self.dealer,
                            tablePlayer = self.tablePlayer,
                            deck = self.deck,
                        }))
        -- Push a UpdatePlayerStats state that will give the player
        -- the bet and the winnings back once it is the top state on
        -- the stack
        gStateStack:push(UpdatePlayerStatsState({
                            player = self.tablePlayer.player,
                            stats = {money = 2*self.tablePlayer.curBet,
                                     fun = 2*self.tablePlayer.curBet},
                        }))
        gStateStack:push(CasGDispResState({
                            result = 'WIN',
                            rgb = {r=0, g=255, b=0},
                        }))
        else
            -- Pop Check Dealer State
            gStateStack:pop()
            -- Push Dealer Act State
            gStateStack:push(CasGDealerActState({
                                background = self.background,
                                dealer = self.dealer,
                                tablePlayer = self.tablePlayer,
                                deck = self.deck,
                                delay = 1,
                                }))
        end
end

function CasGCheckDealerState:render()
    self.background:render()
    self.dealer.hand:render()
    self.tablePlayer.hand:render()
end
