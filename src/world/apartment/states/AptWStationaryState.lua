
AptWStationaryState = Class{__includes = BaseState}

function AptWStationaryState:init(params)
    self.player = gGlobalObjs['player']
    self.apartment = params.apartment
end

function AptWStationaryState:enter()
    gStateStack:push(UpdatePlayerStatsState({player = self.player,
        stats = {time = -10}, callback =
    function()
    gStateStack:push(DialogueState(
        'Welcome home\n\nWhat would you like to do next?',
        function()
            gStateStack:push(AptWInitialMenuState({apartment = self.apartment}))
        end))

    end}))
end

function AptWStationaryState:update(dt)
end

function AptWStationaryState:render()
    self.apartment:render()
    if self.player then
        self.player:render()
    end
end
