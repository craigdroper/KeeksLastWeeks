
AlleyWFunMenuState = Class{__includes = BaseState}

function AlleyWFunMenuState:init(params)
    self.alley = params.alley

    self.funMenu = Menu {
        items = {
            {
                text = 'Hit the Bar',
                onSelect = function()
                    -- Pop AlleyWFunMenuState
                    gStateStack:pop()
                    -- Pop AlleyWStationaryState
                    gStateStack:pop()
                    -- Transition to leave state
                    gStateStack:push(AlleyWExitState(
                        {
                            alley = self.alley,
                            nextState = BarWEnterState({bar = Bar()})
                        }))
                end
            },
        }
    }
end

function AlleyWFunMenuState:enter()
end

function AlleyWFunMenuState:update(dt)
    self.funMenu:update(dt)
end

function AlleyWFunMenuState:render()
    self.funMenu:render()
end
