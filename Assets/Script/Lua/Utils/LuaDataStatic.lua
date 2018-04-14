require "Template/TemplateDefine";

LuaDataStatic = {};

local m_arrTemplate = { };

function LuaDataStatic.SearchItemTpl(nTempID)
	if(nTempID == nil or nTempID <= 0) then
		return nil;
	end
	if(m_arrTemplate[nTempID] == nil) then
		m_arrTemplate[nTempID] = require ("Template/Item/"..nTempID);
	end
    return m_arrTemplate[nTempID];
end
--战斗信息模板
function LuaDataStatic.SearchFightData(nTempID)
    if(nTempID == nil or nTempID <= 0) then
		return nil;
	end
	if(m_arrTemplate[nTempID] == nil) then
        if(LuaFileExists("Template/FightData/"..nTempID) == false) then
            return nil;
        end
		m_arrTemplate[nTempID] = require ("Template/FightData/"..nTempID);
	end
    return m_arrTemplate[nTempID];
end
--世界boss模板
function LuaDataStatic.SearchBossFightData(nTempID)
    if(nTempID == nil or nTempID <= 0) then
		return nil;
	end
	if(m_arrTemplate[nTempID] == nil) then
        if(LuaFileExists("Template/Ogre/"..nTempID) == false) then
            return nil;
        end
		m_arrTemplate[nTempID] = require ("Template/Ogre/"..nTempID);
	end
    return m_arrTemplate[nTempID];
end
function LuaDataStatic.SearchSpriteTpl(nTempID)
	if(nTempID == nil or nTempID <= 0) then
		return nil;
	end
	if(m_arrTemplate[nTempID] == nil) then
		m_arrTemplate[nTempID] = require ("Template/Sprite/"..nTempID);
	end
    return m_arrTemplate[nTempID];
end

function LuaDataStatic.SearchSkillTpl(nTempID)
    if(nTempID == nil or nTempID <= 0) then
		return nil;
	end
	if(m_arrTemplate[nTempID] == nil) then
		m_arrTemplate[nTempID] = require ("Template/Skill/"..nTempID);
        if(m_arrTemplate[nTempID] ~= nil and m_arrTemplate[nTempID].SkillInitID == 0)
        then
            m_arrTemplate[nTempID].SkillInitID = nTempID;
        end
	end
    return m_arrTemplate[nTempID];
end 
function LuaDataStatic.SearchTalentSkillTpl(nTempID)
    if(nTempID == nil or nTempID <= 0) then
		return nil;
	end
	if(m_arrTemplate[nTempID] == nil) then
		m_arrTemplate[nTempID] = require ("Template/TalentSkill/"..nTempID);
	end
    return m_arrTemplate[nTempID];
end 
function LuaDataStatic.SearchTollgateReward(nTempID)
    if(nTempID == nil or nTempID <= 0) then
		return nil;
	end
	if(m_arrTemplate[nTempID] == nil) then
		m_arrTemplate[nTempID] = require ("Template/TollgateReward/"..nTempID);
	end
    return m_arrTemplate[nTempID];
end

function LuaDataStatic.SearchDropTableTpl(nTempID)
    if(nTempID == nil or nTempID <= 0) then
		return nil;
	end
	if(m_arrTemplate[nTempID] == nil) then
		m_arrTemplate[nTempID] = require ("Template/DropTable/"..nTempID);
	end
    return m_arrTemplate[nTempID];
end

function LuaDataStatic.SearchTplForName(strTempName)
	if(strTempName == nil or strTempName == "") then
		return nil;
	end
	if(m_arrTemplate[strTempName] == nil) then
		m_arrTemplate[strTempName] = require ("Template/"..strTempName);
	end
    return m_arrTemplate[strTempName];
end

function LuaDataStatic.SearchMultiComposeTpl(nTempID)
	if(nTempID == nil or nTempID <= 0) then
		return nil;
	end
	if(m_arrTemplate[nTempID] == nil) then
		m_arrTemplate[nTempID] = require ("Template/MultiCompose/"..nTempID);
	end
    return m_arrTemplate[nTempID];
end
function LuaDataStatic.SearchBuffTpl(nTempID)
	if(nTempID == nil or nTempID <= 0) then
		return nil;
	end
	if(m_arrTemplate[nTempID] == nil) then
		m_arrTemplate[nTempID] = require ("Template/Buff/"..nTempID);
	end
    return m_arrTemplate[nTempID];
end
function LuaDataStatic.SearchLevelPrizeTableTpl(nTempID)
	if(nTempID == nil or nTempID <= 0) then
		return nil;
	end
	if(m_arrTemplate[nTempID] == nil) then
		m_arrTemplate[nTempID] = require ("Template/PrizeRuleTable/"..nTempID);
	end
    return m_arrTemplate[nTempID];
