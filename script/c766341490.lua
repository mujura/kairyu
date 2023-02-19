-- Kairyu-Mujura
Duel.LoadScript("script.lua")

local s, id = GetID()
function s.initial_effect(c)
    Script.TreatedAsNormalMonster(c, LOCATION_HAND + LOCATION_GRAVE)
    Script.CanNormalSummonWithoutTributing(c, aux.Stringid(id, 0))
    Script.IfNormalSummonedWithoutTributingLevelBecomes(c, 3)
    Script.IfSpecialSummonedLevelBecomes(c, 3)
    Script.IfThisCardIsDestroyedWhileUmiIsOnTheFieldNormalSummon1WATERNormalMonsterFromYourHand(c)
    local e1 = Effect.CreateEffect(c)
    e1:SetCategory(CATEGORY_DESTROY + CATEGORY_DISABLE)
    e1:SetType(EFFECT_TYPE_FIELD + EFFECT_TYPE_TRIGGER_O)
    e1:SetProperty(EFFECT_FLAG_DELAY)
    e1:SetCode(EVENT_SPSUMMON_SUCCESS)
    e1:SetRange(LOCATION_MZONE)
    e1:SetTarget(Script.TargetNegateThatCardsEffectsIncludingInTheGY)
    e1:SetOperation(Script.DestroyThisCardAndIfYouDoNegateThatCardEffectsIncludingInTheGY)
    c:RegisterEffect(e1)
end

s.listed_names = { 22702055 }
