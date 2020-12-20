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
require 'src/states/game/UpdatePlayerStatsState'
require 'src/states/game/UserInputState'
require 'src/gui/Menu'
require 'src/gui/Panel'
require 'src/gui/Selection'
require 'src/gui/Textbox'
require 'src/gui/Inputbox'

-- Drug filters
require 'src/filters/NoFilter'
require 'src/filters/CokeFilter'

-- Apartment World requirements
require 'src/world/apartment/Apartment'
require 'src/world/apartment/states/AptWStationaryState'
require 'src/world/apartment/states/AptWEnterState'
require 'src/world/apartment/states/AptWExitState'
require 'src/world/apartment/states/AptWInitialMenuState'
require 'src/world/apartment/states/AptWFunMenuState'
require 'src/world/apartment/states/AptWRecoverMenuState'

-- Bar World requirements
require 'src/world/bar/Bar'
require 'src/world/bar/states/BarWStationaryState'
require 'src/world/bar/states/BarWEnterState'
require 'src/world/bar/states/BarWExitState'

-- Bar Breakout Game requirements
require 'src/games/bar/src/BarGBall'
require 'src/games/bar/src/BarGBrick'
require 'src/games/bar/src/BarGLevelMaker'
require 'src/games/bar/src/BarGPaddle'
require 'src/games/bar/src/BarGPowerUp'
require 'src/games/bar/src/BarGBackground'
require 'src/games/bar/src/BarGBeerBrick'
require 'src/games/bar/src/states/BarGGameOverState'
require 'src/games/bar/src/states/BarGPlayState'
require 'src/games/bar/src/states/BarGServeState'
-- require 'src/games/bar/src/states/BarGStartState'
require 'src/games/bar/src/states/BarGVictoryState'
require 'src/games/bar/src/states/BarGStartState'

-- Club World requirements
require 'src/world/club/Club'
require 'src/world/club/states/ClubWEnterState'
require 'src/world/club/states/ClubWEnterFloorState'
require 'src/world/club/states/ClubWStationaryState'
require 'src/world/club/states/ClubWExitState'

-- Club Game requirements
require 'src/games/club/src/ClubGBackground'
require 'src/games/club/src/ClubGArrow'
require 'src/games/club/src/ClubGArrowTarget'
require 'src/games/club/src/ClubGUtils'
require 'src/games/club/src/states/ClubGStartState'
require 'src/games/club/src/states/ClubGCountdownState'
require 'src/games/club/src/states/ClubGPlayState'
require 'src/games/club/src/states/ClubGVictoryState'
require 'src/games/club/src/states/ClubGGameOverState'

-- Casino world requirements
require 'src/world/casino/Casino'
require 'src/world/casino/states/CasWEnterState'
require 'src/world/casino/states/CasWStationaryState'
require 'src/world/casino/states/CasWExitState'

-- Casino game requirements
require 'src/games/casino/src/CasGBackground'
require 'src/games/casino/src/CasGCard'
require 'src/games/casino/src/CasGDeck'
require 'src/games/casino/src/CasGHand'
require 'src/games/casino/src/CasGDealer'
require 'src/games/casino/src/CasGTablePlayer'
require 'src/games/casino/src/states/CasGStartState'
require 'src/games/casino/src/states/CasGShuffleState'
require 'src/games/casino/src/states/CasGBetState'
require 'src/games/casino/src/states/CasGDealState'
require 'src/games/casino/src/states/CasGActMenuState'
require 'src/games/casino/src/states/CasGDispResState'
require 'src/games/casino/src/states/CasGCheckPlayerState'
require 'src/games/casino/src/states/CasGDealerFlipState'
require 'src/games/casino/src/states/CasGClearHandState'
require 'src/games/casino/src/states/CasGContinueMenuState'
require 'src/games/casino/src/states/CasGCheckDealerState'
require 'src/games/casino/src/states/CasGDealerActState'
require 'src/games/casino/src/states/CasGCheckWinnerState'
require 'src/games/casino/src/states/CasGCheckDealerBJState'
require 'src/games/casino/src/states/CasGInsureMenuState'

-- Date World requirements
require 'src/world/date/DateWLobby'
require 'src/world/date/DateWRestaurant'
require 'src/world/date/states/DateWEnterLobbyState'
require 'src/world/date/states/DateWHostWelcomeState'
require 'src/world/date/states/DateWEnterRestState'
require 'src/world/date/states/DateWStationaryState'
require 'src/world/date/states/DateWExitState'

-- Date Game requirements
require 'src/games/date/src/DateGBackground'
require 'src/games/date/src/DateGCouple'
require 'src/games/date/src/states/DateGStartState'
require 'src/games/date/src/states/DateGPlayState'
require 'src/games/date/src/states/DateGLoseState'

