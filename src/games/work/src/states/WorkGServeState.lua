
WorkGServeState = Class{__includes = BaseState}

function WorkGServeState:init(params)
    self.background = params.background
    self.player1 = params.player1
    self.player2 = params.player2
    self.ball = params.ball
    -- places the ball in the middle of the screen, no velocity
    self.ball:reset()
    self.servingPlayer = params.servingPlayer
end

function WorkGServeState:update(dt)
    self.ball.dy = math.random(-50, 50)
    if self.servingPlayer == 1 then
        self.ball.dx = math.random(140, 200)
    else
        self.ball.dx = -math.random(140, 200)
    end
    if love.keyboard.wasPressed('enter') or love.keyboard.wasPressed('return') then
        -- Once the enter key is pressed pop off serve and push play
        gStateStack:pop()
        gStateStack:push(WorkGPlayState({
            background = self.background,
            player1 = self.player1,
            player2 = self.player2,
            ball = self.ball,
            servingPlayer = self.servingPlayer,
            }))
    end
end

function WorkGServeState:render()
    self.background:render()
    self.player1:render()
    self.player2:render()
    self.ball:render()
    -- UI messages
    love.graphics.setFont(gFonts['small'])
    love.graphics.printf('Player ' .. tostring(self.servingPlayer) .. "'s serve!", 
        0, 10, VIRTUAL_WIDTH, 'center')
    love.graphics.printf('Press Enter to serve!', 0, 20, VIRTUAL_WIDTH, 'center')
end
