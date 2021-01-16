--[[
    GD50
    Pokemon

    Author: Colton Ogden
    cogden@cs50.harvard.edu
]]

WeedGBattleSprite = Class{}

function WeedGBattleSprite:init(texture, x, is_player)
    self.texture = texture
    self.is_player = is_player
    self.x = x
    self.opacity = 255
    self.blinking = false
    local imgH = nil
    local imgW = nil
    local targetHeight = nil
    if not self.is_player then
        targetHeight = 150
        imgW, imgH = gWeedGTextures[self.texture]:getDimensions()
    else
        targetHeight = 100
        imgH = gFramesInfo['keeks-frames'][gKEEKS_IDLE_RIGHT]['height']
        imgW = gFramesInfo['keeks-frames'][gKEEKS_IDLE_RIGHT]['width']
    end
    self.scale = targetHeight / imgH
    self.width = imgW * self.scale
    self.height = imgH * self.scale
    local vertOffest = 50
    if not self.is_player then
        self.y = vertOffest
    else
        -- Panel Height is 64
        self.y = VIRTUAL_HEIGHT - 80 - vertOffest - self.height
    end

    -- https://love2d.org/forums/viewtopic.php?t=79617
    -- white shader that will turn a sprite completely white when used; allows us
    -- to brightly blink the sprite when it's acting
    self.whiteShader = love.graphics.newShader[[
        extern float WhiteFactor;

        vec4 effect(vec4 vcolor, Image tex, vec2 texcoord, vec2 pixcoord)
        {
            vec4 outputcolor = Texel(tex, texcoord) * vcolor;
            outputcolor.rgb += vec3(WhiteFactor);
            return outputcolor;
        }
    ]]
end

function WeedGBattleSprite:update(dt)

end

function WeedGBattleSprite:render()
    love.graphics.setColor(255, 255, 255, self.opacity)

    -- if blinking is set to true, we'll send 1 to the white shader, which will
    -- convert every pixel of the sprite to pure white
    love.graphics.setShader(self.whiteShader)
    self.whiteShader:send('WhiteFactor', self.blinking and 1 or 0)

    if not self.is_player then
        love.graphics.draw(gWeedGTextures[self.texture], self.x, self.y, 0, self.scale, self.scale)
    else
        love.graphics.draw(
            gTextures['keeks-walk'],
            gFrames['keeks-frames'][gKEEKS_IDLE_RIGHT],
            self.x,
            self.y, 0, self.scale, self.scale)
    end

    -- reset shader
    love.graphics.setShader()
end