end
function LuaDataStatic.SearchHorseSkillTpl(nTempID)
    if(nTempID == nil or nTempID <= 0) then
		return nil;
	end
	if(m_arrTemplate[nTempID] == nil) then
		m_arrTemplate[nTempID] = require ("Template/HorseSkill/"..nTempID);
	end
    return m_arrTemplate[nTempID];
end 
function LuaDataStatic.SearchMysticBoxRandTableTpl(nTempID)
    if(nTempID == nil or nTempID <= 0) then
		return nil;
	end
	if(m_arrTemplate[nTempID] == nil) then
		m_arrTemplate[nTempID] = require ("Template/MysticBoxRandTable/"..nTempID);
	end
    return m_arrTemplate[nTempID];
end
function LuaDataStatic.SearchAstorlogyDropTableTpl(nTempID)
    if(nTempID == nil or nTempID <= 0) then
		return nil;
	end
	if(m_arrTemplate[nTempID] == nil) then
		m_arrTemplate[nTempID] = require ("Template/HeartMagicDropTable/"..nTempID);
	end
    return m_arrTemplate[nTempID];
end 
function LuaDataStatic.SearchHorseTpl(nTempID)
    if(nTempID == nil or nTempID <= 0) then
		return nil;
	end
	if(m_arrTemplate[nTempID] == nil) then
		m_arrTemplate[nTempID] = require ("Template/Horse/"..nTempID);
	end
    return m_arrTemplate[nTempID];
end
--伙伴
function LuaDataStatic.SearchPlayerPartnerTpl(nTempID)
     if(nTempID == nil or nTempID <= 0) then
		return nil;
	end
	if(m_arrTemplate[nTempID] == nil) then
		m_arrTemplate[nTempID] = require ("Template/PlayerPartner/"..nTempID);
	end
    return m_arrTemplate[nTempID];
end
--主角
function LuaDataStatic.SearchPlayerTpl()
    if(m_arrTemplate["Player"] == nil) then
        m_arrTemplate["Player"] = require ("Template/Player");
    end
    return m_arrTemplate["Player"];
end
--地图元素模板
function LuaDataStatic.SearchMapElementTpl(nTempID)
    if(nTempID == nil or nTempID <= 0) then
		return nil;
	end
	if(m_arrTemplate[nTempID] == nil) then
		m_arrTemplate[nTempID] = require ("Template/MapElement/"..nTempID);
	end
    return m_arrTemplate[nTempID];
end
function LuaDataStatic.SearchTalentConfigTpl()
     
	if(m_arrTemplate["1100"] == nil) then
		m_arrTemplate["1100"] = require ("Template/Talent/1100");
	end
    return m_arrTemplate["1100"];
end
function LuaDataStatic.SearchDartConfigTpl()
     
	if(m_arrTemplate["DartConfig"] == nil) then
		m_arrTemplate["DartConfig"] = require ("Template/DartConfig");
	end
    return m_arrTemplate["DartConfig"];
end
function LuaDataStatic.SearchVIPConfigTpl()
     
	if(m_arrTemplate["VIPConfig"] == nil) then
		m_arrTemplate["VIPConfig"] = require ("Template/VIPConfig");
	end
    return m_arrTemplate["VIPConfig"];
end
--世界boss模板加载
function LuaDataStatic.SearchWorldBossConfigTpl()
     
	if(m_arrTemplate["WorldBossActivityTable"] == nil) then
		m_arrTemplate["WorldBossActivityTable"] = require ("Template/WorldBossActivityTable");
	end
    return m_arrTemplate["WorldBossActivityTable"];
end
function LuaDataStatic.SearchNpcTpl(nTempID)
     if(nTempID == nil or nTempID <= 0) then
		return nil;
	end
	if(m_arrTemplate[nTempID] == nil) then
		m_arrTemplate[nTempID] = require ("Template/Npc/"..nTempID);
	end
    return m_arrTemplate[nTempID];
end
function LuaDataStatic.SearchBlockNpcTpl(nTempID)
     if(nTempID == nil or nTempID <= 0) then
		return nil;
	end
	if(m_arrTemplate[nTempID] == nil) then
		m_arrTemplate[nTempID] = require ("Template/Block/"..nTempID);
	end
    return m_arrTemplate[nTempID];
end
function LuaDataStatic.SearchVIPRechargeConfigTpl(nTempID)
    if (nTempID == nil or nTempID <= 0) then
        return nil;
    end
    if (m_arrTemplate[nTempID] == nil) then
        m_arrTemplate[nTempID] = require("Template/VIPLevelConfig/" .. nTempID);
    end
    return m_arrTemplate[nTempID];
