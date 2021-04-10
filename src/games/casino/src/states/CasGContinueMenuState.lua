
CasGContinueMenuState = Class{__includes = BaseState}

function CasGContinueMenuState:init(params)
    self.background = params.background
    self.dealer = params.dealer
    self.tablePlayer = params.tablePlayer
    self.deck = params.deck
    self.isFirstUpdate = true

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
                        self.background.song:stop()
                        self.background.songTimer:remove()
                        gStateStack:push(FadeOutState({r = 255, g = 255, b = 255}, 1,
                            function()
                            end))
                        end))
                end
            },
        }
    }
end

function CasGContinueMenuState:enter()
    -- Effectively a no-op player stat check, except for when the player
    -- has bet all remaining money, and lost and the money is at zero,
    -- since that will trigger a game over in the update player stats
    gStateStack:push(UpdatePlayerStatsState({
                        player = gGlobalObjs['player'],
                        stats = {},
                    }))
end

function CasGContinueMenuState:update(dt)
    self.menu:update(dt)
    if self.isFirstUpdate then
        self.isFirstUpdate = false
    end
end

function CasGContinueMenuState:render()
    self.background:render()
    self.dealer.hand:render()
    self.tablePlayer.hand:render()
    self.menu:render()
end
