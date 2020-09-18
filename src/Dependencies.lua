--
-- libraries
--

Class = require 'lib/class'
Event = require 'lib/knife.event'
push = require 'lib/push'
Timer = require 'lib/knife.timer'

require 'src/Animation'
require 'src/constants'
require 'src/Entity'
require 'src/entity_defs'
require 'src/GameObject'
require 'src/game_objects'
require 'src/Hitbox'
require 'src/Player'
require 'src/StateMachine'
require 'src/StateStack'
require 'src/Util'
require 'src/states/BaseState'
require 'src/states/game/FadeInState'
require 'src/states/game/FadeOutState'
require 'src/states/game/DialogueState'
require 'src/gui/Menu'
require 'src/gui/Panel'
require 'src/gui/Selection'
require 'src/gui/Textbox'

-- Apartment World requirements
require 'src/world/apartment/Apartment'
require 'src/world/apartment/states/AptWPrimaryState'
require 'src/world/apartment/states/AptWLeaveState'
require 'src/world/apartment/states/AptWBaseMenuState'
require 'src/world/apartment/states/AptWFunMenuState'

-- Bar Breakout Game requirements
require 'src/games/bar/src/BGBall'
require 'src/games/bar/src/BGBrick'
require 'src/games/bar/src/BGLevelMaker'
require 'src/games/bar/src/BGPaddle'
require 'src/games/bar/src/BGPowerUp'
require 'src/games/bar/src/states/BGGameOverState'
require 'src/games/bar/src/states/BGPlayState'
require 'src/games/bar/src/states/BGServeState'
-- require 'src/games/bar/src/states/BGStartState'
require 'src/games/bar/src/states/BGVictoryState'

-- Coke Flappy Bird Game requirements
require 'src/games/coke/src/CokeGBird'
require 'src/games/coke/src/CokeGPipe'
require 'src/games/coke/src/CokeGPipePair'
require 'src/games/coke/src/states/CokeGCountdownState'
require 'src/games/coke/src/states/CokeGPlayState'
require 'src/games/coke/src/states/CokeGScoreState'
require 'src/games/coke/src/states/CokeGTitleScreenState'

-- TODO will be deleted since we're not borrowing from Zelda right now
require 'src/world/Doorway'
require 'src/world/Dungeon'
require 'src/world/Room'

require 'src/states/entity/EntityIdleState'
require 'src/states/entity/EntityWalkState'

require 'src/states/entity/player/PlayerIdleState'
require 'src/states/entity/player/PlayerSwingSwordState'
require 'src/states/entity/player/PlayerWalkState'
require 'src/states/entity/player/PlayerLiftState'
require 'src/states/entity/player/PlayerPotWalk'
require 'src/states/entity/player/PlayerPotIdleState'
require 'src/states/entity/player/PlayerThrowState'

require 'src/states/game/GameOverState'
require 'src/states/game/PlayState'
require 'src/states/game/StartState'

gTextures = {
    --TODO delete legacy code from here
    ['tiles'] = love.graphics.newImage('graphics/tilesheet.png'),
    ['background'] = love.graphics.newImage('graphics/background.png'),
    ['character-walk'] = love.graphics.newImage('graphics/character_walk.png'),
    ['character-swing-sword'] = love.graphics.newImage('graphics/character_swing_sword.png'),
    ['character-lift'] = love.graphics.newImage('graphics/character_pot_lift.png'),
    ['character-pot-walk'] = love.graphics.newImage('graphics/character_pot_walk.png'),
    ['hearts'] = love.graphics.newImage('graphics/hearts.png'),
    ['switches'] = love.graphics.newImage('graphics/switches.png'),
    ['entities'] = love.graphics.newImage('graphics/entities.png'),
    --TODO delete legacy code to here
    ['apartment'] = love.graphics.newImage('graphics/sets/interior2.jpg'),
    ['bar'] = love.graphics.newImage('graphics/sets/interior3.png'),
    ['keeks-walk'] = love.graphics.newImage('graphics/characters/kiki_walk.png'),
    ['cursor'] = love.graphics.newImage('graphics/cursor.png'),
}

gFrames = {
    -- TODO delete legacy code from here
    ['tiles'] = GenerateQuads(gTextures['tiles'], 16, 16),
    ['character-walk'] = GenerateQuads(gTextures['character-walk'], 16, 32),
    ['character-swing-sword'] = GenerateQuads(gTextures['character-swing-sword'], 32, 32),
    ['character-lift'] = GenerateQuads(gTextures['character-lift'], 16, 32),
    ['character-pot-walk'] = GenerateQuads(gTextures['character-pot-walk'], 16, 32),
    ['entities'] = GenerateQuads(gTextures['entities'], 16, 16),
    ['hearts'] = GenerateQuads(gTextures['hearts'], 16, 16),
    ['switches'] = GenerateQuads(gTextures['switches'], 16, 18),
    -- TODO to here
    ['keeks-walk'] = GenerateQuads(gTextures['keeks-walk'], 77, 77),
}

gFramesInfo = {}

local retDict = GenerateApartmentQuadsAndInfo(gTextures['apartment'])
gFrames['apartment'] = retDict['quads']
gFramesInfo['apartment'] = retDict['info']

retDict = GenerateBarQuadsAndInfo(gTextures['bar'])
gFrames['bar'] = retDict['quads']
gFramesInfo['bar'] = retDict['info']