end
--根据vip等级找相应的vip模板
function LuaDataStatic.SearchVIPConfigForViplevel(vipLevel)
    if(vipLevel == nil or vipLevel <= 0) then
		return nil;
	end
    local nTempID = 0;
    --print("vip等级");
    if 1<= vipLevel and vipLevel <= 16 then
        nTempID = 201 + (vipLevel -1);
    end
	if(m_arrTemplate[nTempID] == nil) then
		m_arrTemplate[nTempID] = require ("Template/VIPLevelConfig/"..nTempID);
	end
    return m_arrTemplate[nTempID];
end
function LuaDataStatic.SearchTransferNpcTpl(nTempID)
     if(nTempID == nil or nTempID <= 0) then
		return nil;
	end
	if(m_arrTemplate[nTempID] == nil) then
		m_arrTemplate[nTempID] = require ("Template/Transfer/"..nTempID);
	end
    return m_arrTemplate[nTempID];
end
function LuaDataStatic.SearchCollectNpcTpl(nTempID)
     if(nTempID == nil or nTempID <= 0) then
		return nil;
	end
	if(m_arrTemplate[nTempID] == nil) then
		m_arrTemplate[nTempID] = require ("Template/CollectNpc/"..nTempID);
	end
    return m_arrTemplate[nTempID];
end
function LuaDataStatic.SearchMapEventTpl(nTempID)
     if(nTempID == nil or nTempID <= 0) then
		return nil;
	end
	if(m_arrTemplate[nTempID] == nil) then
		m_arrTemplate[nTempID] = require ("Template/MapEventConfig/"..nTempID);
	end
    return m_arrTemplate[nTempID];
end
function LuaDataStatic.SearchMapNewsTpl(nTempID)
     if(nTempID == nil or nTempID <= 0) then
		return nil;
	end
	if(m_arrTemplate[nTempID] == nil) then
		m_arrTemplate[nTempID] = require ("Template/MapNewsConfig/"..nTempID);
	end
    return m_arrTemplate[nTempID];
end
function LuaDataStatic.SearchArrayTpl()
	if(m_arrTemplate["1001"] == nil) then
		m_arrTemplate["1001"] = require ("Template/Array/1001");
	end
    return m_arrTemplate["1001"];
end
function LuaDataStatic.SearchLevelExp()
    if nil==m_arrTemplate["103"] then
        m_arrTemplate["103"] = require("Template/LevelExp/103");
    end
    return m_arrTemplate["103"];
end

function LuaDataStatic.SearchTplForName(strTempName)
	if(strTempName == nil or strTempName == "") then
		return nil;
	end
	if(m_arrTemplate[strTempName] == nil) then
		m_arrTemplate[strTempName] = require ("Template/"..strTempName);
	end
    return m_arrTemplate[strTempName];
end

function LuaDataStatic.IsSchoolNpc(SchoolType, SchoolNpcID)
    if(SchoolType <= 0)
    then
        return false;
    end
    return false
end
--怪物模板
function LuaDataStatic.SearchOgrePartnerTpl(nTempID)
    if(nTempID == nil or nTempID <= 0) then
		return nil;
	end
	if(m_arrTemplate[nTempID] == nil) then
        if(LuaFileExists("Template/OgrePartner/"..nTempID) == false) then
            return nil;
        end
		m_arrTemplate[nTempID] = require ("Template/OgrePartner/"..nTempID);
	end
    return m_arrTemplate[nTempID];
end
function LuaDataStatic.SearchVipConfig()
    if nil==m_arrTemplate["VipConfig"] then
        m_arrTemplate["VipConfig"] = require("Template/VIPConfig");
    end
    return m_arrTemplate["VipConfig"];
end
function LuaDataStatic.SearchStrengthConfig()
    if nil==m_arrTemplate["StrengthConfig"] then
        m_arrTemplate["StrengthConfig"] = require("Template/StrengthConfig");
    end
    return m_arrTemplate["StrengthConfig"];
end
function LuaDataStatic.SearchPartnerTalentTpl(nTempID)
    if(nTempID == nil or nTempID <= 0) then
		return nil;
	end
	if(m_arrTemplate[nTempID] == nil) then
		m_arrTemplate[nTempID] = require ("Template/PartnerTalent/"..nTempID);
	end
    return m_arrTemplate[nTempID];
end 
function LuaDataStatic.WisdomStudy()
    if nil==m_arrTemplate["WisdomStudy"] then
        m_arrTemplate["WisdomStudy"] = require("Template/StudyHeartMagicTable");
    end
    return m_arrTemplate["WisdomStudy"];
