--region *.lua
--Date
--此文件由[BabeLua]插件自动生成

LuaCitySceneManager = {};

this = LuaCitySceneManager;

function LuaCitySceneManager.OnReconnectScene(nMapID, nPosX, nPosY)
    -- 在同一个场景，则不再加载
    if(UnityEngine.SceneManagement.SceneManager.GetActiveScene().name == tostring(nMapID)) then
        return;
    end
	--如果在战斗中，先结束战斗
--		if (this.mGameState ~= GAMG_STATE_CITY) then
--			LuaCProModule.ClearBattleList()
--			this.mBattleManager.CloseBattle()
--		end
    LuaCUILoadingPanel.ShowUI();

    LuaEntityManager.ClearMpcList();--清空玩家列表
	LuaEntityManager.ClearNpcList();--请求npc列表
   
   -- 大地图打开，则关上
   if(LuaCUIWorldMap.GetVisible()) then
        LuaCUIWorldMap.HideUI();
   end

    SceneLoadAsyncOperation = UnityEngine.SceneManagement.SceneManager.LoadSceneAsync(tostring(nMapID));
    LuaGame.AddPerFrameFunc("LuaCitySceneManager.OnReconnectSceneing", LuaCitySceneManager.OnReconnectSceneing);
end
function LuaCitySceneManager.OnReconnectSceneing()
    LuaCUILoadingPanel.updateProgressBar(10 + SceneLoadAsyncOperation.progress * 100 * 0.9);

    if (SceneLoadAsyncOperation.isDone) then
        LuaGame.RemovePerFrameFunc("LuaCitySceneManager.OnReconnectSceneing");
        -- 创建所有实体
        LuaEntityManager.CreaterAllEntity();
        -- 同步主角位置
        LuaEntityManager.OnSyncPos(LuaCHeroProperty.m_unEntityID, LuaCHeroProperty.mPosX, LuaCHeroProperty.mPosY);
        local cameraFollow = UnityEngine.Camera.main:GetComponent("CCameraFollow");
        if (cameraFollow ~= nil) then
            --剧情地图里隐藏主角
            if(LuaCMapModule.IsInPlotMap()) then
                if(LuaEntityManager.m_hero ~= nil) then
                    LuaEntityManager.m_hero.gameObject:SetActive(false);
                end
            else
                if(LuaEntityManager.m_hero ~= nil) then
                    LuaEntityManager.m_hero.gameObject:SetActive(true);
                    cameraFollow:ResetCameraPosition(LuaEntityManager.m_hero.transform.position.x, LuaEntityManager.m_hero.transform.position.y);
                end
            end
            -- 根据地图的大小，设置相机移动的范围
            local mapGameObject = UnityEngine.GameObject.Find("citymap");
            if (mapGameObject ~= nil) then
                local bc2d = mapGameObject:GetComponent("BoxCollider2D");
                if (bc2d ~= null) then
                    cameraFollow:SetCameraMoveRcet(bc2d.size.x, bc2d.offset.y - bc2d.size.y * 0.5);
                end
            end
        end
         -- 显示游戏主界面
        if(not LuaCMapModule.IsInPlotMap() and not LuaCMapModule.IsInActivityMap()) then
            --print("主界面2");
            LuaCUIManager.ShowMainUI();
        elseif(LuaCMapModule.IsInPlotMap()) then
            LuaCUIManager.CloseAllUI();
        end
        LuaCUILoadingPanel.HideUI();
    end
end
function LuaCitySceneManager.ExitFB(nBattleType)
    local nTaskID=0
	local BagBox
	local t=0
	
    --  显示主角形象
    LuaEntityManager.m_hero.gameObject:SetActive(true);
    if(LuaEntityManager.m_hero.m_nRideID > 0) then
        local prefabUrl = "Prefabs/Entity/Ride/" .. LuaEntityManager.m_hero.m_nRideID .. ".prefab";
        local prefabObj = CAssetManager.GetAsset(prefabUrl);
        if (prefabObj ~= null) then
            LuaEntityManager.m_hero:ChangeRide(LuaEntityManager.m_hero.m_nRideID, prefabObj);
        end
    end
    -- 主相机设置到主角
    local cameraFollow =  UnityEngine.Camera.main:GetComponent("CCameraFollow");
    if(cameraFollow ~= nil) then
        cameraFollow:ResetCameraPosition(LuaEntityManager.m_hero.transform.position.x, LuaEntityManager.m_hero.transform.position.y);
    end
    -- 显示游戏主界面
    --print("主界面3");
    LuaCUIManager.ShowMainUI();
    LuaCUIUnlockFunctionPrompt.ShowWaitFunctionUI()
    LuaCUIPowerChange.ShowPowerChange();
    if LuaCProModule.m_bLevelUp == true then
        LuaEntityManager.PlayerLevelUp();
    end
    
