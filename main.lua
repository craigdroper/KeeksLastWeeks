--[[
    GD50
    Legend of Zelda

    Author: Colton Ogden
    cogden@cs50.harvard.edu
]]

require 'src/Dependencies'

function love.load()
    math.randomseed(os.time())
    love.window.setTitle('Legend of Zelda')
    love.graphics.setDefaultFilter('nearest', 'nearest')

    push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
        fullscreen = true,
        vsync = true,
        resizable = true
    })

    love.graphics.setFont(gFonts['small'])

    gStateStack = StateStack()

    gGlobalObjs = {}
    player = Player()
    player.stateMachine = StateMachine {
        -- Initial thought is that the player will only have to be "idle"
        -- since any movement is controlled completely by the program
        -- and there is no need for a "walk" type state where we need
        -- to check if we're interacting with the map
        ['idle'] = function() return PlayerIdleState(player) end,
    }
    player:changeState('idle')
    gGlobalObjs['player'] = player

    gGlobalObjs['filter'] = NoFilter()

    gStateStack:push(FadeInState({r = 255, g = 255, b = 255}, 1,
        function()
            gStateStack:push(AptWEnterState())
            -- gStateStack:push(BarWEnterState())
            -- gStateStack:push(BarGStartState())
            -- gStateStack:push(AlleyWEnterState())
            -- gStateStack:push(CokeGTitleScreenState())
            gStateStack:push(FadeOutState({r = 255, g = 255, b = 255}, 1,
                function()
                end))
    end))

    love.keyboard.keysPressed = {}
    love.mouse.buttonsPressed = {}
end

function love.resize(w, h)
    push:resize(w, h)
end

function love.keypressed(key)
    love.keyboard.keysPressed[key] = true
end

--[[
    LÖVE2D callback fired each time a mouse button is pressed; gives us the
    X and Y of the mouse, as well as the button in question.
]]
function love.mousepressed(x, y, button)
    love.mouse.buttonsPressed[button] = true
end

function love.keyboard.wasPressed(key)
    return love.keyboard.keysPressed[key]
end

--[[
    Equivalent to our keyboard function from before, but for the mouse buttons.
]]
function love.mouse.wasPressed(button)
    return love.mouse.buttonsPressed[button]
end

function love.update(dt)
    if love.keyboard.wasPressed('escape') then
        love.event.quit()
    end

    Timer.update(dt)
    gStateStack:update(dt)
    gGlobalObjs['filter']:update(dt)

    love.keyboard.keysPressed = {}
end

function love.draw()
    push:start()
    gStateStack:render()
    gGlobalObjs['filter']:render()
    push:finish()
end

function love.graphics.filterDrawD(d, x, y, r, sx, sy, ox, oy, kx, ky)
    x = x or 0
    y = y or 0
    r = r or 0
    sx = sx or 1
    sy = sy or sx
    ox = ox or 0
    oy = oy or 0
    kx = kx or 0
    ky = ky or 0
    gGlobalObjs['filter']:drawD(d, x, y, r, sx, sy, ox, oy, kx, ky)
end

function love.graphics.filterDrawQ(t, q, x, y, r, sx, sy, ox, oy, kx, ky)
    x = x or 0
    y = y or 0
    r = r or 0
    sx = sx or 1
    sy = sy or sx
    ox = ox or 0
    oy = oy or 0
    kx = kx or 0
    ky = ky or 0
    gGlobalObjs['filter']:drawQ(t, q, x, y, r, sx, sy, ox, oy, kx, ky)
end
