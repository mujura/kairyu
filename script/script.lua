Script = {}

function Script.TreatedAsNormalMonster(c, location)
    local e1 = Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e1:SetCode(EFFECT_ADD_TYPE)
    e1:SetRange(location)
    e1:SetValue(TYPE_NORMAL)
    c:RegisterEffect(e1)
    local e2 = e1:Clone()
    e2:SetCode(EFFECT_REMOVE_TYPE)
    e2:SetValue(TYPE_EFFECT)
    c:RegisterEffect(e2)
end

local function CanNormalSummonWithoutTributing(e, c, minc)
    if c == nil then
        return true
    end
    return minc == 0 and c:IsLevelAbove(5) and Duel.GetLocationCount(c:GetControler(), LOCATION_MZONE) > 0
end

function Script.CanNormalSummonWithoutTributing(c, description)
    local e1 = Effect.CreateEffect(c)
    e1:SetDescription(description)
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetCode(EFFECT_SUMMON_PROC)
    e1:SetCondition(CanNormalSummonWithoutTributing)
    c:RegisterEffect(e1)
end

local function NormalSummonedWithoutTributing(e)
    return e:GetHandler():GetMaterialCount() == 0
end

local function IfNormalSummonedWithoutTributingLevelBecomes(level)
    return function(e, tp, eg, ep, ev, re, r, rp)
        local c = e:GetHandler()
        local e1 = Effect.CreateEffect(c)
        e1:SetType(EFFECT_TYPE_SINGLE)
        e1:SetCode(EFFECT_CHANGE_LEVEL)
        e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
        e1:SetRange(LOCATION_MZONE)
        e1:SetCondition(NormalSummonedWithoutTributing)
        e1:SetValue(level)
        e1:SetReset(RESET_EVENT|RESETS_STANDARD_DISABLE & ~RESET_TOFIELD)
        c:RegisterEffect(e1)
    end
end

function Script.IfNormalSummonedWithoutTributingLevelBecomes(c, level)
    local e1 = Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetCode(EFFECT_SUMMON_COST)
    e1:SetOperation(IfNormalSummonedWithoutTributingLevelBecomes(level))
    c:RegisterEffect(e1)
end

local function IfSpecialSummonedLevelBecomes(level)
    return function(e, tp, eg, ep, ev, re, r, rp)
        local c = e:GetHandler()
        local e1 = Effect.CreateEffect(c)
        e1:SetType(EFFECT_TYPE_SINGLE)
        e1:SetCode(EFFECT_CHANGE_LEVEL)
        e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
        e1:SetRange(LOCATION_MZONE)
        e1:SetValue(level)
        e1:SetReset(RESET_EVENT|(RESETS_STANDARD|RESET_DISABLE) & ~(RESET_TOFIELD|RESET_LEAVE))
        c:RegisterEffect(e1)
    end
end

function Script.IfSpecialSummonedLevelBecomes(c, level)
    local e1 = Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetCode(EFFECT_SPSUMMON_COST)
    e1:SetOperation(IfSpecialSummonedLevelBecomes(level))
    c:RegisterEffect(e1)
end

local function UmiIsOnTheField(tp)
    local isFaceupUmi = aux.FaceupFilter(Card.IsCode, 22702055)
    local umiIsOnTheField = Duel.IsExistingMatchingCard(isFaceupUmi, tp, LOCATION_ONFIELD, LOCATION_ONFIELD, 1, nil)
    local fieldIsTreatedAsUmi = Duel.IsEnvironment(22702055)
    return umiIsOnTheField or fieldIsTreatedAsUmi
end

local function DestroyedWhileUmiIsOnTheField(e, tp, eg, ep, ev, re, r, rp)
    return e:GetHandler():IsReason(REASON_DESTROY)
        and (UmiIsOnTheField(e:GetHandlerPlayer()) or UmiIsOnTheField(re:GetHandlerPlayer()))
end

local function WATERNormalMonster(c)
    return c:IsAttribute(ATTRIBUTE_WATER) and c:IsType(TYPE_NORMAL + TYPE_MONSTER) and c:IsSummonable(true, nil)
end

local function Target1WATERNormalMonsterInYourHand(e, tp, eg, ep, ev, re, r, rp, chk)
    if chk == 0 then return Duel.IsExistingMatchingCard(WATERNormalMonster, tp, LOCATION_HAND, 0, 1, nil) end
    local g = Duel.GetMatchingGroup(WATERNormalMonster, tp, LOCATION_HAND, 0, nil)
    Duel.SetOperationInfo(0, CATEGORY_SUMMON, g, 1, 0, 0)
end

local function NormalSummon1WATERNormalMonsterFromYourHand(e, tp, eg, ep, ev, re, r, rp)
    Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_SUMMON)
    local tc = Duel.SelectMatchingCard(tp, WATERNormalMonster, tp, LOCATION_HAND, 0, 1, 1, nil):GetFirst()
    if tc then
        Duel.Summon(tp, tc, true, nil)
    end
end

function Script.IfThisCardIsDestroyedWhileUmiIsOnTheFieldNormalSummon1WATERNormalMonsterFromYourHand(c)
    local e1 = Effect.CreateEffect(c)
    e1:SetCategory(CATEGORY_SUMMON)
    e1:SetType(EFFECT_TYPE_SINGLE + EFFECT_TYPE_TRIGGER_F)
    e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP + EFFECT_FLAG_DELAY)
    e1:SetCode(EVENT_TO_GRAVE)
    e1:SetCondition(DestroyedWhileUmiIsOnTheField)
    e1:SetTarget(Target1WATERNormalMonsterInYourHand)
    e1:SetOperation(NormalSummon1WATERNormalMonsterFromYourHand)
    c:RegisterEffect(e1)
end

local function IsNegatable(c)
    return c:IsNegatable()
end

function Script.NegatableCardExistsAndIsNotSelf(e, tp, eg, ep, ev, re, r, rp)
    return eg:IsExists(IsNegatable, 1, nil) and not eg:IsContains(e:GetHandler())
end

function Script.TargetNegateThatCardsEffectsIncludingInTheGY(e, tp, eg, ep, ev, re, r, rp, chk)
    if chk == 0 then return e:GetHandler():IsDestructable() end
    Duel.SetOperationInfo(0, CATEGORY_DESTROY, e:GetHandler(), 1, tp, LOCATION_MZONE)
    Duel.SetOperationInfo(0, CATEGORY_DISABLE, eg:Filter(IsNegatable, nil), 1, 0, 0)
end

function Script.DestroyThisCardAndIfYouDoNegateThatCardEffectsIncludingInTheGY(e, tp, eg, ep, ev, re, r, rp)
    local c = e:GetHandler()
    if c:IsRelateToEffect(e) and Duel.Destroy(c, REASON_EFFECT) > 0 then
        local e1 = Effect.CreateEffect(e:GetHandler())
        e1:SetType(EFFECT_TYPE_SINGLE)
        e1:SetCode(EFFECT_DISABLE)
        e1:SetReset(RESET_EVENT + RESETS_STANDARD_EXC_GRAVE)
        local e2 = Effect.CreateEffect(e:GetHandler())
        e2:SetType(EFFECT_TYPE_SINGLE)
        e2:SetCode(EFFECT_DISABLE_EFFECT)
        e2:SetReset(RESET_EVENT + RESETS_STANDARD_EXC_GRAVE)
        for tc in eg:Filter(IsNegatable, nil):Iter() do
            tc:RegisterEffect(e1)
            tc:RegisterEffect(e2)
        end
    end
end

return Script
