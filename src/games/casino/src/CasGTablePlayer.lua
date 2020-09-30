
CasGTablePlayer = Class{}

function CasGTablePlayer:init()
    self.hand = CasGHand(VIRTUAL_WIDTH/2, VIRTUAL_HEIGHT - 50)
    self.player = gGlobalObjs['player']
end

function CasGTablePlayer:getValue()
    return self.hand:getValue()
end

function CasGTablePlayer:getSoftValue()
    return self.hand:getValue()
end

function CasGTablePlayer:getNextAction()
    -- Some user input
end
