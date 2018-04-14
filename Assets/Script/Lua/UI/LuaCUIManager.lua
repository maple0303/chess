--require "UI/mainui/LuaCUIMainBottomBar";
--require "UI/mainui/LuaCUIMainTopBar";
--require "UI/mainui/LuaCUIHeroHead";
--require "UI/Equip/LuaCUIEquip";
--require "UI/Fb/LuaCUIOneFbItem";
--require "UI/Fb/LuaCUICommonFB";
--require "UI/Fb/LuaCUIFBTraining";
--require "UI/Fb/LuaCUIStarHeroList";
--require "UI/Task/LuaCUINpcDlg";
--require "UI/Chat/LuaCUIChat";
--require "UI/StudySkill/LuaCUIStudySkill";
--require "UI/Equip/LuaCUIEnchaseBatch";
--require "UI/Equip/LuaCUIEquipCompose";
--require "UI/LuaCUIWorldMap";
--require "UI/Role/LuaCUIRole";
--require "UI/Tips/LuaCUIItemTips"
--require "UI/Tips/LuaCUIBatTips"
--require "UI/Tips/LuaCUISkillTips"
--require "UI/Tips/LuaCUIStudySkillTips"
--require "UI/Role/LuaCUIFoster";
--require "UI/LuaCUIMysticShop";
--require "UI/HeartMagic/LuaCUIImpartsSanctum";
--require "UI/HeartMagic/LuaCUIImpartsWisdom";
--require "UI/Role/LuaCUIMeridian";
--require "UI/confirm/LuaCUIConfirm";
--require "UI/School/LuaCUISchoolJoin";
--require "UI/dailytask/LuaCUIDailyView";
--require "UI/dailytask/LuaCUIDailyTaskItem";
--require "UI/dailytask/LuaCUIDailyTask";
--require "UI/dailytask/LuaCUIDailyTaskGetPrize";
--require "UI/LuaCUIUnlockFunctionPrompt"
--require "UI/warsport/LuaCUIArena";
--require "UI/LuaCUIArray";
--require "UI/LuaCUIRomance";
--require "UI/yunbiao/LuaCUIYunBiao";
--require "UI/yunbiao/LuaCUIYunBiaoDlg";
--require "UI/WorldBoss/LuaCUIWorldBossFunction";
--require "UI/activityAnswer/LuaCUIActivityAnswerCountdown";
--require "UI/LuaCUICreateCharacter";
--require "UI/LuaCUITavernList";
--require "UI/LuaCUIActivityViewItem";
--require "UI/LuaCUIVIP";
--require "UI/warsport/LuaCUIWarSportRank";
--require "UI/Fb/LuaCUIFbFail";
--require "UI/Fb/LuaCUIFbWin";
--require "UI/Task/LuaCUITaskTrace"
--require "UI/garden/LuaCUIGarden";
--require "UI/garden/LuaCUIGardenQua";
--require "UI/CampBattle/LuaCUICampBattle"
--require "UI/garden/LuaCUIGardenSeed";
--require "UI/WorldBoss/LuaCUIWorldBossBattleEnd"
--require "UI/Ride/LuaCUIRideInfo";
--require "UI/Ride/LuaCUIRideSelect";
--require "UI/LuaCUIShop";
--require "UI/LuaCUIBattleTopInfo";
--require "UI/LuaCUIMoneySymbol";
--require "UI/mail/LuaCUIMail";
--require "UI/openFunc/LuaCUIOpenFunc";
--require "UI/openFunc/LuaCUINextGuide";
--require "UI/School/LuaCUISchoolWeijie";
--require "UI/School/LuaCUISchoolTeacher";
--require "UI/School/LuaCUISchoolBattlefield";
--require "UI/LuaCUISports";
--require "UI/Guide/LuaCUIGuide";
--require "Game/LuaGuideManager";
--require "UI/HeartMagic/LuaCUIWisdomExchange"
--require "UI/LuaCUIPowerChange"
--require "UI/Tips/LuaCUIHeartTips"


LuaCUIManager = {};

