local this = LuaGameFrameWork
LuaGameFrameWork = 
{ 
	isHideMpc = 0x00000f,
	mGameState = 0,
	mMap = nil,
	m_BattleMapParent = nil,
	mRoleManager = nil,             	    --角色管理器
	
	
	mBattleManager = nil,	--战斗管理器
	mMultiBattleManager = nil,	--多人副本战斗管理器
	m_UIManager = nil,			--文件数据0
	m_UICreateCharacter = nil,		--创建角色界面
	
	mStateBuffer = nil,									--记录游戏中的状态信息，0位标记是否进行提示任务提醒
	m_arrInfo = {},								--连续飘字的数据
	m_numFrame = 0,										--连续飘字效果的帧速
}

local nLoadCompleteEventTimer = 0;			--加载完成计数

function LuaGameFrameWork.ctor()
	
	this.mGameState = GAMG_STATE_INIT;
	this.mRoleManager=CRoleManager.new()


	this.mBattleManager = CBattleManager.new()
	this.m_BattleMapParent=DisplayObjectContainer.new
	this.addChild(this.m_BattleMapParent)
	this.m_BattleMapParent.addChild(this.mBattleManager.m_BattleMap)
	this.mBattleManager.m_BattleMap.visible=false
	this.mMultiBattleManager=CMultiBattleManager.new
	this.mMultiBattleManager.m_BattleMap=this.mBattleManager.m_BattleMap
	--			m_StoryManager=new CStoryManager;
	--			addChild(m_StoryManager);
	--UI层
	this.m_UIManager=CUIManager.new()
	--游戏层管理类初始化
	CGameLayerManager.initLayers(this)
	--当前正在下载的小包的索引1
	CPreBattleTalent.new
	CFloatEffectManager.new
	--加载脏词
	LuaCDirtyWord.init()
	
	this.m_nPreTime=getTimer()
	this.mStateBuffer=Byte{}()
end
	--登录验证返回
function LuaGameFrameWork.OnLoginSceneResponse(e)
	local nRoleID=0
	--验证通关，关闭登录界面，初始化游戏
	GameMain.instance.clearLogin()
	nRoleID=LuaCHeroProperty.mCharID
	if (nRoleID==0) then
			--没有角色，需要创建角色
	end
		this.m_UICreateCharacter=CUICreateCharacter.new
		this.m_UICreateCharacter.ShowUI()
		CGameLayerManager.loadingContainer.addChild(this.m_UICreateCharacter)
	elseif (nRoleID>0) then
		--有角色，显示加载界面
		this.startGame()
	elseif (nRoleID==-1) then
		CUIConfirm.gCUIConfirm.show(GameMain.instance.getLanguageStr("FrameModule_STOP_Account"),function(){GameMain.instance.logout();})
	end
end
	--创建角色返回
function LuaGameFrameWork.OnCreateCharResponse(nRoleID)
	Account.postCreatRole(CUserAccount.ServerID.toString(),CUserAccount.ServerID.toString(),CUserAccount.UserName,nRoleID.toString(),LuaCHeroProperty.mName,1)
	this.m_UICreateCharacter.HideUI()
	OnSendIDFA(1)
	this.startGame()
end
	--开始游戏
function LuaGameFrameWork.startGame()
	--激活码界面00
	stage.addChild(FrameEventUtility.startEngine())
	FrameEventUtility.add(OnFrame)
	this.showLoading()
end
	--我的版本1
function LuaGameFrameWork.showLoading()
	CTextureManager.gTextureManager.splitImage("images/ui/loadingpanel.xml","images/ui/loadingpanel")
	CUILoadingPanel.gUILoadingPanel.ShowLoginLoadRes()
	CUILoadingPanel.gUILoadingPanel.addEventListener(CUILoadingPanel.EVENT_LOAD_COMPLETE,this.onLoadResEnd)
	this.mGameState=GAME_STATE_LOGIN_LOADING
end
	--主角登录游戏
