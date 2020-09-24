
AlleyWDrugMenuState = Class{__includes = BaseState}

function AlleyWDrugMenuState:init(params)
    self.alley = params.alley

    self.drugMenu = Menu {
        items = {
            {
                text = 'Coke',
                onSelect = function()
                    -- Pop AlleyWDrugMenuState
                    gStateStack:pop()
                    -- Transition to coke game
                    gStateStack:push(CokeGTitleScreenState())
                end
            },
        }
    }
end

function AlleyWDrugMenuState:enter()
end

function AlleyWDrugMenuState:update(dt)
    self.drugMenu:update(dt)
end

function AlleyWDrugMenuState:render()
    self.drugMenu:render()
end
