
ClubGCountdownState = Class{__includes = BaseState}

-- takes 1 second to count down each time
COUNTDOWN_TIME = 1.0

function ClubGCountdownState:init(params)
    self.count = 3
    self.timer = 0
    self.background = params.background
    self.targets = params.targets
    self.health = 100
    self.score = params.score
    self.level = params.level
    local songDef = gClubGSongs[math.random(#gClubGSongs)]
    self.song = songDef.song
    self.songBPM = songDef.bpm
    self.song:play()
end

--[[
    Keeps track of how much time has passed and decreases count if the
    timer has exceeded our countdown time. If we have gone down to 0,
    we should transition to our ClubGPlayState.
]]
function ClubGCountdownState:update(dt)
    self.timer = self.timer + dt

    -- loop timer back to 0 (plus however far past COUNTDOWN_TIME we've gone)
    -- and decrement the counter once we've gone past the countdown time
    if self.timer > COUNTDOWN_TIME then
        self.timer = self.timer % COUNTDOWN_TIME
        self.count = self.count - 1

        -- when 0 is reached, we should enter the ClubGPlayState
        if self.count == 0 then
            gStateStack:pop()
            gStateStack:push(ClubGPlayState({
                background = self.background,
                targets = self.targets,
                score = self.score,
                health = self.health,
                level = self.level,
                song = self.song,
                songBPM = self.songBPM,
                }))
        end
    end
end

function ClubGCountdownState:render()
    -- Draw stationary background
    self.background:render()

    ClubGUtils():renderScore(self.score)
    ClubGUtils():renderHealth(self.health)

    -- render count big in the middle of the screen
    love.graphics.setFont(gFonts['huge-flappy-font'])
    love.graphics.printf(tostring(self.count), 0, 120, VIRTUAL_WIDTH, 'center')

    for _, target in pairs(self.targets) do
        target:renderImage()
    end
end
