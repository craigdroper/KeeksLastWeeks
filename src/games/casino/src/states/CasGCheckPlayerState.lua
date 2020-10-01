
CasGCheckPlayerState = Class{__includes = BaseState}

function CasGCheckPlayerState:init(params)
    self.background = params.background
    self.dealer = params.dealer
    self.tablePlayer = params.tablePlayer
    self.deck = params.deck
end

function CasGCheckPlayerState:isBust(playVal, playSoftVal)
    if playSoftVal == nil then
        return playVal > 21
    else
        return playVal > 21 and playSoftVal > 21
    end
end

function CasGCheckPlayerState:enter()
    local playVal = self.tablePlayer:getValue()
    local playSoftVal = self.tablePlayer:getSoftValue()
    if self:isBust(playVal, playSoftVal) then
        gStateStack:push(CasGDispResState({
                    result = 'BUST',
                    -- Since we want to have DispRestState pop itself
                    -- and the CheckPlayerState before pushing the ClearHand
                    -- state, set popPrevState to true
                    popPrevState = true,
                    nextState = CasGClearHandState({
                                background = self.background,
                                dealer = self.dealer,
                                tablePlayer = self.tablePlayer,
                                deck = self.deck,
                                }),
                }))
        else
            -- Pop Check Player State
            gStateStack:pop()
            -- Push Player Act Menu State
            gStateStack:push(CasGActMenuState({
                                background = self.background,
                                dealer = self.dealer,
                                tablePlayer = self.tablePlayer,
                                deck = self.deck,
                                }))
        end
end

function CasGCheckPlayerState:render()
    self.background:render()
    self.dealer.hand:render()
    self.tablePlayer.hand:render()
end
