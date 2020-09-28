
AlleyWStationaryState = Class{__includes = BaseState}

function AlleyWStationaryState:init(params)
    self.player = gGlobalObjs['player']
    self.alley = params.alley
    -- The mini game that will be pushed on top of this state can
    -- access this data structure to indicate how the player
    -- did in the game
    self.gameStats = nil
end

function AlleyWStationaryState:enter()
    gStateStack:push(DialogueState(
        'Keeks: Mikhail! So good to see you comrade!\n\n' ..
        'Mikhail: Enough talk, what do you desire?',
        function()
            gStateStack:push(AlleyWDrugMenuState({alley = self.alley}))
        end))
end

function AlleyWStationaryState:update(dt)
    if self.gameStats then
        --[[ Do something special here for all drugs if multiplier is 0,
             maybe say "This is Shit!" and then sulk back to the apartment
        --]]
        if self.alley.drugName == 'coke' then
            gGlobalObjs['filter'] = CokeFilter({multiplier = self.gameStats.multiplier})
        else
            error('Unrecognized drug name')
        end

        gStateStack:push(UpdatePlayerStatsState({player = self.player,
            stats = {money = -100, health = -10}, callback =
        function()
        gStateStack:push(DialogueState(
            'Keeks:WOOOOOOOOOO! I am feeling '..self.gameStats.multiplier..' times better!\n'..
            'No way I can go back to my apartment now. Hey Mikhail?\n\n'..
            'Mikhail: Ya?\n\n'..
            'Keeks: How about a lift to some fun?\n\n'..
            'Mikhail: I am not your Uber driver pretty boy. Why don\'t you take '..
            'those fancy loafers out for a spin',

        function()
            -- Pop the stationary state, push the exit state
            gStateStack:pop()
            gStateStack:push(AlleyWExitCarState(
                {alley = self.alley}))
        end))
        end}))
    end
end

function AlleyWStationaryState:render()
    self.alley:render()
    if self.player then
        self.player:render()
    end
end