gFonts = {
    ['small'] = love.graphics.newFont('fonts/font.ttf', 8),
    ['medium'] = love.graphics.newFont('fonts/font.ttf', 16),
    ['large'] = love.graphics.newFont('fonts/font.ttf', 32),
    ['medium-flappy-font'] = love.graphics.newFont('src/games/coke/fonts/flappy.ttf', 14),
    ['flappy-font'] = love.graphics.newFont('src/games/coke/fonts/flappy.ttf', 28),
    ['huge-flappy-font'] = love.graphics.newFont('src/games/coke/fonts/flappy.ttf', 56),
    -- TODO delete 
    ['gothic-medium'] = love.graphics.newFont('fonts/GothicPixels.ttf', 16),
    ['gothic-large'] = love.graphics.newFont('fonts/GothicPixels.ttf', 32),
    ['zelda'] = love.graphics.newFont('fonts/zelda.otf', 64),
    ['zelda-small'] = love.graphics.newFont('fonts/zelda.otf', 32),
}

gSounds = {
    ['door'] = love.audio.newSource('sounds/door.wav'),
    ['blip'] = love.audio.newSource('sounds/blip.wav'),
    ['footsteps'] = love.audio.newSource('sounds/footsteps.wav'),
    -- Currently unused sounds
    ['music'] = love.audio.newSource('sounds/music.mp3'),
    ['sword'] = love.audio.newSource('sounds/sword.wav'),
    ['hit-enemy'] = love.audio.newSource('sounds/hit_enemy.wav'),
    ['hit-player'] = love.audio.newSource('sounds/hit_player.wav'),
    ['powerup'] = love.audio.newSource('sounds/powerup.wav'),
    ['lift'] = love.audio.newSource('sounds/lift.wav'),
    ['throw'] = love.audio.newSource('sounds/throw.wav'),
    ['breakpot'] = love.audio.newSource('sounds/breakpot.wav'),
}

gBGTextures = {
    ['background'] = love.graphics.newImage('src/games/bar/graphics/background.png'),
    ['main'] = love.graphics.newImage('src/games/bar/graphics/breakout.png'),
    ['arrows'] = love.graphics.newImage('src/games/bar/graphics/arrows.png'),
    ['hearts'] = love.graphics.newImage('src/games/bar/graphics/hearts.png'),
    ['particle'] = love.graphics.newImage('src/games/bar/graphics/particle.png')
}

gBGFrames = {
    ['arrows'] = GenerateQuads(gBGTextures['arrows'], 24, 24),
    ['paddles'] = GenerateQuadsPaddles(gBGTextures['main']),
    ['balls'] = GenerateQuadsBalls(gBGTextures['main']),
    ['bricks'] = GenerateQuadsBricks(gBGTextures['main']),
    ['lock_brick'] = GenerateQuadsLockBrick(gBGTextures['main']),
    ['hearts'] = GenerateQuads(gBGTextures['hearts'], 10, 9),
    ['powerups'] = GenerateQuadsPowerups(gBGTextures['main']),
}

gBGSounds = {
    ['paddle-hit'] = love.audio.newSource('src/games/bar/sounds/paddle_hit.wav'),
    ['score'] = love.audio.newSource('src/games/bar/sounds/score.wav'),
    ['wall-hit'] = love.audio.newSource('src/games/bar/sounds/wall_hit.wav'),
    ['confirm'] = love.audio.newSource('src/games/bar/sounds/confirm.wav'),
    ['select'] = love.audio.newSource('src/games/bar/sounds/select.wav'),
    ['no-select'] = love.audio.newSource('src/games/bar/sounds/no-select.wav'),
    ['brick-hit-1'] = love.audio.newSource('src/games/bar/sounds/brick-hit-1.wav'),
    ['brick-hit-2'] = love.audio.newSource('src/games/bar/sounds/brick-hit-2.wav'),
    ['hurt'] = love.audio.newSource('src/games/bar/sounds/hurt.wav'),
    ['victory'] = love.audio.newSource('src/games/bar/sounds/victory.wav'),
    ['recover'] = love.audio.newSource('src/games/bar/sounds/recover.wav'),
    ['high-score'] = love.audio.newSource('src/games/bar/sounds/high_score.wav'),
    ['pause'] = love.audio.newSource('src/games/bar/sounds/pause.wav'),
    ['powerup'] = love.audio.newSource('src/games/bar/sounds/powerup.wav'),
    ['music'] = love.audio.newSource('src/games/bar/sounds/music.wav'),
}

gCokeGImages = {
    ['ground'] = love.graphics.newImage('src/games/coke/graphics/ground.png'),
    ['background'] = love.graphics.newImage('src/games/coke/graphics/background.png'),
    ['pipe'] = love.graphics.newImage('src/games/coke/graphics/pipe.png'),
    ['bird'] = love.graphics.newImage('src/games/coke/graphics/bird.png'),
    ['pause'] = love.graphics.newImage('src/games/coke/graphics/pause.png'),
}

gCokeSounds = {
    ['jump'] = love.audio.newSource('src/games/coke/sounds/jump.wav', 'static'),
    ['explosion'] = love.audio.newSource('src/games/coke/sounds/explosion.wav', 'static'),
    ['hurt'] = love.audio.newSource('src/games/coke/sounds/hurt.wav', 'static'),
    ['score'] = love.audio.newSource('src/games/coke/sounds/score.wav', 'static'),
    ['pause'] = love.audio.newSource('src/games/coke/sounds/pause.wav', 'static'),
    ['music'] = love.audio.newSource('src/games/coke/sounds/marios_way.mp3', 'static')
}
