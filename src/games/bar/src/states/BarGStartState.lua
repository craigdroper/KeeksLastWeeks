--[[
    For now just a temporary start state that will initialize
    all the necessary objects to begin the first round of the Bar
    mini game, as well as provide the user with the outline of some
    of the basic rules

    This can be (and likely will be) extended to also provide some dialogue
    explaining the basic rules
--]]

BarGStartState = Class{__includes = BaseState}

function BarGStartState:init()
    self.background = BarGBackground()
    self.paddle = BarGPaddle(1)
    self.level = 1
    self.bricks = BarGLevelMaker.createMap(self.level)
    self.ball = BarGBall()
    self.ball.skin = math.random(7)
    self.recoverPoints = 5000
end

function BarGStartState:enter()
    -- Push a dialogue box with some simple instructions
    gStateStack:push(DialogueState(
        '<Instructions for mini game>',
        function()
            -- Once the dialogue state is closed, pop off the start
            -- state and push on a serve state for level 1
            gStateStack:pop()
            gStateStack:push(BarGServeState({
                background = self.background,
                paddle = self.paddle,
                bricks = self.bricks,
                -- health = 3,
                -- XXX Dev test
                health = 1,
                score = 0,
                level = self.level,
                recoverPoints = self.recoverPoints,
                ball = self.ball}))
        end))
end

function BarGStartState:update(dt)
end

function BarGStartState:render()
    self.background:render()
    self.paddle:render()
    self.ball:render()

    for k, brick in pairs(self.bricks) do
        brick:render()
    end
end
