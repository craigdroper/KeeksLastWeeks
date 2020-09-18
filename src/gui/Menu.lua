--[[
    GD50
    Pokemon

    Author: Colton Ogden
    cogden@cs50.harvard.edu

    A Menu is simply a Selection layered onto a Panel, at least for use in this
    game. More complicated Menus may be collections of Panels and Selections that
    form a greater whole.
]]

Menu = Class{}

function Menu:init(def)
    -- TODO dynamically create a bottom and center justified menu with
    -- dimensions to fit all the items and the cursor
    local maxTextLength = 0
    for _, item in pairs(def.items) do
        if item.text:len() > maxTextLength then
            maxTextLength = item.text:len()
        end
    end
    local charPixelHeight = 32
    local charPixelWidth = 10
    local cursorWidth = 28
    local menuWidth = (charPixelWidth * maxTextLength) + 2 * cursorWidth
    local menuHeight = charPixelHeight * #def.items
    local menuX = (VIRTUAL_WIDTH - menuWidth) / 2
    local menuY = (VIRTUAL_HEIGHT - TEXT_Y_PAD - menuHeight)

    self.panel = Panel(menuX, menuY, menuWidth, menuHeight)
    self.selection = Selection {
        items = def.items,
        x = menuX,
        y = menuY,
        width = menuWidth,
        height = menuHeight,
    }
end

function Menu:update(dt)
    self.selection:update(dt)
end

function Menu:render()
    self.panel:render()
    self.selection:render()
end
