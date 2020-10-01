
CasGInsureMenuState = Class{__includes = BaseState}

function CasGInsureMenuState:init(params)
    self.background = params.background
    self.dealer = params.dealer
    self.tablePlayer = params.tablePlayer
    self.deck = params.deck
    self.callback = params.callback

    self.menu = Menu {
        items = {
            {
                text = 'Buy Insurance',
                onSelect =
                function()
                    self.tablePlayer.insureBet = math.floor(self.tablePlayer.curBet/2)
                    -- Pop InsureMenu
                    gStateStack:pop()
                    -- Push an update to the player stats to subtract
                    -- an additional half of the current bet as insurance
                    gStateStack:push(UpdatePlayerStatsState({
                            player = self.tablePlayer.player,
                            stats =
                                {money = -self.tablePlayer.insureBet},
                        }))
                    self.callback()
                end
            },
            {
                text = 'No Insurance',
                onSelect =
                function()
                    -- Pop Insure Menu
                    gStateStack:pop()
                    self.callback()
                end
            },
        }
    }
end

function CasGInsureMenuState:update(dt)
    self.menu:update(dt)
end

function CasGInsureMenuState:render()
    self.menu:render()
end
