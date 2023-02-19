-- Kairyu-Mujura
Duel.LoadScript("script.lua")

local s, id = GetID()
function s.initial_effect(c)
    Script.TreatedAsNormalMonster(c, LOCATION_HAND + LOCATION_GRAVE)
    Script.CanNormalSummonWithoutTributing(c, aux.Stringid(id, 0))
    Script.IfNormalSummonedWithoutTributingLevelBecomes(c, 3)
    Script.IfSpecialSummonedLevelBecomes(c, 3)
    Script.IfThisCardIsDestroyedWhileUmiIsOnTheFieldNormalSummon1WATERNormalMonsterFromYourHand(c)
end

s.listed_names = { 22702055 }
