
CasGStartState = Class{__includes = BaseState}

function CasGStartState:init()
    self.background = CasGBackground()
    self.dealer = CasGDealer()
    self.tablePlayer = CasGTablePlayer()
    self.deck = CasGDeck(4)
end

function CasGStartState:enter()
    self.startMenu = Menu {
        items = {
            {
                text = 'Play',
                onSelect =
                    function()
                        -- Pop off CasGStartState
                        gStateStack:pop()
                        -- Transition to playing blackjack
                        gStateStack:push(CasGShuffleState({
                            background = self.background,
                            dealer = self.dealer,
                            tablePlayer = self.tablePlayer,
                            deck = self.deck,
                            }))
                    end
            },
            {
                text = 'Instructions',
                onSelect =
                    function()
                        gStateStack:push(CasGInstructionsState())
                    end
            },
        }
    }
end

function CasGStartState:update(dt)
    self.startMenu:update(dt)
end

function CasGStartState:render()
    self.background:render()
    self.startMenu:render()
end
