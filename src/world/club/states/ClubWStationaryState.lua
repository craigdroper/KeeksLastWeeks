
ClubWStationaryState = Class{__includes = BaseState}

function ClubWStationaryState:init(params)
    self.player = gGlobalObjs['player']
    self.club = params.club
    -- The mini game that will be pushed on top of this state can
    -- access this data structure to indicate how the player
    -- did in the game
    self.gameStats = nil
end

function ClubWStationaryState:enter()
    gStateStack:push(DialogueState(
        'Keeks: Hey, DJ BJ! Mind if you get me backstage?\n'..
        'DJ BJ: I have no idea who you are\n'..
        'Keeks: C\'mon, I\'ve been coming to your sets for years!\n'..
        'DJ BJ: Well if that\'s true, you shouldn\'t have any trouble proving to '..
        'me you can cut a rug...',
        function()
            gClubSounds['background']:stop()
            -- TODO with ClubGStartState() gStateStack:push(BarGStartState())
            self.gameStats = {score = 100}
        end))
end

function ClubWStationaryState:update(dt)
    if self.gameStats then
        gClubSounds['background']:play()
        gStateStack:push(UpdatePlayerStatsState({player = self.player,
            -- Club mini game will reward its own score that can be dropped right in here
            stats = {fun = self.gameStats.score, money = -100}, callback =
        function()
        gStateStack:push(DialogueState(
            'DJ BJ: Not bad, but you seem like more of a top 50 guy, so ' ..
            'no way I\'m going to let you back here. Security! Get this guy '..
            'out of here!',
        function()
            -- Pop the stationary state, push the exit state
            -- Increase player walk speed like he's running out
            self.player.walkSpeed = 200
            gStateStack:pop()
            gStateStack:push(ClubWExitState(
                {club = self.club, nextState = AptWEnterState()}))
        end))
        end}))
    end
end

function ClubWStationaryState:render()
    self.club:renderBase()
    if self.player then
        self.player:render()
    end
    self.club:renderEffects()
end
