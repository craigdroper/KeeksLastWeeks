
DateGCouple = Class{}

function DateGCouple:init()
    local IDLE_DOWN = 1
    self.keeksTexture = gTextures['keeks-walk']
    self.keeksFullQuad = gFrames['keeks-walk'][IDLE_DOWN]
    local x, y, w, h = self.keeksFullQuad:getViewport()
    local APRX_SPRITE_HALF_HEIGHT = 58
    self.keeksHalfQuad = love.graphics.newQuad(
        x, y, w, APRX_SPRITE_HALF_HEIGHT, self.keeksTexture:getDimensions())
    self.keeksX = VIRTUAL_WIDTH/2 + 12
    self.keeksY = VIRTUAL_HEIGHT/2 - 12

    -- self.fiance

    -- Both of these sprites are the same dimensions, so can share scaling factors
    self.genSX = 1.25
    self.genSY = 1.25
end

function DateGCouple:render()
    love.graphics.filterDrawQ(self.keeksTexture, self.keeksHalfQuad,
        self.keeksX, self.keeksY, 0, self.genSX, self.genSY)
    -- TODO draw fiance
end
