--[[
    GD50
    Breakout Remake

    -- BarGServeState Class --

    Author: Colton Ogden
    cogden@cs50.harvard.edu

    The state in which we are waiting to serve the ball; here, we are
    basically just moving the paddle left and right with the ball until we
    press Enter, though everything in the actual game now should render in
    preparation for the serve, including our current health and score, as
    well as the level we're on.
]]

BarGServeState = Class{__includes = BaseState}

function BarGServeState:init(params)
    -- grab game state from params
    self.paddle = params.paddle
    self.bricks = params.bricks
    self.health = params.health
    self.score = params.score
    -- self.highScores = params.highScores
    self.level = params.level
    self.recoverPoints = params.recoverPoints

    -- init new ball (random color for fun)
    self.ball = params.ball
    self.ball.skin = params.ball.skin
end

function BarGServeState:update(dt)
    -- have the ball track the player
    self.paddle:update(dt)
    self.ball.x = self.paddle.x + (self.paddle.width / 2) - 4
    self.ball.y = self.paddle.y - 8

    print('Updateing ServeState')

    if love.keyboard.wasPressed('enter') or love.keyboard.wasPressed('return') then
        print('Enter or Return was pressed')
        -- Pop off the current Serve state, and push a new PlayState
        -- with all the important state infor
        gStateStack:pop()
        gStateStack:push(BarGPlayState({
            paddle = self.paddle,
            bricks = self.bricks,
            health = self.health,
            score = self.score,
            -- highScores = self.highScores,
            ball = self.ball,
            level = self.level,
            recoverPoints = self.recoverPoints
        }))
    end

end

function BarGServeState:render()
    self.paddle:render()
    self.ball:render()

    for k, brick in pairs(self.bricks) do
        brick:render()
    end

    --[[ TODO update these global functions in Util.lua for KLW, they
         are stubbed out for now
         --]]
    renderScore(self.score)
    renderHealth(self.health)

    love.graphics.setFont(gFonts['large'])
    love.graphics.printf('Level ' .. tostring(self.level), 0, VIRTUAL_HEIGHT / 3,
        VIRTUAL_WIDTH, 'center')

    love.graphics.setFont(gFonts['medium'])
    love.graphics.printf('Press Enter to serve!', 0, VIRTUAL_HEIGHT / 2,
        VIRTUAL_WIDTH, 'center')
end
