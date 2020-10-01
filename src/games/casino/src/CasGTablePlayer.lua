
CasGTablePlayer = Class{}

function CasGTablePlayer:init()
    self.hand = CasGHand(VIRTUAL_WIDTH/2, VIRTUAL_HEIGHT - 130)
    self.player = gGlobalObjs['player']
    self.curBet = 0
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
