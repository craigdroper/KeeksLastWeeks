
DoctorWExitGameState = Class{__includes = BaseState}

function DoctorWExitGameState:init(params)
    self.player = gGlobalObjs['player']
    self.room = DoctorWRoom()
    -- self.gameStats = params.gameStats
end

function DoctorWExitGameState:enter()
    gStateStack:push(DialogueState('Good Doctor: How ya feeling bud?\n' ..
        'Keeks: I don\'t know...a little better I guess? Definitely still not '..
        'feeling 100%...\n'..
        'Good Doctor: Yeah, my prognosis is years of your work hard play hard '..
        'lifestyle may require a miracle to get you back to 100%, but at least '..
        'for now we\'ve got you patched up and you can get back out there and do '..
        'what you do best: partaaay!\n'..
        'Keeks: Yeah I guess that\'s true. Great! Well thanks dude!\n'..
        'Good Doctor: It\'s not "dude", its Doctor! I didn\'t go to four years '..
        'of medical school to be called dude you little brat. Now get the hell '..
        'out of my office',
    function()
        gStateStack:push(UpdatePlayerStatsState({player = self.player,
            stats = {money = -100, health = 0}, callback =
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
