--[[
    GD50
    Match-3 Remake

    -- AcidGStartState Class --

    Author: Colton Ogden
    cogden@cs50.harvard.edu

    Represents the state the game is in when we've just started; should
    simply display "Match-3" in large text, as well as a message to press
    Enter to begin.
]]

local positions = {}

AcidGStartState = Class{__includes = BaseState}

function AcidGStartState:init()
    self.bkgrd = AcidGBackground()
    self.board = AcidGBoard(32, 64)

    -- currently selected menu item
    self.currentMenuItem = 1

    -- colors we'll use to change the title text
    self.colors = {
        [1] = {217, 87, 99, 255},
        [2] = {95, 205, 228, 255},
        [3] = {251, 242, 54, 255},
        [4] = {118, 66, 138, 255},
        --[[
        [5] = {153, 229, 80, 255},
        [6] = {223, 113, 38, 255}
        --]]
    }

    -- letters of MATCH 3 and their spacing relative to the center
    self.letterTable = {
        {'A', -52},
        {'C', -16},
        {'I', 14},
        {'D', 52},
    }

    -- time for a color change if it's been half a second
    self.colorTimer = Timer.every(0.075, function()

        -- shift every color to the next, looping the last to front
        -- assign it to 0 so the loop below moves it to 1, default start
        self.colors[0] = self.colors[#self.colors]

        for i = #self.colors, 1, -1 do
            self.colors[i] = self.colors[i - 1]
        end
    end)

    -- generate full table of tiles just for display
    for i = 1, 64 do
        table.insert(positions, gAcidGFrames['tiles'][math.random(18)][math.random(6)])
    end

    -- used to animate our full-screen transition rect
    self.transitionAlpha = 0

    -- if we've selected an option, we need to pause input while we animate out
    self.pauseInput = false

    gAcidGSounds['music']:setLooping(true)
    gAcidGSounds['music']:play()
end

function AcidGStartState:update(dt)
    -- as long as can still input, i.e., we're not in a transition...
    if not self.pauseInput then

        -- change menu selection
        if love.keyboard.wasPressed('up') or love.keyboard.wasPressed('down') then
            self.currentMenuItem = self.currentMenuItem == 1 and 2 or 1
            gAcidGSounds['select']:play()
        end

        -- switch to another state via one of the menu options
        if love.keyboard.wasPressed('enter') or love.keyboard.wasPressed('return') then
            if self.currentMenuItem == 1 then

                -- tween, using Timer, the transition rect's alpha to 255, then
                -- transition to the BeginGame state after the animation is over
                Timer.tween(1, {
                    [self] = {transitionAlpha = 255}
                }):finish(function()
                    self.bkgrd:beginTransitioning()
                    gStateStack:pop()
                    gStateStack:push(AcidGBeginGameState({
                        bkgrd = self.bkgrd,
                        level = 1,
                    }))

                    -- remove color timer from Timer
                    self.colorTimer:remove()
                end)
            else
                gStateStack:push(DialogueState(
                    'The colors, OH THE COLORS!\n'..
                    'Try and match at least three mini-tabs of acid in a row within the '..
                    'blotter paper grid. Click the mini-tabs with the mouse to move '..
                    'them. You can only switch two tabs that are neighbors in one '..
                    'of the cardinal directions (up, right, down, left).\n'..
                    'Match enough tabs and score enough points before the timer '..
                    'runs out to advance to a....higher level\n'..
                    'New levels can bring new types of acid (different shapes). '..
                    'Try and match as many of the pattenerned tabs as possible, since '..
                    'they are worth more points than the unmarked tabs.\n'..
                    'Finally, keep an eye out for sparkling tabs. Matching a row '..
                    'that has a sparkling tab will give get your score so high, you\'ll be asking '..
                    'yourself: "Is this forever?"'
                , function()
                    self.pauseInput = false
                  end))
            end

            -- turn off input during transition
            self.pauseInput = true
        end
    end

    -- update our Timer, which will be used for our fade transitions
    Timer.update(dt)
end

function AcidGStartState:render()
    self.bkgrd:render()
    self.board:render()

    -- render all tiles and their drop shadows
    --[[
    for y = 1, 8 do
        for x = 1, 8 do

            -- render shadow first
            love.graphics.setColor(0, 0, 0, 255)
            love.graphics.draw(gAcidGTextures['main'], positions[(y - 1) * x + x],
                (x - 1) * 32 + 128 + 3, (y - 1) * 32 + 16 + 3)

            -- render tile
            love.graphics.setColor(255, 255, 255, 255)
            love.graphics.draw(gAcidGTextures['main'], positions[(y - 1) * x + x],
                (x - 1) * 32 + 128, (y - 1) * 32 + 16)
        end
    end
    --]]

    -- keep the background and tiles a little darker than normal
    love.graphics.setColor(0, 0, 0, 128)
    love.graphics.rectangle('fill', 0, 0, VIRTUAL_WIDTH, VIRTUAL_HEIGHT)

    self:drawMatch3Text(-60)
    self:drawOptions(12)

    -- draw our transition rect; is normally fully transparent, unless we're moving to a new state
    love.graphics.setColor(255, 255, 255, self.transitionAlpha)
    love.graphics.rectangle('fill', 0, 0, VIRTUAL_WIDTH, VIRTUAL_HEIGHT)
end

--[[
    Draw the centered MATCH-3 text with background rect, placed along the Y
    axis as needed, relative to the center.
]]
function AcidGStartState:drawMatch3Text(y)

    -- draw semi-transparent rect behind MATCH 3
    love.graphics.setColor(255, 255, 255, 128)
    love.graphics.rectangle('fill', VIRTUAL_WIDTH / 2 - 76, VIRTUAL_HEIGHT / 2 + y - 11, 150, 58, 6)

    -- draw MATCH 3 text shadows
    love.graphics.setFont(gFonts['large'])
    self:drawTextShadow('ACID', VIRTUAL_HEIGHT / 2 + y)

    -- print MATCH 3 letters in their corresponding current colors
    for i = 1, #self.letterTable do
        love.graphics.setColor(self.colors[i])
        love.graphics.printf(self.letterTable[i][1], 0, VIRTUAL_HEIGHT / 2 + y,
            VIRTUAL_WIDTH + self.letterTable[i][2], 'center')
    end
end

--[[
    Draws "Start" and "Quit Game" text over semi-transparent rectangles.
]]
function AcidGStartState:drawOptions(y)

    -- draw rect behind start and quit game text
    love.graphics.setColor(255, 255, 255, 128)
    love.graphics.rectangle('fill', VIRTUAL_WIDTH / 2 - 76, VIRTUAL_HEIGHT / 2 + y, 150, 58, 6)

    -- draw Start text
    love.graphics.setFont(gFonts['medium'])
    self:drawTextShadow('Start', VIRTUAL_HEIGHT / 2 + y + 8)

    if self.currentMenuItem == 1 then
        love.graphics.setColor(99, 155, 255, 255)
    else
        love.graphics.setColor(48, 96, 130, 255)
    end

    love.graphics.printf('Start', 0, VIRTUAL_HEIGHT / 2 + y + 8, VIRTUAL_WIDTH, 'center')

    -- draw Quit Game text
    love.graphics.setFont(gFonts['medium'])
    self:drawTextShadow('Instructions', VIRTUAL_HEIGHT / 2 + y + 33)

    if self.currentMenuItem == 2 then
        love.graphics.setColor(99, 155, 255, 255)
    else
        love.graphics.setColor(48, 96, 130, 255)
    end

    love.graphics.printf('Instructions', 0, VIRTUAL_HEIGHT / 2 + y + 33, VIRTUAL_WIDTH, 'center')
end

--[[
    Helper function for drawing just text backgrounds; draws several layers of the same text, in
    black, over top of one another for a thicker shadow.
]]
function AcidGStartState:drawTextShadow(text, y)
    love.graphics.setColor(34, 32, 52, 255)
    love.graphics.printf(text, 2, y + 1, VIRTUAL_WIDTH, 'center')
    love.graphics.printf(text, 1, y + 1, VIRTUAL_WIDTH, 'center')
    love.graphics.printf(text, 0, y + 1, VIRTUAL_WIDTH, 'center')
    love.graphics.printf(text, 1, y + 2, VIRTUAL_WIDTH, 'center')
end
