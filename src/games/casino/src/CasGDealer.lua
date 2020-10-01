
CasGDealer = Class{}

function CasGDealer:init()
    self.hand = CasGHand(VIRTUAL_WIDTH/2, 60)
end

function CasGDealer:getValue()
    return self.hand:getValue()
end

function CasGDealer:getSoftValue()
    return self.hand:getSoftValue()
end

function CasGDealer:getNextAction()
    -- Rules here for dealer on given values
end
