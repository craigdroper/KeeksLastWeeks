
WorkGPlayState = Class{__includes = BaseState}

local PADDLE_SPEED = 300

function WorkGPlayState:init(params)
    self.background = params.background
    self.player1 = params.player1
    self.player2 = params.player2
    self.ball = params.ball
    self.background = params.background
end

function WorkGPlayState:update(dt)
    -- detect ball collision with paddles, reversing dx if true and
    -- slightly increasing it, then altering the dy based on the position
    -- at which it collided, then playing a sound effect
    if self.ball:collides(self.player1) then
        self.ball.dx = -self.ball.dx * 1.1
        self.ball.x = self.player1.x + self.player1.width

        -- keep velocity going in the same direction, but randomize it
        if self.ball.dy < 0 then
            self.ball.dy = -math.random(10, 150)
        else
            self.ball.dy = math.random(10, 150)
        end

        gWorkSounds['paddle_hit']:play()
    end
    if self.ball:collides(self.player2) then
        self.ball.dx = -self.ball.dx * 1.1
        self.ball.x = self.player2.x - self.ball.width

        -- keep velocity going in the same direction, but randomize it
        if self.ball.dy < 0 then
            self.ball.dy = -math.random(10, 150)
        else
            self.ball.dy = math.random(10, 150)
        end

        gWorkSounds['paddle_hit']:play()
    end

    -- detect upper and lower screen boundary collision, playing a sound
    -- effect and reversing dy if true
    if self.ball.y <= 0 then
        self.ball.y = 0
        self.ball.dy = -self.ball.dy
        gWorkSounds['wall_hit']:play()
    end

    -- -4 to account for the ball's size
    if self.ball.y >= VIRTUAL_HEIGHT - self.ball.height then
        self.ball.y = VIRTUAL_HEIGHT - self.ball.height
        self.ball.dy = -self.ball.dy
        gWorkSounds['wall_hit']:play()
    end

    -- if we reach the left edge of the screen, go back to serve
    -- and update the score and serving player
    if self.ball.x < 0 then
        self.player2.score = self.player2.score + 1
        gWorkSounds['score']:play()

        -- if we've reached a score of 10, the game is over; set the
        -- state to done so we can show the victory message
        if self.player2.score == 10 then
            -- Game is over, player 2 wins
            gStateStack:pop()
            gStateStack:push(WorkGGameOverState({
                background = self.background,
                player1 = self.player1,
                player2 = self.player2,
                ball = self.ball,
                winningPlayer = 2,
                scoreDelta = self.player2.score - self.player1.score,
                }))
        else
            -- Player 2 has scored, return to serve state with Player 1 serving
            gStateStack:pop()
            gStateStack:push(WorkGServeState({
                background = self.background,
                player1 = self.player1,
                player2 = self.player2,
                ball = self.ball,
                servingPlayer = 1,
                }))
        end
    end

    -- if we reach the right edge of the screen, go back to serve
    -- and update the score and serving player
    if self.ball.x > VIRTUAL_WIDTH then
        self.player1.score = self.player1.score + 1
        gWorkSounds['score']:play()

        -- if we've reached a score of 10, the game is over; set the
        -- state to done so we can show the victory message
        if self.player1.score == 10 then
            -- Game is over, player 1 wins
            gStateStack:pop()
            gStateStack:push(WorkGGameOverState({
                background = self.background,
                player1 = self.player1,
                player2 = self.player2,
                ball = self.ball,
                winningPlayer = 1,
                scoreDelta = self.player1.score - self.player2.score,
                }))
        else
            -- Player 1 has scored, return to serve state with Player 2 serving
            gStateStack:pop()
            gStateStack:push(WorkGServeState({
                background = self.background,
                player1 = self.player1,
                player2 = self.player2,
                ball = self.ball,
                servingPlayer = 2,
                }))
        end
    end

    if love.keyboard.isDown('up') then
        self.player1.dy = -PADDLE_SPEED
    elseif love.keyboard.isDown('down') then
        self.player1.dy = PADDLE_SPEED
    else
        self.player1.dy = 0
    end

    -- player 2
    -- UPDATE: player 2 will be the AI paddle and it will always
    -- "chase" the ball by appropriately changing its direction
    -- depending on where the ball is in relation to itself
    -- To make the AI a little more human, we'll only update the y
    -- position once the ball has crossed the halfway point
    -- To make the AI far (and fun) for a human to play against,
    -- we'll program the AI to occaisionally make random mistakes
    if self.ball.x > VIRTUAL_WIDTH / 2 then
      -- This is a parameter that could be tweaked with some type of
      -- 'difficulty' input variable selected at the beginning of the game
      -- but for now its hardcoded to make a move in the wrong direction ~6% of the time
      potentialMistake = math.random(15) == 1 and -1 or 1
      if self.player2.y > self.ball.y + self.ball.height then
          self.player2.dy = potentialMistake * -PADDLE_SPEED
      elseif self.player2.y + self.player2.height < self.ball.y then
          self.player2.dy = potentialMistake * PADDLE_SPEED
      else
          self.player2.dy = 0
      end
    else
        self.player2.dy = 0
    end

    self.ball:update(dt)
    self.player1:update(dt)
    self.player2:update(dt)
end

function WorkGPlayState:render()
    self.background:render()
    self.player1:render()
    self.player2:render()
    self.ball:render()
end
