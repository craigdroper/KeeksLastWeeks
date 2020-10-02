
DateGCouple = Class{}

function DateGCouple:init(player)
    self.player = player
    self.player.x = VIRTUAL_WIDTH/2 + 45
    self.player.y = VIRTUAL_HEIGHT/2 + 10
    self.player.scaleX = 1.25
    self.player.scaleY = 1.25
    self.player:changeAnimation('idle-down')
    -- Display only the bottom half of the quad, as if the table he's sitting
    -- at is blocking us from seeing his legs
    self.player:setSubQuadShifts(0, 0, 0, -self.player.offsetY)

    -- self.fiance
end

function DateGCouple:render()
    self.player:render()
end
