--[[
    GD50
    Pokemon

    Author: Colton Ogden
    cogden@cs50.harvard.edu

    A WeedGMenu is simply a Selection layered onto a Panel, at least for use in this
    game. More complicated WeedGMenus may be collections of Panels and Selections that
    form a greater whole.
]]

WeedGMenu = Class{}

function WeedGMenu:init(def)
    self.panel = Panel(def.x, def.y, def.width, def.height)
    
    self.selection = Selection {
        items = def.items,
        x = def.x,
        y = def.y,
        width = def.width,
        height = def.height
    }
end

function WeedGMenu:update(dt)
    self.selection:update(dt)
end

function WeedGMenu:render()
    self.panel:render()
    self.selection:render()
end
