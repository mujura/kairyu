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

return Script
