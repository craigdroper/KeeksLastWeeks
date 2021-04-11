
CasGInstructionsState = Class{__includes = BaseState}

function CasGInstructionsState:init()
end

function CasGInstructionsState:enter()
    gStateStack:push(DialogueState(
        'This is a standard blackjack table with standard blackjack rules.\n'..
        'You are playing one on one against the dealer, each attempting to get as close to 21 '..
        'as possible without going over.\n'..
        'Ties go to the dealer, and the dealer must hit on 16 or less and stay on 17 or more.\n'..
        'This table supports a minimal number of actions. Before each hand, input how much of your '..
        'money you want to bet. After the cards are dealt, you will have the option to hit or stay. '..
        'Once your turn is complete, the dealer will play out its hand and a winner will be determined.\n'..
        'There is no splitting at this table, but insurance is offered.',
        -- Callback arg
        function()
            -- Pop off this state and return to the Menu state
            gStateStack:pop()
        end
        )
    )
end

function CasGInstructionsState:update(dt)
end

function CasGInstructionsState:render()
end
