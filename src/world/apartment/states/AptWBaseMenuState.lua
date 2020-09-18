
AptWBaseMenuState = Class{__includes = BaseState}

function AptWBaseMenuState:init()
    print('Constructing AptWBaseState')
    self.aptMenu = Menu {
        items = {
            {
                text = 'Have Fun',
                onSelect = function()
                    -- Pop off AptWBaseMenuState
                    gStateStack:pop()
                    -- TODO push AptWFunMenuState
                end
            },
            {
                text = 'Stock Up',
                onSelect = function()
                    -- Pop off AptWBaseMenuState
                    gStateStack:pop()
                    -- TODO pop AptSit State then
                    -- push Leave Apartment to Drug Alley or Car
                end
            },
            {
                text = 'Recover',
                onSelect = function()
                    -- Pop off AptWBaseMenuState
                    gStateStack:pop()
                    -- TODO push AptWRecoverMenuState
                end
            },
        }
    }
end

function AptWBaseMenuState:enter()
end

function AptWBaseMenuState:update(dt)
    self.aptMenu:update(dt)
end

function AptWBaseMenuState:render()
    self.aptMenu:render()
end