function LuaGameFrameWork.OnNotifyYourProData()
	Account.postLoginRole(CUserAccount.ServerID.toString(),CUserAccount.ServerID.toString(),CUserAccount.UserName,LuaCHeroProperty.mCharID.toString(),
		LuaCHeroProperty.mName,LuaCHeroProperty.mLevel)
	--			GameRecharge.addPayEventListener();
	Account.postEnterGame()
	if (this.mGameState==GAME_STATE_LOGIN_LOADING) then
		--判断是否需要下载20资源包
	--				var bNeedLoardRes:Boolean=CPartPackageInfo.IsDownload(LuaCMapModule.mCurMapID);
	--				if(bNeedLoardRes)
	--				{
	--					CPartPackageInfo.downLoadCompleteCallback=CUILoadingPanel.gUILoadingPanel.loadSpcRes;
	--					CPartPackageInfo.startDownload();
	--整包版本0
	--				else
			CUILoadingPanel.gUILoadingPanel.loadSpcRes()
		end
	end
	CreaterSpc()
end
	--初始化游戏逻辑
function LuaGameFrameWork.InitGameLogic()
	--初始化声音模块			
	SoundUtility.init()
	--初始化场景名称
	CSceneNameManager.gSceneNameManager.Init()
	--记录玩家登陆界面的时间
	LuaCProModule.loginDate=GameFrameWork.instance.GetSeverDate()
end
	--资源加载完成
function LuaGameFrameWork.onLoadResEnd(e)
	nLoadCompleteEventTimer=5
end
function LuaGameFrameWork.OnFrame()
	local nCurTime=0
	local nDownCurTime=0
	if (stage.stageWidth==0 or stage.stageHeight==0) then
		return 
	end
	nCurTime=getTimer()
	this.m_nLastFrameTime=nCurTime
	--游戏初始化时不进行下面代码
	if (this.mGameState==GAMG_STATE_INIT) then
		return 
	end
	--理游戏服务器消息
	this.mLoigcManager.OnTimer()
	--最新版本0
	ProcessKeyboardInput()
	if (this.mGameState==GAME_STATE_LOGIN_LOADING) then
	elseif (this.mGameState==GAME_STATE_SCENE_LOADING) then
	elseif (this.mGameState==GAME_STATE_BATTlE_LOADING) then
			if (nLoadCompleteEventTimer>0) then
				nLoadCompleteEventTimer=nLoadCompleteEventTimer-1
				if (nLoadCompleteEventTimer==0) then
					if (this.mGameState==GAME_STATE_BATTlE_LOADING) then
						CBattleManager.gBattleManager.OnLoadComplete()
					else
						this.showGameUI()
						this.mGameState=GAMG_STATE_CITY
					end
				end
			elseif (this.mGameState==GAMG_STATE_CITY) then
			--处理玩家数据更新
			this.mRoleManager.Update()
			--处理地图数据更新	
			if (this.mMap~=nil) then
				this.mMap.Update()
			elseif (this.mGameState==GAME_STATE_BATTLE) then
			this.mBattleManager.Update()
	elseif (this.mGameState==GAME_STATE_MULTI_BATTLE) then
			this.mMultiBattleManager.Update()
	elseif (this.mGameState==GAME_STATE_STORY) then
			--				m_StoryManager.Update();
	else
			break
	end
	
	
	--			if(CExpTipsEffectManager!=null)
	--			{
	--				CExpTipsEffectManager.gExpTipsEffectManger.OnFrame();
	--			}
	if (String(this.m_arrInfo).length>0) then
	--				if(mGameState==GAMG_STATE_CITY&&!CItemModule.gItemModule.jadeFlag)
	--				{
	--					if(!CExpTipsEffectManager.gExpTipsEffectManger.floatVisble)
	--					{
	--总下载量0
	--					}
	--					if(m_numFrame%25==0)
	--					{
	--						LuaCUIFlyTips.ShowFlyTips(m_arrInfo.shift());
	--					}
	--				}
	--				else
	--				{
	--					CExpTipsEffectManager.gExpTipsEffectManger.floatVisble=false;
	--正在更新资源的信息0
		this.m_numFrame = this.m_numFrame+1
	else
		this.m_numFrame = 0
	end
end
	--切换到游戏场景界面
function LuaGameFrameWork.showGameUI()
	CUIManager.gUIManager.CloseAllUI()
	--			CSoundManager.gSoundManager.LoadSoundConfig();
	--判断是否正在进行活动，有的话则加重相关活动资源
	if (LuaCActivityModule.mCurrentActivity==ACTIVITY_TYPE_WORLDBOSS_RAID_VULTURE or LuaCActivityModule.mCurrentActivity==ACTIVITY_TYPE_WORLDBOSS_CRAZE_APE or LuaCActivityModule.mCurrentActivity==ACTIVITY_TYPE_FACTIONBOSS) then
		CUIManager.gUIManager.ShowWorldBossUI()
		if (LuaCUISystemSetting.m_bPlaySound) then
			--播放场景音乐
			SoundUtility.play(LuaCActivityModule.mCurrentActivity.toString())
		end
	elseif (LuaCActivityModule.mCurrentActivity==ACTIVITY_TYPE_SCHOOL_BATTLE) then
		CUIManager.gUIManager.ShowSchoolBattleUI()
		if (LuaCUISystemSetting.m_bPlaySound) then
			--播放场景音乐
			SoundUtility.play(LuaCActivityModule.mCurrentActivity.toString())
		end
	elseif (LuaCActivityModule.CheckCurrentFactionWar()) then
		CUIManager.gUIManager.ShowFactionWarUI()
		if (LuaCUISystemSetting.m_bPlaySound) then
			--播放场景音乐
			SoundUtility.play(LuaCActivityModule.mCurrentActivity.toString())
		end
	elseif (LuaCActivityModule.mCurrentActivity==ACTIVITY_TYPE_QUESTION) then
		CUIManager.gUIManager.ShowQuestionsAnswersUI()
		if (LuaCUISystemSetting.m_bPlaySound) then
			--播放场景音乐
			SoundUtility.play(LuaCActivityModule.mCurrentActivity.toString())
		end
	else
		CUIManager.gUIManager.ShowMainUI()
		--CUIUnlockFunctionPrompt.gUnlockFunctionPrompt.ShowWaitFunctionUI()
		if (LuaCUISystemSetting.m_bPlaySound) then
			--播放场景音乐
			SoundUtility.play(this.mMap.m_nMapID.toString())
		end
	end
	UpdateMainUI()
	--			CUIPromptManager.gPromptManager.LoadPromptConfigXmL();
	--下载更新任务列表0
	LuaCAutoTraceManager.StartCount()
	--判断体力是否充足
	if (LuaCHeroProperty.m_nStrength<=0) then
		CUIHelpTip.gCUIHelpTip.showDazuo()
	end
	if (LuaCHeroProperty.GetPlayerLevel()==1) then
		CUIWelcome.gUIWelcome.ShowUI()
	end
	CUIManager.gUIManager.GameIn()
	CUILoadingPanel.gUILoadingPanel.HideUI()
	System.gc()
end
function LuaGameFrameWork.UpdateMainUI()
	local i=0
	local arrOfflineKey
	local nCharID=0
	local playerProperty
	local button
	local arrFriendInfo
	local objFriendInfo
	local nCharID1=0
	local showMe
	local date
	CUIManager.gUIManager.UpdateUIArrowPromptForLevel()
    LuaCUIHeroHead.UpdateUI();
	CUIMainShortcutBar.gUIMainShortcutBar.initShowBtn()
    LuaCUIMainBottomBar.UpdateExp();
	CUIRightShortcutBar.gUIRightShortcutBar.UpdateSenceName()
    LuaCUIMainTopBar.UpdataTopActivityBtn();
	CUILeftShortcutBar.gUILeftShortcutBar.Update()
	CUIChat.gUIChat.UpdateChannelBtn()
	CUIHelpTip.gCUIHelpTip.visible=false
	--更新打坐界面
	CUIPracticeTip.gUIPracticeTip.setPracticeInfo()
	i=0
	if (CFriendModule.gFriendModule.isChatTip) then
		arrOfflineKey=CFriendModule.gFriendModule.mOfflineMsgMap.keys()
		i=0
		while  i<String(arrOfflineKey).length  do
			nCharID=arrOfflineKey[i]
			playerProperty=CFriendModule.gFriendModule.mOfflineMsgMap.getValue(nCharID)
			--添加到私聊提示框数组中，启动私聊提示5秒显示倒计时
			CFriendModule.gFriendModule.mChatTip.put(nCharID,playerProperty)
			if (not CFriendModule.gFriendModule.chatTipTime) then
				CFriendModule.gFriendModule.chatTipTime=true
			end
			CFriendModule.gFriendModule.chatTipTimeCount=0
						i=i+1
		end
		CUIFriendChatTip.gUIFriendChatTip.ShowUI()
		--添加有聊天信息的感叹号提示
		button=CUIMainShortcutBar.gUIMainShortcutBar.m_FriendBtn
		CHelpEffectManager.gCHelpEffectManager.showEffect(button,"plaint",24,0)
	end
	--离线添加好友的通知
	if (CFriendModule.gFriendModule.isAddedFriend) then
		CFriendModule.gFriendModule.isAddedFriend=false
		arrFriendInfo=CFriendModule.gFriendModule.mAddedFriend
		if (arrFriendInfo~=nil) then
			i=0
			while  i<String(arrFriendInfo).length  do
				objFriendInfo=arrFriendInfo[i]
				if (objFriendInfo~=nil) then
					CUIFriendList.gFriendsList.NotifyAttended(objFriendInfo.name,objFriendInfo.id)
				end
								i=i+1
			end
		end
	end
	if (LuaCActivityModule.isHistory) then
		nCharID1=LuaCActivityModule.mPlayerID
		CChatManager.gChatManager.ShowPrivateChat(nCharID1)
	end
	--日常任务
	--LuaCUIDailyView.gCUIDailyView.parseShowList()
	--			//更新公告xml
	--			CXMLManager.gXMLManager.LoadXMLData("%63%6F%6E%66%69%67%2F%75%70%64%61%74%65%62%75%6C%6C%65%74%69%6E%2E%78%6D%6C",CUIUpdateBulletin.gUIUpdateBulletin.ReadUpdateBulletinXml);
	--			//VIP信息XML
	--是否需要检测更新包大小0
	--加载错误码配置文档
	this.mErrorCode.LoadErrorCodeXml()
	

	--显示功能预告
	CUINextGuide.gCUINextGuide.showNextGuide()
	--在任务追踪界面显示箭头提示
	if (CUITaskTrace.gUITaskTrace~=nil) then
		CUITaskTrace.gUITaskTrace.ShowArrowTip()
	end
	--在线时长奖励加上服务器时间
	date=GetSeverDate()
	LuaCHeroProperty.mOnlinePrizeTime=LuaCHeroProperty.mOnlinePrizeCd+(date.time/1000)
	if (LuaCMainFunction.HasFunction(LuaCMainFunctionType.MAIN_FUNCTION_Activity) or LuaCMainFunction.HasFunction(LuaCMainFunctionType.MAIN_FUNCTION_SERVER_WAR)) then
		--请求江湖活动数据
		LuaCActivityModule.SendCMessageGetAllActivityInfoRequest()
		--获取配置文件中的江湖活动数据
		--				CXMLManager.gXMLManager.LoadXMLData("%63%6F%6E%66%69%67%2F%75%69%2F%61%63%74%69%76%69%74%79%76%69%65%77%2E%78%6D%6C",CommonMethod.getActivityInfo);
	end
	--判断是否存在新邮件
	if (LuaCHeroProperty.mUnreadMail) then
		CUIRightShortcutBar.gUIRightShortcutBar.isShowNewMail(true)
	end
end
function LuaGameFrameWork.OnClickScene(event)
	local nMouseX = 0;
	local nMouseY = 0;
	
	--计算地图坐标
	nMouseX=Math.abs(event.stageX-this.mMap.x)
	nMouseY=Math.abs(event.stageY-this.mMap.y)
	--显示加载百分比的容器0
	CRoleManager.gRoleManager.m_hero.mSelectObjID=0
	--点击其他地点时清空任务副本标记
	if (LuaCUICommonFB~=nil) then
		LuaCUICommonFB.ResetPBFlag()
	end
	--判断是否在自动追踪的保护时间内
	if (LuaCAutoTraceManager.IsInAutoTraceProtectTimer()) then
		return 
	end
	if (LuaCAutoTraceManager.IsAutoTrace()) then
		LuaCAutoTraceManager.EndAutoTracing()
	end
	if (this.mMap~=nil) then
		SpcMove(nMouseX,nMouseY,LuaCHeroProperty.mAlive)
	end
end
	--		public function onDoubleClick(e:TouchEvent):void
	--		{
	--			var nMouseX:int=mMap.mouseX;
	--			var nMouseY:int=mMap.mouseY;
	--			
	--			CRoleManager.gRoleManager.m_hero.mSelectObjID=0;
	--			
	--QQ登录选择界面00
	--子控件，用于界面元素居中1
	--			{
	--				LuaCAutoTraceManager.EndAutoTracing();
	--			}
	--			
	--			//点击其他地点时清空任务副本标记
	--			if(LuaCUICommonFB!=null)
	--			{
	--				LuaCUICommonFB.ResetPBFlag();
	--进度条容器0
	--			
	--			if(mMap!=null)
	--			{
	--				SpcMove(nMouseX,nMouseY,LuaCHeroProperty.mAlive);
	--			}
	--		}
	--主角地图移动事件-1无角色		0直接移动到位置		1移动到位置后有操作
function LuaGameFrameWork.SpcMove(nMouseX,nMouseY,isLive)
	if isLive == nil then isLive=true end
	local nCurTimer=0
	local selecNPC
	local npcPro
	local selecMPC=getTimer()
	if (nCurTimer-LuaCHeroProperty.mFightTimer<500) then
		--界面默认缩放比例3
	end
		return  0
	end
	--停止打坐
	if (GameFrameWork.instance.mMap.mPlayer.ActionState==CharacterSprite2.ACTION_SIT) then
		CUIPracticeTip.gUIPracticeTip.stopRest()
	end
	--隐藏私聊管理提示
	if (CUIFriendChatTip.gUIFriendChatTip.flag==CUIFriendChatTip.MANAGER) then
		CUIFriendChatTip.gUIFriendChatTip.HideUI()
	end
	--隐藏显示的玩家头像面板
	if (CUISpcHeadPlayer.gUISpcHeadPlayer.visible) then
		CUISpcHeadPlayer.gUISpcHeadPlayer.HideUI()
	end   
    end
	if (CRoleManager.gRoleManager==nil) then
		return -1
	end
	--判处是否点击在NPC身上
	selecNPC=CRoleManager.gRoleManager.GetSelectNpc(nMouseX,nMouseY)
	if (selecNPC~=nil) then
		--如果是阻挡npc则再最近的地方停下
		npcPro=LuaCProModule.GetPropertyByEntityID(selecNPC.m_unEntityID)
		if (npcPro~=nil and npcPro.mEntityType == ENTITYTYPE_BLOCK) then
			--向点击的地方位置移动
			this.mMap.MoveToMap(nMouseX,nMouseY,isLive)
		else
			this.mMap.MoveToNpc(selecNPC.m_unEntityID,selecNPC.mCellX,selecNPC.mCellY,isLive)
		end
		return  0
	end
	selecMPC=CRoleManager.gRoleManager.GetSelectMpc(nMouseX,nMouseY,CheckSelectPVPPlayer)
	if (selecMPC~=nil) then
		this.mMap.MoveToMpc(selecMPC.m_unEntityID,selecMPC.mCellX,selecMPC.mCellY,isLive)
		return  0
	end
	--更新内容背景图0
	this.mMap.MoveToMap(nMouseX,nMouseY,isLive)
	return  0
end

function LuaGameFrameWork.OnMouseDown(e)

	OnClickScene(e)
end
function LuaGameFrameWork.OnMouseUp(e)

	if (this.m_UIManager~=nil and this.m_UIManager.m_PickObjectIcon~=nil and this.m_UIManager.m_PickObjectIcon.IsExist()) then
		if (e.target==this and CUIPickObjectIcon.gPickObjectIcon.mType==CUIPickObjectIcon.PICK_TYPE_ITEM) then
			--丢弃物品
		else
			CUIPickObjectIcon.gPickObjectIcon.Resume()
		end
	end
end
function LuaGameFrameWork.OnMouseOut(e)
	--mbMouseDown=false;
end

	--创建主角色
function LuaGameFrameWork.CreaterSpc()
	local unEntityID=0
	local strRoleName
	local strClothesUrl
	local nDisguiseMaskID=0
	local pTplDisguiseMask
	local nPosX=0
	local nPosY=0
	local nDirection=0
	local nRideID=0
	local nArtifact
	local nPlayerStatus=0
	local cTpl
	local pItem
	local artifactData
	local strTitle
	local nAddSpeedPre
	local nPhaseIndex=0
	unEntityID=LuaCHeroProperty.m_unEntityID
	strRoleName=LuaCHeroProperty.mName
	strClothesUrl=""
	nDisguiseMaskID=LuaCHeroProperty.mDisguiseMaskID
	if (nDisguiseMaskID~=0) then
		pTplDisguiseMask=CDataStatic.SearchTpl(nDisguiseMaskID)
		if (nil==pTplDisguiseMask) then
			strClothesUrl=LuaCHeroProperty.GetRoleClothesUrl()
		else
			strClothesUrl="config/npc/"..pTplDisguiseMask.mModalName..".xml"
		end
	else
		strClothesUrl=LuaCHeroProperty.GetRoleClothesUrl()
	end
	this.mRoleManager.m_hero.SetDisguiseMaskID(nDisguiseMaskID)
	nPosX=LuaCHeroProperty.mPosX
	nPosY=LuaCHeroProperty.mPosY
	nDirection=LuaCHeroProperty.mDirection
	nRideID=LuaCHeroProperty.mCurRideID
	--判断所创建的玩家是否开启打坐功能
	if (LuaCMainFunction.HasFunction(LuaCMainFunctionType.MAIN_FUNCTION_CULTIVATION)==true) then
		nPlayerStatus=1
	else
		nPlayerStatus=0
	end
	--加载坐骑配置文件
	CRideConfig.LoadRideConfigXml()
	--加载翅膀配置文件
	CWingConfig.LoadWingConfigXml()
	--设置人物方向
	this.mRoleManager.CreaterSpc(unEntityID,strRoleName,strClothesUrl,nPosX,nPosY,nDirection,nRideID,nPlayerStatus)
	this.mRoleManager.m_hero.OnMoveCellCallBack=OnSpcMoveCellCallBack
	this.mRoleManager.m_hero.OnClickNpcCallBack=OnClickObj
	this.mRoleManager.m_hero.OnClickMpcCallBack=OnClickPlayer
	this.mRoleManager.m_hero.OnStartMoveCallBack=OnStartMoveCallBack
	this.mRoleManager.m_hero.OnEndMoveCallBack=OnEndMoveCallBack
	--1:放大过程，2缩小过程,0初始状态0
	nArtifact=CItemModule.gItemModule.GetArtifactID()
	if (nArtifact~=nil and String(nArtifact).length>1) then
	if (0<nArtifact[0]) then
			--刷新神器
			cTpl=CDataStatic.spArtifactConfig
			if (cTpl==nil) then
				return 
			end
			pItem=CDataStatic.SearchTpl(nArtifact[0])
			artifactData=cTpl.getArtifactData(pItem.mQuality)
			if (nArtifact[1]>=artifactData.effectBeginLv) then
				CRoleManager.gRoleManager.ChangeWing(unEntityID,nArtifact[0])
			end
	end
	end
	--设置人物头顶称号
	strTitle=CommonMethod.GetPlayerTitleText(LuaCHeroProperty.mMaxCombatPower)
	this.mRoleManager.m_hero.SetTitle(strTitle)
	UpdateSpcAlive()
	--设置玩家速度
	nAddSpeedPre=0
	nPhaseIndex=nRideID-1
	if (nPhaseIndex>=0 and nPhaseIndex<MAX_HORSE_PHASE and CDataStatic.spHorseConfig~=nil and this.mRoleManager.m_hero.m_nDisguiseMaskID==0) then
		nAddSpeedPre=CDataStatic.spHorseConfig.mSpeed[nPhaseIndex]/10000
	end
	this.mRoleManager.m_hero.SetAddMoveSpeed(nAddSpeedPre)
	--阵营战中不显示称号图标
	if (not LuaCActivityModule.CheckCurrentFactionWar()) then
		this.mRoleManager.UpdateRoleTitle(unEntityID,
			LuaCHeroProperty.mArenaPlace+1,
			LuaCSchoolProperty.schoolType,
			LuaCHeroProperty.mTitle & SCHOOL_MASTER,
			(LuaCHeroProperty.mTitle & SERVER_MASTER)>>2,
			(LuaCHeroProperty.mTitle & FACTION_MASTER)>>1)
	end
end
	--创建其他玩家
function LuaGameFrameWork.CreaterMpc(Entity)
	local strURL
	local pTplDisguiseMask
	local Mpc
	local campID=0
	local myID=0
	local strTitle
	local nAddSpeedPre
	local nPhaseIndex=0
	if (this.mRoleManager.m_MpcMap.size()>=this.mMap.mMaxPlayerNum) then
		return 
	end
	strURL=""
	if (Entity.mDisguiseMaskID~=0) then
		pTplDisguiseMask=CDataStatic.SearchTpl(Entity.mDisguiseMaskID)
		if (nil==pTplDisguiseMask) then
			strURL=Entity.GetRoleClothesUrl()
		else
			strURL="config/npc/"..pTplDisguiseMask.mModalName..".xml"
		end
	else
		strURL=Entity.GetRoleClothesUrl()
	end
	Mpc=this.mRoleManager.CreaterMpc(Entity.m_unEntityID,strURL,Entity.mPosX,Entity.mPosY,Entity.mDirection,Entity.mCurRideID,Entity.mPlayerStatus,Entity.mDisguiseMaskID)
	if (Mpc==nil) then
		return 
	end
	--			Mpc.name=Entity.mName;
	campID=Entity.mCampID
	myID=LuaCHeroProperty.mCampID
	if (Entity.mCampID~=LuaCHeroProperty.mCampID and Entity.mCampID~=0) then
		Mpc.mTextName.htmlText="<font color='#ff0000'>"..Entity.mName.."</font>"
	else
		Mpc.mTextName.htmlText="<font color='#ffffff'>"..Entity.mName.."</font>"
	end
	if (Entity.mCampBattleState==1) then
		Mpc.SetHeadBattleIcon("images/icon/head/fighting.png")
	end
	Mpc.setGray(not Entity.mAlive)
	HideOrShowPlayerMpc(Mpc)
	strTitle=CommonMethod.GetPlayerTitleText(Entity.mMaxCombatPower)
	Mpc.SetTitle(strTitle)
	Mpc.OnMoveCellCallBack=OnMpcMoveCellCallBack
	nAddSpeedPre=0
	nPhaseIndex=Entity.mCurRideID-1
	if (nPhaseIndex>=0 and nPhaseIndex<MAX_HORSE_PHASE and CDataStatic.spHorseConfig~=nil and Mpc.m_nDisguiseMaskID==0) then
		nAddSpeedPre=CDataStatic.spHorseConfig.mSpeed[nPhaseIndex]/10000
	end
	Mpc.SetAddMoveSpeed(nAddSpeedPre)
	--刷新称号
	--阵营战中不显示称号图标
	if (not LuaCActivityModule.CheckCurrentFactionWar()) then
		this.mRoleManager.UpdateRoleTitle(Entity.m_unEntityID,Entity.mArenaPlace,Entity.mSchoolType,
			Entity.mTitle & SCHOOL_MASTER,
			(Entity.mTitle & SERVER_MASTER)>>2,
			(Entity.mTitle & FACTION_MASTER)>>1)
	end
	--创建翅膀
	CRoleManager.gRoleManager.ChangeWing(Entity.m_unEntityID,Entity.mArtifactInfo&0x00ffff)
end
function LuaGameFrameWork.HideOrShowPlayerMpc(Mpc)
	if (LuaCActivityModule.mCurrentActivity==ACTIVITY_TYPE_WORLDBOSS_RAID_VULTURE or LuaCActivityModule.mCurrentActivity==ACTIVITY_TYPE_WORLDBOSS_CRAZE_APE or LuaCActivityModule.mCurrentActivity==ACTIVITY_TYPE_QUESTION or LuaCActivityModule.mCurrentActivity==ACTIVITY_TYPE_FACTIONBOSS) then
		if ((this.isHideMpc&(1<<1))==0) then
			Mpc.visible=false
		else
			Mpc.visible=true
		end
	elseif (LuaCActivityModule.CheckCurrentFactionWar()) then
		--确认0
		Mpc.visible=true
	elseif ((this.isHideMpc&(1<<0))==0) then
		--已点击隐藏玩家按钮,隐藏城镇玩家
	end
		Mpc.visible=false
	else
		Mpc.visible=true
	end
end

	--删除角色
function LuaGameFrameWork.DeleteMpc(unEntityID)
	this.mRoleManager.DeleteMpc(unEntityID)
end
	--创建NPC
function LuaGameFrameWork.CreaterNpc(unEntityID,nEntityType,nTempID,nPosX,nPosY,nDirection,bAliveState)
	if bAliveState == nil then bAliveState=false end
	local strName
	local strModelName
	local OgreTemp
	local BlockTemp
	local NpcTemp=""
	strModelName=""
	if (nEntityType == ENTITYTYPE_OGRE) then
		OgreTemp=CDataStatic.SearchTpl(nTempID)
		if (OgreTemp~=nil) then
			strName=OgreTemp.mName
			strModelName=OgreTemp.mModelName
		end
	elseif (nEntityType == ENTITYTYPE_BLOCK) then
		BlockTemp=CDataStatic.SearchTpl(nTempID)
		if (BlockTemp~=nil) then
			strName=BlockTemp.mName
			strModelName=BlockTemp.mModelName
			if (CGameMap.gGameMap~=nil) then
				CGameMap.gGameMap.SetDynamicGridBlock(BlockTemp.mArrPos,nPosX,nPosY)
			end
		end
	else
		NpcTemp=CDataStatic.SearchTpl(nTempID)
		if (NpcTemp~=nil) then
			strName=NpcTemp.mName
			strModelName=NpcTemp.mModelName
		end
	end
	this.mRoleManager.CreaterNpc(unEntityID,strName,nTempID,nPosX,nPosY,nDirection,bAliveState,strModelName)
	--如果是否是任务追踪npc
	if (nEntityType == ENTITYTYPE_FUNCNPC) then
		--如果是功能npc,判断是否有任务
		LuaCTaskUIManager.SetNpcTaskState(unEntityID,nTempID)
		LuaCAutoTraceManager.CheckTaskTrace(unEntityID,nTempID,nPosX,nPosY)
	end
end
	--删除NPC
function LuaGameFrameWork.DeleteNpc(unEntityID)
	this.mRoleManager.DeleteNpc(unEntityID)
end
	--地图上实体移动	
function LuaGameFrameWork.OnEntityPath(unEntityID,toCellX,toCellY)
	this.mRoleManager.OnEntityPath(unEntityID,toCellX,toCellY)
end
	--取消0
function LuaGameFrameWork.OnEntityRest(unEntityID,nMapX,nMapY,nDirection)
	this.mRoleManager.OnEntityRest(unEntityID,nMapX,nMapY,nDirection)
end
	--地图上实体站起
function LuaGameFrameWork.OnEntityStand(unEntityID,nMapX,nMapY,nDirection)
	this.mRoleManager.OnEntityStand(unEntityID,nMapX,nMapY,nDirection)
end
	--地图上同步实体位置	
function LuaGameFrameWork.OnSyncPos(unEntityID,toCellX,toCellY)
	if (this.mGameState==GAMG_STATE_CITY) then
		this.mRoleManager.OnSyncPos(unEntityID,toCellX,toCellY)
	end
end

	--其他玩家移动单元格回调函数
function LuaGameFrameWork.OnMpcMoveCellCallBack(nEntityID,NextPoint)
	local NPCProperty = luaEntityProList[nEntityID];
	if (NPCProperty==nil) then
		return 
	end
	NPCProperty.mPosX=NextPoint.x
	NPCProperty.mPosY=NextPoint.y
end
	--点击NPC
function LuaGameFrameWork.OnClickObj(unEntityID)
	local NPCProperty
	local nW=0
	local nH=0
	CUINpcDlg.gpNpcDlg.mFunctionState=0
	--得到NPC实体数据
	NPCProperty = luaEntityProList[unEntityID];
	if (NPCProperty==nil) then
		return 
	end
	--判断NPC和玩家间的距离
	nW=CRoleManager.gRoleManager.m_hero.mCellX-NPCProperty.mPosX
	nH=CRoleManager.gRoleManager.m_hero.mCellY-NPCProperty.mPosY
	if (nW>1 or nW<-1 or nH>1 or nH<-1) then
		return 
	end
	if (LuaCAutoTraceManager.IsAutoTrace()) then
		LuaCAutoTraceManager.EndAutoTracing()
	end
	if (NPCProperty.mEntityType == ENTITYTYPE_FUNCNPC) then
		--选择的QQ平台登录类型00
	end
		OnClickFunctionNpc(NPCProperty);
	elseif (NPCProperty.mEntityType == ENTITYTYPE_OGRE) then
		--确认按钮(左边)1
	end
		OnClickOgre(NPCProperty);
	elseif (NPCProperty.mEntityType == ENTITYTYPE_PLAYER) then
			--其他玩家
	end
		OnClickPvpPlayer(NPCProperty);
	end
end
	--点击功能NPC
function LuaGameFrameWork.OnClickFunctionNpc(NPCProperty)
	local NpcTemp
	local arrNpcFunc
	local FBInfoObject
	local NpcData
	local SchoolType=0
	local HasTask
	local strTalk
	local i=0
	--得到NPC模板
	NpcTemp=Template.CDataStatic.SearchTpl(NPCProperty.mTemplateID)
	if (NpcTemp==nil) then
		return 
	end
	--npc功能数组
	arrNpcFunc={}()
	--判断是否是传送NPC
	if ((NpcTemp.mServiceType&CTemplateNpc.NPC_SERVICE_TYPE_STAGE)>0) then
		--先判断是否有副本信息
		local arrFBStarData = LuaCProModule.GetArrFBStarData(this.mMap.m_nMapID);
		if (arrFBStarData == nil) then
			--没有的话向服务器发送请求获得副本信息的消息
			LuaCProModule.SendGetMapDataRequest(this.mMap.m_nMapID, BATTLE_TYPE_OGRE)
		else
			LuaCUICommonFB.ShowFBInfo(this.mMap.m_nMapID);
		end
	elseif ((NpcTemp.mServiceType&CTemplateNpc.NPC_SERVICE_TYPE_FACTION_MAP)~=0) then
		LuaCProModule.SendPlayerTeleRequest(LuaCMapModule.mCurMapID)
	else
		NpcData=nil
		--激活码
		if ((NpcTemp.mServiceType&CTemplateNpc.NPC_SERVICE_TYPE_NWEERGIFTPACKAGE)>0) then
			NpcData = LuaCNpcDlgData.new()
			NpcData.mType=CNpcDlgData.TYPE_NPC_ACTIVATION_CODE
			--确认按钮(中间)0
			NpcData.mDlgOptionName=LanguageData.gLanguageData.UI_WEBGAME_012
			NpcData.mNpcEntityID=NPCProperty.m_unEntityID
			NpcData.mParam.push(0)
			NpcData.mParam.push(NpcTemp.mServiceParam)
			arrNpcFunc.push(NpcData)
		end
		--武器店
		if ((NpcTemp.mServiceType&CTemplateNpc.NPC_SERVICE_TYPE_EQUIP_SHOP)>0) then
			NpcData=CNpcDlgData.new()
			NpcData.mType=CNpcDlgData.TYPE_NPC_SHOP
			--NpcData.mDlgOptionName="%U6B66%U5668%U5E97";
			NpcData.mDlgOptionName=LanguageData.gLanguageData.UI_WEBGAME_013
			NpcData.mNpcEntityID=NPCProperty.m_unEntityID
			NpcData.mParam.push(0)
			NpcData.mParam.push(NpcTemp.mServiceParam)
			arrNpcFunc.push(NpcData)
		end
		--仓库
		if ((NpcTemp.mServiceType&CTemplateNpc.NPC_SERVICE_TYPE_STORAGE)>0 and LuaCMainFunction.HasFunction(LuaCMainFunctionType.MAIN_FUNCTION_STORAGE)) then
			NpcData=CNpcDlgData.new()
			NpcData.mType=CNpcDlgData.TYPE_NPC_WAREHOUSE
			--NpcData.mDlgOptionName="%U4ED3%U5E93";
			NpcData.mDlgOptionName=LanguageData.gLanguageData.UI_WEBGAME_014
			NpcData.mNpcEntityID=NPCProperty.m_unEntityID
			NpcData.mParam.push(0)
			NpcData.mParam.push(NpcTemp.mServiceParam)
			arrNpcFunc.push(NpcData)
		end
		--玉牌店
		if ((NpcTemp.mServiceType&CTemplateNpc.NPC_SERVICE_TYPE_JADE_CARD_SHOP)>0 and LuaCMainFunction.HasFunction(LuaCMainFunctionType.MAIN_FUNCTION_JADESHOP)) then
			NpcData=CNpcDlgData.new()
			NpcData.mType=CNpcDlgData.TYPE_NPC_SHOP
			--NpcData.mDlgOptionName="%U7389%U724C%U5E97";
			NpcData.mDlgOptionName=LanguageData.gLanguageData.UI_WEBGAME_015
			NpcData.mNpcEntityID=NPCProperty.m_unEntityID
			NpcData.mParam.push(0)
			NpcData.mParam.push(NpcTemp.mServiceParam)
			arrNpcFunc.push(NpcData)
		end
		--神秘商店
		if ((NpcTemp.mServiceType&CTemplateNpc.NPC_SERVICE_TYPE_SECRET_SHOP)>0 and LuaCMainFunction.HasFunction(LuaCMainFunctionType.MAIN_FUNCTION_MYSTICSHOP)) then
			NpcData=CNpcDlgData.new()
			NpcData.mType=CNpcDlgData.TYPE_NPC_SECRET_SHOP
			--NpcData.mDlgOptionName="%U795E%U79D8%U5546%U5E97";
			NpcData.mDlgOptionName=LanguageData.gLanguageData.UI_WEBGAME_016
			NpcData.mNpcEntityID=NPCProperty.m_unEntityID
			arrNpcFunc.push(NpcData)
		end
		--心法
		if ((NpcTemp.mServiceType&CTemplateNpc.NPC_SERVICE_TYPE_HEART_MAGIC)>0 and LuaCMainFunction.HasFunction(LuaCMainFunctionType.MAIN_FUNCTION_HEARTMAGEIC)) then
			NpcData=CNpcDlgData.new()
			NpcData.mType=CNpcDlgData.TYPE_NPC_HEARTMAGIC
			--取消按钮0
			NpcData.mDlgOptionName=LanguageData.gLanguageData.UI_WEBGAME_017
			NpcData.mNpcEntityID=NPCProperty.m_unEntityID
			arrNpcFunc.push(NpcData)
		end
		SchoolType=LuaCSchoolProperty.schoolType
		if (CTemplateSchoolConfig.gpScoolConfig.IsSchoolNpc(SchoolType,NpcTemp.mTempID)) then
			--门派信息								
			if ((NpcTemp.mServiceType&CTemplateNpc.NPC_SERVICE_TYPE_SCHOOL_INFO)>0) then
				NpcData=CNpcDlgData.new()
				NpcData.mType=CNpcDlgData.TYPE_NPC_SCHOOLDATA
				--NpcData.mDlgOptionName="%U95E8%U6D3E%U4FE1%U606F";
				NpcData.mDlgOptionName=LanguageData.gLanguageData.UI_WEBGAME_018
				NpcData.mNpcEntityID=NPCProperty.m_unEntityID
				arrNpcFunc.push(NpcData)
			end
			--挑战掌门
			if ((NpcTemp.mServiceType&CTemplateNpc.NPC_SERVICE_TYPE_SCHOOL_RANK)>0) then
				NpcData=CNpcDlgData.new()
				NpcData.mType=CNpcDlgData.TYPE_NPC_SCHOOLRANK
				--NpcData.mDlgOptionName="%U95E8%U6D3E%U6392%U884C";
				NpcData.mDlgOptionName=LanguageData.gLanguageData.UI_WEBGAME_019
				NpcData.mNpcEntityID=NPCProperty.m_unEntityID
				arrNpcFunc.push(NpcData)
			end
			--门派排行
			if ((NpcTemp.mServiceType&CTemplateNpc.NPC_SERVICE_TYPE_SCHOOL_CHALLENGE)>0) then
				NpcData=CNpcDlgData.new()
				NpcData.mType=CNpcDlgData.TYPE_NPC_CHALLENGEMASTER
				--NpcData.mDlgOptionName="%U6311%U6218%U638C%U95E8";
				NpcData.mDlgOptionName=LanguageData.gLanguageData.UI_WEBGAME_020
				NpcData.mNpcEntityID=NPCProperty.m_unEntityID
				arrNpcFunc.push(NpcData)
			end
		end
		if ((NpcTemp.mServiceType&CTemplateNpc.NPC_SERVICE_TYPE_HOTEL)>0 and LuaCMainFunction.HasFunction(LuaCMainFunctionType.MAIN_FUNCTION_INVITEPARTNER)) then
			NpcData=CNpcDlgData.new()
			NpcData.mType=CNpcDlgData.TYPE_NPC_TAVERN
			--NpcData.mDlgOptionName="%U9152%U9986";
			NpcData.mDlgOptionName=LanguageData.gLanguageData.UI_WEBGAME_021
			NpcData.mNpcEntityID=NPCProperty.m_unEntityID
			arrNpcFunc.push(NpcData)
		end
		--药店
		if ((NpcTemp.mServiceType&CTemplateNpc.NPC_SERVICE_TYPE_MEDICINESHOP)>0) then
			NpcData=CNpcDlgData.new()
			NpcData.mType=CNpcDlgData.TYPE_NPC_SHOP
			--NpcData.mDlgOptionName="%U836F%U5E97";
			NpcData.mDlgOptionName=LanguageData.gLanguageData.UI_WEBGAME_022
			NpcData.mNpcEntityID=NPCProperty.m_unEntityID
			NpcData.mParam.push(0)
			NpcData.mParam.push(NpcTemp.mServiceParam)
			arrNpcFunc.push(NpcData)
		end
		--确认按钮0
		HasTask=LuaCTaskManager.IsNpcHasTask(NpcTemp.mTempID)
		if (String(arrNpcFunc).length==1 and HasTask==false) then
			NpcData=arrNpcFunc[0]
			OnClickNpcDlg(NpcData)
		else
			CUINpcDlg.gpNpcDlg.ClearDlg()
			CUINpcDlg.gpNpcDlg.ShowUI()
			strTalk=CDataStatic.GetHXName(NpcTemp.mTalk)
			CUINpcDlg.gpNpcDlg.SetNpcInfo(NpcTemp.mName,NPCProperty.m_unEntityID,NpcTemp.mModelName,strTalk)
			i=0
			while  i<String(arrNpcFunc).length  do
				NpcData=arrNpcFunc[i]
				CUINpcDlg.gpNpcDlg.SetDlg(OnClickNpcDlg,NpcData,TASK_STATE_NONE)
								i=i+1
			end
			CUINpcDlg.gpNpcDlg.mFunctionState=1
			LuaCTaskUIManager.OnClickNpc(NPCProperty)
		end
	end
end
	--点击npc对话
function LuaGameFrameWork.OnClickNpcDlg(DlgData)
	if (DlgData==nil) then
		return 
	end
	if (DlgData.mType==CNpcDlgData.TYPE_NPC_ACTIVATION_CODE) then
			CUIActivationCode.gUIActivationCode.ShowUI()
		elseif (DlgData.mType==CNpcDlgData.TYPE_NPC_SHOP) then
			CUIShop.gUIShop.openPage(DlgData.mParam[0],DlgData.mParam[1],DlgData.mNpcEntityID)
			CUIBaggage.gUIBaggage.ShowUI()
		elseif (DlgData.mType==CNpcDlgData.TYPE_NPC_WAREHOUSE) then
			if (CUIWarehouse.gUIWarehouse) then
				CUIBaggage.gUIBaggage.ShowUI()
				CUIWarehouse.gUIWarehouse.ShowUI()
			end
		elseif (DlgData.mType==CNpcDlgData.TYPE_NPC_SECRET_SHOP) then
			LuaCUIMysticShop.ShowUI()
		elseif (DlgData.mType==CNpcDlgData.TYPE_NPC_SCHOOLDATA) then
			if (CUISchoolInfo.gUISchoolInfo) then
				CUISchoolInfo.gUISchoolInfo.ShowUI()
			end
		elseif (DlgData.mType==CNpcDlgData.TYPE_NPC_SCHOOLRANK) then
			if (CUISchoolRank.gCUISchoolRank) then
				CUISchoolRank.gCUISchoolRank.ShowUI()
			end
		elseif (DlgData.mType==CNpcDlgData.TYPE_NPC_CHALLENGEMASTER) then
			LuaCSchoolModule.SendMessageChallengeMasterRequest(DlgData.mNpcEntityID);
		elseif (DlgData.mType==CNpcDlgData.TYPE_NPC_TAVERN) then
			
			LuaCProModule.SendGetPartnerInfoRequest()
			
		elseif (DlgData.mType==CNpcDlgData.TYPE_NPC_HEARTMAGIC) then
		    LuaCUIImpartsSanctum.ShowUI();
		end
	end
	if (CUINpcDlg.gpNpcDlg.visible) then
		CUINpcDlg.gpNpcDlg.HideUI()
	end
end
	--点击怪物
function LuaGameFrameWork.OnClickOgre(OgreProperty)
	local OgreTemp=Template.CDataStatic.SearchTpl(OgreProperty.mTemplateID)
	if (OgreTemp==nil) then
		return 
	end
	if (LuaCHeroProperty.CanBattle()) then
		--玩家没在战斗中并且是活着状态，则向玩家发起战斗
	end
		LuaCActivityModule.SendFightOgreRequest(OgreProperty.mEntityType,OgreProperty.m_unEntityID)
		LuaCHeroProperty.mFightTimer=getTimer()
	else
		LuaCUIFlyTips.ShowFlyTips(LanguageData.gLanguageData.UI_WEBGAME_023)
	end
end
	--点击其他玩家pk
function LuaGameFrameWork.OnClickPvpPlayer(MpcProperty)
	--判断玩家是否可以战斗
	if (not LuaCHeroProperty.CanBattle()) then
		return 
	end
	LuaCActivityModule.SendFightOgreRequest(MpcProperty.mEntityType,MpcProperty.m_unEntityID)
	LuaCHeroProperty.mFightTimer=getTimer()
end
	--点击其他玩家
function LuaGameFrameWork.OnClickPlayer(unEntityID)
	local MPCProperty
	local name
	local metier=0
	local sex=0
	local charID=0
	local level=0
	--得到玩家的基本信息
	MPCProperty = luaEntityProList[unEntityID];
	name=MPCProperty.mName
	metier=MPCProperty.m_nMetier
	sex=MPCProperty.mSex
	charID=MPCProperty.mCharID
	level=MPCProperty.mLevel
	CUISpcHeadPlayer.gUISpcHeadPlayer.data={name:name,metierID:metier,sex:sex,charID:charID,level:level}
	CUISpcHeadPlayer.gUISpcHeadPlayer.ShowUI()
	--CFriendModule.gFriendModule.SendLookPropertyRequest(unEntityID);
end
	--取消按钮0
function LuaGameFrameWork.CheckSelectPVPPlayer(unEntityID)
	local MpcProperty
	if (not this.mMap.m_IsPVP) then
		--是pvp地图
	end
		return  0
	end
	--得到NPC实体数据
	MpcProperty = luaEntityProList[unEntityID];
	if (MpcProperty == nil) then
		return -1
	end
	if (MpcProperty.mEntityType ~= ENTITYTYPE_PLAYER) then
			--其他玩家
	end
		return -2
	end
	--如果是阵营战活动，需要判断是否是同阵营玩家
	if (LuaCActivityModule.CheckCurrentFactionWar()) then
		if (MpcProperty.mCampID==LuaCHeroProperty.mCampID) then
			return -3;	--同阵营不能PK
		end
	end
	--判断玩家是否可以战斗
	if (not LuaCHeroProperty.CanBattle()) then
		return -4
	end
	--目标是否已死亡
	if (not MpcProperty.mAlive) then
		return -5
	end
	return  0;--可以战斗
end
	--重新连接场景
function LuaGameFrameWork.OnReconnectScene(nMapID,nPlayerPosX,nPlayerPosY)
	local nMapID=0
	--提示内容文本0
	if (this.mGameState==GAMG_STATE_INIT) then
		return 
	end
	nMapID=LuaCMapModule.mCurMapID
	--判断是否是同一张地图
	if (this.mMap.m_nMapID~=nMapID) then
		--如果在战斗中，先结束战斗
		if (this.mGameState~=GAMG_STATE_CITY) then
			LuaCProModule.ClearBattleList()
			this.mBattleManager.CloseBattle()
		end
		this.mMap.visible=false
		CUIManager.gUIManager.CloseAllUI()
		this.mRoleManager.ClearMpcList();--清空玩家列表
		this.mRoleManager.ClearNpcList();--请求npc列表
		this.mRoleManager.m_hero.ShowTitleIcon(true);		--默认显示头顶称号
		if (nMapID<=ACTIVITY_MAP_ID_END and nMapID>=ACTIVITY_MAP_ID_START) then
			if (LuaCActivityModule.mCurrentActivity==ACTIVITY_TYPE_WORLDBOSS_RAID_VULTURE or LuaCActivityModule.mCurrentActivity==ACTIVITY_TYPE_WORLDBOSS_CRAZE_APE or LuaCActivityModule.mCurrentActivity==ACTIVITY_TYPE_FACTIONBOSS) then
				LoadWorldBossActivitySceneResource()
			elseif (LuaCActivityModule.mCurrentActivity==ACTIVITY_TYPE_SCHOOL_BATTLE) then
				LoadSchoolBattleActivitySceneResource()
			elseif (LuaCActivityModule.CheckCurrentFactionWar()) then
				LoadFactionWarActivitySceneResource()
				--要隐藏主角头顶称号
				this.mRoleManager.m_hero.ShowTitleIcon(false)
			elseif (LuaCActivityModule.mCurrentActivity==ACTIVITY_TYPE_QUESTION) then
				LoadQuestionActivitySceneResource()
			end
		end
		if (this.mGameState==GAME_STATE_LOGIN_LOADING) then
			--在登陆加载时则不显示场景加载界面
		end
			CUILoadingPanel.gUILoadingPanel.loadMapRes(LuaCMapModule.mCurMapID)
		else
			this.mGameState=GAME_STATE_SCENE_LOADING
			CUILoadingPanel.gUILoadingPanel.ShowReconnectSceneLoading(LuaCMapModule.mCurMapID)
		end
	end
	this.mRoleManager.OnSyncPos(LuaCHeroProperty.m_unEntityID,nPlayerPosX,nPlayerPosY)
end
function LuaGameFrameWork.OnLoadReconnectSceneComplete()
	local nMapID=0
	local n=0
	this.mGameState=GAMG_STATE_CITY
	nMapID=LuaCMapModule.mCurMapID
	this.mMap.LoadMap(nMapID)
	this.mMap.visible=true
	if (nMapID<=ACTIVITY_MAP_ID_END and nMapID>=ACTIVITY_MAP_ID_START) then
		n=LuaCActivityModule.mCurrentActivity
		if (LuaCActivityModule.mCurrentActivity==ACTIVITY_TYPE_WORLDBOSS_RAID_VULTURE or LuaCActivityModule.mCurrentActivity==ACTIVITY_TYPE_WORLDBOSS_CRAZE_APE or LuaCActivityModule.mCurrentActivity==ACTIVITY_TYPE_FACTIONBOSS) then
			CUIManager.gUIManager.ShowWorldBossUI()
			if (LuaCUISystemSetting.m_bPlaySound) then
				SoundUtility.play(LuaCActivityModule.mCurrentActivity.toString())
			end
		elseif (LuaCActivityModule.mCurrentActivity==ACTIVITY_TYPE_SCHOOL_BATTLE) then
			CUIManager.gUIManager.ShowSchoolBattleUI()
			if (LuaCUISystemSetting.m_bPlaySound) then
				--播放场景音乐
				SoundUtility.play(LuaCActivityModule.mCurrentActivity.toString())
			end
		elseif (LuaCActivityModule.CheckCurrentFactionWar()) then
			CUIManager.gUIManager.ShowFactionWarUI()
			if (LuaCUISystemSetting.m_bPlaySound) then
				--播放场景音乐
				soundutility.play(luacactivitymodule.mcurrentactivity.tostring())
			end
		elseif (LuaCActivityModule.mCurrentActivity==ACTIVITY_TYPE_QUESTION) then
			CUIManager.gUIManager.ShowQuestionsAnswersUI()
			if (LuaCUISystemSetting.m_bPlaySound) then
				--提示更新内容文本0
				SoundUtility.play(LuaCActivityModule.mCurrentActivity.toString())
			end
		else
			CUIManager.gUIManager.ShowMainUI()
			CUIRightShortcutBar.gUIRightShortcutBar.UpdateSenceName()
			if (LuaCUISystemSetting.m_bPlaySound) then
				--播放场景音乐
				SoundUtility.play(this.mMap.m_nMapID.toString())
			end
		end
	else
		CUIManager.gUIManager.ShowMainUI()
		CUIRightShortcutBar.gUIRightShortcutBar.UpdateSenceName()
		if (LuaCUISystemSetting.m_bPlaySound) then
			--播放场景音乐
			SoundUtility.play(this.mMap.m_nMapID.toString())
		end
	end
	UpdateSpcAlive()
	--同步主角位置
	this.mRoleManager.OnSyncPos(LuaCHeroProperty.m_unEntityID,
		LuaCHeroProperty.mPosX,LuaCHeroProperty.mPosY)
end
	--开始战斗
function LuaGameFrameWork.StartBattle()
	if (this.mMap.mPlayer.ActionState==CharacterSprite2.ACTION_SIT) then
		CUIPracticeTip.gUIPracticeTip.stopRest()
	end
	this.mBattleManager.OnBattleProcessNotify()
end
	--开始战斗（多人副本）
function LuaGameFrameWork.StartMultiBattle(nWinIndex)
	if (this.mMap.mPlayer.ActionState==CharacterSprite2.ACTION_SIT) then
		CUIPracticeTip.gUIPracticeTip.stopRest()
	end
	if (CUITeamFB.gCUITeamFB.visible) then
		CUITeamFB.gCUITeamFB.HideUI()
	end
	this.mMultiBattleManager.m_nBattleWinIndex=nWinIndex
	this.mMultiBattleManager.m_nBattleType=CProModule.BATTLE_TYPE_MultiFB
	this.mMultiBattleManager.OnBattleProcessNotify()
end
	--战斗结束
function LuaGameFrameWork.EndBattle(nBattleType)
	local nTaskID=0
	local BagBox
	local t=0
	LuaCProModule.DelFirstBattleProcess()
	if (String(LuaCProModule.m_arrBattle).length>0) then
		--战斗列表里还有战斗则继续播放
	end
		this.mGameState=GAME_STATE_BATTlE_LOADING
		StartBattle()
		return 
	end
	this.mGameState=GAMG_STATE_CITY
	--同步下人物坐标
	this.mRoleManager.OnSyncPos(LuaCHeroProperty.m_unEntityID,
		LuaCHeroProperty.mPosX,LuaCHeroProperty.mPosY)
	if (nBattleType==CProModule.BATTLE_TYPE_WORLD_BOSS) then
		if (CUIManager.gUIManager) then
			CUIManager.gUIManager.ShowWorldBossUI()
		end
		CUIWorldBossDeadCountDown.gUIWorldBossDeadCountDown.visible=true
		if (not LuaCActivityModule.mStartingActivityList.containsKey(ACTIVITY_TYPE_WORLDBOSS_CRAZE_APE) and not LuaCActivityModule.mStartingActivityList.containsKey(ACTIVITY_TYPE_WORLDBOSS_RAID_VULTURE)) then
			--活动结束
		end
			ActivityEnd(ACTIVITY_TYPE_WORLDBOSS_CRAZE_APE)
		end
	elseif (nBattleType==LuaProDefine.BATTLE_TYPE_SCHOOLBATTLE_PVE or nBattleType==CProModule.BATTLE_TYPE_SCHOOLBATTLE_PVP) then
		--提示框容器0
		CUISchoolBattleFight.gSchoolBattleFight.HideUI()
		if (not LuaCActivityModule.mStartingActivityList.containsKey(ACTIVITY_TYPE_SCHOOL_BATTLE)) then
			--活动结束
		end
			ActivityEnd(ACTIVITY_TYPE_SCHOOL_BATTLE)
		end
		--隐藏头顶战斗图标
		CRoleManager.gRoleManager.m_hero.SetHeadBattleIcon("")
		CUIWorldBossDeadCountDown.gUIWorldBossDeadCountDown.visible=true
	elseif (nBattleType==CProModule.BATTLE_TYPE_FACTIONWAR) then
		--关闭门派战界面
		CUISchoolBattleFight.gSchoolBattleFight.HideUI()
		--判断帮会是否结束
		if (LuaCFactionModule.mWarResult.size()) then
			FactionWarEnd()
		end
		if (not LuaCActivityModule.ChechStartingFactionWar()) then
			--活动结束
		end
			ActivityEnd(ACTIVITY_TYPE_FACTION_WAR_LEVEL4)
		end
		--隐藏头顶战斗图标
		CRoleManager.gRoleManager.m_hero.SetHeadBattleIcon("")
	elseif (nBattleType==CProModule.BATTLE_TYPE_FactionBoss) then
		if (CUIManager.gUIManager) then
			CUIManager.gUIManager.ShowWorldBossUI()
		end
		CUIWorldBossDeadCountDown.gUIWorldBossDeadCountDown.visible=true
		if (not LuaCActivityModule.mStartingActivityList.containsKey(ACTIVITY_TYPE_FACTIONBOSS)) then
			ActivityEnd(ACTIVITY_TYPE_FACTIONBOSS)
		end
	else
		CUIManager.gUIManager.ShowMainUI()
		if (nBattleType==CProModule.BATTLE_TYPE_ARENA) then
			LuaCUIArena.ShowUI();
			if (LuaCUISystemSetting.m_bPlaySound) then
				--播放场景音乐
				SoundUtility.play(this.mMap.m_nMapID.toString())
			end
		end
		--门派位阶
		elseif (nBattleType==CProModule.BATTLE_TYPE_SchoolChallenge_pvp or nBattleType==CProModule.BATTLE_TYPE_SchoolChallenge_pve or nBattleType==CProModule.BATTLE_TYPE_SchoolApprientice) then
			LuaCUISchoolWeijie.ShowUI();
			if (nBattleType==CProModule.BATTLE_TYPE_SchoolApprientice) then
				LuaCUISchoolTeacher.ShowUI();
			end
		end
		--迷宫
		elseif (nBattleType==CProModule.BATTLE_TYPE_Maze or nBattleType==CProModule.BATTLE_TYPE_MysticMaze) then
			CUIMaze.gCUIMaze.hideAutoPrice()
			CUIMaze.gCUIMaze.ShowUI()
		end
		--提示框内组件容器0
		elseif (nBattleType==CProModule.BATTLE_TYPE_MultiFB) then
			CTeamDataManager.gCTeamDataManager.teamID=-1
			CUITeamFBSelect.gCUITeamFBSelect.ShowUI()
			if (LuaCUISystemSetting.m_bPlaySound) then
				--播放场景音乐
				SoundUtility.play(this.mMap.m_nMapID.toString())
			end
		elseif (nBattleType==CProModule.BATTLE_TYPE_LocalSelectWar) then
			LuaCServerWarModule.SendMessageGetWorldWarInfoRequest()
		end
		--巅峰对决
		elseif (nBattleType==CProModule.BATTLE_TYPE_WorldArena) then
			CUIPeakVS.gUIPeakVS.ShowUI()
			if (LuaCUISystemSetting.m_bPlaySound) then
				--播放场景音乐
				SoundUtility.play(this.mMap.m_nMapID.toString())
			end
		end
		--是否有升级动画需要播放
		if (CUIManager.gUIManager.m_bPlayLeveUpEffect) then
			CUIManager.gUIManager.SetLevelUpEffect()
		end
		--CUIUnlockFunctionPrompt.gUnlockFunctionPrompt.ShowWaitFunctionUI()
		--任务提示计时开始
		LuaCAutoTraceManager.StartCount()
		--如果是剧情副本战斗完成，看玩家身上是否有完成的主线任务，有则自动寻路交任务
		if (nBattleType==BATTLE_TYPE_OGRE and not CUIGuideView.gCUIGuideView.visible) then
			nTaskID=LuaCTaskManager.GetCompleteTask()
			if (nTaskID>0) then
				--有已完成主线任务，则自动寻路完成,不跨地图寻路
				LuaCAutoTraceManager.StartCurAutoTrace(nTaskID,false)
			end
		end
		--在任务追踪界面显示箭头提示
		CUITaskTrace.gUITaskTrace.ShowArrowTip()
		if (LuaCUISystemSetting.m_bPlaySound) then
			--播放场景音乐
			SoundUtility.play(this.mMap.m_nMapID.toString())
		end
	end
	--子控件，用于界面元素居中0
	if (LuaCHeroProperty.m_nStrength<=0) then
		CUIHelpTip.gCUIHelpTip.showDazuo()
	end
	BagBox=CItemModule.gItemModule.GetItemBox(ITEM_WHERE_BAGGAGE)
	if (BagBox:GetSpaceTotalNum()==0 and --以下战斗会有装备掉出，若玩家背包已满，给予提示(nBattleType==BATTLE_TYPE_OGRE--普通怪 or nBattleType==BATTLE_TYPE_HERO_OGRE--精英怪 or nBattleType==CProModule.BATTLE_TYPE_MultiFB--多人副本 or nBattleType==CProModule.BATTLE_TYPE_JXZ)) then
				--聚贤庄
	end
		LuaCUIFlyTips.ShowFlyTips(LanguageData.gLanguageData.UI_WEBGAME_024)
	end
	--是否存在传闻
	if (LuaCChatModule.mPrizeInfo~="") then
		CUIChat.gUIChat.putMsg(LuaCChatModule.mPrizeInfo,CUIChat.MSG_TYPE_SYSTEM,CUIChat.MSG_SUBTYPE_HORN,0,0,0,LanguageData.gLanguageData.UI_WEBGAME_025)
		LuaCChatModule.mPrizeInfo=""
	end
	--是否存在提示
	if (String(CUIChat.gUIChat.mPromptInfo).length>0) then
		t=0
		while  t<String(CUIChat.gUIChat.mPromptInfo).length  do
			CUIChat.gUIChat.putMsg(CUIChat.gUIChat.mPromptInfo[t],CUIChat.MSG_TYPE_SYSTEM,CUIChat.MSG_SUBTYPE_HORN,0,0,0,LanguageData.gLanguageData.UI_WEBGAME_026)
						t=t+1
		end
		CUIChat.gUIChat.mPromptInfo={}
	end
	LuaCActivityModule.PlayBackInterceptDart()
end
	--加载世界boss战活动场景
function LuaGameFrameWork.LoadWorldBossActivitySceneResource()
	--初始化BOSS战UI资源
	CUIManager.gUIManager.LoadWorldBossUI()
end
	--切换账号按钮000
function LuaGameFrameWork.LoadSchoolBattleActivitySceneResource()
	--切换背景音乐的时候音乐过渡效果所持续的时间01
	CUIManager.gUIManager.LoadSchoolBattleUI()
end
	--通用提示框2
function LuaGameFrameWork.LoadCampBattleActivitySceneResource()
	--初始化阵营战UI资源
	CUIManager.gUIManager.LoadCampBattleUI()
end
	--加载帮派战活动场景资源
function LuaGameFrameWork.LoadFactionWarActivitySceneResource()
	--初始化帮派战UI资源
	CUIManager.gUIManager.LoadFactionWarUI()
end
	--加载江湖问答活动场景资源
function LuaGameFrameWork.LoadQuestionActivitySceneResource()
	--初始化江湖问答UI资源
	CUIManager.gUIManager.LoadQuestionsAnswersUI()
end
	--活动结束
function LuaGameFrameWork.ActivityEnd(nActivityID)
	local strText
	local strSchoolName
	--阵营战特殊处理
	if (nActivityID==ACTIVITY_TYPE_CAMP_BATTLE) then
		if (CUICampBattle.gUICampBattle.visible) then
			CUICampBattle.gUICampBattle.ActivityEnd()
		end
		return 
	end
	if (this.mGameState~=GAMG_STATE_CITY) then
		return 
	end
	if (this.mMap.m_nMapID>ACTIVITY_MAP_ID_END or this.mMap.m_nMapID<ACTIVITY_MAP_ID_START) then
		return 
	end
	strText=""
	if (nActivityID==ACTIVITY_TYPE_WORLDBOSS_CRAZE_APE or nActivityID==ACTIVITY_TYPE_WORLDBOSS_RAID_VULTURE) then
		--更新特有提示框0
		if (CUIWorldBossHPProgress.gUIWorldBossHPProgress.mCurrHP<=0) then
			--boss被击杀
		end
			--strText="%42%4F%53%53%U88AB%U51FB%U6740%UFF0C%U6D3B%U52A8%U7ED3%U675F";
			strText=LanguageData.gLanguageData.UI_WEBGAME_027
		else
			--strText="%U65F6%U95F4%U7ED3%U675F%UFF0C%42%4F%53%53%U672A%U88AB%U51FB%U6740";
			strText=LanguageData.gLanguageData.UI_WEBGAME_029
		end
		CUIConfirm.gCUIConfirm.show(strText,OnClickActivityEndOKBtn)
	elseif (nActivityID==ACTIVITY_TYPE_SCHOOL_BATTLE) then
		if (LuaCActivityModule.mWinCampID~=0) then
			strSchoolName=LuaCSchoolModule.GetSchoolName(LuaCActivityModule.mWinCampID);
			--strText=strSchoolName+"%U83B7%U5F97%U80DC%U5229%UFF0C%U6D3B%U52A8%U7ED3%U675F";
			strText=strSchoolName+LanguageData.gLanguageData.UI_WEBGAME_028
		else
			--strText="%U65F6%U95F4%U7ED3%U675F%UFF0C%42%4F%53%53%U672A%U88AB%U51FB%U6740";
			strText=LanguageData.gLanguageData.UI_WEBGAME_029
		end
		CUIConfirm.gCUIConfirm.show(strText,OnClickActivityEndOKBtn)
	elseif (nActivityID==ACTIVITY_TYPE_FACTIONBOSS) then
		--在活动地图中显示活动结束确定框
		if (CUIWorldBossHPProgress.gUIWorldBossHPProgress.mCurrHP<=0) then
			--boss被击杀
		end
			--strText="%42%4F%53%53%U88AB%U51FB%U6740%UFF0C%U6D3B%U52A8%U7ED3%U675F";
			strText=LanguageData.gLanguageData.UI_WEBGAME_027
		else
			--strText="%U65F6%U95F4%U7ED3%U675F%UFF0C%42%4F%53%53%U672A%U88AB%U51FB%U6740";
			strText=LanguageData.gLanguageData.UI_WEBGAME_029
		end
		CUIConfirm.gCUIConfirm.show(strText,OnClickActivityEndOKBtn)
	end
	--是否加载过图集0
	--{
	--				CUIFactionWarResult.gUIFactionWarResult.show();
	--}
end
	--帮派战战斗结束
function LuaGameFrameWork.FactionWarEnd()
	if (this.mGameState~=GAMG_STATE_CITY) then
		return 
	end
	if (this.mMap.m_nMapID>ACTIVITY_MAP_ID_END or this.mMap.m_nMapID<ACTIVITY_MAP_ID_START) then
		return 
	end
	CUIFactionWarResult.gUIFactionWarResult.show()
end
function LuaGameFrameWork.OnClickActivityEndOKBtn()
	CUIConfirm.gCUIConfirm.HideUI()
	LuaCActivityModule.SendLeaveActivityRequest()
end
	--玩家升级
function LuaGameFrameWork.PlayerLevelUp()
	if (this.mRoleManager and this.mRoleManager.m_hero) then
		CUIManager.gUIManager.SetLevelUpEffect();--播放升级特效
		CUIManager.gUIManager.UpdateUIArrowPromptForLevel()
	end
	if (LuaCUIStudySkill.GetVisible() == true) then
		LuaCUIStudySkill.Update();
	end
    LuaCUIHeroHead.UpdateUI();
    --布阵更新
    if LuaCUIArray.GetVisible() == true then
        LuaCUIArray.ShowUI();
    end
	--20级时更新头顶按钮
	if (LuaCHeroProperty.GetPlayerLevel()==20) then
--		CUITopShortcutBar.gUITopShortcutBar.InitAllBtnByData()
        LuaCUIMainTopBar.UpdataTopActivityBtn();
	end
	this.mMap.StartShake()
end
	--玩家属性升级
function LuaGameFrameWork.PlayerPropertyUp(arrInfo)
	local info
	--Level:int,HP:int,JueAttack:int,JueDefence:int,WaiAttack:int,WaiDefence:int,NeiAttack:int,NeiDefence:int
	if (this.mRoleManager and this.mRoleManager.m_hero) then
		this.m_arrInfo={}
		if (arrInfo[0][0]>0) then
			--是否是安卓系统0
			this.m_arrInfo.push(CommonMethod.replaceOldWithNew(LanguageData.gLanguageData.UI_WEBGAME_030,"",{arrInfo[0][1]}))
		end
		if (arrInfo[1][0]>0) then
			if (LuaCProModule.m_bStudySkill) then
				LuaCProModule.m_bStudySkill=false
				--m_arrInfo.push("%U5168%U961F%U751F%U547D%U63D0%U5347"+arrInfo[1][0]);
				this.m_arrInfo.push(CommonMethod.replaceOldWithNew(LanguageData.gLanguageData.UI_WEBGAME_031,"",{arrInfo[1][0]}))
			else
				--m_arrInfo.push("%U751F%U547D%U63D0%U5347%U5230"+arrInfo[1][1]);
				this.m_arrInfo.push(CommonMethod.replaceOldWithNew(LanguageData.gLanguageData.UI_WEBGAME_032,"",{arrInfo[1][1]}))
			end
		end
		if (arrInfo[2][0]>0) then
			if (LuaCProModule.m_bStudySkill) then
				LuaCProModule.m_bStudySkill=false
				--m_arrInfo.push("%U5168%U961F%U5916%U529F%U653B%U51FB%U63D0%U5347"+arrInfo[2][0]);
				this.m_arrInfo.push(CommonMethod.replaceOldWithNew(LanguageData.gLanguageData.UI_WEBGAME_033,"",{arrInfo[2][0]}))
			else
				--m_arrInfo.push("%U5916%U529F%U653B%U51FB%U63D0%U5347%U5230"+arrInfo[2][1]);
				this.m_arrInfo.push(CommonMethod.replaceOldWithNew(LanguageData.gLanguageData.UI_WEBGAME_034,"",{arrInfo[2][1]}))
			end
		end
		if (arrInfo[3][0]>0) then
			if (LuaCProModule.m_bStudySkill) then
				LuaCProModule.m_bStudySkill=false
				--m_arrInfo.push("%U5168%U961F%U5916%U529F%U9632%U5FA1%U63D0%U5347"+arrInfo[3][0]);
				this.m_arrInfo.push(CommonMethod.replaceOldWithNew(LanguageData.gLanguageData.UI_WEBGAME_035,"",{arrInfo[3][0]}))
			else
				--m_arrInfo.push("%U5916%U529F%U9632%U5FA1%U63D0%U5347%U5230"+arrInfo[3][1]);
				this.m_arrInfo.push(CommonMethod.replaceOldWithNew(LanguageData.gLanguageData.UI_WEBGAME_036,"",{arrInfo[3][1]}))
			end
		end
		if (arrInfo[4][0]>0) then
			if (LuaCProModule.m_bStudySkill) then
				LuaCProModule.m_bStudySkill=false
				--m_arrInfo.push("%U5168%U961F%U7EDD%U6280%U653B%U51FB%U63D0%U5347"+arrInfo[4][0]);
				this.m_arrInfo.push(CommonMethod.replaceOldWithNew(LanguageData.gLanguageData.UI_WEBGAME_037,"",{arrInfo[4][0]}))
			else
				--m_arrInfo.push("%U7EDD%U6280%U653B%U51FB%U63D0%U5347%U5230"+arrInfo[4][1]);
				this.m_arrInfo.push(CommonMethod.replaceOldWithNew(LanguageData.gLanguageData.UI_WEBGAME_038,"",{arrInfo[4][1]}))
			end
		end
		if (arrInfo[5][0]>0) then
			if (LuaCProModule.m_bStudySkill) then
				LuaCProModule.m_bStudySkill=false
				--m_arrInfo.push("%U5168%U961F%U7EDD%U6280%U9632%U5FA1%U63D0%U5347"+arrInfo[5][0]);
				this.m_arrInfo.push(CommonMethod.replaceOldWithNew(LanguageData.gLanguageData.UI_WEBGAME_039,"",{arrInfo[5][0]}))
			else
				--分包的版本号0
				this.m_arrInfo.push(CommonMethod.replaceOldWithNew(LanguageData.gLanguageData.UI_WEBGAME_040,"",{arrInfo[5][1]}))
			end
		end
		if (arrInfo[6][0]>0) then
			if (LuaCProModule.m_bStudySkill) then
				LuaCProModule.m_bStudySkill=false
				--m_arrInfo.push("%U5168%U961F%U5947%U672F%U653B%U51FB%U63D0%U5347"+arrInfo[6][0]);
				this.m_arrInfo.push(CommonMethod.replaceOldWithNew(LanguageData.gLanguageData.UI_WEBGAME_041,"",{arrInfo[6][0]}))
			else
				--m_arrInfo.push("%U5947%U672F%U653B%U51FB%U63D0%U5347%U5230"+arrInfo[6][1]);
				this.m_arrInfo.push(CommonMethod.replaceOldWithNew(LanguageData.gLanguageData.UI_WEBGAME_042,"",{arrInfo[6][1]}))
			end
		end
		if (arrInfo[7][0]>0) then
			if (LuaCProModule.m_bStudySkill) then
				LuaCProModule.m_bStudySkill=false
				--m_arrInfo.push("%U5168%U961F%U5947%U672F%U9632%U5FA1%U63D0%U5347"+arrInfo[7][0]);
				this.m_arrInfo.push(CommonMethod.replaceOldWithNew(LanguageData.gLanguageData.UI_WEBGAME_043,"",{arrInfo[7][0]}))
			else
				--m_arrInfo.push("%U5947%U672F%U9632%U5FA1%U63D0%U5347%U5230"+arrInfo[7][1]);
				this.m_arrInfo.push(CommonMethod.replaceOldWithNew(LanguageData.gLanguageData.UI_WEBGAME_044,"",{arrInfo[7][1]}))
			end
		end
		info={}
	--				mRoleManager.m_hero.PropertyUpEffect(info);
	end
end
	--根据职业ID获得职业文本
function LuaGameFrameWork.GetMetierText(MetierID)
	local tempMetier=CDataStatic.SearchMetierTpl(MetierID)
	if (tempMetier==nil) then
		return ""
	end
	return  tempMetier.m_strMemtier
end
	--操作状态信息
	--type:0置位1清位/value:表示第几位
function LuaGameFrameWork.TreatStateBuffer(value,type)
	if type == nil then type=0 end
	local index=0
	local offset=0
	local bitValue=0
	if (this.mStateBuffer==nil) then
		return 
	end
	index=value/8
	offset=value%8
	bitValue=1
	bitValue=(bitValue<<offset)
	if (type==0) then
		this.mStateBuffer[index]|=bitValue
	elseif (type==1) then
		this.mStateBuffer[index]&=(~bitValue)
	end
end
	--分包数量0
function LuaGameFrameWork.ReadStateBuffer(value)
	local index=0
	local offset=0
	local bitValue=0
	if (this.mStateBuffer==nil) then
		return  0
	end
	index=value/8
	offset=value%8
	bitValue=1
	bitValue=(bitValue<<offset)
	if (int(this.mStateBuffer[index]&bitValue)>0) then
		return  1
	end
	return  0
end
function LuaGameFrameWork.ReAddChildBattleMap()
	this.m_BattleMapParent.addChild(this.mBattleManager.m_BattleMap)
end
function LuaGameFrameWork.OutLogChat(ChatContent)
	CUIChat.gUIChat.putMsg(ChatContent,CUIChat.MSG_TYPE_SYSTEM,CUIChat.MSG_SUBTYPE_LOG,0,0,0,"提示")
end
function LuaGameFrameWork.GetSeverDate()
	local date=Date.new()
	date.time=date.time-CoreModule.gCoreModule.delayedTime
	return  date
end
function LuaGameFrameWork.RefreshDisguiseMask(unEntityID,nDisguiseMaskID)
	local strUrl
	local nAddSpeedPre
	local nPhaseIndex=0
	local pCharaPro
	local pTplDisguiseMask=""
	if (nDisguiseMaskID==0) then
		if (LuaCHeroProperty.m_unEntityID==unEntityID) then
			strUrl=LuaCHeroProperty.GetRoleClothesUrl()
			LuaCHeroProperty.mDisguiseMaskID=nDisguiseMaskID
			nAddSpeedPre=0
			nPhaseIndex=LuaCHeroProperty.mCurRideID-1
			if (nPhaseIndex>=0 and nPhaseIndex<MAX_HORSE_PHASE and CDataStatic.spHorseConfig~=nil) then
				nAddSpeedPre=CDataStatic.spHorseConfig.mSpeed[nPhaseIndex]/10000
			end
		else
			pCharaPro = luaEntityProList[unEntityID];
			if (nil~=pCharaPro) then
				pCharaPro.mDisguiseMaskID=nDisguiseMaskID
				strUrl=pCharaPro.GetRoleClothesUrl()
			end
			nAddSpeedPre=0
			nPhaseIndex=pCharaPro.mCurRideID-1
			if (nPhaseIndex>=0 and nPhaseIndex<MAX_HORSE_PHASE and CDataStatic.spHorseConfig~=nil) then
				nAddSpeedPre=CDataStatic.spHorseConfig.mSpeed[nPhaseIndex]/10000
			end
		end
		this.mRoleManager.RefreshDisguiseMask(unEntityID,nDisguiseMaskID,strUrl,nAddSpeedPre)
	else
		pTplDisguiseMask=CDataStatic.SearchTpl(nDisguiseMaskID)
		if (nil==pTplDisguiseMask) then
			return 
		end
		if (LuaCHeroProperty.m_unEntityID==unEntityID) then
			LuaCHeroProperty.mDisguiseMaskID=nDisguiseMaskID
		else
			pCharaPro = luaEntityProList[unEntityID];
			if (nil~=pCharaPro) then
				pCharaPro.mDisguiseMaskID=nDisguiseMaskID
			end
		end
		strUrl="config/npc/"..pTplDisguiseMask.mModalName..".xml"
		this.mRoleManager.RefreshDisguiseMask(unEntityID,nDisguiseMaskID,strUrl,0)
	end
end
function LuaGameFrameWork.dispose()
	local dsp=FrameEventUtility.getMC()
	if (dsp~=nil and stage.getChildIndex(dsp)~=-1) then
		stage.removeChild(dsp)
	end
	FrameEventUtility.reset()
	SoundUtility.dispose()
	this.instance=nil
	super.dispose()
end