end
function LuaDataStatic.SpWisdomUp()
    if nil==m_arrTemplate["HeartMagicUpgTable"] then
        m_arrTemplate["HeartMagicUpgTable"] = require("Template/HeartMagicUpgTable");
    end
    return m_arrTemplate["HeartMagicUpgTable"];
end
--心法 品质经验
function LuaDataStatic.SpWisdomUp_GetQualityExp(quality)
    local returnInt=0; 
    if quality==TmItemQuality.emItemQuality_Green then
        returnInt = LuaDataStatic.SpWisdomUp().GreenExp;
    elseif quality==TmItemQuality.emItemQuality_Blue then
        returnInt = LuaDataStatic.SpWisdomUp().BlueExp;
     elseif quality==TmItemQuality.emItemQuality_Purple then
        returnInt = LuaDataStatic.SpWisdomUp().PurpleExp;   
     elseif quality==TmItemQuality.emItemQuality_Yellow then
        returnInt = LuaDataStatic.SpWisdomUp().YellowExp; 
     elseif quality==TmItemQuality.emItemQuality_Red then
        returnInt = LuaDataStatic.SpWisdomUp().RedExp; 
     elseif quality==TmItemQuality.emItemQuality_Orange then
        returnInt = LuaDataStatic.SpWisdomUp().GoldExp; 
    end
    return returnInt;
end
--心法 当前升级MAX经验
function LuaDataStatic.SpWisdomUp_GetMaxExp(level,quality)
    if (level >= #LuaDataStatic.SpWisdomUp().LevelExp) 
    then
        return 0;
    elseif(level == #LuaDataStatic.SpWisdomUp().LevelExp)
    then
        level = level - 1;
    end
    local nMaxExp = LuaDataStatic.SpWisdomUp().LevelExp[level + 1]; 
    if quality==TmItemQuality.emItemQuality_Green then
        nMaxExp = nMaxExp*LuaDataStatic.SpWisdomUp().GreenExpRatio;
    elseif quality==TmItemQuality.emItemQuality_Blue then
        nMaxExp = nMaxExp*LuaDataStatic.SpWisdomUp().BlueExpRatio;
     elseif quality==TmItemQuality.emItemQuality_Purple then
        nMaxExp = nMaxExp*LuaDataStatic.SpWisdomUp().PurpleExpRatio;   
     elseif quality==TmItemQuality.emItemQuality_Yellow then
        nMaxExp = nMaxExp*LuaDataStatic.SpWisdomUp().YellowExpRatio; 
     elseif quality==TmItemQuality.emItemQuality_Red then
        nMaxExp = nMaxExp*LuaDataStatic.SpWisdomUp().RedExpRatio; 
     elseif quality==TmItemQuality.emItemQuality_Orange then
        nMaxExp = nMaxExp*LuaDataStatic.SpWisdomUp().GoldExpRatio; 
    end
    return nMaxExp;
end
--得到技能在图鉴索引
function LuaDataStatic.GetSkillConfigIndex(skillID)
    local skillTpl =  LuaDataStatic.SearchSkillTpl(skillID);
    local skillConfig = LuaDataStatic.SearchTplForName("StudySkillConfig");
    if(skillTpl == nil or skillConfig == nil)
    then
        return -1;
    end
    for i = 1, #skillConfig.StudyData
    do
        local skillData = skillConfig.StudyData[i];
        if(skillData ~= nil and skillData.SkillID == skillTpl.SkillInitID)
        then
            return i;
        end
    end
    return -1;
end

--得到技能数据
function LuaDataStatic.GetSkillConfigData(skillID)
    local skillTpl =  LuaDataStatic.SearchSkillTpl(skillID);
    local skillConfig = LuaDataStatic.SearchTplForName("StudySkillConfig");
    if(skillTpl == nil or skillConfig == nil)
    then
        return nil;
    end
    for i = 1, #skillConfig.StudyData
    do
        local skillData = skillConfig.StudyData[i];
        if(skillData ~= nil and skillData.SkillID == skillTpl.SkillInitID)
        then
            return skillData;
        end
    end
    return nil;
end
--得到友好度培养所需总经验
function LuaDataStatic.GetFriendTrainNeedExp(friendPhase, friendLv, friendExp)
    local levelTpl = LuaDataStatic.SearchTplForName("Favorability");
    if(levelTpl == nil)
    then
        return 0;
    end
    local needExp = 0;
    for i = 1, #levelTpl.Favorability
    do
        local lv = 0;
        if(i > friendPhase)
        then
            break;
        elseif(i == friendPhase)
        then
            lv = friendLv;
        else
            lv = #levelTpl.Favorability[i].Favorability;
        end

        for j = 1, lv
        do
            needExp = needExp + levelTpl.Favorability[i].Favorability[j];
        end
    end
    needExp = needExp + friendExp;
    return needExp;
end


