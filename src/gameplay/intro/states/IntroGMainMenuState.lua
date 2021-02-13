
IntroGMainMenuState = Class{__includes = BaseState}

function IntroGMainMenuState:init()
    self.player = gGlobalObjs['player']
    self.background = IntroGBackground()
end

function IntroGMainMenuState:enter()
    gIntroSounds['callme']:setLooping(true)
    gIntroSounds['callme']:play()
    self.startMenu = Menu {
        items = {
            {
                text = 'Play',
                onSelect =
                    function()
                    gStateStack:push(FadeInState({r = 255, g = 255, b = 255}, 1,
                        function()
                        -- Pop off IntroGMainMenuState
                        gStateStack:pop()
                    -- Transition to entering the apartment state
                    self.player.displayStats = true
                    gIntroSounds['callme']:stop()
                    gStateStack:push(AptWEnterState())
                    gStateStack:push(FadeOutState({r = 255, g = 255, b = 255}, 1,
                        function()
                        end))
                        end))
                    end
            },
            {
                text = 'Instructions',
                onSelect =
                    function()
                        gStateStack:push(IntroGInstructionsState(
                                {background = self.background}))
                    end
            },
        }
    }
end

function IntroGMainMenuState:update(dt)
    self.background:update(dt)
    self.startMenu:update(dt)
end

function IntroGMainMenuState:render()
    self.background:render()
    self.startMenu:render()
end
