
AptWFunMenuState = Class{__includes = BaseState}

function AptWFunMenuState:init()
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
                    gStateStack:push(AptWLeaveState())
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
