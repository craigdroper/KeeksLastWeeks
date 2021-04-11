
DoctorWEnterGameState = Class{__includes = BaseState}

function DoctorWEnterGameState:init(params)
    self.player = gGlobalObjs['player']
    self.room = params.room
end

function DoctorWEnterGameState:enter()
    gStateStack:push(DialogueState('Good Doctor: Keeks my friend, what ' ..
        'brings you in today? Finally finished your punch card for a free '..
        'visit ?\n'..
        'Keeks: No doctor, it just feels like I\'m a little low on health, '..
        'wanted to see if you could help be feel better.\n'..
        'Good Doctor: Well as you know by now, I\'m more of trial and error '..
        'physician as opposed to many of my more traditional by the books '..
        'contemporaries. Let\'s do what we usually do and literally throw '..
        'pills at it. I\'ll grab a fistful, and toss it at your mouth, '..
        'and we\'ll see what sticks!',
        function()
            gStateStack:push(FadeInState({r = 255, g = 255, b = 255}, 1,
                function()
            -- Pop the WEnterGame state off
            gStateStack:pop()
            gStateStack:push(DocGStartState())
            gStateStack:push(FadeOutState({r = 255, g = 255, b = 255}, 1,
                function()
                end))
                end))
        end))
end

function DoctorWEnterGameState:update(dt)
    self.player:update(dt)
end

function DoctorWEnterGameState:render()
    self.room:render()
    self.player:render()
end
