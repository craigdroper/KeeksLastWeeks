
CasGCheckPlayerState = Class{__includes = BaseState}

function CasGCheckPlayerState:init(params)
    self.background = params.background
    self.dealer = params.dealer
    self.tablePlayer = params.tablePlayer
    self.deck = params.deck
end

function CasGCheckPlayerState:enter()
    if self.tablePlayer.hand:getBestValue() > 21 then
        -- Pop this base check player state
        gStateStack:pop()
        -- Push a new base clear hand state that won't be
        -- updated until the display result is finished
        gStateStack:push(CasGClearHandState({
                            background = self.background,
                            dealer = self.dealer,
                            tablePlayer = self.tablePlayer,
                            deck = self.deck,
                        }))
        -- Push a DispResult State
        gStateStack:push(CasGDispResState({
                    result = 'BUST',
                    rgb = {r=255, g=0, b=0},
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
