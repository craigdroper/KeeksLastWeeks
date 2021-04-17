
CasWStationaryState = Class{__includes = BaseState}

function CasWStationaryState:init(params)
    self.player = gGlobalObjs['player']
    self.casino = params.casino
    -- The mini game that will be updating the money and fun
    -- stats as we go, hand by hand, so this will only
    -- be a boolean to indicate the mini game is over and the
    -- player should exit
    self.gameOver = false
    self.cashCache = self.player.money
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
        local msg = nil
        if self.player.money > self.cashCache then
            msg = 'Not sure I\'ve ever walked away from a heater like that, but '..
            'it feels amazing to have finally made some money at this place! I\'m '..
            'feeling so good that I\'ll even give you a tip Mr Dealer:\n\n'..
            'Stay in school. Peace bitches!'
        elseif self.player.money < self.cashCache then
            msg = 'Keeks: Really thought today was my day to finally take the house...' ..
            'Oh well, you know I\'ll be back!\nAs for you, you horrible dealer, I\'m '..
            'sure you\'ve heard by now my tipping policy is like my moral character: non-existent.'
        else
            msg = 'Keeks: A scratch day at the table is basically a win for me! Add in some '..
            'free drinks and the chance to curse at another human being just for dealing '..
            'cards as their job, and I\'d say I came out on top.\n'..
            'As for you Mr Dealer, I\'m sure you\'ve heard by now '..
            'my tipping policy is like my moral character:\nnon-existent.'
        end
        gStateStack:push(DialogueState(msg,
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