--    local mainGameObject = UnityEngine.GameObject.Find("GameMain");
--    if (UnityEngine.Camera.main ~= nil) then
--        UnityEngine.Camera.main.transform.position = UnityEngine.Vector3.New(0, 0, -10);
--    end

--	if (nBattleType==CProModule.BATTLE_TYPE_WORLD_BOSS) then
--		if (CUIManager.gUIManager) then
--			CUIManager.gUIManager.ShowWorldBossUI()
--		end
--		CUIWorldBossDeadCountDown.gUIWorldBossDeadCountDown.visible=true
--		if (not LuaCActivityModule.mStartingActivityList.containsKey(ACTIVITY_TYPE_WORLDBOSS_CRAZE_APE) and not LuaCActivityModule.mStartingActivityList.containsKey(ACTIVITY_TYPE_WORLDBOSS_RAID_VULTURE)) then
--			--活动结束
--			ActivityEnd(ACTIVITY_TYPE_WORLDBOSS_CRAZE_APE)
--		end
--	elseif (nBattleType==LuaProDefine.BATTLE_TYPE_SCHOOLBATTLE_PVE or nBattleType==CProModule.BATTLE_TYPE_SCHOOLBATTLE_PVP) then
--		--提示框容器0
--		CUISchoolBattleFight.gSchoolBattleFight.HideUI()
--		if (not LuaCActivityModule.mStartingActivityList.containsKey(ACTIVITY_TYPE_SCHOOL_BATTLE)) then
--			--活动结束
--			ActivityEnd(ACTIVITY_TYPE_SCHOOL_BATTLE)
--		end
--		--隐藏头顶战斗图标
--		CRoleManager.gRoleManager.m_hero.SetHeadBattleIcon("")
--		CUIWorldBossDeadCountDown.gUIWorldBossDeadCountDown.visible=true
--	elseif (nBattleType==CProModule.BATTLE_TYPE_FACTIONWAR) then
--		--关闭门派战界面
--		CUISchoolBattleFight.gSchoolBattleFight.HideUI()
--		--判断帮会是否结束
--		if (LuaCFactionModule.mWarResult.size()) then
--			FactionWarEnd()
--		end
--		if (not LuaCActivityModule.ChechStartingFactionWar()) then
--			--活动结束
--			ActivityEnd(ACTIVITY_TYPE_FACTION_WAR_LEVEL4)
--		end
--		--隐藏头顶战斗图标
--		CRoleManager.gRoleManager.m_hero.SetHeadBattleIcon("")
--	elseif (nBattleType==CProModule.BATTLE_TYPE_FactionBoss) then
--		if (CUIManager.gUIManager) then
--			CUIManager.gUIManager.ShowWorldBossUI()
--		end
--		CUIWorldBossDeadCountDown.gUIWorldBossDeadCountDown.visible=true
--		if (not LuaCActivityModule.mStartingActivityList.containsKey(ACTIVITY_TYPE_FACTIONBOSS)) then
--			ActivityEnd(ACTIVITY_TYPE_FACTIONBOSS)
--		end
--	else
--		CUIManager.gUIManager.ShowMainUI()
--		if (nBattleType==CProModule.BATTLE_TYPE_ARENA) then
--			LuaCUIArena.ShowUI()
--			if (LuaCUISystemSetting.m_bPlaySound) then
--				--播放场景音乐
--				SoundUtility.play(this.mMap.m_nMapID.toString())
--			end
--		--门派位阶
--		elseif (nBattleType==CProModule.BATTLE_TYPE_SchoolChallenge_pvp or nBattleType==CProModule.BATTLE_TYPE_SchoolChallenge_pve or nBattleType==CProModule.BATTLE_TYPE_SchoolApprientice) then
--			LuaCUISchoolWeijie.ShowUI()
--			if (nBattleType==CProModule.BATTLE_TYPE_SchoolApprientice) then
--				LuaCUISchoolTeacher.ShowUI()
--			end
--		--迷宫
--		elseif (nBattleType==CProModule.BATTLE_TYPE_Maze or nBattleType==CProModule.BATTLE_TYPE_MysticMaze) then
--			CUIMaze.gCUIMaze.hideAutoPrice()
--			CUIMaze.gCUIMaze.ShowUI()
--		--提示框内组件容器0
--		elseif (nBattleType==CProModule.BATTLE_TYPE_MultiFB) then
--			CTeamDataManager.gCTeamDataManager.teamID=-1
--			CUITeamFBSelect.gCUITeamFBSelect.ShowUI()
--			if (LuaCUISystemSetting.m_bPlaySound) then
--				--播放场景音乐
--				SoundUtility.play(this.mMap.m_nMapID.toString())
--			end
--		elseif (nBattleType==CProModule.BATTLE_TYPE_LocalSelectWar) then
--			LuaCServerWarModule.SendMessageGetWorldWarInfoRequest()
--		--巅峰对决
--		elseif (nBattleType==CProModule.BATTLE_TYPE_WorldArena) then
--			CUIPeakVS.gUIPeakVS.ShowUI()
--			if (LuaCUISystemSetting.m_bPlaySound) then
--				--播放场景音乐
--				SoundUtility.play(this.mMap.m_nMapID.toString())
--			end
--		end
--		--是否有升级动画需要播放
--		if (CUIManager.gUIManager.m_bPlayLeveUpEffect) then
--			CUIManager.gUIManager.SetLevelUpEffect()
--		end
--		--任务提示计时开始
		LuaCAutoTraceManager.StartCount()
		--如果是剧情副本战斗完成，看玩家身上是否有完成的主线任务，有则自动寻路交任务
		if (nBattleType == BATTLE_TYPE_OGRE) then
			nTaskID = LuaCTaskManager.GetCompleteTask(1)
			if (nTaskID > 0 and not LuaCUIOpenFunc.GetVisible()) then
