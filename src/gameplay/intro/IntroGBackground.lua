
IntroGBackground = Class{}

function IntroGBackground:init()
    self.backgroundScrollSpeed = 30
    local sampleImg = gIntroImages['img2']
    self.imgW, self.imgH = sampleImg:getDimensions()
    self.scale = VIRTUAL_HEIGHT / self.imgH
    self.scaledW = self.imgW * self.scale

    self.imgs = {}
    -- Choosing to only include images 2-6 since 1 isn't exclusively keeks
    self.numPics = 5
    for i = 2, 6 do
        local imgDef = {
            img = gIntroImages['img'..i],
            x = (self.scaledW) * (i - 2)
        }
        table.insert(self.imgs, imgDef)
    end

    self.colors = {
        [1] = {217, 87, 99, 255},
        [2] = {95, 205, 228, 255},
        [3] = {251, 242, 54, 255},
        [4] = {118, 66, 138, 255},
        [5] = {153, 229, 80, 255},
        [6] = {223, 113, 38, 255}
    }
    self.currentColor = 1
    self.colorTimer = 0

end

function IntroGBackground:update(dt)
    local scrollOffset = self.backgroundScrollSpeed * dt
    for _, imgDef in pairs(self.imgs) do
        imgDef.x = imgDef.x - scrollOffset
        if imgDef.x < -self.scaledW then
            imgDef.x = imgDef.x + self.scaledW * self.numPics
        end
    end

    self.colorTimer = self.colorTimer + dt
    if self.colorTimer > 1 then
        self.colorTimer = 0
        if self.currentColor ~= #self.colors then
            self.currentColor = self.currentColor + 1
        else
            self.currentColor = 1
        end
    end
end

function IntroGBackground:render()
    for _, imgDef in pairs(self.imgs) do
        love.graphics.filterDrawD(imgDef.img, imgDef.x, 0, 0, self.scale, self.scale)
    end

    love.graphics.setColor(self.colors[self.currentColor])
    love.graphics.setFont(gFonts['huge'])
    love.graphics.printf('KEEKS LAST WEEKS!', 0, 32, VIRTUAL_WIDTH, 'center')
    love.graphics.setColor(255, 255, 255, 255)
end
