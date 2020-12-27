--[[
    GD50
    Angry Birds

    Author: Colton Ogden
    cogden@cs50.harvard.edu
]]

BACKGROUND_TYPES = {
    'colored-land', 'blue-desert', 'blue-grass', 'blue-land', 
    'blue-shroom', 'colored-desert', 'colored-grass', 'colored-shroom'
}

DocGBackground = Class{}

function DocGBackground:init()
    self.bkgrd = gDoctorImages['brainscan']
    self.bkgrdX = 0
    self.bkgrdY = 0
    self.bkgrdW, self.bkgrdH = self.bkgrd:getDimensions()
    self.bkgrdSX = VIRTUAL_WIDTH / self.bkgrdW
    self.bkgrdSY = VIRTUAL_HEIGHT  / self.bkgrdH
    self.xOffset = 0
end

function DocGBackground:update(dt)
    --[[
    if love.keyboard.isDown('left') then
        self.xOffset = self.xOffset + DOCG_BACKGROUND_SCROLL_X_SPEED * dt
    elseif love.keyboard.isDown('right') then
        self.xOffset = self.xOffset - DOCG_BACKGROUND_SCROLL_X_SPEED * dt
    end

    self.xOffset = self.xOffset % self.width
    --]]
end

function DocGBackground:render()
    --[[
    love.graphics.draw(gDocGTextures[self.background], self.xOffset, -128)
    love.graphics.draw(gDocGTextures[self.background], self.xOffset + self.width, -128)
    love.graphics.draw(gDocGTextures[self.background], self.xOffset - self.width, -128)
    --]]
    love.graphics.filterDrawD(self.bkgrd, self.bkgrdX, self.bkgrdY, 0,
        self.bkgrdSX, self.bkgrdSY)
end
