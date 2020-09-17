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

    gStateMachine = StateMachine {
        --[[
            TODO one of the states should be the "Dirty Bit Productions" tweenin opacity
            title and then it goes into the "Start" menu state
        --]]
        ['start'] = function() return StartState() end,
        ['play'] = function() return PlayState() end,
        ['game-over'] = function() return GameOverState() end,
        -- Add Bar Mini Game States to global state machine
        -- ['bar-game-start'] = function() return BGStartState() end,
        ['bar-game-play'] = function() return BGPlayState() end,
        ['bar-game-serve'] = function() return BGServeState() end,
        ['bar-game-game-over'] = function() return BGGameOverState() end,
        ['bar-game-game-victory'] = function() return BGVictoryState() end,
        -- Add Coke Mini Game States to global state machine
        ['coke-game-title'] = function() return CokeGTitleScreenState() end,
        ['coke-game-countdown'] = function() return CokeGCountdownState() end,
        ['coke-game-play'] = function() return CokeGPlayState() end,
        ['coke-game-score'] = function() return CokeGScoreState() end
    }
    -- gStateMachine:change('start')
    gStateMachine:change('coke-game-title')
    --[[
    gStateMachine:change('bar-game-serve', {
        paddle = BGPaddle(1),
        bricks = BGLevelMaker.createMap(32),
        health = 3,
        score = 0,
        level = 32,
        recoverPoints = 5000,
    })
    --]]

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
    gStateMachine:update(dt)

    love.keyboard.keysPressed = {}
end

function love.draw()
    push:start()
    gStateMachine:render()
    push:finish()
end
