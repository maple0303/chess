--region *.lua
--Date
--此文件由[BabeLua]插件自动生成

LuaCBattleManager = 
{
    m_bJump = false,
 };
local this = LuaCBattleManager;

local m_FBMapid = 0;
local m_FBIndex = 0;
local m_BattleMapID = 0;
local m_strMapNameUrl = "";
local m_arrOgreList = { };
local m_arrMoving = { };            -- 移动中的
local m_arrLoadUrl = {};
local m_nCurProgress = 0;
local m_bossInfo = {};

-- 进入普通副本
function LuaCBattleManager.EnterCommonFB(nMapID, nFBIndex)
--    if (GameFrameWork.mGameState ~= GameFrameWork.GAMG_STATE_CITY) then
--        -- 非城镇状态不能进入
--        LuaCUIFlyTips.ShowFlyTips(LanguageData.GetLanguageText("UI_WEBGAME_001"));
--        return;
--    end
    LuaCProModule.SendCommonInstanceFightRequest(nMapID, nFBIndex, BATTLE_TYPE_OGRE);
    m_FBMapid = nMapID;
    m_FBIndex = nFBIndex;
end
--进入精英副本
function LuaCBattleManager.EnterHeroFB(nMapID,nFBIndex,nBattleMapID,strMapNameUrl,nOgreID)
--	if (GameFrameWork.mGameState ~= GameFrameWork.GAMG_STATE_CITY) then
--        LuaCUIFlyTips.ShowFlyTips(LanguageData.GetLanguageText("UI_WEBGAME_001"));
--		return ;--非城镇状态不能进入
--	end
	m_BattleMapID = nBattleMapID;
	m_strMapNameUrl = strMapNameUrl;
	m_arrOgreList = {};
    table.insert(m_arrOgreList,{ogre = nOgreID});
	LuaCProModule.SendCommonInstanceFightRequest(nMapID, nFBIndex, BATTLE_TYPE_HERO_OGRE)
end
--进入pvp副本加载相关资源
function LuaCBattleManager.EnterPvPFB()
--	if (GameFrameWork.mGameState ~= GameFrameWork.GAMG_STATE_CITY) then
--        LuaCUIFlyTips.ShowFlyTips(LanguageData.GetLanguageText("UI_WEBGAME_001"));
--		return ;--非城镇状态不能进入
--	end
	LuaCArenaModule.SendCMessageChallengeRequest(LuaCProModule.m_nPvPChallengID)
end
--进入迷宫副本
function LuaCBattleManager.EnterMazeFB(shenmi, mapid, nOgreID)
	if (GameFrameWork.mGameState ~= GameFrameWork.GAMG_STATE_CITY) then
        LuaCUIFlyTips.ShowFlyTips(LanguageData.GetLanguageText("UI_WEBGAME_001"));
		return ;--非城镇状态不能进入
	end
	this.m_BattleMapID = mapid;
    this.m_arrOgreList = {};
    table.insert(this.m_arrOgreList, {ogre = nOgreID});
	LuaCProModule.SendCMessageMazeFightRequest(shenmi)
end
	--进入门派位阶挑战
function LuaCBattleManager.EnterWeijieFB(line, i, nOgreID)
--	if (GameFrameWork.mGameState ~= GameFrameWork.GAMG_STATE_CITY) then
--        LuaCUIFlyTips.ShowFlyTips(LanguageData.GetLanguageText("UI_WEBGAME_001"));
--		return ;--非城镇状态不能进入
--	end
    this.m_arrOgreList = {};
    table.insert(this.m_arrOgreList,{ogre = nOgreID});
	LuaCSchoolModule.SendCMessageChallengeOfficalRequest(line, i);
end
	--进入怒闯聚贤庄
function LuaCBattleManager.EnterJXZFB(nOgreID)
	if (LuaCBattleProcessManager.m_BattleProcessData == nil or LuaCBattleProcessManager.m_BattleProcessData.m_nBattleType ~= LuaProDefine.BATTLE_TYPE_JXZ) then
		if (GameFrameWork.mGameState ~= GameFrameWork.GAMG_STATE_CITY) then
            LuaCUIFlyTips.ShowFlyTips(LanguageData.GetLanguageText("UI_WEBGAME_001"));
			return ;--非城镇状态不能进入
		end
	end
	LuaCBattleProcessManager.m_BattleProcessData = nil;
	LuaCProModule.ClearBattleList();
    this.m_arrOgreList = {};
    table.insert(this.m_arrOgreList,{ogre = nOgreID});
	LuaCProModule.SendCMessageJXZFightRequest();
end
	--战斗回放
function LuaCBattleManager.EnterPvPFBPlayBack(nPlayBackID,nType,isBack)
	if nType == nil then nType = 0 end
	if isBack == nil then isBack = true end
--	if (GameFrameWork.mGameState ~= GameFrameWork.GAMG_STATE_CITY) then
--        LuaCUIFlyTips.ShowFlyTips(LanguageData.GetLanguageText("UI_WEBGAME_001"));
--		return ;--非城镇状态不能进入
--	end
	if (isBack == true) then
		isReplayBattle = true;
	else
		isReplayBattle = false;
	end
	--场景信息,type:0为本地录像，1：全局录像
	LuaCProModule.SendPlayBackBattleRequest(nPlayBackID,nType);
end
	--进入师门挑战
function LuaCBattleManager.EnterChallengeApprentice()
--	if (GameFrameWork.mGameState ~= GameFrameWork.GAMG_STATE_CITY) then
--		LuaCUIFlyTips.ShowFlyTips(LanguageData.GetLanguageText("UI_WEBGAME_001"));
--		return ;--非城镇状态不能进入
--	end
end
	--进入运镖挑战
function LuaCBattleManager.EnterDartFB(dartIndex)
	if (GameFrameWork.mGameState ~= GameFrameWork.GAMG_STATE_CITY) then
		LuaCUIFlyTips.ShowFlyTips(LanguageData.GetLanguageText("UI_WEBGAME_001"));
		return ;--非城镇状态不能进入
	end
end
	--如果是PC进入PC的登陆界面0
function LuaCBattleManager.EnterSchoolMasterFB()
	if (GameFrameWork.mGameState ~= GameFrameWork.GAMG_STATE_CITY) then
		LuaCUIFlyTips.ShowFlyTips(LanguageData.GetLanguageText("UI_WEBGAME_001"));
		return ;--非城镇状态不能进入
	end
end
	--进入世界boss战，加载相关资源
function LuaCBattleManager.EnterWorldBossFB(nBattleMapID)
--	--设置玩家停止移动
--	LuaEntityManager.m_hero.StopMove();
end
-- 接收服务器战斗通知
function LuaCBattleManager.OnBattleProcessNotify()
    if (LuaCBattleProcessManager.m_BattleProcessData ~= nil) then
        -- 正在播放战斗则先退出
        if(this.m_bJump) then
            LuaCBattleProcessManager.m_BattleProcessData = LuaCProModule.GetFirstBattleProcess();
        end
        return;
    end

    LuaCBattleProcessManager.m_nBattleState = BATTLE_INIT;
    LuaCBattleProcessManager.m_BattleProcessData = LuaCProModule.GetFirstBattleProcess();
    if (LuaCBattleProcessManager.m_BattleProcessData == nil) then
        --GameFrameWork.mGameState = GAMG_STATE_CITY;
        return;
    end
    LuaCUILoadingPanel.ShowUI();

    if (LuaCBattleProcessManager.m_BattleProcessData.m_nBattleType == BATTLE_TYPE_ARENA) then
        m_BattleMapID = 10003;
        m_strMapNameUrl = "";
        m_arrOgreList = { };
    elseif (LuaCBattleProcessManager.m_BattleProcessData.m_nBattleType == BATTLE_TYPE_SchoolChallenge_pvp
        or LuaCBattleProcessManager.m_BattleProcessData.m_nBattleType == BATTLE_TYPE_SchoolChallenge_pve) then
        m_BattleMapID = 10006;
        m_strMapNameUrl = "";
    elseif (LuaCBattleProcessManager.m_BattleProcessData.m_nBattleType == BATTLE_TYPE_Maze
        or LuaCBattleProcessManager.m_BattleProcessData.m_nBattleType == BATTLE_TYPE_MysticMaze) then
        m_strMapNameUrl = "";
    elseif (LuaCBattleProcessManager.m_BattleProcessData.m_nBattleType == BATTLE_TYPE_DART) then
        m_BattleMapID = 10005;
        m_strMapNameUrl = "";
        m_arrOgreList = { };
    elseif (LuaCBattleProcessManager.m_BattleProcessData.m_nBattleType == BATTLE_TYPE_JXZ) then
        m_BattleMapID = 2015;
        m_strMapNameUrl = "";
    elseif (LuaCBattleProcessManager.m_BattleProcessData.m_nBattleType == BATTLE_TYPE_WORLD_BOSS) then
        m_BattleMapID = LuaCActivityModule.mBattleMapID;
        m_strMapNameUrl = "";
        m_arrOgreList = { };
    elseif (LuaCBattleProcessManager.m_BattleProcessData.m_nBattleType == BATTLE_TYPE_CAMPBATTLE) then
        m_BattleMapID = 10004;
        m_strMapNameUrl = "";
        m_arrOgreList = { };
    elseif (LuaCBattleProcessManager.m_BattleProcessData.m_nBattleType == BATTLE_TYPE_FACTIONWAR) then
        m_BattleMapID = 10007;
        m_strMapNameUrl = "";
        m_arrOgreList = { };
    elseif (LuaCBattleProcessManager.m_BattleProcessData.m_nBattleType == BATTLE_TYPE_SCHOOLBATTLE_PVE
        or LuaCBattleProcessManager.m_BattleProcessData.m_nBattleType == BATTLE_TYPE_SCHOOLBATTLE_PVP
        or LuaCBattleProcessManager.m_BattleProcessData.m_nBattleType == BATTLE_TYPE_SchoolApprientice) then
        m_BattleMapID = 10003;
        m_strMapNameUrl = "";
        m_arrOgreList = { };
    elseif (LuaCBattleProcessManager.m_BattleProcessData.m_nBattleType == BATTLE_TYPE_FactionBoss) then
        m_BattleMapID = 10008;
        m_strMapNameUrl = "";
        m_arrOgreList = { };
    elseif (LuaCBattleProcessManager.m_BattleProcessData.m_nBattleType == BATTLE_TYPE_LocalSelectWar) then
        m_BattleMapID = 2030;
        m_strMapNameUrl = "";
        m_arrOgreList = { };
    elseif (LuaCBattleProcessManager.m_BattleProcessData.m_nBattleType == BATTLE_TYPE_WorldArena) then
        m_BattleMapID = 10003;
        m_strMapNameUrl = "";
        m_arrOgreList = { };
    end
    
    --  隐藏主角形象，主相机设置到0,0点
    LuaEntityManager.m_hero.gameObject:SetActive(false);
    local mainGameObject = UnityEngine.GameObject.Find("GameMain");
    if (UnityEngine.Camera.main ~= nil) then
        UnityEngine.Camera.main.transform.position = UnityEngine.Vector3.New(0, 0, UnityEngine.Camera.main.transform.position.z);
    end
    this.LoadBattleRes();
