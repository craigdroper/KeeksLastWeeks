
ClubGStartState = Class{__includes = BaseState}

function ClubGStartState:init()
    self.background = ClubGBackground()
    self.level = 1
    self.targets = self:initTargets()
end

function ClubGStartState:initTargets()
    -- All of the arrow targets and arrows will be within the middle third
    -- of the screen width, leaving room for other animations on the sides
    local leftArrowX = (VIRTUAL_WIDTH) / 3
    local rightArrowX = 2*(VIRTUAL_WIDTH) / 3
    -- Determine 3 padding sections between arrows the arrow region into quads
    local tmpTgt = ClubGArrowTarget(0, 0, 'down')
    local arrowWidth = tmpTgt.width
    local arrowPad = (rightArrowX - leftArrowX - 4*arrowWidth) / 3
    local topPad = 50
    local targets = {
        ['left'] = ClubGArrowTarget(leftArrowX, topPad, 'left'),
        ['down'] = ClubGArrowTarget(leftArrowX + (arrowPad + arrowWidth), topPad, 'down'),
        ['up'] = ClubGArrowTarget(leftArrowX + 2*(arrowPad + arrowWidth), topPad, 'up'),
        ['right'] = ClubGArrowTarget(leftArrowX + 3*(arrowPad + arrowWidth), topPad, 'right'),
    }
    return targets
end

function ClubGStartState:enter()
    -- Push a dialogue box with some simple instructions
    gStateStack:push(DialogueState(
        '<Instructions for DDR at the Club>',
        function()
            -- pop the club mini game start
            -- state and push on a serve state for level 1
            gStateStack:pop()
            gStateStack:push(ClubGCountdownState({
                background = self.background,
                targets = self.targets,
                score = 0,
                level = self.level,
                }))
        end))
end

function ClubGStartState:update(dt)
end

function ClubGStartState:render()
    self.background:render()

    for _, target in pairs(self.targets) do
        target:renderImage()
    end
end
