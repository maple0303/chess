LuaRedDot = { };
local this = LuaRedDot;
--判断道具背包是否满
function LuaRedDot.JudgeBagSpace()
    local BagBox = LuaCItemModule.GetItemBox(ITEM_WHERE_BAGGAGE)
	if (BagBox == nil) then
		return; 
	end  
    if (BagBox:GetSpaceTotalNum() == 0) then
		return true;    --已满
    else
        return false;   --未满
	end 
end
--判断心法背包背包是否满
function LuaRedDot.JudgeWisdomBagSpace()
    local wisdomBox = LuaCItemModule.GetItemBox(ITEM_WHERE_WISDOM_BAG)
	if (wisdomBox == nil) then
		return; 
	end  
    if (wisdomBox:GetSpaceTotalNum() == 0) then
		return true; --没有空格 已满
    else
        return false;  --未满
	end 
end
--判断宝石背包是否满
function LuaRedDot.JudgeStoneBagSpace()
    local stoneBox = LuaCItemModule.GetItemBox(ITEM_WHERE_GEM_STONE_BAG)
	if (stoneBox == nil) then
		return; 
	end  
    if (stoneBox:GetSpaceTotalNum() == 0) then
		return true; --没有空格 已满
    else
        return false;  --未满
	end 
end
--心法免费次数红点判断
function LuaRedDot.JudgeFreeHeartStudy()
    if LuaCHeroProperty.heartMagicFreeTimes > 0 then
        return true;
    else
        return false;
    end
end
--体质点足够可以升级红点判断
function LuaRedDot.JudgeFreeHeartStudy()
    if LuaCHeroProperty.heartMagicFreeTimes > 0 then
        return true;
    else
        return false;
    end
end
--是否有新邮件
function LuaRedDot.JudgeHasNewMail()
    local arrMail = LuaCMailModule.m_arrMapMail;
    for k,mailData in ipairs(arrMail) do
        if (mailData:HasStatus(EmMailStatus.EMail_Status_Read)==false) then--没读过
            return true;
        end
	end
    return false;
end