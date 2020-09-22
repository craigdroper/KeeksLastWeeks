
BarWStationaryState = Class{__includes = BaseState}

function BarWStationaryState:init(params)
    self.player = gGlobalObjs['player']
    self.bar = params.bar
    -- The mini game that will be pushed on top of this state can
    -- access this flag to indicate that the game is complete
    self.isGamePlayed = false
end

function BarWStationaryState:enter()
    gStateStack:push(DialogueState(
        'Bartender: Morning Keeks! ' ..
        'We\'ve got your favorite seat saved for you. ' ..
        'What\'ll it be?',
        function()
            gStateStack:push(BarGStartState())
        end))
end

function BarWStationaryState:update(dt)
    if self.isGamePlayed then
        gStateStack:push(DialogueState(
            'Bartender: Hope you enjoyed your time at the bar Keeks! ' ..
            'Just kidding, I know you always do.' ..
            'Now while I\'ve got you here, do you think we could settle up your tab?\n\n' ..
            'Keeks: Ummm...',
        function()
            -- Pop the stationary state, push the exit state
            gStateStack:pop()
            gStateStack:push(BarWExitState(
                {bar = self.bar, nextGameState = AptWEnterState()}))
        end))
    end
end

function BarWStationaryState:render()
    self.bar:render()
    if self.player then
        self.player:render()
    end
end
