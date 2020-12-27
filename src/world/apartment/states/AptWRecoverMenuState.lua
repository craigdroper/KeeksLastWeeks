
AptWRecoverMenuState = Class{__includes = BaseState}

function AptWRecoverMenuState:init(params)
    self.apartment = params.apartment

    self.aptMenu = Menu {
        items = {
            {
                text = 'Go on Date',
                onSelect = function()
                    -- Pop AptWRecoverMenuState
                    gStateStack:pop()
                    -- Pop AptStationaryState
                    gStateStack:pop()
                    -- Transition to leave state
                    gStateStack:push(AptWExitState(
                        {
                            apartment = self.apartment,
                            nextGameState = DateWEnterLobbyState()
                        }))
                end
            },
            {
                text = 'Go to Work',
                onSelect = function()
                    -- Pop AptWRecoverMenuState
                    gStateStack:pop()
                    -- Pop AptStationaryState
                    gStateStack:pop()
                    -- Transition to leave state
                    gStateStack:push(AptWExitState(
                        {
                            apartment = self.apartment,
                            nextGameState = WorkWEnterOfficeState()
                        }))
                end
            },
            {
                text = 'Visit the Doctor',
                onSelect = function()
                    -- Pop AptWRecoverMenuState
                    gStateStack:pop()
                    -- Pop AptStationaryState
                    gStateStack:pop()
                    -- Transition to leave state
                    gStateStack:push(AptWExitState(
                        {
                            apartment = self.apartment,
                            nextGameState = DoctorWEnterRoomState()
                        }))
                end
            },
        }
    }
end

function AptWRecoverMenuState:enter()
end

function AptWRecoverMenuState:update(dt)
    self.aptMenu:update(dt)
end

function AptWRecoverMenuState:render()
    self.aptMenu:render()
end
