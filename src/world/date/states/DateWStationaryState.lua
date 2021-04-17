
DateWStationaryState = Class{__includes = BaseState}

function DateWStationaryState:init(params)
    self.player = gGlobalObjs['player']
    self.rest = params.rest
    self.isGameOver = false
end

function DateWStationaryState:enter()
    gSounds['footsteps']:stop()
    gStateStack:push(DialogueState(
        'Keeks: Hey baby...Hope you haven\'t been waiting too long...',
        function()
    gStateStack:push(FadeInState({r = 255, g = 255, b = 255}, 1,
        function()
            -- Keep the Stationary State on, and put the mini game
            -- on top of it
            gStateStack:push(DateGStartState())
            gStateStack:push(FadeOutState({r = 255, g = 255, b = 255}, 1,
                function()
                end))
        end))
        end))
end

function DateWStationaryState:update(dt)
    if self.isGameOver then
        gStateStack:push(DialogueState(
            'Keeks: Well, looks like its just you and me tonight Righty...',
        function()
            -- Pop the stationary state, push the exit state
            -- Increase player walk speed like he's running out
            gStateStack:pop()
            gStateStack:push(DateWExitState(
                {rest = self.rest}))
        end))
    end
end

function DateWStationaryState:render()
    self.rest:render()
    self.player:render()
end
