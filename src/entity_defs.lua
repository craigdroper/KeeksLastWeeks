--[[
    Author: Colton Ogden
    cogden@cs50.harvard.edu

    Repurposed by croper for KLW
]]

ENTITY_DEFS = {
    ['keeks'] = {
        width = 36,
        height = 58,
        offsetX = 20,
        offsetY = 18,
        animations = {
            ['walk-left'] = {
                frames = {9, 10, 11, 12, 13, 14, 15, 16},
                interval = 0.05,
                texture = 'keeks-walk'
            },
            ['walk-right'] = {
                frames = {17, 18, 19, 20, 21, 22, 23, 24},
                interval = 0.05,
                texture = 'keeks-walk'
            },
            ['walk-down'] = {
                frames = {1, 2, 3, 4, 5, 6, 7, 8},
                interval = 0.05,
                texture = 'keeks-walk'
            },
            ['walk-up'] = {
                frames = {25, 26, 27, 28, 29, 30, 31, 32},
                interval = 0.05,
                texture = 'keeks-walk'
            },
            ['idle-left'] = {
                frames = {15},
                texture = 'keeks-walk'
            },
            ['idle-right'] = {
                frames = {23},
                texture = 'keeks-walk'
            },
            ['idle-down'] = {
                frames = {1},
                texture = 'keeks-walk'
            },
            ['idle-up'] = {
                frames = {25},
                texture = 'keeks-walk'
            },
        },
    },
}
