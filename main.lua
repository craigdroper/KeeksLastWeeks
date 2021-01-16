--[[
    GD50
    Legend of Zelda

    Author: Colton Ogden
    cogden@cs50.harvard.edu
]]

require 'src/Dependencies'

function love.load()
    math.randomseed(os.time())
    love.window.setTitle('Keeks Last Weeks')
    love.graphics.setDefaultFilter('nearest', 'nearest')

    push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
        fullscreen = true,
        vsync = true,
        resizable = true
    })

    love.graphics.setFont(gFonts['small'])

    gStateStack = StateStack()

    gGlobalObjs = {}

    player = createPlayer()
    gGlobalObjs['player'] = player

    gGlobalObjs['filter'] = NoFilter()

    gStateStack:push(FadeInState({r = 255, g = 255, b = 255}, 1,
        function()
            -- gStateStack:push(AptWEnterState())
            -- gStateStack:push(BarWEnterState())
            -- gStateStack:push(BarGStartState())
            -- gStateStack:push(AlleyWEnterState())
            -- gStateStack:push(CokeGTitleScreenState())
            -- gStateStack:push(ClubWEnterState())
            -- gStateStack:push(ClubGStartState())
            -- gStateStack:push(CasWEnterState())
            -- gStateStack:push(CasGStartState())
            -- gStateStack:push(DateWEnterLobbyState())
            -- gStateStack:push(DateWEnterRestState())
            -- gStateStack:push(DateGStartState())
            -- gStateStack:push(WorkWEnterOfficeState())
            -- gStateStack:push(WorkGStartState())
            -- player.health = 50
            -- gStateStack:push(DoctorWEnterRoomState())
            -- gStateStack:push(DocGStartState())
            -- gStateStack:push(AcidGStartState())
            gStateStack:push(WeedGStartState())
            gStateStack:push(FadeOutState({r = 255, g = 255, b = 255}, 1,
                function()
                end))
    end))

    love.keyboard.keysPressed = {}
    love.mouse.buttonsPressed = {}
    love.mouse.keysReleased = {}
    love.mouse.mouseClicks = {}
    love.keyboard.textInput = ''
end

function love.resize(w, h)
    push:resize(w, h)
end

function love.keypressed(key)
    love.keyboard.keysPressed[key] = true
    -- Additional logic to manage the textinput string
    if key == 'backspace' then
        --[[
            From stack overflow, and may be overkill for the game
        local byteoffset = utf8.offset(love.keyboard.textInput, -1)
        if byteoffset then
            -- remove the last UTF-8 character.
            -- string.sub operates on bytes rather than
            -- UTF-8 characters, so we couldn't do string.sub(text, 1, -2).
            love.keyboard.textInput = string.sub(
                love.keyboard.textInput, 1, byteoffset - 1)
        end
        --]]
        if love.keyboard.textInput:len() then
            love.keyboard.textInput = string.sub(
                love.keyboard.textInput, 1, love.keyboard.textInput:len() - 1)
        end
    end
end

function love.textinput(t)
    love.keyboard.textInput = love.keyboard.textInput .. t
end

function love.keyboard.getCurrentText()
    return love.keyboard.textInput
end

function love.keyboard.clearCurrentText()
    love.keyboard.textInput = ''
end

--[[
    LÖVE2D callback fired each time a mouse button is pressed; gives us the
    X and Y of the mouse, as well as the button in question.
]]
function love.mousepressed(x, y, button)
    love.mouse.buttonsPressed[button] = true
    -- Simplified design choice to only process "primary" mouse clicks
    if button == 1 then
        virtualX, virtualY = push:toGame(x, y)
        if virtualX and virtualY then
            table.insert(love.mouse.mouseClicks, {x=virtualX, y=virtualY})
        end
    end
end

function love.mousereleased(x, y, key)
    love.mouse.keysReleased[key] = true 
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

function love.mouse.wasReleased(key)
    return love.mouse.keysReleased[key]
end

function love.update(dt)
    if love.keyboard.wasPressed('escape') then
        love.event.quit()
    end

    Timer.update(dt)
    gStateStack:update(dt)
    gGlobalObjs['filter']:update(dt)

    love.keyboard.keysPressed = {}
    love.mouse.buttonsPressed = {}
    love.mouse.keysReleased = {}
    love.mouse.mouseClicks = {}
end

function love.draw()
    push:start()
    gStateStack:render()
    gGlobalObjs['filter']:render()
    gGlobalObjs['player']:renderStats()
    push:finish()
end

function love.graphics.filterDrawD(d, x, y, r, sx, sy, ox, oy, kx, ky)
    gGlobalObjs['filter']:drawD(d,
    x or 0,
    y or 0,
    r or 0,
    sx or 1,
    sy or sx,
    ox or 0,
    oy or 0,
    kx or 0,
    ky or 0)
end

function love.graphics.filterDrawQ(t, q, x, y, r, sx, sy, ox, oy, kx, ky)
    gGlobalObjs['filter']:drawQ(t, q,
    x or 0,
    y or 0,
    r or 0,
    sx or 1,
    sy or sx,
    ox or 0,
    oy or 0,
    kx or 0,
    ky or 0)
end
