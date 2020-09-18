
AptWFunMenuState = Class{__includes = BaseState}

function AptWFunMenuState:init(params)
    self.apartment = params.apartment

    self.aptMenu = Menu {
        items = {
            {
                text = 'Hit the Bar',
                onSelect = function()
                    -- Pop AptWFunMenuState
                    gStateStack:pop()
                    -- Pop AptSitState
                    gStateStack:pop()
                    -- Transition to leave state
                    gStateStack:push(AptWExitState({apartment = self.apartment}))
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
