
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
        'Keeks: Chicago Breakfast Club! It\'s been a minute. Not like the ironic '..
        'expresion, I think its literally been a minute. Whats on the drug menu today?\n\n' ..
        'Chicago Breakfast Club: You tell me Keeks, what do you desire?',
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
        elseif self.alley.drugName == 'acid' then
            gGlobalObjs['filter'] = AcidFilter({multiplier = self.gameStats.multiplier})
        elseif self.alley.drugName == 'weed' then
            gGlobalObjs['filter'] = WeedFilter({multiplier = self.gameStats.multiplier})
        else
            error('Unrecognized drug name')
        end

        gStateStack:push(UpdatePlayerStatsState({player = self.player,
            stats = {money = -100, health = -10}, callback =
        function()
        gStateStack:push(DialogueState(
            'Keeks: WOW! I am feeling '..self.gameStats.multiplier..' times better!\n'..
            'No way I can go back to my apartment now. Hey buddy?\n\n'..
            'Chicago Breakfast Club: What?\n\n'..
            'Keeks: How about a lift to some fun?\n\n'..
            'Chicago Breakfast Club: I am not your Uber driver pretty boy. Why don\'t you take '..
            'those fancy loafers out for a spin?',

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
