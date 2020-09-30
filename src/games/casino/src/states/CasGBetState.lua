
CasGBetState = Class{__includes = BaseState}

function CasGBetState:init(params)
    self.background = params.background
    self.dealer = params.dealer
    self.tablePlayer = params.tablePlayer
    self.deck = params.deck
    -- Necessary to retrieve input from UserInputState
    self.userInput = nil
end

function CasGBetState:enter()
    gStateStack:push(DialogueState(
        'Dealer: Players, place your bets',
        function()
            gStateStack:push(UserInputState('$', '%D'))
        end))
end

function CasGBetState:update(dt)
    if self.userInput then
        local bet = tonumber(self.userInput)
        gStateStack:push(UpdatePlayerStatsState({
            player = self.tablePlayer.player,
            stats = {money = -bet},
            callback = function()
                -- Pop off casino bet state, and push on
                -- casino deal state
                gStateStack:pop()
                gStateStack:push(CasGDealState({
                    background = self.background,
                    dealer = self.dealer,
                    player = self.player,
                    deck = self.deck,
                    dealCards = {
                        [1] = {dest = self.player, faceUp = true},
                        [2] = {dest = self.player, faceUp = true},
                        [3] = {dest = self.dealer, faceUp = true},
                        [4] = {dest = self.dealer, faceUp = false},
                    }
                }))
            end}))
    end
end

function CasGBetState:render()
    self.background:render()
end
