
CasWStationaryState = Class{__includes = BaseState}

function CasWStationaryState:init(params)
    self.player = gGlobalObjs['player']
    self.casino = params.casino
    -- The mini game that will be pushed on top of this state can
    -- access this data structure to indicate how the player
    -- did in the game
    self.gameStats = nil
end

function CasWStationaryState:enter()
    gStateStack:push(DialogueState(
        'Keeks: Dealer, I got a stack burning a hole in my pocket, '..
        'shuffle \'em up!',
        function()
            -- DEVXXX
            self.gameStats = {score = 666}
            -- TODO
            -- gStateStack:push(CasinoGStartState())
        end))
end

function CasWStationaryState:update(dt)
    if self.gameStats then
        gStateStack:push(UpdatePlayerStatsState({player = self.player,
            -- Casino mini game will reward its own score that can be
            -- dropped right in here
            stats = {fun = self.gameStats.score}, callback =
        function()
        gStateStack:push(DialogueState(
            'Keeks: Really though today was my day to finally take the house...' ..
            'Oh well, you know I\'ll be back!',
        function()
            -- Pop the stationary state, push the exit state
            -- Increase player walk speed like he's running out
            gStateStack:pop()
            gStateStack:push(CasWExitState(
                {casino = self.casino, nextState = AptWEnterState()}))
        end))
        end}))
    end
end

function CasWStationaryState:render()
    self.casino:render()
    self.player:render()
end
