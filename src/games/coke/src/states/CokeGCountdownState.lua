--[[
    Countdown State
    Author: Colton Ogden
    cogden@cs50.harvard.edu

    Counts down visually on the screen (3,2,1) so that the player knows the
    game is about to begin. Transitions to the CokeGPlayState as soon as the
    countdown is complete.
]]

CokeGCountdownState = Class{__includes = BaseState}

-- takes 1 second to count down each time
COUNTDOWN_TIME = 0.75

function CokeGCountdownState:init(params)
    self.count = 3
    self.timer = 0
    self.background = params.background
    self.bird = CokeGBird()
end

--[[
    Keeps track of how much time has passed and decreases count if the
    timer has exceeded our countdown time. If we have gone down to 0,
    we should transition to our CokeGPlayState.
]]
function CokeGCountdownState:update(dt)
    self.timer = self.timer + dt

    -- loop timer back to 0 (plus however far past COUNTDOWN_TIME we've gone)
    -- and decrement the counter once we've gone past the countdown time
    if self.timer > COUNTDOWN_TIME then
        self.timer = self.timer % COUNTDOWN_TIME
        self.count = self.count - 1

        -- when 0 is reached, we should enter the CokeGPlayState
        if self.count == 0 then
            gStateStack:pop()
            gStateStack:push(CokeGPlayState({
                background = self.background,
                bird = self.bird}))
        end
    end
end

function CokeGCountdownState:render()
    -- Draw stationary background
    self.background:render()
    self.bird:render()

    -- render count big in the middle of the screen
    love.graphics.setFont(gFonts['huge-flappy-font'])
    love.graphics.setColor(255,0,0,255)
    love.graphics.printf(tostring(self.count), 0, 120, VIRTUAL_WIDTH, 'center')
    love.graphics.setColor(255,255,255,255)

    -- Finally draw stationary ground
    love.graphics.filterDrawD(gCokeGImages['ground'], 0, VIRTUAL_HEIGHT - 16)
end