-- Work World requirements
require 'src/world/work/WorkWOffice'
require 'src/world/work/states/WorkWEnterOfficeState'
require 'src/world/work/states/WorkWEnterMeetingState'
require 'src/world/work/states/WorkWExitMeetingState'
require 'src/world/work/states/WorkWExitOfficeState'

-- Work Game requirements
require 'src/games/work/src/WorkGBackground'
require 'src/games/work/src/WorkGBall'
require 'src/games/work/src/WorkGPaddle'
require 'src/games/work/src/states/WorkGStartState'
require 'src/games/work/src/states/WorkGServeState'
require 'src/games/work/src/states/WorkGPlayState'
require 'src/games/work/src/states/WorkGGameOverState'

-- Doctor World requirements
require 'src/world/doctor/DoctorWRoom'
require 'src/world/doctor/states/DoctorWEnterRoomState'
require 'src/world/doctor/states/DoctorWEnterGameState'
require 'src/world/doctor/states/DoctorWExitGameState'
require 'src/world/doctor/states/DoctorWExitRoomState'

-- Doctor Game requirements
require 'src/games/doctor/src/DocGAlien'
require 'src/games/doctor/src/DocGAlienLaunchMarker'
require 'src/games/doctor/src/DocGBackground'
require 'src/games/doctor/src/DocGLevel'
require 'src/games/doctor/src/DocGObstacle'
require 'src/games/doctor/src/states/DocGPlayState'
require 'src/games/doctor/src/states/DocGStartState'

-- Drug Alley World requirements
require 'src/world/alley/Alley'
require 'src/world/alley/states/AlleyWStationaryState'
require 'src/world/alley/states/AlleyWEnterState'
require 'src/world/alley/states/AlleyWExitState'
require 'src/world/alley/states/AlleyWDrugMenuState'
require 'src/world/alley/states/AlleyWExitCarState'
require 'src/world/alley/states/AlleyWFunMenuState'

-- Coke Flappy Bird Game requirements
require 'src/games/coke/src/CokeGBird'
require 'src/games/coke/src/CokeGPipe'
require 'src/games/coke/src/CokeGPipePair'
require 'src/games/coke/src/CokeGBackground'
require 'src/games/coke/src/states/CokeGCountdownState'
require 'src/games/coke/src/states/CokeGPlayState'
require 'src/games/coke/src/states/CokeGScoreState'
require 'src/games/coke/src/states/CokeGTitleScreenState'

require 'src/states/entity/EntityIdleState'
require 'src/states/entity/EntityWalkState'

-- TODO delete start
require 'src/states/entity/player/PlayerIdleState'
require 'src/states/game/GameOverState'
require 'src/states/game/PlayState'
require 'src/states/game/StartState'
-- TODO delete end

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
    ['city'] = love.graphics.newImage('graphics/sets/urban1.png'),
    ['sec-rep-walk'] = love.graphics.newImage('graphics/characters/sec_rep.png'),
}

gTOTAL_CHAR_COUNT = 4

for charCount = 1, gTOTAL_CHAR_COUNT do
    gTextures['character-'..charCount] = love.graphics.newImage('graphics/characters/character_'..charCount..'.png')
end

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
    ['city'] = GenerateQuads(gTextures['city'], 16, 16, {right=1, down=1}, false),
}

gFramesInfo = {}

local retDict = GenerateApartmentQuadsAndInfo(gTextures['apartment'])
gFrames['apartment'] = retDict['quads']
gFramesInfo['apartment'] = retDict['info']

retDict = GenerateBarQuadsAndInfo(gTextures['bar'])
gFrames['bar'] = retDict['quads']
gFramesInfo['bar'] = retDict['info']

retDict = GenerateKeeksQuadsandInfo(gTextures['keeks-walk'])
gFrames['keeks-frames'] = retDict['quads']
gFramesInfo['keeks-frames'] = retDict['info']

retDict = GenerateCharacterQuadsAndInfo(gTextures['sec-rep-walk'])
gFrames['sec-rep-frames'] = retDict['quads']
gFramesInfo['sec-rep-frames'] = retDict['info']

for charCount = 1, gTOTAL_CHAR_COUNT do
    retDict = GenerateCharacterQuadsAndInfo(gTextures['character-'..charCount])
    gFrames['character-'..charCount] = retDict['quads']
    gFramesInfo['character-'..charCount] = retDict['info']
end

