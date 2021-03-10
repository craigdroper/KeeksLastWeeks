
WeedGInstructionsState = Class{__includes = BaseState}

function WeedGInstructionsState:init()
end

function WeedGInstructionsState:enter()
        gStateStack:push(DialogueState("" ..
            'Welcome to the wonderful world of Smokey-Mon! Feel free to wander around, but beware: ' ..
            'this isn\'t your typical grass growing in these fields. If you encounter one of our '..
            'Smokey-Mon strains, you\'ll have to try and smoke them down to nothing before they do '..
            'the same to you. Good luck!',
        -- Callback arg
        function()
            -- Pop off this state and return to the Menu state
            gStateStack:pop()
        end
        )
    )
end

function WeedGInstructionsState:update(dt)
end

function WeedGInstructionsState:render()
end
