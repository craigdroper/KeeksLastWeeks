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
    self.bricks = BarGLevelMaker.createMap(self.level, self.background)
end

function BarGStartState:enter()
    self.startMenu = Menu {
        items = {
            {
                text = 'Play',
                onSelect =
                    function()
                        -- Pop off BarGStartState
                        gStateStack:pop()
                        -- Transition to entering the apartment state
                        gStateStack:push(BarGServeState({
                            background = self.background,
                            paddle = self.paddle,
                            bricks = self.bricks,
                            -- health = 3,
                            -- XXX Dev test
                            health = 1,
                            score = 0,
                            level = self.level,
                            -- recoverPoints = self.recoverPoints,
                            }))
                    end
            },
            {
                text = 'Instructions',
                onSelect =
                    function()
                        gStateStack:push(BarGInstructionsState())
                    end
            },
        }
    }
end

function BarGStartState:update(dt)
    self.startMenu:update(dt)
end

function BarGStartState:render()
    self.background:render()
    self.paddle:render()

    for k, brick in pairs(self.bricks) do
        brick:render()
    end
    self.startMenu:render()
end
