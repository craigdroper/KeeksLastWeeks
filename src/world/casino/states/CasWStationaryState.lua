
CasWStationaryState = Class{__includes = BaseState}

function CasWStationaryState:init(params)
    self.player = gGlobalObjs['player']
    self.casino = params.casino
    -- The mini game that will be updating the money and fun
    -- stats as we go, hand by hand, so this will only
    -- be a boolean to indicate the mini game is over and the
    -- player should exit
    self.gameOver = false
end

function CasWStationaryState:enter()
    gStateStack:push(DialogueState(
        'Keeks: Dealer, I got a stack burning a hole in my pocket, '..
        'shuffle \'em up!',
        function()
    gStateStack:push(FadeInState({r = 255, g = 255, b = 255}, 1,
        function()
            -- Keep the Stationary State on, and put the mini game
            -- on top of it
            gCasSounds['background']:stop()
            gStateStack:push(CasGStartState())
            gStateStack:push(FadeOutState({r = 255, g = 255, b = 255}, 1,
                function()
                end))
        end))
        end))
end

function CasWStationaryState:update(dt)
    if self.gameOver then
        gCasSounds['background']:play()
        gStateStack:push(DialogueState(
            'Keeks: Really thought today was my day to finally take the house...' ..
            'Oh well, you know I\'ll be back!',
        function()
            -- Pop the stationary state, push the exit state
            -- Increase player walk speed like he's running out
            gStateStack:pop()
            gStateStack:push(CasWExitState(
                {casino = self.casino, nextState = AptWEnterState()}))
        end))
    end
end

function CasWStationaryState:render()
    self.casino:render()
    self.player:render()
end