end

--加载战斗资源
function LuaCBattleManager.LoadBattleRes()
    -- 关闭所有界面
    local nTotal = 0;

    ExeCoroutineTask(LuaCUIManager.CloseAllUI, 
        function()
            m_nCurProgress = m_nCurProgress + 1;
            LuaCUILoadingPanel.updateProgressBar(m_nCurProgress / nTotal * 100);
        end);
    nTotal = nTotal + 1;

    --  加载地图资源
    if (LuaCBattleProcessManager.m_BattleProcessData.m_nBattleType == BATTLE_TYPE_OGRE) then
        -- 剧情副本
        m_BattleMapID = 0;
        m_strMapNameUrl = ""
        m_arrOgreList = { };
        this.OnLoadBattleCityMapConfig("config/fb/" .. LuaCBattleProcessManager.m_BattleProcessData.m_nBattleCityMapID);
    elseif (LuaCBattleProcessManager.m_BattleProcessData.m_nBattleType == BATTLE_TYPE_JXZ) then
        if (LuaCJXZData.SummonNum > 0) then
            local tplJXZConfig = LuaDataStatic.SearchTplForName("JXZConfig");
            if (tplJXZConfig ~= nil) then
                -- 召唤了乔峰，加载乔峰的技能
                for i, sumobj in ipairs(tplJXZConfig.SummonPartner) do
                    if (LuaCJXZData.fightStage <= sumobj.Level) then
                        local tplOgrePartner = LuaDataStatic.SearchOgrePartnerTpl(sumobj.PartnerID);
                        if (tplOgrePartner ~= nil) then
                            this.LoadSkillEffect(tplOgrePartner.SkillID);
                        end
                        break;
                    end
                end
            end
        end
        if (LuaCJXZData.UseSkill) then
            -- 使用了乾坤一掷
            this.LoadSkillEffect(tplJXZConfig.NirvanaSkillID);
        end
    end

    -- 加载战斗场景
    if(LuaCBattleProcessManager.m_BattleScene == nil) then
        LoadResAsync("Prefabs/battle/battlescene.prefab", 
            function(scenePrefabObj)
                if(scenePrefabObj == nil) then
                    return;
                end
                local battlescene = UnityEngine.GameObject.Instantiate(scenePrefabObj);
                battlescene.name = "battlescene";
                UnityEngine.GameObject.DontDestroyOnLoad(battlescene);
                LuaCBattleProcessManager.m_BattleScene = battlescene;

                if(LuaCBattleProcessManager.m_BattleScene ~= nil) then
                    LuaCBattleProcessManager.m_BattleScene:SetActive(true);
                    LuaCBattleProcessManager.m_battleEffectCtl = LuaCBattleProcessManager.m_BattleScene:GetComponent("CBattleEffectController");
                end
                m_nCurProgress = m_nCurProgress + 1;
                LuaCUILoadingPanel.updateProgressBar(m_nCurProgress / nTotal * 100);
            end
        );
    else
        if(LuaCBattleProcessManager.m_BattleScene ~= nil) then
            LuaCBattleProcessManager.m_BattleScene:SetActive(true);
            LuaCBattleProcessManager.m_battleEffectCtl = LuaCBattleProcessManager.m_BattleScene:GetComponent("CBattleEffectController");
        end
    end
    nTotal = nTotal + 1;

    GetAssetSpriteAsync(m_BattleMapID, "Textures/battlemap/" .. m_BattleMapID .. ".png", 
        function(sp)
            local mapSprite = LuaCBattleProcessManager.m_BattleScene.transform:FindChild("mapsprite");
            if (mapSprite ~= nil) then
                local spriteReander = mapSprite:GetComponent("SpriteRenderer");
                if (spriteReander ~= nil) then
                    GetAssetSpriteAsync(m_BattleMapID, "Textures/battlemap/" .. m_BattleMapID .. ".png", 
                        function(sp)
                            spriteReander.sprite = sp;
                            if(spriteReander.sprite ~= nil) then
                	            spriteReander.sprite.name = m_BattleMapID;
				            end
                            m_nCurProgress = m_nCurProgress + 1;
                            LuaCUILoadingPanel.updateProgressBar(m_nCurProgress / nTotal * 100);
                        end);
                end
            end
            m_nCurProgress = m_nCurProgress + 1;
            LuaCUILoadingPanel.updateProgressBar(m_nCurProgress / nTotal * 100);
        end);
    nTotal = nTotal + 1;

    -- 加载背景音乐
    local audioUrl = "";
    local nBattleType = LuaCBattleProcessManager.m_BattleProcessData.m_nBattleType;
    if(nBattleType ~= BATTLE_TYPE_CAMPBATTLE and nBattleType ~= BATTLE_TYPE_WORLD_BOSS) then
        -- 判断是否开启声音
--	    if (LuaCUISystemSetting.m_bPlaySound) then
		    --根据不同战斗类型播放不同音乐
		    if (nBattleType == BATTLE_TYPE_OGRE or nBattleType == BATTLE_TYPE_HERO_OGRE or nBattleType == BATTLE_TYPE_SCHOOLMASTER_PVE or nBattleType == BATTLE_TYPE_SCHOOLBATTLE_PVE) then
			    --播放pve音乐
		        audioUrl = "Sound/bgm/pve.mp3";
		    elseif (nBattleType == BATTLE_TYPE_ARENA or nBattleType == BATTLE_TYPE_DART or nBattleType == BATTLE_TYPE_SCHOOLMASTER_PVE or nBattleType == BATTLE_TYPE_SCHOOLMASTER_PVP or nBattleType == BATTLE_TYPE_SCHOOLBATTLE_PVP
                or nBattleType == BATTLE_TYPE_SchoolChallenge_pvp or nBattleType == BATTLE_TYPE_SchoolChallenge_pve or nBattleType == BATTLE_TYPE_SchoolApprientice or nBattleType == BATTLE_TYPE_LocalSelectWar or nBattleType == BATTLE_TYPE_WorldArena) then
			    --播放pvp音乐
		        audioUrl = "Sound/bgm/pvp.mp3";
		    elseif (nBattleType == BATTLE_TYPE_JXZ) then
			    if (LuaCJXZData.fightStage == 0) then
				    audioUrl = "Sound/bgm/pvp.mp3";
			    end
		    end
--	    end
    end

    -- 加载背景音乐
    LoadResAsync(audioUrl, 
        function(audioClip)
            if(LuaCBattleProcessManager.m_BattleScene ~= nil) then
                local audioSource = LuaCBattleProcessManager.m_BattleScene:GetComponent("AudioSource");
                if(audioSource ~= nil) then
                    audioSource.clip = audioClip;
                    m_nCurProgress = m_nCurProgress + 1;
                    LuaCUILoadingPanel.updateProgressBar(m_nCurProgress / nTotal * 100);
                end
            end
        end );
    nTotal = nTotal + 1;

    -- 加载界面资源
    ExeCoroutineTask(
        function()
            LuaCUIBattleTopInfo.ShowUI();
            LuaCUILoadingPanel.SetAsLastSibling();
            LuaCUIBattleTopInfo.UpdateMapName(m_strMapNameUrl);
            LuaCUIBattleTopInfo.ClearLeftHead();
        end, function()
            m_nCurProgress = m_nCurProgress + 1;
            LuaCUILoadingPanel.updateProgressBar(m_nCurProgress / nTotal * 100);
        end
    );
    nTotal = nTotal + 1;

    --  加载战斗角色资源
    this.CreatRole();
    nTotal = nTotal + 1;
    LuaCUILoadingPanel.updateProgressBar(m_nCurProgress / nTotal * 100);
end

function LuaCBattleManager.LoadComplete()
    LuaCitySceneManager.StopSceneSound();

    local bDirectionLeft = false;
    -- true左false右
    if (LuaCBattleProcessManager.m_BattleProcessData.m_nBattlePlayerID1 == LuaCHeroProperty.mCharID) then
        bDirectionLeft = true;
    else
        bDirectionLeft = false;
    end
    -- 创建自己的战斗角色
    local battleRoleInfo = nil;
    if (bDirectionLeft) then
        battleRoleInfo = LuaCBattleProcessManager.m_BattleProcessData.m_BattleLeftPlayerInfo;
    else
        battleRoleInfo = LuaCBattleProcessManager.m_BattleProcessData.m_BattleRightPlayerInfo;
    end
    this.InitRoleHeadInfo(battleRoleInfo, bDirectionLeft);
    -- 创建对方战斗角色
    if (LuaCBattleProcessManager.m_BattleProcessData.m_nBattleType == BATTLE_TYPE_ARENA
        or LuaCBattleProcessManager.m_BattleProcessData.m_nBattleType == BATTLE_TYPE_DART
        or LuaCBattleProcessManager.m_BattleProcessData.m_nBattleType == BATTLE_TYPE_SCHOOLMASTER_PVP
        or LuaCBattleProcessManager.m_BattleProcessData.m_nBattleType == BATTLE_TYPE_SCHOOLBATTLE_PVP
        or LuaCBattleProcessManager.m_BattleProcessData.m_nBattleType == BATTLE_TYPE_SchoolChallenge_pvp
        or LuaCBattleProcessManager.m_BattleProcessData.m_nBattleType == BATTLE_TYPE_CAMPBATTLE
        or LuaCBattleProcessManager.m_BattleProcessData.m_nBattleType == BATTLE_TYPE_FACTIONWAR
        or LuaCBattleProcessManager.m_BattleProcessData.m_nBattleType == BATTLE_TYPE_SchoolApprientice
        or LuaCBattleProcessManager.m_BattleProcessData.m_nBattleType == BATTLE_TYPE_LocalSelectWar
        or LuaCBattleProcessManager.m_BattleProcessData.m_nBattleType == BATTLE_TYPE_WorldArena) then
        -- 和其他玩家战斗
        if (bDirectionLeft) then
            battleRoleInfo = LuaCBattleProcessManager.m_BattleProcessData.m_BattleRightPlayerInfo;
        else
            battleRoleInfo = LuaCBattleProcessManager.m_BattleProcessData.m_BattleLeftPlayerInfo;
        end
        this.InitRoleHeadInfo(battleRoleInfo, not bDirectionLeft);
    end

    if (LuaCBattleProcessManager.m_BattleProcessData.m_nBattleType == BATTLE_TYPE_SCHOOLBATTLE_PVE 
    or LuaCBattleProcessManager.m_BattleProcessData.m_nBattleType == BATTLE_TYPE_SCHOOLBATTLE_PVP 
    or LuaCBattleProcessManager.m_BattleProcessData.m_nBattleType == BATTLE_TYPE_FACTIONWAR) then
	--				CUISchoolBattleFight.gSchoolBattleFight.mFightBase.addChild(CUIManager.gUIManager.mSceneChangeEffect);
	--				CUIManager.gUIManager.mSceneChangeEffect.x=m_BattleMap.mMapVisualStartX;
	--				CUIManager.gUIManager.mSceneChangeEffect.y=m_BattleMap.mMapVisualStartY;
	--				CUIManager.gUIManager.mSceneChangeEffect.scaleX=m_BattleMap.scaleX;
	--				CUIManager.gUIManager.mSceneChangeEffect.scaleY=m_BattleMap.scaleY;
