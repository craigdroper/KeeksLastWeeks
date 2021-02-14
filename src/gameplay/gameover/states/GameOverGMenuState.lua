
GameOverGMenuState = Class{__includes = BaseState}

function GameOverGMenuState:init()
end

function GameOverGMenuState:enter()
    self.menu = Menu {
        items = {
            {
                text = 'Play Again',
                onSelect =
                    function()
                    gStateStack:push(FadeInState({r = 255, g = 255, b = 255}, 1,
                        function()
                        -- Pop off GameOverGMenuState
                        gStateStack:pop()
                        -- Pop off GameOverGTitleState
                        gStateStack:pop()
                    -- Transition to entering the apartment state
                    gGameOverSounds['wedding']:stop()
                    gGlobalObjs['player'] = createPlayer()
                    gStateStack:push(AptWEnterState())
                    gStateStack:push(FadeOutState({r = 255, g = 255, b = 255}, 1,
                        function()
                        end))
                        end))
                    end
            },
            {
                text = 'Quit',
                onSelect =
                    function()
                        love.event.quit()
                    end
            },
        }
    }
end

function GameOverGMenuState:update(dt)
    self.menu:update(dt)
end

function GameOverGMenuState:render()
    self.menu:render()
end
