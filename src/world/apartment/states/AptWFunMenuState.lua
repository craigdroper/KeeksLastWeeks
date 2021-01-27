
AptWFunMenuState = Class{__includes = BaseState}

function AptWFunMenuState:init(params)
    self.apartment = params.apartment

    self.aptMenu = Menu {
        items = {
            {
                text = 'Drink at the Bar',
                onSelect = function()
                    -- Pop AptWFunMenuState
                    gStateStack:pop()
                    -- Pop AptStationaryState
                    gStateStack:pop()
                    -- Transition to leave state
                    gStateStack:push(AptWExitState(
                        {
                            apartment = self.apartment,
                            nextGameState = BarWEnterExteriorState()
                        }))
                end
            },
            {
                text = 'Hit the Club',
                onSelect = function()
                    -- Pop AptWFunMenuState
                    gStateStack:pop()
                    -- Pop AptStationaryState
                    gStateStack:pop()
                    -- Transition to leave state
                    gStateStack:push(AptWExitState(
                        {
                            apartment = self.apartment,
                            nextGameState = ClubWEnterState()
                        }))
                end
            },
            {
                text = 'Gamble at the Casino',
                onSelect = function()
                    -- Pop AptWFunMenuState
                    gStateStack:pop()
                    -- Pop AptStationaryState
                    gStateStack:pop()
                    -- Transition to leave state
                    gStateStack:push(AptWExitState(
                        {
                            apartment = self.apartment,
                            nextGameState = CasWEnterState()
                        }))
                end
            },
        }
    }
end

function AptWFunMenuState:enter()
end

function AptWFunMenuState:update(dt)
    self.aptMenu:update(dt)
end

function AptWFunMenuState:render()
    self.aptMenu:render()
end