--		CUISchoolBattleFight.gSchoolBattleFight.Show(true);
	else
	--				CUIChat.gUIChat.visible=true;
	--				CUINotice.gUINotice.visible=true;
	--				CUIBattleJump.gUIBattleJump.ShowUI();
	--				CUIBattleJump.gUIBattleJump.ChangeBtn(true);
		if (LuaCBattleProcessManager.m_BattleProcessData.m_nBattleType == BATTLE_TYPE_ARENA 
        or LuaCBattleProcessManager.m_BattleProcessData.m_nBattleType == BATTLE_TYPE_DART 
        or LuaCBattleProcessManager.m_BattleProcessData.m_nBattleType == BATTLE_TYPE_SchoolChallenge_pvp 
        or LuaCBattleProcessManager.m_BattleProcessData.m_nBattleType == BATTLE_TYPE_SchoolApprientice 
        or LuaCBattleProcessManager.m_BattleProcessData.m_nBattleType == BATTLE_TYPE_LocalSelectWar 
        or LuaCBattleProcessManager.m_BattleProcessData.m_nBattleType == BATTLE_TYPE_WorldArena) then
			LuaCUIBattleTopInfo.ShowEnermyRoleInfo();
			LuaCUIBattleTopInfo.ShowRightMemberInfo();
			LuaCUIBattleTopInfo.ClearRightHead();
		end
--		if (LuaCBattleProcessManager.m_BattleProcessData.m_nBattleType == LuaProDefine.BATTLE_TYPE_JXZ) then
--			CUIJXZBattleInfo.gCUIJXZBattleInfo.ShowUI();
--		end
	end
    
    -- 隐藏loading界面
    LuaCUILoadingPanel.HideUI();

    this.OnLoadBattleSceneing();
end

function LuaCBattleManager.OnLoadBattleSceneing()
    --检测角色入场动画
    this.CheckRoleEnterEffect();
end

-- 加载副本配置文件
function LuaCBattleManager.OnLoadBattleCityMapConfig(strUrl)
    local xmlData = LoadXmlData(strUrl);
    if(xmlData == nil) then
        return;
    end
    local FBConfigXml = this.GetFBConfigXml(xmlData);
    if (FBConfigXml == nil) then
        return;
    end
    local nMapID = FBConfigXml.Attributes["mapid"];
    if (nMapID == "" or nMapID == "0") then
        return;
    end
    m_BattleMapID = nMapID;
    -- 获得副本名称资源信息
    for i, childData in ipairs(FBConfigXml.ChildNodes) do
        if(childData.Name == "nameurl") then
            m_strMapNameUrl = childData.InnerText;
        end
    end
    -- 判断是否有剧情，有的话先播剧情，再播战斗
    local bStory = false;
    local OgreListXml = this.GetFBOgreListXml(FBConfigXml);
    if (OgreListXml == nil) then
        return;
    end

    m_arrOgreList = { };
    for key, ogrexml in pairs(OgreListXml.ChildNodes) do
        -- 加载剧情相关资源
        local nBeginStoryID = 0;
        local strStoryID = ogrexml.Attributes["BeginStoryID"];
        if (strStoryID ~= "" and strStoryID ~= "0") then
            nBeginStoryID = tonumber(strStoryID)
        end
        local nEndStoryID = 0;
        strStoryID = ogrexml.Attributes["EndStoryID"];
        if (strStoryID ~= "" and strStoryID ~= "0") then
            nEndStoryID = tonumber(strStoryID);
        end
        -- 加载怪物资源
        local nOgreID = 0;
        local strOgreID = ogrexml.Attributes["id"];
        if (strOgreID ~= "" and strOgreID ~= "0") then
            nOgreID = tonumber(strOgreID);
        end
        
        table.insert(m_arrOgreList,
        {
            ogre = nOgreID,
            beginstory = nBeginStoryID,
            endstory = nEndStoryID,
        } );
    end
end
-- 获得副本配置文件
function LuaCBattleManager.GetFBConfigXml(xmlData)
    local childxml;
    if (xmlData == nil) then
        return nil;
    end

    local nFBIndex = 0;
    -- 初始化游戏公告按钮0
    for key, childxml in ipairs(xmlData.ChildNodes) do
        if (childxml.Name == "FB") then
            -- 找到对应的副本
            if (nFBIndex == LuaCBattleProcessManager.m_BattleProcessData.m_nBattleFBIndex) then
                -- 加载战场地图
                return childxml;
            end
            nFBIndex = nFBIndex + 1;
        end
    end
    return nil;
end
-- 获得副本怪物列表配置文件
function LuaCBattleManager.GetFBOgreListXml(fbConfigXml)
    local ogreList
    if (fbConfigXml == nil) then
        return nil;
    end

    for each, ogreList in ipairs(fbConfigXml.ChildNodes) do
        if (ogreList.Name == "OgreList") then
            return ogreList;
        end
    end
    return nil;
end
-- 创建战斗角色资源
function LuaCBattleManager.CreatRole()
    -- 创建自己
    -- 得到出阵的伙伴基本信息数组
    local bDirectionLeft = false;
    -- true左false右
    if (LuaCBattleProcessManager.m_BattleProcessData.m_nBattlePlayerID1 == LuaCHeroProperty.mCharID) then
        bDirectionLeft = true;
    else
        bDirectionLeft = false;
    end
    -- 创建自己的战斗角色
    local battleRoleInfo = nil;
    if (bDirectionLeft) then
        battleRoleInfo = LuaCBattleProcessManager.m_BattleProcessData.m_BattleLeftPlayerInfo;
    else
        battleRoleInfo = LuaCBattleProcessManager.m_BattleProcessData.m_BattleRightPlayerInfo;
    end
    this.CreatRoleArrayResoure(battleRoleInfo, bDirectionLeft, true);
    -- 创建对方战斗角色
    if (LuaCBattleProcessManager.m_BattleProcessData.m_nBattleType == BATTLE_TYPE_ARENA
        or LuaCBattleProcessManager.m_BattleProcessData.m_nBattleType == BATTLE_TYPE_DART
        or LuaCBattleProcessManager.m_BattleProcessData.m_nBattleType == BATTLE_TYPE_SCHOOLMASTER_PVP
        or LuaCBattleProcessManager.m_BattleProcessData.m_nBattleType == BATTLE_TYPE_SCHOOLBATTLE_PVP
        or LuaCBattleProcessManager.m_BattleProcessData.m_nBattleType == BATTLE_TYPE_SchoolChallenge_pvp
        or LuaCBattleProcessManager.m_BattleProcessData.m_nBattleType == BATTLE_TYPE_CAMPBATTLE
        or LuaCBattleProcessManager.m_BattleProcessData.m_nBattleType == BATTLE_TYPE_FACTIONWAR
        or LuaCBattleProcessManager.m_BattleProcessData.m_nBattleType == BATTLE_TYPE_SchoolApprientice
        or LuaCBattleProcessManager.m_BattleProcessData.m_nBattleType == BATTLE_TYPE_LocalSelectWar
        or LuaCBattleProcessManager.m_BattleProcessData.m_nBattleType == BATTLE_TYPE_WorldArena) then
        -- 和其他玩家战斗
        if (bDirectionLeft) then
            battleRoleInfo = LuaCBattleProcessManager.m_BattleProcessData.m_BattleRightPlayerInfo;
        else
            battleRoleInfo = LuaCBattleProcessManager.m_BattleProcessData.m_BattleLeftPlayerInfo;
        end
        this.CreatRoleArrayResoure(battleRoleInfo, not bDirectionLeft, false);
    else
        -- 打怪
        this.CreatOgreArrayResoure();
    end
end

