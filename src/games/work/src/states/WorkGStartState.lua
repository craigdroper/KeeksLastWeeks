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
    self.startMenu = Menu {
        items = {
            {
                text = 'Play',
                onSelect =
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
                    end
            },
            {
                text = 'Instructions',
                onSelect =
                    function()
                        gStateStack:push(WorkGInstructionsState())
                    end
            },
        }
    }
end

function WorkGStartState:update(dt)
    self.startMenu:update(dt)
end

function WorkGStartState:render()
    self.background:render()
    self.player1:render()
    self.player2:render()
    self.ball:render()
    self.startMenu:render()
end