gFonts = {
    ['small'] = love.graphics.newFont('fonts/font.ttf', 8),
    ['medium'] = love.graphics.newFont('fonts/font.ttf', 16),
    ['large'] = love.graphics.newFont('fonts/font.ttf', 32),
    ['huge'] = love.graphics.newFont('fonts/font.ttf', 64),
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
    ['hurt'] = love.audio.newSource('sounds/hurt.wav'),
    -- Currently unused sounds
    ['music'] = love.audio.newSource('sounds/music.mp3'),
    ['sword'] = love.audio.newSource('sounds/sword.wav'),
    ['hit-enemy'] = love.audio.newSource('sounds/hit_enemy.wav'),
    ['hit-player'] = love.audio.newSource('sounds/hit_player.wav'),
    ['powerup'] = love.audio.newSource('sounds/powerup.wav'),
    ['lift'] = love.audio.newSource('sounds/lift.wav'),
    ['throw'] = love.audio.newSource('sounds/throw.wav'),
    ['breakpot'] = love.audio.newSource('sounds/breakpot.wav'),
    ['jump'] = love.audio.newSource('sounds/yahoo.wav'),
}

gBGTextures = {
    ['background'] = love.graphics.newImage('src/games/bar/graphics/background.png'),
    ['arrows'] = love.graphics.newImage('src/games/bar/graphics/arrows.png'),
    -- TODO nothing above here is in use
    ['main'] = love.graphics.newImage('src/games/bar/graphics/breakout.png'),
    ['hearts'] = love.graphics.newImage('src/games/bar/graphics/hearts.png'),
    ['particle'] = love.graphics.newImage('src/games/bar/graphics/particle.png'),
    ['beer'] = love.graphics.newImage('src/games/bar/graphics/beer.png'),
}

gBGFrames = {
    ['arrows'] = GenerateQuads(gBGTextures['arrows'], 24, 24),
    ['paddles'] = GenerateQuadsPaddles(gBGTextures['main']),
    ['balls'] = GenerateQuadsBalls(gBGTextures['main']),
    ['bricks'] = GenerateQuadsBricks(gBGTextures['main']),
    ['lock_brick'] = GenerateQuadsLockBrick(gBGTextures['main']),
    -- TODO nothing above here is in use
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
    ['nose'] = love.graphics.newImage('src/games/coke/graphics/nose.png'),
    ['background-base'] = love.graphics.newImage('src/games/coke/graphics/cocaine_pile.png'),
    ['background-ext'] = love.graphics.newImage('src/games/coke/graphics/cocaine_lines.jpg'),
}

gClubWImages = {
    ['club-background'] = love.graphics.newImage('graphics/sets/mid_interior.jpg'),
}

gCasWImages = {
    ['casino-background'] = love.graphics.newImage('graphics/sets/rivers_interior.jpg'),
    ['table-background'] = love.graphics.newImage('graphics/sets/blackjack_table.png'),
}

gCasSounds = {
    ['background'] = love.audio.newSource('sounds/casino_whitenoise.mp3'),
}


gCokeSounds = {
    ['jump'] = love.audio.newSource('src/games/coke/sounds/jump.wav', 'static'),
    ['explosion'] = love.audio.newSource('src/games/coke/sounds/explosion.wav', 'static'),
    ['hurt'] = love.audio.newSource('src/games/coke/sounds/hurt.wav', 'static'),
    ['score'] = love.audio.newSource('src/games/coke/sounds/score.wav', 'static'),
    ['pause'] = love.audio.newSource('src/games/coke/sounds/pause.wav', 'static'),
    ['music'] = love.audio.newSource('src/games/coke/sounds/marios_way.mp3', 'static'),
    ['sniff'] = love.audio.newSource('src/games/coke/sounds/sniff.mp3', 'static'),
    ['sneeze'] = love.audio.newSource('src/games/coke/sounds/sneeze.wav', 'static'),
}

gClubGImages = {
    ['background'] = love.graphics.newImage('src/games/club/graphics/background.jpg'),
    ['arrow-outline'] = love.graphics.newImage('src/games/club/graphics/arrow_outline.png'),
}

gClubGTextures = {
    ['arrows'] = love.graphics.newImage('src/games/club/graphics/arrows.png'),
}

gClubGFrames = {
    ['arrows'] = GenerateQuads(gClubGTextures['arrows'], 30, 30),
}

gClubSounds = {
    ['miss'] = love.audio.newSource('src/games/club/sounds/hurt.wav'),
    ['hit'] = love.audio.newSource('src/games/club/sounds/select.wav'),
    ['background'] = love.audio.newSource('src/games/club/sounds/muffled_club.mp3'),
}

gClubGSongs = {
    love.audio.newSource('src/games/club/sounds//club_tracks/call_on_me.mp3'),
}

gCasGTextures = {
    ['cards'] = love.graphics.newImage('src/games/casino/graphics/cards_tileset.png'),
}

gCasGFrames = {
    ['cards'] = GenerateQuads(gCasGTextures['cards'], 48, 64),
}

