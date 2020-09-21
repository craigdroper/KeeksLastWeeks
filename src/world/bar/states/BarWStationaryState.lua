
BarWStationaryState = Class{__includes = BaseState}

function BarWStationaryState:init(params)
    self.player = gGlobalObjs['player']
    self.bar = params.bar
end

function BarWStationaryState:enter()
    gStateStack:push(DialogueState(
        'Bartender: Morning Keeks! ' ..
        'We\'ve got your favorite seat saved for you. ' ..
        'What\'ll it be?',
        function()
            gStateStack:push(BarWExitState(
                {bar = self.bar, nextGameState = AptWEnterState()}))
        end))
end

function BarWStationaryState:update(dt)
    self.player:update(dt)
end

function BarWStationaryState:render()
    self.bar:render()
    if self.player then
        self.player:render()
    end
end
