
WorkGGameOverState = Class{__includes = BaseState}

function WorkGGameOverState:init(params)
    self.background = params.background
    self.player1 = params.player1
    self.player2 = params.player2
    self.ball = params.ball
    -- places the ball in the middle of the screen, no velocity
    self.ball:reset()
    self.winningPlayer = params.winningPlayer
    self.scoreDelta = params.scoreDelta
end

function WorkGGameOverState:update(dt)
    -- Push a dialogue box depending on the result
    gameStats = {}
    local dialogue
    if self.winningPlayer == 1 then
        gameStats['score'] = scoreDelta
        dialogue = 'SEC: Well, I guess everything checks out after all and the deal '..
            'can proceed. I bet your company will be giving you a nice bonus for this.\n'..
            'Until next time Keeks.'
    else
        gameStats['score'] = 0
        dialogue = 'SEC: You thought you could get this shit passed us? We\'re '..
        'slapping your company with a huge fine, and I\'ll bet that means no '..
        'bonus for Keeks for a very long time'
    end
    gStateStack:push(DialogueState(dialogue,
        function()
            -- Once the dialogue state is closed, pop off the gameover
            -- state and fade into exiting the meeting
    gStateStack:push(FadeInState({r = 255, g = 255, b = 255}, 1,
        function()
            -- Pop the GameOver state off
            gStateStack:pop()
            gStateStack:push(WorkWExitMeetingState({gameStats = gameStats}))
            gStateStack:push(FadeOutState({r = 255, g = 255, b = 255}, 1,
                function()
                end))
        end))
        end))
end

function WorkGGameOverState:render()
    self.background:render()
    self.player1:render()
    self.player2:render()
    self.ball:render()
end
