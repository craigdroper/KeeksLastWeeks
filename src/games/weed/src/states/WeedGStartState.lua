--[[
    GD50
    Pokemon

    Author: Colton Ogden
    cogden@cs50.harvard.edu
]]

WeedGStartState = Class{__includes = BaseState}

function WeedGStartState:init()
    gWeedGSounds['marley']:setLooping(true)
    gWeedGSounds['marley']:play()

    self.sprite = POKEMON_DEFS[POKEMON_IDS[math.random(#POKEMON_IDS)]].battleSpriteFront
    local swidth, sheight = gWeedGTextures[self.sprite]:getDimensions()
    local targHeight = 150
    self.scale = targHeight / sheight
    self.spriteX = VIRTUAL_WIDTH/2 - (swidth * self.scale)/2
    self.spriteY = VIRTUAL_HEIGHT/2 - (sheight * self.scale)/2

    self.tween = Timer.every(2, function()
        Timer.tween(0.2, {
            [self] = {spriteX = -64}
        })
        :finish(function()
            self.sprite = POKEMON_DEFS[POKEMON_IDS[math.random(#POKEMON_IDS)]].battleSpriteFront
            swidth, sheight = gWeedGTextures[self.sprite]:getDimensions()
            self.scale = targHeight / sheight
            self.spriteX = VIRTUAL_WIDTH

            Timer.tween(0.2, {
                [self] = {spriteX = VIRTUAL_WIDTH/2 - (swidth * self.scale)/2}
            })
        end)
    end)
end

function WeedGStartState:enter()
    self.startMenu = Menu {
        items = {
            {
                text = 'Play',
                onSelect =
                    function()
                    gStateStack:push(FadeInState({r = 255, g = 255, b = 255}, 1,
                        function()
                        -- Pop off BarGStartState
                        gStateStack:pop()
                        gStateStack:push(WeedGPlayState())
                        gStateStack:push(FadeOutState({r = 255, g = 255, b = 255}, 1,
                            function()
                            end))
                        end))
                    end
            },
            {
                text = 'Instructions',
                onSelect =
                    function()
                        gStateStack:push(WeedGInstructionsState())
                    end
            },
        }
    }
end

function WeedGStartState:update(dt)
    self.startMenu:update(dt)
end

function WeedGStartState:render()
    love.graphics.clear(188, 188, 188, 255)

    love.graphics.setColor(24, 24, 24, 255)
    love.graphics.setFont(gFonts['large'])
    love.graphics.printf('Smokey-Mon!', 0, VIRTUAL_HEIGHT / 2 - 128, VIRTUAL_WIDTH, 'center')
    love.graphics.setFont(gFonts['medium'])
    love.graphics.printf('Press Enter', 0, VIRTUAL_HEIGHT / 2 + 124, VIRTUAL_WIDTH, 'center')
    love.graphics.setFont(gFonts['small'])

    love.graphics.setColor(45, 184, 45, 124)
    -- love.graphics.ellipse('fill', VIRTUAL_WIDTH / 2, VIRTUAL_HEIGHT / 2 + 32, 72, 24)
    love.graphics.ellipse('fill', VIRTUAL_WIDTH / 2, VIRTUAL_HEIGHT / 2 + 32, 128, 50)

    love.graphics.setColor(255, 255, 255, 255)
    local swidth, sheight = gWeedGTextures[self.sprite]:getDimensions()
    local targHeight = 100
    local scale = targHeight / sheight
    local sx = VIRTUAL_WIDTH/2 - (swidth * scale)/2
    local sy = VIRTUAL_HEIGHT/2 - (sheight * scale)/2
    love.graphics.draw(
        gWeedGTextures[self.sprite],
        self.spriteX, self.spriteY, 0, self.scale, self.scale)

    self.startMenu:render()
end
