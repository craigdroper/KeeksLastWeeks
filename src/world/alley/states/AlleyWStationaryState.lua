
AlleyWStationaryState = Class{__includes = BaseState}

function AlleyWStationaryState:init(params)
    self.player = gGlobalObjs['player']
    self.alley = params.alley
end

function AlleyWStationaryState:enter()
    gStateStack:push(DialogueState(
        'Keeks: Mikhail! So good to see you comrade...',
        function()
            -- Pop off the AlleyWStationary state,
            -- and push the AlleyExitState with the correct
            -- next state as determined by this stationary state
            gStateStack:pop()
            gStateStack:push(AlleyWExitState({
                        alley = self.alley,
                        nextState = AptWEnterState()}))

        end))
end

function AlleyWStationaryState:update(dt)
end

function AlleyWStationaryState:render()
    self.alley:render()
    if self.player then
        self.player:render()
    end
end
