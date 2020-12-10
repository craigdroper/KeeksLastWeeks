
WorkWEnterMeetingState = Class{__includes = BaseState}

function WorkWEnterMeetingState:init(params)
    self.player = gGlobalObjs['player']
    self.office = params.office
end

function WorkWEnterMeetingState:enter()
    gStateStack:push(DialogueState('Coworker: Ayyy Keeks! Looks like I owe '..
        'Bob $100, I did NOT think you were going to make it in today. '..
        'Guessing you re-upped on addy then?\n'..
        'Keeks: Yeah got my new dose, but Starbucks said they could only give '..
        'me 4 venti cold brews at a time, so I\'ll probably only make it '..
        'half the day.\n'..
        'Coworker: In that case, you better hurry up and get your ass to the '..
        'meeting room, Boss is in there, and said he wants to talk to you about '..
        'the last deal you put together...\n'..
        'Keeks: Last deal? Shit I don\'t even remember what that was, everythings '..
        'blurring together...',
            function()
                self:tweenEnter()
            end))
end

function WorkWEnterMeetingState:tweenEnter()
    local APRX_TURN_X = VIRTUAL_WIDTH/2 + 20
    local DESK_Y = VIRTUAL_HEIGHT*2/4 + 25
    local DESK_X = VIRTUAL_WIDTH *3/4 - 45
    local START_HOP_X = DESK_X - 40
    local MID_HOP_X = (DESK_X + START_HOP_X)/2
    local HOP_Y = DESK_Y - 40
    local MEETING_Y = VIRTUAL_HEIGHT/2  - 40
    local APRX_SECOND_TURN_X = APRX_TURN_X + 80


    self.player:changeAnimation('idle-left')
    gSounds['jump']:play()
    Timer.tween(0.2, {
        [self.player] = {x = MID_HOP_X, y = HOP_Y}
    }):finish(
        function()
    Timer.tween(0.2, {
        [self.player] = {x = START_HOP_X, y = DESK_Y}
    }):finish(
        function()
    gSounds['footsteps']:play()
    local walkPixels = self.player.x - APRX_TURN_X
    self.player:changeAnimation('walk-left')
    Timer.tween(self.player:getPixelWalkTime(walkPixels), {
        [self.player] = {x = APRX_TURN_X}
    }):finish(
        function()
    local walkPixels = self.player.y - MEETING_Y
    self.player:changeAnimation('walk-up')
    Timer.tween(self.player:getPixelWalkTime(walkPixels), {
        [self.player] = {y = MEETING_Y, x = APRX_SECOND_TURN_X,
                        scaleY = 1.5, scaleX = 1.5}
    }):finish(
        function()
    local walkPixels = VIRTUAL_WIDTH  - self.player.x
    self.player:changeAnimation('walk-right')
    Timer.tween(self.player:getPixelWalkTime(walkPixels), {
        [self.player] = {x = VIRTUAL_WIDTH + 1}
    }):finish(
        function()
    gStateStack:push(FadeInState({r = 255, g = 255, b = 255}, 1,
        function()
            -- Pop the WEnterMeeting state off
            gStateStack:pop()
            gStateStack:push(WorkWExitMeetingState())
            gStateStack:push(FadeOutState({r = 255, g = 255, b = 255}, 1,
                function()
                end))
        end))
        end)
        end)
        end)
        end)
        end)

end

function WorkWEnterMeetingState:update(dt)
    self.player:update(dt)
end

function WorkWEnterMeetingState:render()
    self.office:render()
    self.player:render()
end