--检测角色入场动画
function LuaCBattleManager.CheckRoleEnterEffect()
    if(#m_arrMoving == 0) then
        -- 加载完成开始副本
        this.StartFB();
--        LuaCBattleProcessManager.StartFB();
        return;
    end

    local nCurPriority = 100;
    for i, roleInfo in ipairs(m_arrMoving) do
        local bMoving = roleInfo.isMoving;
        if(bMoving) then
            return;
        end
        local priority = roleInfo.priority;
        if(priority < nCurPriority) then
            nCurPriority = priority;
        end
    end

    for j, roleInfo in ipairs(m_arrMoving) do
        if(roleInfo.priority == nCurPriority) then
            roleInfo.isMoving = true;
            local role = roleInfo.role;
            if(roleInfo.action == "run") then
                role:PlayRunAnimation();
                role:MoveToPosition(roleInfo.targetPos, LuaCBattleManager.OnEnterEnd);
            else
                role:PlayRunAnimation();
                role:JumpToPosition(LuaCBattleProcessManager.m_battleEffectCtl.m_fJumpTime, roleInfo.targetPos, LuaCBattleManager.OnEnterEnd);
            end
        end
    end
end
--角色入场结束
function LuaCBattleManager.OnEnterEnd(role)
    role:PlayStandAnimation();

    for i, roleInfo in ipairs(m_arrMoving) do
        if(roleInfo.role == role) then
            table.remove(m_arrMoving, i);
        end
    end
    this.CheckRoleEnterEffect();
end

-- 创建角色战斗资源
function LuaCBattleManager.CreatRoleArrayResoure(battleRoleInfo, left, bMySelf)
    local nMemberIndex = 1;
    for n, dataObject in ipairs(battleRoleInfo.MemberFightInfo) do
        -- 翅膀ID
        local nArtifactID = luabit.band(dataObject.ArtifactID, 0x00ffff);
        -- 战前触发的天赋ID
        local arrTalentID = { };
        for i, nTalentID in ipairs(dataObject.ArrTalentID) do
            table.insert(arrTalentID, nTalentID);
        end

        local prefabUrl = "";
        if (dataObject.tempid == 0) then
            -- 是主角自己
            prefabUrl = "Prefabs/Entity/Role/" .. battleRoleInfo:GetRoleBattleModuleName() .. ".prefab";
        else
            -- 找到伙伴模板
            local tplMember = LuaDataStatic.SearchPlayerPartnerTpl(dataObject.tempid);
            if (tplMember ~= nil) then
                prefabUrl = "Prefabs/Entity/Npc/" .. tplMember.ModelName .. "_battle.prefab";
            end
        end
        table.insert(m_arrLoadUrl, prefabUrl);
        if (dataObject.tempid == 0) then
            -- 创建战斗角色
            this.LoadRoleRes(prefabUrl, battleRoleInfo, dataObject, left, 0);
        else
            -- 创建战斗角色
            this.LoadRoleRes(prefabUrl, battleRoleInfo, dataObject, left, nMemberIndex);
            -- 找到伙伴模板
            local tplMember = LuaDataStatic.SearchPlayerPartnerTpl(dataObject.tempid);
            if (tplMember ~= nil) then
                nMemberIndex = nMemberIndex + 1;
            end
        end
    end
    -- --创建坐骑形象
--  local Ride = nil
    -- if (battleRoleInfo.PlayerRideID>0) then
    -- 	Ride=CRideSprite.new()
    -- 	Ride.LoadRideSwf(battleRoleInfo.PlayerRideID)
    -- 	if (left) then
    -- 		pos=this.m_BattleMap.GetLeftRidePos()
    -- 		Ride.mirror(1)
    -- 	else
    -- 		pos=this.m_BattleMap.GetRightRidePos()
    -- 		Ride.mirror(-1)
    -- 	end
    -- 	m_RideMap.put(Mpc.m_unEntityID+Mpc.mMapX,Ride)
    -- 	Ride.x=pos.x
    -- 	Ride.y=pos.y
    -- 	Ride.PlayAnimation()
    -- 	this.m_BattleMap.AddMapObj(Ride)
    -- end
    -- 初始化头顶信息
--    this.InitRoleHeadInfo(battleRoleInfo, left);
end

-- 创建战斗角色
function LuaCBattleManager.LoadRoleRes(prefabUrl, battleRoleInfo, dataObject, left, nMemberIndex)
    LoadResAsync(prefabUrl, 
        function(prefabObj)
            for i, url in ipairs(m_arrLoadUrl) do
                if(url == prefabUrl) then
                    table.remove(m_arrLoadUrl, i);
                end
            end
            
            if(prefabObj == nil) then
                return;
            end
            local roleGameObject = UnityEngine.GameObject.Instantiate(prefabObj);
            if (roleGameObject == nil) then
                return;
            end
            local Mpc = roleGameObject:GetComponent("CBattleRole");
            if(Mpc == nil) then
                return;
            end
            local battlePos = nil;
            if (left == true) then
                local posGameObject = UnityEngine.GameObject.Find("mapsprite/leftTeamPos/battle_pos"..(dataObject.pos + 1));
                if(posGameObject ~= nil) then
                    battlePos = posGameObject.transform.position;
                end
            else
                local posGameObject = UnityEngine.GameObject.Find("mapsprite/rightTeamPos/battle_pos"..(dataObject.pos + 1));
                if(posGameObject ~= nil) then
                    battlePos = posGameObject.transform.position;
                end
            end
            --设置移动速度
            if(LuaCBattleProcessManager.m_battleEffectCtl.m_fMoveSpeed > 0) then
                Mpc.m_nSpeed = LuaCBattleProcessManager.m_battleEffectCtl.m_fMoveSpeed;
            end

            Mpc.transform:SetParent(LuaCBattleProcessManager.m_BattleScene.transform, false);
            Mpc.name = Mpc.name .. "_" .. dataObject.pos;
            Mpc.m_unEntityID = dataObject.pos;
            -- 设置人物位置和方向
            if (battlePos ~= nil) then
                if(dataObject.tempid == 0) then
                    if (left) then
                        Mpc.transform.position = UnityEngine.Vector3.New(-7.5, battlePos.y + 1.5, 0);
                    else
                        Mpc.transform.position = UnityEngine.Vector3.New(7.5, battlePos.y + 1.5, 0);
                    end
                else
                    if (left) then
                        Mpc.transform.position = UnityEngine.Vector3.New(battlePos.x - 7.5, battlePos.y, 0);
                    else
                        Mpc.transform.position = UnityEngine.Vector3.New(battlePos.x + 7.5, battlePos.y, 0);
                    end
                end
            end

            if (dataObject.tempid == 0) then
                Mpc:SetRoleName(battleRoleInfo.Name);
                nMetierID = battleRoleInfo.PlayerMetier;
                nSkillID = battleRoleInfo.PlayerSKillID;
                Mpc.m_nTempID = 0;
                Mpc.m_nBattleSpriteType = BATTLE_SPRITE_TYPE_PLAYER;

                --加到入场动画移动列表中
                table.insert(m_arrMoving,
                {
                    role = Mpc, 
                    targetPos = battlePos,
                    priority = 2,
                    action = "jump",
                    isMoving = false,
                } );
            else
                -- 找到伙伴模板
                local tplMember = LuaDataStatic.SearchPlayerPartnerTpl(dataObject.tempid);
                if (tplMember ~= nil) then
                    Mpc:SetRoleName(CLanguageData.GetTplText(tplMember.Name));
    --                Mpc.m_strMemberBustUrl = "images/icon/bust/" .. tplMember.ModelName;
    --                Mpc.m_arrMatchData = tplMember.MatchData;
    --                Mpc.m_arrEnemyData.push(tplMember.EnemyData);
                    nMetierID = tplMember.MetierID;
                    nSkillID = tplMember.SkillID;
                    local strHeadUrl = "Textures/icon/head/big/boss/" .. tplMember.ModelName .. ".png";
                    LuaCUIBattleTopInfo.UpdateHeadIcon(nMemberIndex, strHeadUrl, Mpc.m_unEntityID, left);
                    nMemberIndex = nMemberIndex + 1;
                end

                Mpc.m_nTempID = dataObject.tempid;
                -- 战前触发的天赋
    --            Mpc.m_arrPreTalent = arrTalentID;
                Mpc.m_nBattleSpriteType = BATTLE_SPRITE_TYPE_OGRE;

                --加到入场动画移动列表中
                table.insert(m_arrMoving,
                {
                    role = Mpc,
                    targetPos = battlePos,
                    priority = 1,
                    action = "run",
                    isMoving = false,
                } );
            end
                            
            Mpc.m_nMaxHP = dataObject.MaxHP;
            Mpc.m_nCurHP = dataObject.CurHP;
            Mpc.m_nMetier = nMetierID;
    --        local tplMetier = LuaDataStatic.SearchMetierTpl(nMetierID);
    --        if (tplMetier ~= nil) then
    --            Mpc.m_strMetierName = tplMetier.m_strMemtier;
    --        else
    --            Mpc.m_strMetierName = "";
    --        end
    --        local tplSkill = LuaDataStatic.SearchSkillTpl(nSkillID);
    --        if (tplSkill ~= nil) then
    --            Mpc.m_strSkillName = tplSkill.m_strSkillName;
    --            Mpc.m_nSkillID = nSkillID;
    --        else
    --            Mpc.m_strSkillName = "";
    --            Mpc.m_nSkillID = 0;
    --        end
    --        Mpc.m_nLevel = dataObject.Level;
    --        Mpc.m_nPower = dataObject.Power;
    --        Mpc.ShowFullPower();
                            
            if (left) then
                Mpc:FlipX(false);
                LuaCBattleProcessManager.m_Team1Map[Mpc.m_unEntityID] = Mpc;
            else
                Mpc:FlipX(true);
                LuaCBattleProcessManager.m_Team2Map[Mpc.m_unEntityID] = Mpc;
            end

            -- 翅膀
    --      Mpc.ChangeWing(nArtifactID);
            if(LuaCBattleProcessManager.m_BattleScene ~= nil) then
                local audioSource = LuaCBattleProcessManager.m_BattleScene:GetComponent("AudioSource");
                Mpc:SetAudioSource(m_audioSource);
            end
                            
            Mpc:SetRoleAttackKeyFrameCallBack(LuaCBattleProcessManager.OnRoleAttackKeyFrame);
            Mpc:SetRoleAttackEndCallBack(LuaCBattleProcessManager.OnRoleAttackEnd);
            Mpc:SetRoleBeatKeyFrameCallBack(LuaCBattleProcessManager.OnRoleBeatKeyFrame);
            Mpc:SetRoleBeatEndCallBack(LuaCBattleProcessManager.OnRoleBeatEnd);
            Mpc:SetRoleDeadEndCallBack(LuaCBattleProcessManager.OnRoleDeadEnd);

            --设置层级
            this.SetRoleLayer(Mpc, dataObject.pos, battlePos.y);

            if(#m_arrLoadUrl == 0) then
                m_nCurProgress = m_nCurProgress + 1;
                LuaCUILoadingPanel.updateProgressBar(100);
                this.LoadComplete();
            end
        end );
end


-- 创建怪物出阵资源
function LuaCBattleManager.CreatOgreArrayResoure()
    -- 加载怪物的资源到下载列表
    local nTempID = LuaCBattleProcessManager.m_BattleProcessData.m_nBattlePlayerID2;
    -- 右边是怪，先读取怪物模板
    local tplOgre = LuaDataStatic.SearchOgreTpl(nTempID);
    if (tplOgre == nil) then
        return;
    end

    m_bossInfo = {strBossHead = "", nBossLevel = 0, strBossName = "", nBossHp = 0, nTotalBossHP = 0};
    for n, nOgrePartnerID in ipairs(tplOgre.OgrePartner) do
        -- 伙伴怪物伙伴模板
        local tplOgrePartner = LuaDataStatic.SearchOgrePartnerTpl(nOgrePartnerID);
        if (tplOgrePartner ~= nil) then
            local prefabUrl = "Prefabs/Entity/Npc/" .. tplOgrePartner.ModelName .. "_battle.prefab";
            table.insert(m_arrLoadUrl, prefabUrl);
            this.LoadOgreRes(prefabUrl, tplOgre, tplOgrePartner, n);

            -- boss怪名称为红色
            if (tplOgrePartner.OgreType == TmOgreType.emOgreType_NormalBOSS or tplOgrePartner.mOgreType == TmOgreType.emOgreType_HeroBOSS) then
                --ogre.m_strFullPowerEffectUrl = "config/effect/normalbossmanqishi";
                -- 如果是boss怪，则显示boss头像
                m_bossInfo["strBossName"] = CLanguageData.GetTplText(tplOgrePartner.Name);
                m_bossInfo["nBossLevel"] = tplOgrePartner.InitLevel;
                m_bossInfo["strBossHead"] = tplOgrePartner.ModelName;
            elseif (tplOgrePartner.mOgreType == TmOgreType.emOgreType_WorldBoss) then
                --ogre.m_strFullPowerEffectUrl = "config/effect/worldbossmanqishi";
                -- 如果是boss怪，则显示boss头像
                m_bossInfo["strBossName"] = CLanguageData.GetTplText(tplOgrePartner.Name);
                m_bossInfo["nBossLevel"] = tplOgrePartner.InitLevel;
                m_bossInfo["strBossHead"] = tplOgrePartner.ModelName;
            end
        end
        local MemberFightInfo = LuaCBattleProcessManager.m_BattleProcessData.m_BattleRightPlayerInfo:GetMemberFightInfoByPos(n - 1);
        if (MemberFightInfo ~= nil) then
            m_bossInfo["nBossHp"] = m_bossInfo["nBossHp"] + MemberFightInfo.CurHP;
            m_bossInfo["nTotalBossHP"] = m_bossInfo["nTotalBossHP"] + MemberFightInfo.MaxHP;
        end
    end
end

-- 加载怪物资源
function LuaCBattleManager.LoadOgreRes(prefabUrl, tplOgre, tplOgrePartner, n)
    LoadResAsync(prefabUrl, 
        function(prefabObj)
            for i, url in ipairs(m_arrLoadUrl) do
                if(url == prefabUrl) then
                    table.remove(m_arrLoadUrl, i);
                end
            end
            local prefabObj = CAssetManager.GetAsset(prefabUrl);
            if(prefabObj == nil) then
                print("找不到NPC预设:  " .. prefabUrl);
                return;
            end
            local ogreGameObject = UnityEngine.GameObject.Instantiate(prefabObj);
            if (ogreGameObject == nil) then
                return;
            end
            ogreGameObject.transform:SetParent(LuaCBattleProcessManager.m_BattleScene.transform, false);
            
            local ogre = ogreGameObject:GetComponent("CBattleRole");
            if (ogre == nil) then
                return;
            end

            local battlePos = nil;
            local MemberFightInfo = LuaCBattleProcessManager.m_BattleProcessData.m_BattleRightPlayerInfo:GetMemberFightInfoByPos(n - 1);
            if (MemberFightInfo ~= nil) then
                ogreGameObject.name = ogreGameObject.name .. "_" .. MemberFightInfo.pos;
                ogre.m_nMaxHP = MemberFightInfo.MaxHP;
                ogre.m_nCurHP = MemberFightInfo.CurHP;
                --ogre.m_nLevel = MemberFightInfo.Level;
                ogre.m_nPower = MemberFightInfo.Power;
                ogre.m_unEntityID = MemberFightInfo.pos;

                local posGameObject = UnityEngine.GameObject.Find("mapsprite/rightTeamPos/battle_pos" .. (MemberFightInfo.pos + 1));
                if (posGameObject ~= nil) then
                    battlePos = posGameObject.transform.position;
                end

                --设置层级
                this.SetRoleLayer(ogre, MemberFightInfo.pos, battlePos.y);

                -- 设置方向
                ogre:FlipX(true);
            end
            -- boss怪名称为红色
            if (tplOgrePartner.OgreType == TmOgreType.emOgreType_NormalBOSS or tplOgrePartner.mOgreType == TmOgreType.emOgreType_HeroBOSS) then
                ogre:SetRoleName("<color='#FF0000'>" .. CLanguageData.GetTplText(tplOgrePartner.Name) .. "</color>");
                --ogre.m_strFullPowerEffectUrl = "config/effect/normalbossmanqishi";
                -- 如果是boss怪，则显示boss头像
                LuaCUIBattleTopInfo.ShowBossInfo();
                ogre.m_nBattleSpriteType = BATTLE_SPRITE_TYPE_BOSS;

                -- 设置怪物位置
                if (battlePos ~= nil) then
                    ogre.transform.position = UnityEngine.Vector3.New(7.5, battlePos.y + 1.5, 0);
                end

                --加到入场动画移动列表中
                table.insert(m_arrMoving,
                {
                    role = ogre,
                    targetPos = battlePos,
                    priority = 2,
                    action = "jump",
                    isMoving = false,
                } );
            elseif (tplOgrePartner.mOgreType == TmOgreType.emOgreType_WorldBoss) then
                ogre:SetRoleName("<color='#FF0000'>" .. CLanguageData.GetTplText(tplOgrePartner.Name) .. "</color>");
                --ogre.m_strFullPowerEffectUrl = "config/effect/worldbossmanqishi";
                -- 如果是boss怪，则显示boss头像
                LuaCUIBattleTopInfo.ShowBossInfo();
                ogre.m_nBattleSpriteType = BATTLE_SPRITE_TYPE_WORLD_BOSS;

                -- 设置怪物位置
                if (battlePos ~= nil) then
                    ogre.transform.position = UnityEngine.Vector3.New(7.5, battlePos.y + 1.5, 0);
                end

                --加到入场动画移动列表中
                table.insert(m_arrMoving,
                {
                    role = ogre,
                    targetPos = battlePos,
                    priority = 2,
                    action = "jump",
                    isMoving = false,
                } );
            else
                ogre:SetRoleName(CLanguageData.GetTplText(tplOgrePartner.Name));
                ogre.m_nBattleSpriteType = BATTLE_SPRITE_TYPE_OGRE;

                -- 设置怪物位置
                if (battlePos ~= nil) then
                    ogre.transform.position = UnityEngine.Vector3.New(battlePos.x + 7.5, battlePos.y, 0);
                end

                --加到入场动画移动列表中
                table.insert(m_arrMoving,
                {
                    role = ogre,
                    targetPos = battlePos,
                    priority = 1,
                    action = "run",
                    isMoving = false,
                } );
            end

            --设置移动速度
            if(LuaCBattleProcessManager.m_battleEffectCtl.m_fMoveSpeed > 0) then
                ogre.m_nSpeed = LuaCBattleProcessManager.m_battleEffectCtl.m_fMoveSpeed;
            end
            ogre.m_nMetier = tplOgrePartner.Metier;
--            local tplMetier = CDataStatic.SearchMetierTpl(tplOgrePartner.Metier);
--            if (tplMetier ~= nil) then
--                Ogre.m_strMetierName = tplMetier.Memtier;
--            else
--                Ogre.m_strMetierName = ""
--            end
--            local tplSkill = CDataStatic.SearchTpl(tplOgrePartner.SkillID);
--            if (tempSkill ~= nil) then
--                Ogre.m_strSkillName = tplSkill.SkillName;
--            else
--                Ogre.m_strSkillName = ""
--            end
--            Ogre.ShowFullPower();
            
            LuaCBattleProcessManager.m_Team2Map[ogre.m_unEntityID] = ogre;

            if(LuaCBattleProcessManager.m_BattleScene ~= nil) then
                local audioSource = LuaCBattleProcessManager.m_BattleScene:GetComponent("AudioSource");
                ogre:SetAudioSource(m_audioSource);
            end
            ogre:SetRoleAttackKeyFrameCallBack(LuaCBattleProcessManager.OnRoleAttackKeyFrame);
            ogre:SetRoleAttackEndCallBack(LuaCBattleProcessManager.OnRoleAttackEnd);
            ogre:SetRoleBeatKeyFrameCallBack(LuaCBattleProcessManager.OnRoleBeatKeyFrame);
            ogre:SetRoleBeatEndCallBack(LuaCBattleProcessManager.OnRoleBeatEnd);
            ogre:SetRoleDeadEndCallBack(LuaCBattleProcessManager.OnRoleDeadEnd);

            if(#m_arrLoadUrl == 0) then
                m_nCurProgress = m_nCurProgress + 1;
                LuaCUILoadingPanel.updateProgressBar(100);
                LuaCBattleManager.UpdateBossInfo();
                this.LoadComplete();
            end
        end);
end

function LuaCBattleManager.UpdateBossInfo()
    if (LuaCUIBattleTopInfo.GetBossInfoVisible()) then
        LuaCUIBattleTopInfo.UpdateBossName(m_bossInfo["strBossName"], m_bossInfo["nBossLevel"]);
        LuaCUIBattleTopInfo.UpdateBossHeadIcon(m_bossInfo["strBossHead"]);
        LuaCUIBattleTopInfo.UpdateBossHp(m_bossInfo["nBossHp"], m_bossInfo["nTotalBossHP"]);
--        if (LuaCBattleProcessManager.m_BattleProcessData.m_nBattleType == LuaProDefine.BATTLE_TYPE_JXZ) then
--     	    orgeprice = CommonMethod.getJXZStage(LuaCJXZData.fightStage)
--     	    if (orgeprice~=nil) then
--     		    bosslevel=parseInt(orgeprice.@bosslevel)
--     		    round=parseInt(orgeprice.@round)
--     		    if (bosslevel>0) then
--     			    nextboss=CommonMethod.getJXZNextBossStage(LuaCJXZData.fightStage)
--     			    if (nextboss~=nil) then
--     				    CUIBattleBossHead.gUIBattleBossHead.setQiPao("<b>"..CommonMethod.replaceOldWithNew(LanguageData.gLanguageData.UI_WEBGAME_002,"",{round,"'#ff0000'"},{parseInt(nextboss.@id)+1,"'#ff0000'"}).."</b>")
--     			    else 
--     				    CUIBattleBossHead.gUIBattleBossHead.setQiPao("")
--     			    end
--     		    end
--     	    end
--        end
     else
     	LuaCUIBattleTopInfo.ShowOgreNum();
     	LuaCUIBattleTopInfo.UpdateOgreNum((LuaCBattleProcessManager.m_BattleProcessData.m_nBattleFBOgreIndex + 1), #m_arrOgreList);
     end
end

--设置角色层级
function LuaCBattleManager.SetRoleLayer(role, nIndex, posY)
    if(role == nil) then
        return;
    end
    local nLayer = math.ceil(100 * (10 - posY)) + nIndex * 10;--nIndex * 4;
    --影子
    local shadowTsm = role.gameObject.transform:FindChild("shadow");
    if(shadowTsm ~= nil) then
        local sprShadow = shadowTsm.gameObject:GetComponent("SpriteRenderer");
        if(sprShadow ~= nil) then
            sprShadow.sortingOrder = nLayer;
        end
    end
    --角色动画
    local spr = role.gameObject:GetComponent("SpriteRenderer");
    if(spr ~= nil) then
        spr.sortingOrder = nLayer + 1;
    end
    --头顶Canvas
    local canvasTsm = role.gameObject.transform:FindChild("Canvas");
    if(canvasTsm ~= nil) then
        local canvas = canvasTsm.gameObject:GetComponent("Canvas");
        if(canvas ~= nil) then
            canvas.sortingOrder = nLayer + 2;
        end
    end
end
--初始化角色头像信息
function LuaCBattleManager.InitRoleHeadInfo(battleRoleInfo, directionLeft)
	if directionLeft == nil then
        directionLeft = false;
    end
	local nLevel = battleRoleInfo:GetRoleLevel();
	local nAll = 0;
	local nCur = 0;
	local memberProperty = nil;
	--主角阵亡，另外从其他地方取到玩家等级
	if (nLevel == 0) then
		memberProperty = LuaCHeroProperty.GetMemberProperty(0);
		nLevel = memberProperty.m_nLevel;
	end
	if (directionLeft) then
        for i, role in pairs(LuaCBattleProcessManager.m_Team1Map) do
			nAll = nAll  + role.m_nMaxHP;
			nCur = nCur + role.m_nCurHP;
		end
	else
		for i, role in pairs(LuaCBattleProcessManager.m_Team2Map) do
			nAll = nAll + role.m_nMaxHP;
			nCur = nCur + role.m_nCurHP;
		end
	end
	if (directionLeft) then
        LuaCUIBattleTopInfo.UpdateHeroCurHP(nCur, nAll);
        LuaCUIBattleTopInfo.UpdateHeroName(battleRoleInfo.Name, nLevel, battleRoleInfo.PlayerPriorAttack);
        LuaCUIBattleTopInfo.UpdateHeroHeadIcon(battleRoleInfo.PlayerMetier, battleRoleInfo.PlayerSex);
	else
        LuaCUIBattleTopInfo.UpdateEnermyRoleCurHP(nCur, nAll);
		LuaCUIBattleTopInfo.UpdateEnermyRoleName(battleRoleInfo.Name, nLevel, battleRoleInfo.PlayerPriorAttack);
        LuaCUIBattleTopInfo.UpdateEnermyRoleHeadIcon(battleRoleInfo.PlayerMetier, battleRoleInfo.PlayerSex);
	end
end
-- 开始副本
function LuaCBattleManager.StartFB()
    if (LuaCBattleProcessManager.m_BattleProcessData.m_nBattleType ~= BATTLE_TYPE_SCHOOLBATTLE_PVE
        and LuaCBattleProcessManager.m_BattleProcessData.m_nBattleType ~= BATTLE_TYPE_SCHOOLBATTLE_PVP
        and LuaCBattleProcessManager.m_BattleProcessData.m_nBattleType ~= BATTLE_TYPE_CAMPBATTLE
        and LuaCBattleProcessManager.m_BattleProcessData.m_nBattleType ~= BATTLE_TYPE_FACTIONWAR) then
        -- 不是门派战和阵营战，则隐藏城市地图
        -- CGameMap.gGameMap.visible=false;
    end
    -- 判断是否有剧情要播放
    local nBeginStoryID = 0;
    local nOgreIndex = LuaCBattleProcessManager.m_BattleProcessData.m_nBattleFBOgreIndex;
    local dataObj = m_arrOgreList[nOgreIndex];
    if (dataObj ~= nil) then
        nBeginStoryID = dataObj.beginstory or 0;
    end

    -- 播放战斗开始特效
    this.StartBattleStartBattleEffcet();
end

--播放战斗开始动画
function LuaCBattleManager.StartBattleStartBattleEffcet()
    if(m_BattleStartEffect == nil) then
        local effectGameObjcet = LuaCBattleProcessManager.m_BattleScene.transform:FindChild("effect");
        if(effectGameObjcet == nil) then
            return;
        end
        effectGameObjcet.gameObject:SetActive(true);

        local battleStart = effectGameObjcet:FindChild("battlestart");
        if(battleStart == nil) then
            return;
        end
        m_BattleStartEffect = battleStart:GetComponent("DragonBones.UnityArmatureComponent");
        if(m_BattleStartEffect == nil) then
            return;
        end
        m_BattleStartEffect:AddEventListener(DragonBones.EventObject.COMPLETE, LuaCBattleManager.OnStartBattleEffcetEnd);
    end
    m_BattleStartEffect.gameObject:SetActive(true);
    m_BattleStartEffect.animation.timeScale = 0.5;
	m_BattleStartEffect.animation:Play(nil, -1);
end
function LuaCBattleManager.OnStartBattleEffcetEnd(event)
    if(m_BattleStartEffect ~= nil) then
--        m_BattleStartEffect.gameObject:SetActive(false);
    end
    if (LuaCBattleProcessManager.m_BattleProcessData ~= nil) then
        if (LuaCBattleProcessManager.m_BattleProcessData.m_nBattleType == BATTLE_TYPE_SCHOOLBATTLE_PVE
        or LuaCBattleProcessManager.m_BattleProcessData.m_nBattleType == BATTLE_TYPE_SCHOOLBATTLE_PVP
        or LuaCBattleProcessManager.m_BattleProcessData.m_nBattleType == BATTLE_TYPE_FACTIONWAR) then
            -- 			CUISchoolBattleFight.gSchoolBattleFight.mFightBase.removeChild(CUIManager.gUIManager.mSceneChangeEffect)
            -- 			CUIManager.gUIManager.mSceneChangeEffect.scaleX=1;
            -- 			CUIManager.gUIManager.mSceneChangeEffect.scaleY=1;
            -- 在用户中心点击注销按钮发出的消息0
            -- 			CUIManager.gUIManager.mSceneChangeEffect.y=0
        end
    end
    
    -- 设置战前天赋信息
    --this.SetTalentInfo();
    -- 开始战斗
--    this.StartBattle();
    LuaCBattleProcessManager.StartBattle();
    LuaCBattleProcessManager.m_funcBattleEnd = this.OnBattleEnd;

    LuaCUIBattleTopInfo.SetBottomBtnShow(true);
end

--战斗结束回调函数
function LuaCBattleManager.OnBattleEnd()
    LuaCUIBattleTopInfo.SetBottomBtnShow(false);
    
	local nPrestige = 0;
	local nMoney = 0;
	local nHonor = 0;
	local nItem = 0;
	local nItemNum = 0;

	local isIWin = false;
	--战斗结束后判断哪方胜利
	--如果胜利方索引是0，则是玩家或胜
	if (LuaCBattleProcessManager.m_BattleProcessData.m_nBattleType == BATTLE_TYPE_OGRE
        or LuaCBattleProcessManager.m_BattleProcessData.m_nBattleType == BATTLE_TYPE_HERO_OGRE) then
			--LuaCUIFbFail.ShowUI();
			--如果胜利方索引是0，则是玩家或胜，1则是失败
			if (LuaCBattleProcessManager.m_BattleProcessData.m_nBattleWinIndex==0) then
				this.CommonFBBattleEnd();
			else
				LuaCUIFbFail.ShowUI();
            end
	elseif (LuaCBattleProcessManager.m_BattleProcessData.m_nBattleType == BATTLE_TYPE_JXZ) then
			LuaCJXZData.lastLevel=LuaCJXZData.fightStage;
			if (LuaCBattleProcessManager.m_BattleProcessData.m_nBattleWinIndex == 0) then
				CUIJXZBattleInfo.gCUIJXZBattleInfo.update();
				CUIJXZBattleWin.gCUIJXZBattleWin.ShowUI();
			else
				if (CUIJXZBattleFail.gCUIJXZBattleFail ~= nil) then
					CUIJXZBattleFail.gCUIJXZBattleFail.ShowUI();
				end
            end
	elseif (LuaCBattleProcessManager.m_BattleProcessData.m_nBattleType == BATTLE_TYPE_DART) then
			if (LuaCBattleProcessManager.m_BattleProcessData.m_nBattlePlayerID1==LuaCHeroProperty.mCharID and LuaCBattleProcessManager.m_BattleProcessData.m_nBattleWinIndex==0) then
				isIWin=true;
			elseif (LuaCBattleProcessManager.m_BattleProcessData.m_nBattlePlayerID2==LuaCHeroProperty.mCharID and LuaCBattleProcessManager.m_BattleProcessData.m_nBattleWinIndex==1) then
				isIWin=true;
			end
			LuaCUIWorldBossBattleEnd.InitData(
				LuaCBattleProcessManager.m_BattleProcessData.m_nDamageValue,
				LuaCBattleProcessManager.m_BattleProcessData.m_nDamagePrestige,
				LuaCBattleProcessManager.m_BattleProcessData.m_nDamageMoney,
				0,0,0,
				isIWin,
				LuaProDefine.BATTLE_TYPE_DART);
			LuaCUIWorldBossBattleEnd.ShowUI();
	elseif (LuaCBattleProcessManager.m_BattleProcessData.m_nBattleType == BATTLE_TYPE_ARENA) then
			if (LuaCBattleProcessManager.m_BattleProcessData.m_nBattlePlayerID1 == LuaCHeroProperty.mCharID and LuaCBattleProcessManager.m_BattleProcessData.m_nBattleWinIndex == 0) then
				isIWin = true;
			elseif (LuaCBattleProcessManager.m_BattleProcessData.m_nBattlePlayerID2==LuaCHeroProperty.mCharID and LuaCBattleProcessManager.m_BattleProcessData.m_nBattleWinIndex == 1) then
				isIWin = true;
			else
				isIWin = false;
			end
			nPrestige = 0;
			nMoney = 0;
			if (isReplayBattle) then
				isReplayBattle = false;
			else
                local spArenaTable = LuaDataStatic.SearchTplForName("ArenaTable");
				nPrestige = spArenaTable.FailurePrestige;
				nMoney = spArenaTable.FailureMoneyFactor * LuaCHeroProperty.GetPlayerLevel();
				if (LuaCBattleProcessManager.m_BattleProcessData.m_nBattlePlayerID1 == LuaCHeroProperty.mCharID and LuaCBattleProcessManager.m_BattleProcessData.m_nBattleWinIndex == 0) then
					nPrestige = spArenaTable.VictoryPrestige;
					nMoney = spArenaTable.VictoryMoneyFactor * LuaCHeroProperty.GetPlayerLevel();
				elseif (LuaCBattleProcessManager.m_BattleProcessData.m_nBattlePlayerID2 == LuaCHeroProperty.mCharID and LuaCBattleProcessManager.m_BattleProcessData.m_nBattleWinIndex == 1) then
					nPrestige = spArenaTable.VictoryPrestige;
					nMoney = spArenaTable.VictoryMoneyFactor * LuaCHeroProperty.GetPlayerLevel();
				end
			end

            if (isIWin) then
				this.CommonFBBattleEnd();
                LuaCUIFbWin.HideStarPanel();
			else
				LuaCUIFbFail.ShowUI(false);
            end
			--LuaCUIWorldBossBattleEnd.InitData(0,nPrestige,nMoney,0,0,0,isIWin,BATTLE_TYPE_ARENA);
			--LuaCUIWorldBossBattleEnd.ShowUI();
	elseif (LuaCBattleProcessManager.m_BattleProcessData.m_nBattleType == BATTLE_TYPE_Maze) then
			if (LuaCBattleProcessManager.m_BattleProcessData.m_nBattleWinIndex==0) then
				CUIOgreDrop.gUIOgerDrop.SetOgreDrop(LuaCBattleProcessManager.m_BattleProcessData.m_nTollgateRewardTalentPoint,
					LuaCBattleProcessManager.m_BattleProcessData.m_nTollgateRewardExp,LuaCBattleProcessManager.m_BattleProcessData.m_arrTollgateRewarItem,
					BATTLE_TYPE_HERO_OGRE)
				CUIOgreDrop.gUIOgerDrop.ShowUI();
				if (LuaCMazeData.currSubMazeLevel< MAZE_MAX_POINT_NUM - 1) then
					LuaCMazeData.currSubMazeLevel=LuaCMazeData.currSubMazeLevel+1;
				else
					LuaCMazeData.currSubMazeLevel=0;
					LuaCMazeData.subMazeLevel=0;
					LuaCMazeData.currMazeLevel=LuaCMazeData.currMazeLevel+1;
					LuaCMazeData.mazeLevel=LuaCMazeData.mazeLevel+1;
				end
			else
				LuaCUIWorldBossBattleEnd.InitData(0,0,0,0,0,0,false,LuaProDefine.BATTLE_TYPE_ARENA);
				LuaCUIWorldBossBattleEnd.ShowUI();
            end
	elseif (LuaCBattleProcessManager.m_BattleProcessData.m_nBattleType == BATTLE_TYPE_MysticMaze) then
			if (LuaCBattleProcessManager.m_BattleProcessData.m_nBattleWinIndex==0) then
				CUIOgreDrop.gUIOgerDrop.SetOgreDrop(LuaCBattleProcessManager.m_BattleProcessData.m_nTollgateRewardTalentPoint,
					LuaCBattleProcessManager.m_BattleProcessData.m_nTollgateRewardExp,LuaCBattleProcessManager.m_BattleProcessData.m_arrTollgateRewarItem,
					BATTLE_TYPE_HERO_OGRE);
				CUIOgreDrop.gUIOgerDrop.ShowUI();
				LuaCMazeData.currMysticLevel=-1;
				LuaCMazeData.mysticLevel=LuaCMazeData.mysticLevel+1;	--可以遇到的神秘关卡
			else
				LuaCUIWorldBossBattleEnd.InitData(0,0,0,0,0,0,false,LuaProDefine.BATTLE_TYPE_ARENA);
				LuaCUIWorldBossBattleEnd.ShowUI();
            end
	elseif (LuaCBattleProcessManager.m_BattleProcessData.m_nBattleType == BATTLE_TYPE_SchoolChallenge_pvp
	or LuaCBattleProcessManager.m_BattleProcessData.m_nBattleType == BATTLE_TYPE_SchoolApprientice
	or LuaCBattleProcessManager.m_BattleProcessData.m_nBattleType == BATTLE_TYPE_SchoolChallenge_pve) then
			if (LuaCBattleProcessManager.m_BattleProcessData.m_nBattlePlayerID1==LuaCHeroProperty.mCharID and LuaCBattleProcessManager.m_BattleProcessData.m_nBattleWinIndex==0) then
				isIWin=true;
			elseif (LuaCBattleProcessManager.m_BattleProcessData.m_nBattlePlayerID2==LuaCHeroProperty.mCharID and LuaCBattleProcessManager.m_BattleProcessData.m_nBattleWinIndex==1) then
				isIWin=true;
			else
				isIWin=false;
			end
            local spSchoolConfig = LuaDataStatic.SearchTplForName("SchoolConfig");
			if (this.isReplayBattle) then
				this.isReplayBattle=false;
			else
				if (LuaCBattleProcessManager.m_BattleProcessData.m_nBattleType~=BATTLE_TYPE_SchoolApprientice) then
					if (LuaCBattleProcessManager.m_BattleProcessData.m_nBattlePlayerID1==LuaCHeroProperty.mCharID and LuaCBattleProcessManager.m_BattleProcessData.m_nBattleWinIndex==0) then
						nPrestige = spSchoolConfig.VictoryPrestige;
						nMoney = spSchoolConfig.VictoryMoney;
					elseif (LuaCBattleProcessManager.m_BattleProcessData.m_nBattlePlayerID2==LuaCHeroProperty.mCharID and LuaCBattleProcessManager.m_BattleProcessData.m_nBattleWinIndex==1) then
						nPrestige = spSchoolConfig.VictoryPrestige;
						nMoney = spSchoolConfig.VictoryMoney;
					else
						nPrestige = spSchoolConfig.FailedPrestige;
						nMoney = spSchoolConfig.FailedMoney;
					end
				else
					nPrestige=0
					nMoney=0
				end
			end
            if (isIWin) then
				this.CommonFBBattleEnd();
                LuaCUIFbWin.HideStarPanel();
			else
				LuaCUIFbFail.ShowUI(false);
            end
			--LuaCUIWorldBossBattleEnd.InitData(0,nPrestige,nMoney,0,0,0,isIWin,BATTLE_TYPE_ARENA)
			--LuaCUIWorldBossBattleEnd.ShowUI()
	elseif (LuaCBattleProcessManager.m_BattleProcessData.m_nBattleType == BATTLE_TYPE_LocalSelectWar) then
			if (LuaCBattleProcessManager.m_BattleProcessData.m_nBattlePlayerID1==CUIRiseWar.gCUIRiseWar.playerId and LuaCBattleProcessManager.m_BattleProcessData.m_nBattleWinIndex==0) then
				isIWin=true
			elseif (LuaCBattleProcessManager.m_BattleProcessData.m_nBattlePlayerID2==CUIRiseWar.gCUIRiseWar.playerId and LuaCBattleProcessManager.m_BattleProcessData.m_nBattleWinIndex==1) then
				isIWin=true
			else
				isIWin=false
			end
			LuaCUIWorldBossBattleEnd.InitData(0,0,0,0,0,0,isIWin,LuaProDefine.BATTLE_TYPE_ARENA)
			LuaCUIWorldBossBattleEnd.ShowUI()
	elseif (LuaCBattleProcessManager.m_BattleProcessData.m_nBattleType == BATTLE_TYPE_WORLD_BOSS
	or LuaCBattleProcessManager.m_BattleProcessData.m_nBattleType == BATTLE_TYPE_FactionBoss
	or LuaCBattleProcessManager.m_BattleProcessData.m_nBattleType == BATTLE_TYPE_SCHOOLBATTLE_PVE) then
			if (LuaCBattleProcessManager.m_BattleProcessData.m_nBattleWinIndex==0) then
				isIWin=true
			else
				isIWin=false
			end
			LuaCUIWorldBossBattleEnd.InitData(
				LuaCBattleProcessManager.m_BattleProcessData.m_nDamageValue,
				LuaCBattleProcessManager.m_BattleProcessData.m_nDamagePrestige,
				LuaCBattleProcessManager.m_BattleProcessData.m_nDamageMoney,
				0,0,0,
				isIWin,
				LuaCBattleProcessManager.m_BattleProcessData.m_nBattleType)
			LuaCUIWorldBossBattleEnd.ShowUI()
	elseif (LuaCBattleProcessManager.m_BattleProcessData.m_nBattleType == BATTLE_TYPE_SCHOOLBATTLE_PVP
	or LuaCBattleProcessManager.m_BattleProcessData.m_nBattleType == BATTLE_TYPE_CAMPBATTLE
	or LuaCBattleProcessManager.m_BattleProcessData.m_nBattleType == BATTLE_TYPE_FACTIONWAR) then
			if (LuaCBattleProcessManager.m_BattleProcessData.m_nBattlePlayerID1==LuaCHeroProperty.mCharID and LuaCBattleProcessManager.m_BattleProcessData.m_nBattleWinIndex==0) then
				isIWin=true
			elseif (LuaCBattleProcessManager.m_BattleProcessData.m_nBattlePlayerID2==LuaCHeroProperty.mCharID and LuaCBattleProcessManager.m_BattleProcessData.m_nBattleWinIndex==1) then
				isIWin=true
			end
			LuaCUIWorldBossBattleEnd.InitData(
				LuaCBattleProcessManager.m_BattleProcessData.m_nDamageValue,
				LuaCBattleProcessManager.m_BattleProcessData.m_nDamagePrestige,
				LuaCBattleProcessManager.m_BattleProcessData.m_nDamageMoney,
				0,0,0,
				isIWin,
				LuaCBattleProcessManager.m_BattleProcessData.m_nBattleType)
			LuaCUIWorldBossBattleEnd.ShowUI()
	elseif (LuaCBattleProcessManager.m_BattleProcessData.m_nBattleType == BATTLE_TYPE_WorldArena) then
			if (LuaCBattleProcessManager.m_BattleProcessData.m_nBattlePlayerID1==LuaCHeroProperty.mCharID and LuaCBattleProcessManager.m_BattleProcessData.m_nBattleWinIndex==0) then
				isIWin=true
			elseif (LuaCBattleProcessManager.m_BattleProcessData.m_nBattlePlayerID2==LuaCHeroProperty.mCharID and LuaCBattleProcessManager.m_BattleProcessData.m_nBattleWinIndex==1) then
				isIWin=true
			else
				isIWin=false
			end
			nHonor=0
			nItem=0
			nItemNum=0
			if (this.isReplayBattle) then
				this.isReplayBattle=false
			else
				--荣誉值
				nHonor=LuaCServerWarModule.m_prizeHonor
				--道具ID
				nItem=LuaCServerWarModule.m_prizeItem
				--道具数量
				nItemNum=LuaCServerWarModule.m_PrizeItemNum
			end
			LuaCUIWorldBossBattleEnd.InitData(0,0,0,
				nHonor,
				nItem,
				nItemNum,
				isIWin,LuaProDefine.BATTLE_TYPE_WorldArena)
			LuaCUIWorldBossBattleEnd.ShowUI()
	end
end
--跳过战斗
function LuaCBattleManager.JumpBattle()
    if (LuaCBattleProcessManager.m_BattleProcessData == nil) then
        return;
    end

    m_arrAttacker = { };
    m_arrTarget = { };
    m_arrBuffer = { };
    m_arrMoving = { };
    m_arrDead = { };
    m_arrBuffObj = { };

    if (LuaCBattleProcessManager.m_BattleProcessData == nil) then
        return;
    end
    LuaCProModule.m_arrBattle = { };

    if (LuaCBattleProcessManager.m_BattleProcessData.m_nBattleType == BATTLE_TYPE_OGRE
        or LuaCBattleProcessManager.m_BattleProcessData.m_nBattleType == BATTLE_TYPE_HERO_OGRE) then
			--LuaCUIFbFail.ShowUI();
	    --如果胜利方索引是0，则是玩家或胜，1则是失败
	    if (LuaCBattleProcessManager.m_BattleProcessData.m_nBattleWinIndex == 0) then
		    local bEnd = true;
            -- 根据怪物索引判断是否还有怪物
            local nOgreIndex = LuaCBattleProcessManager.m_BattleProcessData.m_nBattleFBOgreIndex;
            local nOgreNum = #m_arrOgreList;

            while(nOgreIndex + 1 < nOgreNum) do
                -- 还有怪需要继续战斗
                this.m_bJump = true;
                LuaCProModule.SendCommonInstanceFightRequest(LuaCBattleProcessManager.m_BattleProcessData.m_nBattleCityMapID, LuaCBattleProcessManager.m_BattleProcessData.m_nBattleFBIndex, LuaCBattleProcessManager.m_BattleProcessData.m_nBattleType);
                nOgreIndex = nOgreIndex + 1;
                bEnd = false;
            end
            if (bEnd) then
                this.CommonFBBattleWin();
            end
	    else
		    LuaCUIFbFail.ShowUI();
        end
    elseif(LuaCBattleProcessManager.m_BattleProcessData.m_nBattleType == BATTLE_TYPE_ARENA) then
        if (LuaCBattleProcessManager.m_BattleProcessData.m_nBattlePlayerID1 == LuaCHeroProperty.mCharID and LuaCBattleProcessManager.m_BattleProcessData.m_nBattleWinIndex == 0) then
			bWin = true;
		elseif (LuaCBattleProcessManager.m_BattleProcessData.m_nBattlePlayerID2 == LuaCHeroProperty.mCharID and LuaCBattleProcessManager.m_BattleProcessData.m_nBattleWinIndex == 1) then
			bWin = true;
		else
			bWin = false;
		end

        if (bWin) then
			LuaCBattleManager.CommonFBBattleWin();
            LuaCUIFbWin.HideStarPanel();
		else
			LuaCUIFbFail.ShowUI(false);
        end
    elseif (LuaCBattleProcessManager.m_BattleProcessData.m_nBattleType == BATTLE_TYPE_SchoolChallenge_pvp
	or LuaCBattleProcessManager.m_BattleProcessData.m_nBattleType == BATTLE_TYPE_SchoolApprientice
	or LuaCBattleProcessManager.m_BattleProcessData.m_nBattleType == BATTLE_TYPE_SchoolChallenge_pve) then
        if (LuaCBattleProcessManager.m_BattleProcessData.m_nBattlePlayerID1 == LuaCHeroProperty.mCharID and LuaCBattleProcessManager.m_BattleProcessData.m_nBattleWinIndex == 0) then
			bWin = true;
		elseif (LuaCBattleProcessManager.m_BattleProcessData.m_nBattlePlayerID2 == LuaCHeroProperty.mCharID and LuaCBattleProcessManager.m_BattleProcessData.m_nBattleWinIndex == 1) then
			bWin = true;
		else
			bWin = false;
		end
        if (bWin) then
			LuaCBattleManager.CommonFBBattleWin();
            LuaCUIFbWin.HideStarPanel();
		else
			LuaCUIFbFail.ShowUI(false);
        end
    end

    m_arrOgreList = { };
    LuaCProModule.DelFirstBattleProcess();
end
function LuaCBattleManager.OnGetInstanceNotice()
    local bEnd = true;
    -- 根据怪物索引判断是否还有怪物
    local nOgreIndex = LuaCBattleProcessManager.m_BattleProcessData.m_nBattleFBOgreIndex;
    local nOgreNum = #m_arrOgreList;

    if(nOgreIndex + 1 < nOgreNum) then
        -- 还有怪需要继续战斗
        bEnd = false;
    end
    if (bEnd) then
        this.m_bJump = false;
        this.CommonFBBattleWin();
    else
        LuaCProModule.DelFirstBattleProcess();
    end
end
function LuaCBattleManager.CommonFBBattleEnd()
    local bEnd = true;
    -- 根据怪物索引判断是否还有怪物
    local nOgreIndex = LuaCBattleProcessManager.m_BattleProcessData.m_nBattleFBOgreIndex;
    local nOgreNum = #m_arrOgreList;
   
    if (nOgreIndex + 1 < nOgreNum) then
        bEnd = false;
    end

    if (not bEnd) then
        -- 还有怪需要继续战斗
        this.ContinueBattle();
    else
        this.CommonFBBattleWin();
    end
end

-- 普通副本战斗结束
function LuaCBattleManager.CommonFBBattleWin()
    -- 显示通关奖励界面
    this.ShowUIInstanceAppraise();
end
-- 显示物品掉落结束
function LuaCBattleManager.ShowOgreDropEnd(nBattleType)
    if (nBattleType == BATTLE_TYPE_OGRE) then
        -- 显示掉落宝箱
        this.ShowTreasureBox();
    elseif (nBattleType == BATTLE_TYPE_HERO_OGRE) then
        this.CloseBattle();
    elseif (nBattleType == CProModule.BATTLE_TYPE_MultiFB) then
        CMultiBattleManager.gCMultiBattleManager.CloseBattle();
    end
end
function LuaCBattleManager.ContinueBattle()
    if (LuaCBattleProcessManager.m_BattleProcessData == nil) then
        return;
    end
    -- 还有怪需要继续战斗
    LuaCProModule.SendCommonInstanceFightRequest(LuaCBattleProcessManager.m_BattleProcessData.m_nBattleCityMapID, LuaCBattleProcessManager.m_BattleProcessData.m_nBattleFBIndex, LuaCBattleProcessManager.m_BattleProcessData.m_nBattleType);
    LuaCProModule.m_arrBattle = { };
    LuaCBattleProcessManager.m_BattleProcessData = nil;
    
    LuaCBattleProcessManager.ClearRole();
    LuaCBattleProcessManager.ClearSceneEffect();
    m_arrOgreList = { };
    m_arrAttacker = { };
    m_arrTarget = { };
    m_arrBuffer = { };
    m_arrMoving = { };
    m_arrDead = { };
    m_arrBuffObj = { };
end
function LuaCBattleManager.MasterBattleEnd()
	if (LuaCBattleProcessManager.m_BattleProcessData.m_nBattleType == BATTLE_TYPE_SCHOOLBATTLE_PVE or LuaCBattleProcessManager.m_BattleProcessData.m_nBattleType == BATTLE_TYPE_SCHOOLBATTLE_PVP) then
		CUISchoolBattleFight.gSchoolBattleFight.Show(false);
	end
	this.CloseBattle();
end
function LuaCBattleManager.CloseBattle()
    if (LuaCBattleProcessManager.m_BattleProcessData.m_nBattleType == BATTLE_TYPE_OGRE
        or LuaCBattleProcessManager.m_BattleProcessData.m_nBattleType == BATTLE_TYPE_HERO_OGRE) then
        LuaCProModule.SendReturn2CityRequest(LuaCBattleProcessManager.m_BattleProcessData.m_nBattleType);
    elseif (LuaCBattleProcessManager.m_BattleProcessData.m_nBattleType == BATTLE_TYPE_CAMPBATTLE) then
        LuaCActivityModule.SendEndCampFightRequest();
    elseif (LuaCBattleProcessManager.m_BattleProcessData.m_nBattleType == BATTLE_TYPE_JXZ) then
        LuaCJXZData.purchaseNirvanaTimes = 0;
        LuaCJXZData.purchaseRecoverTimes = 0;
        LuaCJXZData.purchaseSummonTimes = 0;
        LuaCJXZData.SummonNum = 0;
        LuaCJXZData.UseSkill = false;
        CUIJXZStart.gCUIJXZStart.ShowUI();
        CUIJXZBattleInfo.gCUIJXZBattleInfo.HideUI();
    end 

    LuaCBattleProcessManager.CloseBattle();
	

	--			//战斗结束清空天赋动画
	--			if(m_TalentEffect!=null&&m_TalentEffect.parent)
	--			{
	--              if(m_TalentEffect.bust.numChildren)
	--				{
	--					m_TalentEffect.bust.removeChildren();
	--				}
	--				if(m_TalentEffect.talent.numChildren)
	--				{
	--					m_TalentEffect.talent.removeChildren();
	--				}
	--				m_TalentEffect.parent.removeChild(m_TalentEffect);
	--				m_TalentEffect=null;

--	CUIBattleJump.gUIBattleJump.HideUI();
--	CUITreasureBox.gUITreasureBox.HideUI();
--	CUIBattlePlayerInfo.gUIBattlePlayerInfo.HideUI();
--	CUIJXZBattleWin.gCUIJXZBattleWin.HideUI(false);
--	CUIJXZBattleFail.gCUIJXZBattleFail.HideUI(false);
    LuaCUIBattleTopInfo.HideUI();

	if (#LuaCProModule.m_arrBattle == 0) then
        if(not LuaCMapModule.IsInPlotMap()) then
            LuaCitySceneManager.ExitFB(LuaCBattleProcessManager.m_BattleProcessData.m_nBattleType);
        end
	    LuaCBattleProcessManager.m_BattleProcessData = nil;
        LuaCitySceneManager.PlaySceneSound();
	end
end

-- 显示宝箱
function LuaCBattleManager.ShowTreasureBox()
    CUITreasureBox.gUITreasureBox.ShowUI();
end
-- 显示通关评价界面
function LuaCBattleManager.ShowUIInstanceAppraise()
    LuaCUIBattleTopInfo.HideUI();
--    -- 关闭战斗的头像界面
--    CUIBattleJump.gUIBattleJump.HideUI();
--    CUIChat.gUIChat.HideUI();

--    -- 隐藏角色
--    for i, mpc in pairs(LuaCBattleProcessManager.m_Team1Map) do
--        mpc.visible = false;
--    end

--    for i, mpc in pairs(LuaCBattleProcessManager.m_Team1Map) do
--        mpc.visible = false;
--    end

--    for i, ride in pairs(LuaCBattleProcessManager.m_Team1Map) do
--        ride.visible = false;
--    end
    
--     显示通关奖励界面
    LuaCUIFbWin.ShowTollgateReward(
        LuaCBattleProcessManager.m_BattleProcessData.m_nTollgateRewardLevel,
        LuaCBattleProcessManager.m_BattleProcessData.m_nTollgateRewardExp,
        LuaCBattleProcessManager.m_BattleProcessData.m_nTollgateRewardMoney,
        LuaCBattleProcessManager.m_BattleProcessData.m_nTollgateRewardTalentPoint,
        LuaCBattleProcessManager.m_BattleProcessData.m_nTollgateRewardYuBao,
        LuaCBattleProcessManager.m_BattleProcessData.m_arrTollgateRewarItem,
        LuaCBattleProcessManager.m_BattleProcessData.m_nAddMoneyBuff
    );
end

function LuaCBattleManager.SetBattleMapID(mapID)
    m_BattleMapID = mapID;
end
--endregion
