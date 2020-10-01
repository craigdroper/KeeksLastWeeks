
CasGCheckDealerBJState = Class{__includes = BaseState}

function CasGCheckDealerBJState:init(params)
    self.background = params.background
    self.dealer = params.dealer
    self.tablePlayer = params.tablePlayer
    self.deck = params.deck

    self.checkFaceDownCard = false
    self.checkDone = false
    self.flipDur = 2
end

function CasGCheckDealerBJState:isAceUp()
    for _, card in pairs(self.dealer.hand.cards) do
        if card.isAce and card.isFaceUp then
            return true
        end
    end
    return false
end

function CasGCheckDealerBJState:getHoleCard()
    for _, card in pairs(self.dealer.hand.cards) do
        if not card.isFaceUp then
            return card
        end
    end
    return nil
end

function CasGCheckDealerBJState:enter()
    if self:isAceUp() then
        gStateStack:push(CasGInsureMenuState({
                            background = self.background,
                            dealer = self.dealer,
                            tablePlayer = self.tablePlayer,
                            deck = self.deck,
                            callback = function() self.checkFaceDownCard = true end,
                            }))
    else
        --Pop off the check dealer state and
        --move on to the PlayerAct menu
        gStateStack:pop()
        gStateStack:push(CasGActMenuState({
                            background = self.background,
                            dealer = self.dealer,
                            tablePlayer = self.tablePlayer,
                            deck = self.deck,
                            }))
    end
end

function CasGCheckDealerBJState:update(dt)
    if self.checkFaceDownCard and not self.checkDone then
        local holeCard = self:getHoleCard()
        local isHoleTen = holeCard:getValue()[1] == 10
        Timer.tween(self.flipDur/2, {
            [holeCard] = {sxMult = 0}
        }):
        finish(
            function()
                holeCard.isFaceUp = isHoleTen
                Timer.tween(self.flipDur/2, {
                    [holeCard] = {sxMult = 1}
                }):
        finish(
            function()
                if isHoleTen then
                    -- Remove this check state and replace it with a
                    -- clear hand state
                    gStateStack:pop()
                    gStateStack:push(CasGClearHandState({
                                        background = self.background,
                                        dealer = self.dealer,
                                        tablePlayer = self.tablePlayer,
                                        deck = self.deck,
                                    }))
                    if self.tablePlayer.insureBet > 0 then
                        -- Push a UpdatePlayerStats state that will give the player
                        -- the bet and the winnings back once it is the top state on
                        -- the stack
                        gStateStack:push(UpdatePlayerStatsState({
                                        player = self.tablePlayer.player,
                                        stats = {money =
                                            self.tablePlayer.curBet +
                                            self.tablePlayer.insureBet}
                                    }))
                        gStateStack:push(CasGDispResState({
                                        result = 'INSURED LOSS',
                                        rgb = {r=255, g=255, b=0},
                                    }))
                    else
                        gStateStack:push(CasGDispResState({
                                        result = 'LOSS',
                                        rgb = {r=255, g=0, b=0},
                                    }))
                    end
                else
                    -- Pop this check dealer state and offer the
                    -- PlayerAct menu
                    gStateStack:pop()
                    gStateStack:push(CasGActMenuState({
                                background = self.background,
                                dealer = self.dealer,
                                tablePlayer = self.tablePlayer,
                                deck = self.deck,
                            }))
                end
            end)
            end)
        self.checkDone = true
    end
end

function CasGCheckDealerBJState:render()
    self.background:render()
    self.dealer.hand:render()
    self.tablePlayer.hand:render()
end