gCasGImages = {
    ['card-back'] = love.graphics.newImage('src/games/casino/graphics/card_back.png'),
}

gDateWImages = {
    ['lobby'] = love.graphics.newImage('graphics/sets/mastros_lobby.jpg'),
    ['dining-room'] = love.graphics.newImage('graphics/sets/mastros_interior.jpg'),
    ['table'] = love.graphics.newImage('src/games/date/graphics/background.jpg'),
}

gDateSounds = {
    ['background'] = love.audio.newSource('sounds/restaurant_whitenoise.mp3'),
    ['mumble'] = love.audio.newSource('src/games/date/sounds/mumbling.mp3'),
}

gWorkImages = {
    ['office'] = love.graphics.newImage('graphics/sets/work_office.jpg'),
    ['meeting'] = love.graphics.newImage('graphics/sets/work_meeting_room.jpg'),
    --['report'] = love.graphics.newImage('graphics/spac_report.png'),
    ['report'] = love.graphics.newImage('src/games/work/graphics/report.png'),
}

gWorkSounds = {
    ['paddle_hit'] = love.audio.newSource('src/games/work/sounds/paddle_hit.wav'),
    ['wall_hit'] = love.audio.newSource('src/games/work/sounds/wall_hit.wav'),
    ['score'] = love.audio.newSource('src/games/work/sounds/score.wav'),
    ['background'] = love.audio.newSource('sounds/office_whitenoise.mp3'),

}

gDoctorImages = {
    ['room'] = love.graphics.newImage('graphics/sets/doctor_exam_room.png'),
}

gDoctorSounds = {
    ['background'] = love.audio.newSource('sounds/doctor_background.mp3'),
}

gDocGTextures = {
    -- backgrounds
    ['blue-desert'] = love.graphics.newImage('src/games/doctor/graphics/blue_desert.png'),
    ['blue-grass'] = love.graphics.newImage('src/games/doctor/graphics/blue_grass.png'),
    ['blue-land'] = love.graphics.newImage('src/games/doctor/graphics/blue_land.png'),
    ['blue-shroom'] = love.graphics.newImage('src/games/doctor/graphics/blue_shroom.png'),
    ['colored-land'] = love.graphics.newImage('src/games/doctor/graphics/colored_land.png'),
    ['colored-desert'] = love.graphics.newImage('src/games/doctor/graphics/colored_desert.png'),
    ['colored-grass'] = love.graphics.newImage('src/games/doctor/graphics/colored_grass.png'),
    ['colored-shroom'] = love.graphics.newImage('src/games/doctor/graphics/colored_shroom.png'),

    -- aliens
    ['aliens'] = love.graphics.newImage('src/games/doctor/graphics/aliens.png'),

    -- tiles
    ['tiles'] = love.graphics.newImage('src/games/doctor/graphics/tiles.png'),

    -- wooden obstacles
    ['wood'] = love.graphics.newImage('src/games/doctor/graphics/wood.png'),

    -- arrow for trajectory
    ['arrow'] = love.graphics.newImage('src/games/doctor/graphics/arrow.png')
}

gDocGFrames = {
    ['aliens'] = GenerateQuads(gDocGTextures['aliens'], 35, 35),
    ['tiles'] = GenerateQuads(gDocGTextures['tiles'], 35, 35),

    ['wood'] = {
        love.graphics.newQuad(0, 0, 110, 35, gDocGTextures['wood']:getDimensions()),
        love.graphics.newQuad(0, 35, 110, 35, gDocGTextures['wood']:getDimensions()),
        love.graphics.newQuad(320, 180, 35, 110, gDocGTextures['wood']:getDimensions()),
        love.graphics.newQuad(355, 355, 35, 110, gDocGTextures['wood']:getDimensions())
    }
}

-- tweak circular alien quad
gDocGFrames['aliens'][9]:setViewport(105.5, 35.5, 35, 34.2)

gDocGSounds = {
    ['break1'] = love.audio.newSource('src/games/doctor/sounds/break1.wav'),
    ['break2'] = love.audio.newSource('src/games/doctor/sounds/break2.wav'),
    ['break3'] = love.audio.newSource('src/games/doctor/sounds/break3.mp3'),
    ['break4'] = love.audio.newSource('src/games/doctor/sounds/break4.wav'),
    ['break5'] = love.audio.newSource('src/games/doctor/sounds/break5.wav'),
    ['bounce'] = love.audio.newSource('src/games/doctor/sounds/bounce.wav'),
    ['kill'] = love.audio.newSource('src/games/doctor/sounds/kill.wav'),

    ['music'] = love.audio.newSource('src/games/doctor/sounds/music.wav'),
}
