
GameMusic = Class{}

function GameMusic:init(songs)
    self.songs = songs
    self.songIdx = math.random(#self.songs)
    self.song = self.songs[self.songIdx]
end

function GameMusic:startSong()
    self.song:play()
    self.songTimer = Timer.after(self.song:getDuration('seconds'),
        function()
            self:changeSong()
        end
    )
end

function GameMusic:changeSong()
    local maxTry = 10000
    local nextIdx = math.random(#self.songs)
    local tryCount = 0
    while tryCount < maxTry do
        if nextIdx ~= self.songIdx then
            break
        end
        nextIdx = math.random(#self.songs)
        tryCount = tryCount + 1
    end
    self.songIdx = nextIdx
    self.song:stop()
    self.song = self.songs[self.songIdx]
    self:startSong()
end

function GameMusic:stopSong()
    if self.song then
        self.song:stop()
    end
    if self.songTimer then
        self.songTimer:remove()
    end
end
