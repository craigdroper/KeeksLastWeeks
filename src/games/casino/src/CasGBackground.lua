
CasGBackground = Class{}

function CasGBackground:init()
    self.bkgrd = gCasWImages['table-background']
    self.bkgrdX = 0
    self.bkgrdY = 0
    self.bkgrdW, self.bkgrdH = self.bkgrd:getDimensions()
    self.bkgrdSX = VIRTUAL_WIDTH / self.bkgrdW
    self.bkgrdSY = VIRTUAL_HEIGHT / self.bkgrdH

    self.songIdx = math.random(#gCasGSongs)
    self.song = gCasGSongs[self.songIdx]
    self:startSong()
end

function CasGBackground:startSong()
    self.song:play()
    self.songTimer = Timer.after(self.song:getDuration('seconds'),
        function()
            self:changeSong()
        end
    )
end

function CasGBackground:changeSong()
    local maxTry = 10000
    local nextIdx = math.random(#gCasGSongs)
    local tryCount = 0
    while tryCount < maxTry do
        if nextIdx ~= self.songIdx then
            break
        end
        nextIdx = math.random(#gCasGSongs)
    end
    self.songIdx = nextIdx
    self.song:stop()
    self.song = gCasGSongs[self.songIdx]
    self:startSong()
end

function CasGBackground:render()
    love.graphics.filterDrawD(self.bkgrd, self.bkgrdX, self.bkgrdY, 0,
        self.bkgrdSX, self.bkgrdSY)
end
