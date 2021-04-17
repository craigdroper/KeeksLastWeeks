
DocGInstructionsState = Class{__includes = BaseState}

function DocGInstructionsState:init()
end

function DocGInstructionsState:enter()
    gStateStack:push(DialogueState(
        'Looks like your brain could use a little self care!\n'..
        'Use the mouse to click and drag the pills back to fire them at your brain. '..
        'Keep in mind, every virus you kill will give you some health back, even '..
        'if you don\'t kill them all (not that you ever could with the state of Keeks brain...',
        -- Callback arg
        function()
            -- Pop off this state and return to the Menu state
            gStateStack:pop()
        end
        )
    )
end

function DocGInstructionsState:update(dt)
end

function DocGInstructionsState:render()
end
