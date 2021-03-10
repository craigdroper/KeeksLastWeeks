
WorkGInstructionsState = Class{__includes = BaseState}

function WorkGInstructionsState:init()
end

function WorkGInstructionsState:enter()
    gStateStack:push(DialogueState(
        'The SEC has flagged a lot of your latest SPAC deals!\n'..
        'Having them poke around your financials is big trouble, but maybe you can '..
        'throw them off the scent.\n'..
        'Try and get 10 of your reports passed the SEC representative before he gets '..
        '10 passed you using the up and down arrow keys to block the reports from getting through.',
        -- Callback arg
        function()
            -- Pop off this state and return to the Menu state
            gStateStack:pop()
        end
        )
    )
end

function WorkGInstructionsState:update(dt)
end

function WorkGInstructionsState:render()
end
