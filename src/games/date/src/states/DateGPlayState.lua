
DateGPlayState = Class{__includes = BaseState}

function DateGPlayState:init(params)
    self.background = params.background
    self.couple = params.couple
    self.player = params.player

    self.panelX = TEXT_X
    self.panelY = TEXT_Y
    self.panelW = TEXT_WIDTH
    self.panelH = TEXT_HEIGHT
    self.panel = Panel(self.panelX, self.panelY, self.panelW, self.panelH)
    self.font = gFonts['medium']
    self:resetTextChunks()
    self.unit = '..'
    self.isTalkingFinished = false
    self.talkSound = gDateSounds['mumble']
    self.talkSound:setLooping(true)

    self.queues = {
        'Don\'t you agree?',
        'Isn\'t that right?',
        'Do you understand where I\'m coming from?',
        'I think that\'s justified, don\'t you?',
        'I\'m not the bad guy here, I was just trying to help, right?',
    }
    self.userInput = nil

    self:beginDateTalk()
end

function DateGPlayState:resetTextChunks()
    self.respTextChunks = {
        [1] = {['text'] = 'Fiancee:', ['numDots'] = 79},
        [2] = {['text'] = '', ['numDots'] = 86},
        [3] = {['text'] = '', ['numDots'] = 86},
    }
end

function DateGPlayState:beginDateTalk()
    self.talkSound:play()
    self.talkSound:setVolume(1.0)
    self.talkingTween = Timer.every(0.2,
        function()
            for i = 1, #self.respTextChunks do
                local lineText = self.respTextChunks[i]['text']
                local lineWidth = self.respTextChunks[i]['numDots']
                if lineText:len() < lineWidth then
                    local lenDiff = lineWidth - lineText:len()
                    if lenDiff > self.unit:len() then
                        self.respTextChunks[i]['text'] = self.respTextChunks[i]['text'] .. self.unit
                        isFillingPanel = true
                        break
                    else
                        local tmpUnit = ''
                        for i = 1, lenDiff do
                            tmpUnit = tmpUnit .. '.'
                        end
                        self.respTextChunks[i]['text'] = self.respTextChunks[i]['text'] .. tmpUnit
                        if i == #self.respTextChunks then
                            self.isTalkingFinished = true
                        end
                        break
                    end
                end
            end
        end)
end

function DateGPlayState:update(dt)
    if self.isTalkingFinished then
        self.talkSound:stop()
        self.talkingTween:remove()
        gStateStack:push(DialogueState('Fiancee: ' ..
            self.queues[math.random(#self.queues)],
            function()
                gStateStack:push(UserInputState())
            end))
        -- Reset values for next iteration
        self.isTalkingFinished = false
        self:resetTextChunks()
    end
    if self.userInput then
        if self.userInput == 'Yes Honey' then
            -- Push a little extra time for the correct answer
            gStateStack:push(UpdatePlayerStatsState({
                        player = self.player,
                        stats = {time = 2},
                        callback = function()
                            self:beginDateTalk()
                        end}))
        else
            -- Pop off this play state, and push the lose state
            gStateStack:pop()
            gStateStack:push(DateGLoseState({
                        background = self.background,
                        couple = self.couple,
                        player = self.player}))
        end
        -- Reset value for next iteration
        self.userInput = nil
    end
end

function DateGPlayState:renderFiancePanel()
    self.panel:render()
    for i = 1, #self.respTextChunks do
        love.graphics.setFont(self.font)
        love.graphics.print(
            self.respTextChunks[i]['text'],
            self.panelX + 3,
            -- Shifting the periods down a little
            self.panelY + (i - 1) * 16 + 2)
    end
end

function DateGPlayState:render()
    self.background:render()
    self.couple:render()
    self:renderFiancePanel()
end