local m_allUIlist = {};
function LuaCUIManager.Init()
    ---- 加载变灰材质
    --UnityEngine.Resources.Load("materials/UIColor Material");
    ----加载功能预告配置
    --LuaCUIUnlockFunctionPrompt.Init();
    ----加载功能引导配置
    --LuaGuideManager.Init();
    ---- 所有界面加载到ui列表里
    --m_allUIlist["LuaCUIMainBottomBar"] = LuaCUIMainBottomBar;
    --m_allUIlist["LuaCUIMainTopBar"] = LuaCUIMainTopBar;
    --m_allUIlist["LuaCUIHeroHead"] = LuaCUIHeroHead;
    --m_allUIlist["LuaCUIEquip"] = LuaCUIEquip;
    --m_allUIlist["LuaCUICommonFB"] = LuaCUICommonFB;
    --m_allUIlist["LuaCUINpcDlg"] = LuaCUINpcDlg;
    --m_allUIlist["LuaCUIChat"] = LuaCUIChat;
    --m_allUIlist["LuaCUIStudySkill"] = LuaCUIStudySkill;
    --m_allUIlist["LuaCUIEnchaseBatch"] = LuaCUIEnchaseBatch;
    --m_allUIlist["LuaCUIEquipCompose"] = LuaCUIEquipCompose;
    --m_allUIlist["LuaCUIStudySkill"] = LuaCUIStudySkill;
    --m_allUIlist["LuaCUIEnchaseBatch"] = LuaCUIEnchaseBatch;
    --m_allUIlist["LuaCUIWorldMap"] = LuaCUIWorldMap;
    --m_allUIlist["LuaCUIMysticShop"] = LuaCUIMysticShop;
    --m_allUIlist["LuaCUISchoolJoin"] = LuaCUISchoolJoin;
    --m_allUIlist["LuaCUIDailyView"] = LuaCUIDailyView;
    --m_allUIlist["LuaCUIArena"] = LuaCUIArena;
    --m_allUIlist["LuaCUIWarSportRank"] = LuaCUIWarSportRank;
    --m_allUIlist["LuaCUIFbFail"] = LuaCUIFbFail;
    --m_allUIlist["LuaCUIFbWin"] = LuaCUIFbWin;
    --m_allUIlist["LuaCUIGardenQua"] = LuaCUIGardenQua;
    --m_allUIlist["LuaCUIGarden"] = LuaCUIGarden;
    --m_allUIlist["LuaCUIGardenSeed"] = LuaCUIGardenSeed;
    --m_allUIlist["LuaCUIRideInfo"] = LuaCUIRideInfo;
    --m_allUIlist["LuaCUIRideSelect"] = LuaCUIRideSelect;
    --m_allUIlist["LuaCUIShop"] = LuaCUIShop;
    --m_allUIlist["LuaCUITaskTrace"] = LuaCUITaskTrace;
    --m_allUIlist["LuaCUIRole"] = LuaCUIRole;
    --m_allUIlist["LuaCUIMoneySymbol"] = LuaCUIMoneySymbol;
    --m_allUIlist["LuaCUIMail"] = LuaCUIMail;
    --m_allUIlist["LuaCUISchoolWeijie"] = LuaCUISchoolWeijie;
    --m_allUIlist["LuaCUINextGuide"] = LuaCUINextGuide;
    --m_allUIlist["LuaCUISchoolTeacher"] = LuaCUISchoolTeacher;
    --m_allUIlist["LuaCUISchoolBattlefield"] = LuaCUISchoolBattlefield;
    --m_allUIlist["LuaCUISports"] = LuaCUISports;
    --m_allUIlist["LuaCUIGuide"] = LuaCUIGuide;
    --m_allUIlist["LuaCUIStarHeroList"] = LuaCUIStarHeroList;
    --m_allUIlist["LuaCUIActivityViewItem"] = LuaCUIActivityViewItem;
    --m_allUIlist["LuaCUIDailyView"] = LuaCUIDailyView;
    --m_allUIlist["LuaCUIYunBiao"] = LuaCUIYunBiao;
    --m_allUIlist["LuaCUIGuide"] = LuaCUIGuide;
    --m_allUIlist["LuaCUIDailyTaskGetPrize"] = LuaCUIDailyTaskGetPrize;
    ---- 显示游戏主界面
    --if(not LuaCMapModule.IsInPlotMap()) then
    --    --print("主界面6");
    --    LuaCUIManager.ShowMainUI();
    --    -- 如果门派功能开启，但是没有加入门派，需要显示加入门派界面
    --    if (LuaCMainFunction.HasFunction(LuaCMainFunctionType.MAIN_FUNCTION_SCHOOL) and LuaCSchoolProperty.schoolType == 0) then
		--    --LuaCUISchoolJoin.ShowUI();
	 --   end
    --end
end

function LuaCUIManager.ShowMainUI()
--print("显示主界面");
    LuaCUIMainBottomBar.ShowUI();
    LuaCUIMainTopBar.ShowUI();
    LuaCUIHeroHead.ShowUI();
    LuaCUINextGuide.showNextGuide();
    LuaGuideManager.ShowTaskGuide();
end

--关闭所有UI界面
function LuaCUIManager.CloseAllUI()
--print("关闭界面");
    for i, ui in pairs(m_allUIlist) do
        ui.HideUI();
    end
end
