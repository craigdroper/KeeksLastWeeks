
AptWInitialMenuState = Class{__includes = BaseState}

function AptWInitialMenuState:init(params)
    self.apartment = params.apartment

    self.aptMenu = Menu {
        items = {
            {
                text = 'Have Fun',
                onSelect = function()
                    -- Pop off AptWInitialMenuState
                    gStateStack:pop()
                    gStateStack:push(AptWFunMenuState({apartment = self.apartment}))
                end
            },
            {
                text = 'Stock Up',
                onSelect = function()
                    -- Pop off AptWInitialMenuState
                    gStateStack:pop()
                    -- Pop off the AptWStationaryState
                    gStateStack:pop()
                    -- Push the Apt Exit state, with the AlleyWEnter state
                    -- as next state
                    gStateStack:push(AptWExitState({
                        apartment = self.apartment,
                        nextGameState = AlleyWEnterState()}))
                end
            },
            {
                text = 'Recover',
                onSelect = function()
                    -- Pop off AptWInitialMenuState
                    gStateStack:pop()
                    -- TODO push AptWRecoverMenuState
                end
            },
        }
    }
end

function AptWInitialMenuState:enter()
end

function AptWInitialMenuState:update(dt)
    self.aptMenu:update(dt)
end

function AptWInitialMenuState:render()
    self.aptMenu:render()
end
