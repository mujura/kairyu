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

return Script
