
DateGStartState = Class{__includes = BaseState}

function DateGStartState:init()
    self.background = DateGBackground()
    self.player = gGlobalObjs['player']
    self.player:storeSnapshot()
    self.couple = DateGCouple(player)
end

function DateGStartState:enter()
    -- Push a dialogue box with some simple instructions
    gStateStack:push(DialogueState(
        'Fiance: Keeks, I can\'t believe how long you kept me waiting here. '..
        'It\'s like all you care about is having fun and playing your games. '..
        'Fine, let\'s play a game.\n'..
        'If you want to earn yourself any more time to play more of the games, '..
        'you are going to sit here and listen to me talk about everything I want '..
        'to talk about, like my day, my clothes, my hair, my work, my friends, and '..
        'most importantly my feelings, and the only thing I want to hear from you '..
        'the entire time is "Yes Honey"\n'..
        'If at any time, you say anything but "Yes Honey" to me, this date is over '..
        'and you\'re walking home. Got it?!\n\n'..
        'Keeks: Yes Honey',
        function()
            -- pop the club mini game start
            -- state and push on a serve state for level 1
            gStateStack:pop()
            gStateStack:push(DateGPlayState({
                background = self.background,
                couple = self.couple,
                player = self.player,
                }))
        end))
end

function DateGStartState:render()
    self.background:render()
    self.couple:render()
end
