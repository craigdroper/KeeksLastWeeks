
DateGLoseState = Class{__includes = BaseState}

function DateGLoseState:init(params)
    self.background = params.background
    self.couple = params.couple
    self.player = params.player
end

function DateGLoseState:enter()
    gStateStack:push(DialogueState('Fiance: Goddamnit Keeks! You just aren\'t '..
            'paying attention, are you? This date is over, I\'m driving home '..
            'and you can walk!',
            function()
                -- 1) DateWStationary
                -- 2) DateGLoseState
                -- Set the DateWStationary gameOver flag
                local dateWStationary = gStateStack:getNPrevState(1)
                dateWStationary.isGameOver = true
                -- Pop this game mini state as part of a fade between scenes
                gStateStack:push(FadeInState({r = 255, g = 255, b = 255}, 1,
                    function()
                    -- Pop DateGLoseState
                    gStateStack:pop()
                    self.player:restoreSnapshot()
                    gStateStack:push(FadeOutState({r = 255, g = 255, b = 255}, 1,
                        function()
                        end))
                    end))
            end))
end

function DateGLoseState:render()
    self.background:render()
    self.couple:render()
end
