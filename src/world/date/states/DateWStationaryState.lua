
DateWStationaryState = Class{__includes = BaseState}

function DateWStationaryState:init(params)
    self.player = gGlobalObjs['player']
    self.rest = params.rest
    self.gameStats = nil
end

function DateWStationaryState:enter()
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
    if self.gameStats then
        gStateStack:push(UpdatePlayerStatsState({player = self.player,
            -- Club mini game will reward its own score that can be dropped right in here
            stats = {time = self.gameStats.score}, callback =
        function()
        gStateStack:push(DialogueState(
            'Keeks: Well, looks like its just you and me tonight Lefty...' ..
        function()
            -- Pop the stationary state, push the exit state
            -- Increase player walk speed like he's running out
            gStateStack:pop()
            gStateStack:push(DateWExitState(
                {rest = self.rest}))
        end))
        end}))
    end
end

function DateWStationaryState:render()
    self.rest:render()
    self.player:render()
end
