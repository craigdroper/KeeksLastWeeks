
AlleyWStationaryState = Class{__includes = BaseState}

function AlleyWStationaryState:init(params)
    self.player = gGlobalObjs['player']
    self.alley = params.alley
end

function AlleyWStationaryState:enter()
    --[[
    gStateStack:push(DialogueState(
        'Keeks: Mikhail! So good to see you comrade...',
        function()
        end))
        --]]
end

function AlleyWStationaryState:update(dt)
end

function AlleyWStationaryState:render()
    self.alley:render()
    if self.player then
        self.player:render()
    end
end
