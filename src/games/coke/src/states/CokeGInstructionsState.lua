
CokeGInstructionsState = Class{__includes = BaseState}

function CokeGInstructionsState:init()
end

function CokeGInstructionsState:enter()
    gStateStack:push(DialogueState(
        'Time to hit the slopes hombre!\n'..
        'Tap the space bar to take a bump of that devine Bolivian marching powder, '..
        'and watch your nose pop up on a new high.\n'..
        'Keep those bumps coming at exactly the right levels to keep '..
        'your high at exactly the right level and avoid the obstacles',
        -- Callback arg
        function()
            -- Pop off this state and return to the Menu state
            gStateStack:pop()
        end
        )
    )
end

function CokeGInstructionsState:update(dt)
end

function CokeGInstructionsState:render()
end
