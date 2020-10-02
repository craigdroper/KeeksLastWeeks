
CasGContinueMenuState = Class{__includes = BaseState}

function CasGContinueMenuState:init(params)
    self.background = params.background
    self.dealer = params.dealer
    self.tablePlayer = params.tablePlayer
    self.deck = params.deck

    self.menu = Menu {
        items = {
            {
                text = 'Play Another Hand',
                onSelect =
                function()
                    -- Pop Continue Menu
                    gStateStack:pop()
                    -- Push new deal state
                    gStateStack:push(CasGBetState({
                    background = self.background,
                    dealer = self.dealer,
                    tablePlayer = self.tablePlayer,
                    deck = self.deck,
                    }))
                end
            },
            {
                text = 'Tap Out',
                onSelect =
                function()
                    -- Current stak is
                    -- 1) CasWStationary
                    -- 2) ContinueMenu
                    -- Set the CasWStationary gameOver flag
                    local casWStationary = gStateStack:getNPrevState(1)
                    casWStationary.gameOver = true
                    gStateStack:push(FadeInState({r = 255, g = 255, b = 255}, 1,
                        function()
                        -- Pop Continue Menu
                        gStateStack:pop()
                        gStateStack:push(FadeOutState({r = 255, g = 255, b = 255}, 1,
                            function()
                            end))
                        end))
                end
            },
        }
    }
end

function CasGContinueMenuState:update(dt)
    self.menu:update(dt)
end

function CasGContinueMenuState:render()
    self.background:render()
    self.dealer.hand:render()
    self.tablePlayer.hand:render()
    self.menu:render()
end
