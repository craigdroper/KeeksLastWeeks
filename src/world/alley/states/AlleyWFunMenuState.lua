
AlleyWFunMenuState = Class{__includes = BaseState}

function AlleyWFunMenuState:init(params)
    self.alley = params.alley

    self.funMenu = Menu {
        items = {
            {
                text = 'Drink at the Bar',
                onSelect = function()
                    -- Pop AlleyWFunMenuState
                    gStateStack:pop()
                    -- Pop AlleyWStationaryState
                    gStateStack:pop()
                    -- Transition to leave state
                    gStateStack:push(AlleyWExitState(
                        {
                            alley = self.alley,
                            nextState = BarWEnterExteriorState()
                        }))
                end
            },
            {
                text = 'Hit the Club',
                onSelect = function()
                    -- Pop AlleyWFunMenuState
                    gStateStack:pop()
                    -- Pop AlleyWStationaryState
                    gStateStack:pop()
                    -- Transition to leave state
                    gStateStack:push(AlleyWExitState(
                        {
                            alley = self.alley,
                            nextState = ClubWEnterState()
                        }))
                end
            },
            {
                text = 'Gamble at the Casino',
                onSelect = function()
                    -- Pop AlleyWFunMenuState
                    gStateStack:pop()
                    -- Pop AlleyWStationaryState
                    gStateStack:pop()
                    -- Transition to leave state
                    gStateStack:push(AlleyWExitState(
                        {
                            alley = self.alley,
                            nextState = CasWEnterState()
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
