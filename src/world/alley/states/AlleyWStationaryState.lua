
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
        gBarWSounds['exterior']:setLooping(true)
        gBarWSounds['exterior']:play()
        local moneyDelta = nil
        local healthDelta = -5 * self.gameStats.multiplier
        if self.alley.drugName == 'coke' then
            if self.gameStats.multiplier > 0 then
                gGlobalObjs['filter'] = CokeFilter({multiplier = self.gameStats.multiplier})
            else
                healthDelta = -20
            end
            moneyDelta = -100
        elseif self.alley.drugName == 'acid' then
            if self.gameStats.multiplier > 0 then
                gGlobalObjs['filter'] = AcidFilter({multiplier = self.gameStats.multiplier})
            else
                healthDelta = -20
            end
            moneyDelta = -100
        elseif self.alley.drugName == 'weed' then
            if self.gameStats.multiplier > 0 then
                gGlobalObjs['filter'] = WeedFilter({multiplier = self.gameStats.multiplier})
            else
                healthDelta = -20
            end
            moneyDelta = -60
        else
            error('Unrecognized drug name')
        end

        gStateStack:push(UpdatePlayerStatsState({player = self.player,
            stats = {money = moneyDelta, health = healthDelta}, callback =
        function()
        if self.gameStats.multiplier ~= 0 then
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
        else
            gStateStack:push(DialogueState(
                'Keeks: Shit, I don\'t feel anything at all, you sold me some synthetic garbage poison!\n'..
                'I wish I could say I\'ll never buy from you again but you know I\'ll text you '..
                'to roll the dice in a couple days.\n'..
                'For now I feel so sober and sad that I don\'t even '..
                'want to go out. I guess I\'ll just head back to my apartment and sulk around...',
            function()
                -- Pop the stationary state, push the exit state
                gStateStack:pop()
                gStateStack:push(AlleyWExitHomeState(
                    {alley = self.alley}))
            end))
        end
        end}))
    end
end

function AlleyWStationaryState:render()
    self.alley:render()
    if self.player then
        self.player:render()
    end
end
