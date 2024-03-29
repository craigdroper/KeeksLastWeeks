--[[
    GD50
    WeedGPokemon

    Author: Colton Ogden
    cogden@cs50.harvard.edu
]]

WeedGPokemon = Class{}

function WeedGPokemon:init(def, level, isPlayer)
    self.name = def.name
    self.isPlayer = isPlayer
    self.attacks = {
        [1] = {
            text = 'Smoke a Piece',
            minLevel = 1,
            missPercentage = 10,
            multiplier = 1,
        },
        [2] = {
            text = 'Roll a Joint',
            minLevel = 3,
            missPercentage = 20,
            multiplier = 1.4,
        },
        [3] = {
            text = 'Rip a Bong',
            minLevel = 5,
            missPercentage = 50,
            multiplier = 1.75,
        },
        [4] = {
            text = 'Vape a Volcano',
            minLevel = 7,
            missPercentage = 60,
            multiplier = 2.2,
        },
        [5] = {
            text = 'Torch and Dab',
            minLevel = 9,
            missPercentage = 80,
            multiplier = 3.0,
        },
    }

    self.battleSpriteFront = def.battleSpriteFront
    self.battleSpriteBack = def.battleSpriteBack

    self.baseHP = def.baseHP
    self.baseAttack = def.baseAttack
    self.baseDefense = def.baseDefense
    self.baseSpeed = def.baseSpeed

    self.HPIV = def.HPIV
    self.attackIV = def.attackIV
    self.defenseIV = def.defenseIV
    self.speedIV = def.speedIV

    self.HP = self.baseHP
    self.attack = self.baseAttack
    self.defense = self.baseDefense
    self.speed = self.baseSpeed

    self.level = level
    self.currentExp = 0
    self.expToLevel = self.level * self.level * 5 * 0.75

    self:calculateStats()

    self.currentHP = self.HP
end

function WeedGPokemon:calculateStats()
    local level = self.level
    if not self.isPlayer then
        -- NB: Not used right now
        level = level - 1
    end
    for i = 1, self.level do
        self:statsLevelUp()
    end
end

gLastWeedDef = nil

function WeedGPokemon.getRandomDef()
    local tryCount = 0
    local maxTry = 1000
    local weedDefIdx = nil
    while tryCount < maxTry do
        weedDefIdx = math.random(#POKEMON_IDS)
        if weedDefIdx ~= gLastWeedDef then
            break
        end
        tryCount = tryCount + 1
    end
    gLastWeedDef = weedDefIdx
    return POKEMON_DEFS[POKEMON_IDS[gLastWeedDef]]
end

--[[
    Takes the IV (individual value) for each stat into consideration and rolls
    the dice 3 times to see if that number is less than or equal to the IV (capped at 5).
    The dice is capped at 6 just so no stat ever increases by 3 each time, but
    higher IVs will on average give higher stat increases per level. Returns all of
    the increases so they can be displayed in the TakeTurnState on level up.
]]
function WeedGPokemon:statsLevelUp()
    local HPIncrease = 0

    for j = 1, 3 do
        if math.random(6) <= self.HPIV then
            self.HP = self.HP + 3
            HPIncrease = HPIncrease + 1
        end
    end

    local attackIncrease = 0

    for j = 1, 3 do
        if math.random(6) <= self.attackIV then
            self.attack = self.attack + 1
            attackIncrease = attackIncrease + 1
        end
    end

    local defenseIncrease = 0

    for j = 1, 3 do
        if math.random(6) <= self.defenseIV then
            self.defense = self.defense + 1
            defenseIncrease = defenseIncrease + 1
        end
    end

    local speedIncrease = 0

    for j = 1, 3 do
        if math.random(6) <= self.speedIV then
            self.speed = self.speed + 1
            speedIncrease = speedIncrease + 1
        end
    end

    return HPIncrease, attackIncrease, defenseIncrease, speedIncrease
end

function WeedGPokemon:levelUp()
    self.level = self.level + 1
    self.expToLevel = self.level * self.level * 8 * 0.75

    return self:statsLevelUp()
end
