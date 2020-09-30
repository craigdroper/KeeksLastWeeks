
CasGDealer = Class{}

function CasGDealer:init()
    self.hand = CasGHand(VIRTUAL_WIDTH/2, 50)
end

function CasGDealer:getValue()
    return self.hand:getValue()
end

function CasGDealer:getSoftValue()
    return self.hand:getValue()
end

function CasGDealer:getNextAction()
    -- Rules here for dealer on given values
end
