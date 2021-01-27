
BarWStationaryState = Class{__includes = BaseState}

function BarWStationaryState:init(params)
    self.player = gGlobalObjs['player']
    self.bar = params.bar
    -- The mini game that will be pushed on top of this state can
    -- access this data structure to indicate how the player
    -- did in the game
    self.gameStats = nil
end

function BarWStationaryState:enter()
    gStateStack:push(DialogueState(
        'Bartender: Morning Keeks! ' ..
        'We\'ve got your favorite seat saved for you. ' ..
        'What\'ll it be?',
        function()
        gStateStack:push(FadeInState({r = 255, g = 255, b = 255}, 1,
        function()
            -- Keep the Stationary State on, and put the mini game
            -- on top of it
            gStateStack:push(BarGStartState())
            gStateStack:push(FadeOutState({r = 255, g = 255, b = 255}, 1,
                function()
                end))
        end))
        end))
end

function BarWStationaryState:update(dt)
    if self.gameStats then
        gStateStack:push(UpdatePlayerStatsState({player = self.player,
            -- Bar mini game will give 100 fun for every level claered
            stats = {fun = 100 * self.gameStats.score, money = -50}, callback =
        function()
        gStateStack:push(DialogueState(
            'Bartender: Hope you enjoyed your time at the bar Keeks!\n' ..
            'Now while I\'ve got you here, do you think we could settle up your tab?\n\n' ..
            'Keeks: Ummm...',
        function()
            -- Pop the stationary state, push the exit state
            -- Increase player walk speed like he's running out
            self.player.walkSpeed = 150
            gStateStack:pop()
            gStateStack:push(BarWExitState(
                {bar = self.bar, nextGameState = AptWEnterState()}))
        end))
        end}))
    end
end

function BarWStationaryState:render()
    self.bar:render()
    if self.player then
        self.player:render()
    end
end