--				--有已完成主线任务，则自动寻路完成,不跨地图寻路
				--LuaCAutoTraceManager.StartCurAutoTrace(nTaskID,false)
			end
		end
--		--在任务追踪界面显示箭头提示
--		CUITaskTrace.gUITaskTrace.ShowArrowTip()
--		if (LuaCUISystemSetting.m_bPlaySound) then
--			--播放场景音乐
--			SoundUtility.play(this.mMap.m_nMapID.toString())
--		end
--	end
--	--子控件，用于界面元素居中0
--	if (LuaCHeroProperty.m_nStrength<=0) then
--		CUIHelpTip.gCUIHelpTip.showDazuo()
--	end
--	BagBox=CItemModule.gItemModule.GetItemBox(ITEM_WHERE_BAGGAGE)
--	if (BagBox:GetSpaceTotalNum()==0 and --以下战斗会有装备掉出，若玩家背包已满，给予提示
--        (nBattleType==BATTLE_TYPE_OGRE--普通怪 
--        or nBattleType==BATTLE_TYPE_HERO_OGRE--精英怪 
--        or nBattleType==CProModule.BATTLE_TYPE_MultiFB--多人副本 
--        or nBattleType==CProModule.BATTLE_TYPE_JXZ)) then
--				--聚贤庄
--		LuaCUIFlyTips.ShowFlyTips(LanguageData.gLanguageData.UI_WEBGAME_024)
--	end
--	--是否存在传闻
--	if (LuaCChatModule.mPrizeInfo~="") then
--		CUIChat.gUIChat.putMsg(LuaCChatModule.mPrizeInfo,CUIChat.MSG_TYPE_SYSTEM,CUIChat.MSG_SUBTYPE_HORN,0,0,0,LanguageData.gLanguageData.UI_WEBGAME_025)
--		LuaCChatModule.mPrizeInfo=""
--	end
--	--是否存在提示
--	if (String(CUIChat.gUIChat.mPromptInfo).length>0) then
--		t=0
--		while  t<String(CUIChat.gUIChat.mPromptInfo).length  do
--			CUIChat.gUIChat.putMsg(CUIChat.gUIChat.mPromptInfo[t],CUIChat.MSG_TYPE_SYSTEM,CUIChat.MSG_SUBTYPE_HORN,0,0,0,LanguageData.gLanguageData.UI_WEBGAME_026)
--						t=t+1
--		end
--		CUIChat.gUIChat.mPromptInfo={}
--	end
--	LuaCActivityModule.PlayBackInterceptDart()
end

function LuaCitySceneManager.StopSceneSound()
    local mapGameObject = UnityEngine.GameObject.Find("citymap");
    if (mapGameObject ~= nil) then
        local audioSource = mapGameObject:GetComponent("AudioSource");
        if (audioSource ~= null) then
            audioSource:Stop();
        end
    end
end
function LuaCitySceneManager.PlaySceneSound()
    local mapGameObject = UnityEngine.GameObject.Find("citymap");
    if (mapGameObject ~= nil) then
        local audioSource = mapGameObject:GetComponent("AudioSource");
        if (audioSource ~= null) then
            audioSource:Play();
        end
    end
end
--endregion
