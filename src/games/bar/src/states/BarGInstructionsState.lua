
BarGInstructionsState = Class{__includes = BaseState}

function BarGInstructionsState:init()
    --self.background = params.background
end

function BarGInstructionsState:enter()
    gStateStack:push(DialogueState(
        'There are lots of customers between Keeks and his beloved beer.\n'..
        'Hit the other customers with Keeks to clear them away, and once all '..
        'customers are gone, Keeks can finally cross over the bar and get his beer!\n'..
        'Use the left and right arrow keys to move Keek\'s bar seat back and forth to bounce '..
        'him back towards the bar',
        -- Callback arg
        function()
            -- Pop off this state and return to the Menu state
            gStateStack:pop()
        end
        )
    )
end

function BarGInstructionsState:update(dt)
    --self.background:update(dt)
end

function BarGInstructionsState:render()
    --self.background:render()
end
