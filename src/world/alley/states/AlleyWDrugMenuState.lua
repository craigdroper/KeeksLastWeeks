
AlleyWDrugMenuState = Class{__includes = BaseState}

function AlleyWDrugMenuState:init(params)
    self.alley = params.alley

    self.drugMenu = Menu {
        items = {
            {
                text = 'Weed',
                onSelect =
                function()
                    gBarWSounds['exterior']:stop()
                    self.alley.drugName = 'weed'
                    gStateStack:push(FadeInState({r = 255, g = 255, b = 255}, 1,
                        function()
                    -- Pop AlleyWDrugMenuState
                    gStateStack:pop()
                    -- Transition to weed game
                    gStateStack:push(WeedGStartState())
                    gStateStack:push(FadeOutState({r = 255, g = 255, b = 255}, 1,
                        function()
                        end))
                        end))
                end
            },
            {
                text = 'Acid',
                onSelect =
                function()
                    gBarWSounds['exterior']:stop()
                    self.alley.drugName = 'acid'
                    gStateStack:push(FadeInState({r = 255, g = 255, b = 255}, 1,
                        function()
                    -- Pop AlleyWDrugMenuState
                    gStateStack:pop()
                    -- Transition to acid game
                    gStateStack:push(AcidGStartState())
                    gStateStack:push(FadeOutState({r = 255, g = 255, b = 255}, 1,
                        function()
                        end))
                        end))
                end
            },
            {
                text = 'Coke',
                onSelect =
                function()
                    gBarWSounds['exterior']:stop()
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
