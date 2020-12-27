
DoctorWExitGameState = Class{__includes = BaseState}

function DoctorWExitGameState:init(params)
    self.player = gGlobalObjs['player']
    self.room = DoctorWRoom()
    self.gameStats = params.gameStats
end

function DoctorWExitGameState:enter()
    -- Set the player entity's scale factors to the correct values
    -- for this room's tile sizes
    self.player.scaleX = 1.5
    self.player.scaleY = 1.5
    self.player.opacity = 255
    self.player.walkSpeed = 50
    local BED_TOP_X = VIRTUAL_WIDTH/2 + 60
    local BED_TOP_Y = VIRTUAL_HEIGHT/2 - 10
    self.player.x = BED_TOP_X
    self.player.y = BED_TOP_Y
    gStateStack:push(DialogueState('Good Doctor: How ya feeling bud?\n' ..
        'Keeks: I don\'t know...a little better I guess? Definitely still not '..
        'feeling 100%...\n'..
        'Good Doctor: Yeah, my prognosis is years of your work hard play hard '..
        'lifestyle may require a miracle to get you back to 100%, but at least '..
        'for now we\'ve got you patched up and you can get back out there and do '..
        'what you do best: PARTAAAAAY!\n'..
        'Keeks: Yeah I guess that\'s true. Great! Well thanks dude!\n'..
        'Good Doctor: It\'s not "dude", its Doctor! I didn\'t go to four years '..
        'of medical school to be called dude you little brat. Now get the hell '..
        'out of my office',
    function()
        gStateStack:push(UpdatePlayerStatsState({player = self.player,
            stats = {money = -100, health = 5 * self.gameStats.numVirusDestroyed}, callback =
        function()
            -- Pop off this ExitGame state, and push the ExitRoom State
            gStateStack:pop()
            gStateStack:push(DoctorWExitRoomState(
                {office = self.office, nextGameState = AptWEnterState()}))
        end}))
    end))
end

function DoctorWExitGameState:update(dt)
    self.player:update(dt)
end

function DoctorWExitGameState:render()
    self.room:render()
    self.player:render()
end
