
AlleyWDrugMenuState = Class{__includes = BaseState}

function AlleyWDrugMenuState:init(params)
    self.alley = params.alley

    self.drugMenu = Menu {
        items = {
            {
                text = 'Coke',
                onSelect =
                function()
                    self.alley.drugName = 'coke'
                    gStateStack:push(FadeInState({r = 255, g = 255, b = 255}, 1,
                        function()
                    -- Pop AlleyWDrugMenuState
                    gStateStack:pop()
                    -- Transition to coke game
                    gStateStack:push(CokeGTitleScreenState())
                    gStateStack:push(FadeOutState({r = 255, g = 255, b = 255}, 1,
                        function()
                        end))
                        end))
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
