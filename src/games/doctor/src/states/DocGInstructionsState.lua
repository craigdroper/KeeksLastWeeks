
DocGInstructionsState = Class{__includes = BaseState}

function DocGInstructionsState:init()
end

function DocGInstructionsState:enter()
    gStateStack:push(DialogueState(
        'Looks like your brain could use a little self care!\n'..
        'Use the mouse to click and drag the pills back to fire them at your brain. '..
        'You want to destroy as many as the viruses as you can with the pills you\'ve been prescribed '..
        'in order to gain back the most health.',
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
