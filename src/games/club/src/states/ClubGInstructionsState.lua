
ClubGInstructionsState = Class{__includes = BaseState}

function ClubGInstructionsState:init()
end

function ClubGInstructionsState:enter()
    gStateStack:push(DialogueState(
        'Think your classic Keeks head-nod, finger-wag dance is enough to keep you back stage?\n'..
        'Hit the arrow keys when their matching arrows get to the corresponding outlines at '..
        'the top of the screen.\n'..
        'You only get so many missteps before the bouncers kick you out of the booth for getting too sloppy.',
        -- Callback arg
        function()
            -- Pop off this state and return to the Menu state
            gStateStack:pop()
        end
        )
    )
end

function ClubGInstructionsState:update(dt)
end

function ClubGInstructionsState:render()
end
