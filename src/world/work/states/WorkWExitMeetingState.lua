
WorkWExitMeetingState = Class{__includes = BaseState}

function WorkWExitMeetingState:init(params)
    self.player = gGlobalObjs['player']
    self.office = WorkWOffice()
    self.gameStats = params.gameStats
end

function WorkWExitMeetingState:enter()
    -- Set the player entity's scale factors to the correct values
    -- for this room's tile sizes
    self.player.scaleX = 1.5
    self.player.scaleY = 1.5
    self.player.opacity = 255
    self.player.walkSpeed = 50
    self.player.x = VIRTUAL_WIDTH
    local MEETING_Y = VIRTUAL_HEIGHT/2  - 40
    self.player.y = MEETING_Y
    -- Setup tween entrance
    self:tweenEnter()
    -- Begin playing the casino background music
    -- TODO change to office noises
    gDateSounds['background']:setLooping(true)
    gDateSounds['background']:play()
end

function WorkWExitMeetingState:tweenEnter()
    local APRX_TURN_X = VIRTUAL_WIDTH/2 + 20
    local DESK_Y = VIRTUAL_HEIGHT*2/4 + 25
    local DESK_X = VIRTUAL_WIDTH *3/4 - 45
    local START_HOP_X = DESK_X - 40
    local MID_HOP_X = (DESK_X + START_HOP_X)/2
    local HOP_Y = DESK_Y - 40
    local MEETING_Y = VIRTUAL_HEIGHT/2  - 40
    local ANNOUNCEMENT_X = APRX_TURN_X + 25
    local ANNOUNCEMENT_Y = MEETING_Y + 20 

    gSounds['door']:play()
    local doorDuration = gSounds['door']:getDuration()

    Timer.after(doorDuration,
        function()
    gSounds['footsteps']:setLooping(true)
    gSounds['footsteps']:play()

    local walkPixels = self.player.x - ANNOUNCEMENT_X
    self.player:changeAnimation('walk-left')
    Timer.tween(self.player:getPixelWalkTime(walkPixels), {
        [self.player] = {x = ANNOUNCEMENT_X, y = ANNOUNCEMENT_Y}
    }):finish(
        function()
    gSounds['footsteps']:stop()
    self.player:changeAnimation('idle-down')
    gStateStack:push(UpdatePlayerStatsState({player = self.player,
        stats = {money = 100}, callback =
        function()
        gStateStack:push(DialogueState(
            'Keeks: Well that\'s probably the day for me. Happy hour anyone?\n\n'..
            'Just kidding, I drink alone...',
        function()
        -- Pop off this ExitMeeting state, and push the ExitDesk State
        gStateStack:pop()
        gStateStack:push(WorkWExitOfficeState(
            {office = self.office, nextGameState = AptWEnterState()}))
        end))
        end}))
        end)
        end)
end

function WorkWExitMeetingState:update(dt)
    self.player:update(dt)
end

function WorkWExitMeetingState:render()
    self.office:render()
    self.player:render()
end
