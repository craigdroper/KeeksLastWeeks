
CasGStartState = Class{__includes = BaseState}

function CasGStartState:init()
    self.background = CasGBackground()
    self.dealer = CasGDealer()
    self.tablePlayer = CasGTablePlayer()
    self.deck = CasGDeck(4)
end

function CasGStartState:enter()
    -- Push a dialogue box with some simple instructions
    gStateStack:push(DialogueState(
        '<Instructions for BlackJack, num decks, dealer rules, how to bet, no splits, etc>',
        function()
            -- pop the club mini game start
            -- state and push on a serve state for level 1
            gStateStack:pop()
            gStateStack:push(CasGShuffleState({
                background = self.background,
                dealer = self.dealer,
                tablePlayer = self.tablePlayer,
                deck = self.deck,
                }))
        end))
end

function CasGStartState:update(dt)
end

function CasGStartState:render()
    self.background:render()
end
