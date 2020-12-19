--[[
    For now just a temporary start state that will initialize
    all the necessary objects to begin the first round of the Bar
    mini game, as well as provide the user with the outline of some
    of the basic rules

    This can be (and likely will be) extended to also provide some dialogue
    explaining the basic rules
--]]

WorkGStartState = Class{__includes = BaseState}

function WorkGStartState:init()
    self.background = WorkGBackground()
    self.player1 = WorkGPaddle(10, VIRTUAL_HEIGHT/2 - 30,
        'keeks-walk', 'keeks-frames', gKEEKS_IDLE_RIGHT)
    self.player2 = WorkGPaddle(VIRTUAL_WIDTH - 50, VIRTUAL_HEIGHT/2 - 30,
        'sec-rep-walk', 'sec-rep-frames', gCHARACTER_IDLE_LEFT )
    self.ball =  WorkGBall(VIRTUAL_WIDTH / 2 - 2, VIRTUAL_HEIGHT / 2 - 2, 4, 4)
    self.servingPlayer = 1
end

function WorkGStartState:enter()
    -- Push a dialogue box with some simple instructions
    gStateStack:push(DialogueState(
        'SEC: Keeks I presume?\nYour last SPAC filing raised a lot of red flags '..
        'at the commission, seems like there\'s some really shady stuff in here.\n' ..
        'Let\'s go back and forth reviewing your filing, and see if you can '..
        'get anything past me. Let\'s say first to 10?',
        function()
            -- Once the dialogue state is closed, pop off the start
            -- state and push on a play state for level 1
            self.player1.renderScore = true
            self.player2.renderScore = true
            gStateStack:pop()
            gStateStack:push(WorkGServeState({
                background = self.background,
                player1 = self.player1,
                player2 = self.player2,
                ball = self.ball,
                servingPlayer = self.servingPlayer,
                }))
        end))
end

function WorkGStartState:update(dt)
end

function WorkGStartState:render()
    self.background:render()
    self.player1:render()
    self.player2:render()
    self.ball:render()
end
