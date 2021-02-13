
IntroGInstructionsState = Class{__includes = BaseState}

function IntroGInstructionsState:init(params)
    self.background = params.background
end

function IntroGInstructionsState:enter()
    gStateStack:push(DialogueState(
        'Keeks is getting married! He only has these last few weeks of freedom to '..
        'do what Keeks does best: HAVE FUN!\n'..
        'Enjoy some of Keeks all time favorite activities from drinking, partying, drugs, and more drinking, all while racking up the highest FUN score possible!\n'..
        'But beware, all this fun comes at a cost. If Keek\'s TIME, HEALTH, or MONEY '..
        'drop to 0, the fun is over, and its time for our favorite bachelor to start his married life.',
        -- Callback arg
        function()
            -- Pop off this state and return to the Menu state
            gStateStack:pop()
        end,
        nil, nil, nil, nil,
        -- UpdateFunc arg
        function(dt)
            self.background:update(dt)
        end
        )
    )
end

function IntroGInstructionsState:update(dt)
    self.background:update(dt)
end

function IntroGInstructionsState:render()
    self.background:render()
end
