local this = LuaCMultiBattleManager
LuaCMultiBattleManager = { 
	BATTLE_SIDE_POSNUM=6,	--存储在本地的文件的名字231
	BATTLE_TIME_PER=400,	--服务器列表界面32
	BATTLE_POS_MAX=15,	--欧美IOS3
	m_PlayerNum:int,	--上场玩家数
	m_BattleMapID=0
	m_nBattleFBIndex=-1,				--战斗所在的副本索引
	m_strMapNameUrl:String,	--地图标题图片路径
	m_BattleMap:CBattleMap,		--战斗地图层
	m_OgreLess=0,	--怪物剩余数量
	m_arrMultiOgreID={},			--多人副本怪物ID
	m_nWinNum=0
	m_nFail=0
	m_nBattleWinIndex=0
	m_nBattleType=0
	m_arrTeamMap:Array
	m_bPause=false
	m_OgreKillPlayer={}
	m_arrWait={-1,-1,-1}
	gCMultiBattleManager:CMultiBattleManager
}
local m_nSenceBattleState=0
local m_BattleStartEffect:CEffectSprite;		--登陆后检测版本是否有更新0
local m_arrPlayerControler={}
local m_arrRestPlayer={-1,-1,-1}
local m_arrPlayerPos={0,1,2};	--玩家的当前位置，帮助别的玩家打时，会挪过去
local m_arrPlayerDead={0,0,0};	--记录玩家死了
local m_arrOgreDead={};	--记录怪死了
local m_arrInitValue={}
local m_arrLoadedIamgeData:Array;				--记录战斗中加载的技能特效资源，要在战斗结束后释放
function LuaCMultiBattleManager.ctor()
	local i=0
	this.gCMultiBattleManager=this
	this.m_BattleMap=CBattleMap.new()
	this.m_arrTeamMap={}
	m_BattleStartEffect=CEffectSprite.new()
	m_arrLoadedIamgeData={}()
	i=0
	while  i<3  do
		m_arrPlayerControler[i]=CMultiBattlePlayer.new(i)
				i=i+1
	end
end
	--进入普通副本
function LuaCMultiBattleManager.EnterMultiFB()
	if (GameFrameWork.instance.mGameState~=GameFrameWork.GAMG_STATE_CITY) then
		LuaCUIFlyTips.ShowFlyTips(LanguageData.gLanguageData.UI_WEBGAME_001)
		return ;--非城镇状态不能进入
	end
	GameFrameWork.instance.mGameState=GameFrameWork.GAME_STATE_BATTlE_LOADING
	--根据战斗类型加载战斗配置文件
	LuaCActivityModule.SendCMessageMultiFBStartBattleRequest()
end
	--接收服务器战斗通知
function LuaCMultiBattleManager.OnBattleProcessNotify()
	local fbInfo=CTeamDataManager.gCTeamDataManager.getMyTeamInfo()
	if (fbInfo==nil) then
		return 
	end
	String(m_arrLoadedIamgeData).length=0
	--PC端直接进入游戏，手机客户端需要联网检测版本更新0
	--			//加载战斗相关资源
	--			LoadResource.gLoadResource.addLoadList("%73%77%66%72%65%73%6F%75%72%63%65","%69%6D%61%67%65%73%2F%75%69%2F%62%61%74%74%6C%65%2E%73%77%66",null);
	--			LoadResource.gLoadResource.addLoadList("%73%77%66%65%66%66%65%63%74","%69%6D%61%67%65%73%2F%65%66%66%65%63%74%2F%62%61%74%74%6C%65%73%74%61%72%74%2E%73%77%66",null);
	--地图、怪物
	LoadBattleMapConfig()
	--玩家
	LoadRoleResoure()
	--			LoadResource.gLoadResource.endList();
	OnLoadComplete()
end
	--加载副本配置文件
function LuaCMultiBattleManager.LoadBattleMapConfig()
	local mapXML
	local myTeam
	local fbinfo
	local i=0
	local nOgreID=0
	--加载副本地图资源
	mapXML=CFileManager.loadXMLData("config/map/multi_map.xml")
	if (mapXML) then
		this.m_strMapNameUrl=mapXML.fb.(@index==this.m_nBattleFBIndex.toString()).@title
		this.m_BattleMapID=parseInt(mapXML.fb.(@index==this.m_nBattleFBIndex.toString()).@map)
	end
	this.m_BattleMap.LoadMap(this.m_BattleMapID)
	myTeam=CTeamDataManager.gCTeamDataManager.getMyTeamInfo()
	if (myTeam==nil) then
		return 
	end
	fbinfo=CDataStatic.SearchTpl(CDataStatic.spMultiFBConfig.m_FBID[myTeam.fBIndex])
	this.m_arrMultiOgreID={}
	i=0
	while  i<String(fbinfo.m_arrOgreID).length  do
		--加载怪物资源
		nOgreID=fbinfo.m_arrOgreID[i]
		this.m_arrMultiOgreID.push(nOgreID)
				i=i+1
	end
	LoadOgreResource()
end
function LuaCMultiBattleManager.LoadOgreResource()
	local i=0
	local nOgreID=0
	local OgreTemplate
	local n=0
	local nOgrePartnerID=0
	local OgrePartnerTemplate
	local strUrl
	i=0
	while  i<String(this.m_arrMultiOgreID).length  do
		nOgreID=this.m_arrMultiOgreID[i]
		OgreTemplate=CDataStatic.SearchTpl(nOgreID)
		if (OgreTemplate==nil) then
			continue
		end
		n=0
		while  n < MAX_ARRAYS_POS_NUM  do
			nOgrePartnerID=OgreTemplate.mOgrePartner[n]
			if (nOgrePartnerID==0) then
				continue
			end
			--清空游戏数据0
			OgrePartnerTemplate=CDataStatic.SearchTpl(nOgrePartnerID)
			if (OgrePartnerTemplate==nil) then
				continue
			end
			strUrl="config/npc/"..OgrePartnerTemplate.mModelName.."_battle.xml"
			OnLoadRoleXml(strUrl)
			--加载技能资源
			LoadSkillEffect(OgrePartnerTemplate.mSkillID)
						n=n+1
		end
				i=i+1
	end
end
	--加载玩家上阵人员的资源
function LuaCMultiBattleManager.LoadRoleArrayResoure(playerinfo,strRoleImage)
	local strUrl
	local n=0
	local dataObject
	local nSkillID=0
	local nTempID=0
	local MemberTemplate=""
	n=0
	while  n<String(playerinfo.MemberFightInfo).length  do
		dataObject=playerinfo.MemberFightInfo[n]
		if (dataObject==nil) then
			continue
		end
		nSkillID=0
		nTempID=dataObject["tempid"]
		if (nTempID==0) then
				--是主角自己
		end
			strUrl=strRoleImage
			nSkillID=playerinfo.PlayerSKillID
		else
			--找到伙伴模板
			MemberTemplate=CDataStatic.SearchTpl(nTempID)
			if (MemberTemplate~=nil) then
				if (dataObject==nil) then
					continue
				end
				if (nTempID==0) then
						--是主角自己
				end
					strUrl="config/role/quan_nv_1_battle.xml"
					nSkillID=LuaCHeroProperty.GetPlayerSkillID()
				else
					strUrl="config/npc/"..MemberTemplate.mModelName.."_battle.xml"
					nSkillID=MemberTemplate.mSkillID
				end
			end
		end
		OnLoadRoleXml(strUrl)
		LoadSkillEffect(nSkillID)
				n=n+1
	end
end
function LuaCMultiBattleManager.OnLoadRoleXml(strUrl)
	local roleXml
	local strSWFUrl
	local actionItem
	local strActionUrl=CFileManager.loadXMLData(strUrl)
	if (roleXml==nil) then
		return 
	end
	strSWFUrl=roleXml.@swfurl
	if (strSWFUrl~="") then
		if (String(m_arrLoadedIamgeData).indexOf(strSWFUrl)==-1) then
			--已加载过的，不用加载
		end
			m_arrLoadedIamgeData.push(strSWFUrl)
		end
	end
	for each actionItem in pairs(roleXml.children()) do
		strActionUrl=actionItem.@swfurl
		if (strActionUrl=="") then
			continue
		end
		if (String(m_arrLoadedIamgeData).indexOf(strSWFUrl)==-1) then
			--已加载过的，不用加载
		end
			m_arrLoadedIamgeData.push(strSWFUrl)
		end
	end
end
	--加载角色形象和特效资源
function LuaCMultiBattleManager.LoadRoleResoure()
	local i=0
	local playerinfo
	local strRoleImage
	--获取存储在本地的数据0
	i=0
	while  i<String(LuaCActivityModule.m_arrMultiBattlePlayerInfo).length  do
		playerinfo=LuaCActivityModule.m_arrMultiBattlePlayerInfo[i]
		strRoleImage=playerinfo:GetRoleBattleClothesUrl();
		--加载自己的出战角色资源
		LoadRoleArrayResoure(playerinfo,strRoleImage)
				i=i+1
	end
end
function LuaCMultiBattleManager.LoadSkillEffect(nSkillID)
	local skillTemplate
	local strUrl=CDataStatic.SearchTpl(nSkillID)
	if (skillTemplate==nil) then
		return 
	end
	if (skillTemplate.m_strSkillAction=="") then
		return 
	end
	strUrl="config/effect/skill/"..skillTemplate.m_strSkillAction..".xml"
	OnLoadEffectXml(strUrl)
end
	--加载特效xml回调函数,加载特效配置文件
function LuaCMultiBattleManager.OnLoadEffectXml(strUrl)
	local effectXml
	local swfUrl
	local nextUrl=CFileManager.loadXMLData(strUrl)
	if (effectXml==nil) then
		return 
	end
	swfUrl=effectXml.swfurl
	if (swfUrl=="") then
		return 
	end
	if (String(m_arrLoadedIamgeData).indexOf(swfUrl)==-1) then
		m_arrLoadedIamgeData.push(swfUrl)
	--				//没有加载特效swf源文件，则需要加载
	--				if(!CSWFImageManager.gSWFImageManager.IsLoaded(swfUrl))
	--				{
	--					LoadResource.gLoadResource.addLoadList("%73%77%66%65%66%66%65%63%74",swfUrl,null);
	--				}
	--				else if(!CImageManager.gImageManager.HasImageData(swfUrl))
	--默认开启背景音乐0
	--					LoadResource.gLoadResource.addNotLoadList(CSWFImageManager.gSWFImageManager.LoadSWFEffectImageData,[swfUrl,null]);
	--				}
	end
	nextUrl=effectXml.next_effect
	if (nextUrl=="") then
		return 
	end
	OnLoadEffectXml(nextUrl)
end
	--加载完成
function LuaCMultiBattleManager.OnLoadComplete()
	--加载界面资源	
	--			CUIBattleOgreNum.gUIBattleOgreNum.Initialize();
	--			CUIMultiPlayerHead.gCUIMultiPlayerHead.Initialize();
	--			CUIBattlePlayerInfo.gUIBattlePlayerInfo.Initialize();
	StartFB()
end
	--开始副本
function LuaCMultiBattleManager.StartFB()
	CGameMap.gGameMap.visible=false
	m_nSenceBattleState=CBattleManager.BATTLE_INIT
	--播放战斗开始特效
	StartBattleStartBattleEffcet()
	--默认开启音效0
	StartUI()
	--开始战斗
	StartBattle()
end
function LuaCMultiBattleManager.StartUI()
	CUIManager.gUIManager.CloseAllUI()
	CUIChat.gUIChat.visible=true
	CUINotice.gUINotice.visible=true
end
function LuaCMultiBattleManager.StartBattleStartBattleEffcet()
	--判断是否开启声音
	if (LuaCUISystemSetting.m_bPlaySound) then
		--播放pve音乐
	--				CSoundManager.gSoundManager.PlayPveSound();
	end
	m_BattleStartEffect.x=this.m_BattleMap.GetVisualWidth()/2
	m_BattleStartEffect.y=this.m_BattleMap.GetVisualHeight()/2
	--			m_BattleStartEffect.mAnimationFrameInterval=4;
	--			m_BattleStartEffect.LoadEffectSwf("%69%6D%61%67%65%73%2F%65%66%66%65%63%74%2F%62%61%74%74%6C%65%73%74%61%72%74%2E%73%77%66");
	--			CUIManager.gUIManager.mSceneChangeEffect.DisappearBack();
	--			CUIManager.gUIManager.mSceneChangeEffect.addChild(m_BattleStartEffect);
	--			CUIManager.gUIManager.mSceneChangeEffect.EndEffectCallBack=StartBattleEffcetEnd;
	--加载界面00
	--默认显示其他玩家1
end
function LuaCMultiBattleManager.StartBattleEffcetEnd()
	local i=0
	--			CUIManager.gUIManager.mSceneChangeEffect.removeChild(m_BattleStartEffect);
	m_nSenceBattleState=CBattleManager.BATTLE_ATTACK_WAIT
	i=0
	while  i<this.m_PlayerNum  do
		(m_arrPlayerControler[i]).m_nBattleState=CBattleManager.BATTLE_ATTACK_WAIT
				i=i+1
	end
end
	--开始战斗
function LuaCMultiBattleManager.StartBattle()
	local headInfo
	local playerinfo
	local i=0
	if (this.m_BattleMapID~=this.m_BattleMap.m_nMapID) then
		this.m_BattleMap.LoadMap(this.m_BattleMapID)
	end
	--更新地图显示名字图片
	this.m_BattleMap.LoadNameImage(this.m_strMapNameUrl)
	--根据不同的副本显示不同的界面资源
	CUIBattleOgreNum.gUIBattleOgreNum.visible=true
	CUIMultiPlayerHead.gCUIMultiPlayerHead.visible=true
	this.m_OgreLess=String(this.m_arrMultiOgreID).length
	CUIBattleOgreNum.gUIBattleOgreNum.UpdateOgreNum(this.m_OgreLess,this.m_OgreLess)
	--角色头像
	headInfo={}
	i=0
	while  i<String(LuaCActivityModule.m_arrMultiBattlePlayerInfo).length  do
		playerinfo=LuaCActivityModule.m_arrMultiBattlePlayerInfo[i]
		if (playerinfo.CharID==0) then
			continue
		end
		headInfo.push({name:playerinfo.Name,lv:playerinfo:GetRoleLevel(),metier:playerinfo.PlayerMetier,
			"sex":playerinfo.PlayerSex})
				i=i+1
	end
	CUIMultiPlayerHead.gCUIMultiPlayerHead.updateHead(headInfo)
	ClearMap()
	CreatRole()
	GameFrameWork.instance.mGameState=GameFrameWork.GAME_STATE_MULTI_BATTLE
	this.m_BattleMap.visible=true
	this.m_nWinNum=0
	this.m_nFail=0
	m_arrRestPlayer={-1,-1,-1}
	m_arrPlayerPos={0,1,2}
	m_arrPlayerDead={0,0,0}
	m_arrOgreDead={}
	i=0
	while  i<this.m_PlayerNum  do
		(m_arrPlayerControler[i]).StartBattle()
				i=i+1
	end
	return 
end
function LuaCMultiBattleManager.ClearMap()
	this.m_BattleMap.ClearRole()
end
	--初始化特效资源
function LuaCMultiBattleManager.CreatRole()
	local i=0
	local playerinfo
	--创建战斗角色
	i=0
	while  i<String(LuaCActivityModule.m_arrMultiBattlePlayerInfo).length  do
		playerinfo=LuaCActivityModule.m_arrMultiBattlePlayerInfo[i]
		CreatRoleArrayResoure(playerinfo,i)
				i=i+1
	end
	--创建怪
	CreatOgreArrayResoure()
end
function LuaCMultiBattleManager.CreatRoleArrayResoure(battleRoleInfo,playerPosIndex)
	local mapTeam
	local mapPower
	local n=0
	local dataObject
	local nPos=0
	local nTempID=0
	local nLevel=0
	local nSkillID=0
	local nMetierID=0
	local strUrl
	local nArtifactID=0
	local Mpc
	local MemberTemplate
	local tempMetier
	local tempSkill
	local pos={}
	mapPower={}
	n=0
	while  n<String(battleRoleInfo.MemberFightInfo).length  do
		dataObject=battleRoleInfo.MemberFightInfo[n]
		if (dataObject==nil) then
			continue
		end
		nPos=dataObject.pos
		nTempID=dataObject.tempid
		nLevel=dataObject.Level
		nSkillID=0
		nMetierID=0
		strUrl=""
		--默认隐藏其他玩家光效0
		nArtifactID=dataObject.ArtifactID&0x00ffff
		--创建玩家及伙伴
		Mpc=CBattleSprite.new()
		if (nTempID==0) then
				--玩家
		end
			if (battleRoleInfo.CharID==LuaCHeroProperty.mCharID) then
					--是自己
			end
				Mpc.m_strName=LuaCHeroProperty.mName
				strUrl=LuaCHeroProperty.GetRoleBattleClothesUrl()
				nLevel=LuaCHeroProperty.GetPlayerLevel()
				nMetierID=LuaCHeroProperty.m_nMetier
				nSkillID=LuaCHeroProperty.GetPlayerSkillID()
			else
				Mpc.m_strName=battleRoleInfo.Name
				strUrl=battleRoleInfo:GetRoleBattleClothesUrl();
				nLevel=dataObject.Level
				nMetierID=battleRoleInfo.PlayerMetier
				nSkillID=battleRoleInfo.PlayerSKillID
			end
			Mpc.ChangeWing(nArtifactID)
			Mpc.m_nTempID=0
		else
			--找到伙伴模板
			MemberTemplate=CDataStatic.SearchTpl(nTempID)
			if (MemberTemplate==nil) then
				continue
			end
			strUrl="config/npc/"..MemberTemplate.mModelName.."_battle.xml"
			Mpc.m_strName=MemberTemplate.mName
			nLevel=dataObject.Level
			nMetierID=MemberTemplate.mMetierID
			nSkillID=MemberTemplate.mSkillID
			Mpc.m_nTempID=nTempID
			Mpc.ChangeWing(nArtifactID)
		end
		Mpc.scaleX=0.5
		Mpc.scaleY=0.5
		Mpc.m_Map=this.m_BattleMap
		Mpc.m_unEntityID=nPos
		Mpc.m_nMaxHP=dataObject.MaxHP
		Mpc.m_nCurHP=dataObject.CurHP
		Mpc.mTextName.text=""
		Mpc.m_nMetier=nMetierID
		tempMetier=CDataStatic.SearchMetierTpl(nMetierID)
		if (tempMetier~=nil) then
			Mpc.m_strMetierName=tempMetier.m_strMemtier
		else
			Mpc.m_strMetierName=""
		end
		tempSkill=CDataStatic.SearchTpl(nSkillID)
		if (tempSkill~=nil) then
			Mpc.m_strSkillName=tempSkill.m_strSkillName
			Mpc.m_nSkillID=nSkillID
		else
			Mpc.m_strSkillName=""
			Mpc.m_nSkillID=0
		end
		Mpc.m_nLevel=nLevel
		Mpc.m_nPower=dataObject.Power
		mapPower.put(Mpc.m_unEntityID,{Power:dataObject.Power})
		Mpc.LoadRoleImage(strUrl)
		Mpc.SetBattleMoveActionInfo()
		Mpc.ShowFullPower()
		--设置人物位置和方向
		pos=nil
		pos=this.m_BattleMap.GetMultiPlayerPos(playerPosIndex,nPos)
		if (pos~=nil) then
			Mpc.Stand(pos.x,pos.y,CharacterSprite2.DIRECTION_RIGHT)
		else
			Mpc.Stand(0,0,CharacterSprite2.DIRECTION_RIGHT)
		end
		mapTeam.put(Mpc.m_unEntityID,Mpc)
		this.m_BattleMap.AddMapObj(Mpc)
		Mpc.OnStartAttackCallBack=m_arrPlayerControler[playerPosIndex].OnStartAttack
		Mpc.OnEndAttcakCallBack=m_arrPlayerControler[playerPosIndex].OnEndAttack
		Mpc.OnEndBeatingCallBack=m_arrPlayerControler[playerPosIndex].OnEndBeating
				n=n+1
	end
	this.m_arrTeamMap[playerPosIndex]=mapTeam
	m_arrInitValue[playerPosIndex]=mapPower
	--初始化头顶信息
	--		InitRoleHeadInfo(battleRoleInfo,left);
end
	--创建怪物出阵资源
function LuaCMultiBattleManager.CreatOgreArrayResoure()
	local strUrl
	local n=0
	local index=0
	local TempID=0
	local OgreTemplate
	local posIndex=0
	local mapTeam
	local mapPower
	local nOgrePartnerID=0
	local OgrePartnerTemplate
	local Ogre
	local tempMetier
	local tempSkill
	local pos
	local row=0
	strUrl=""
	n=0
	index=0
	while  index<String(this.m_arrMultiOgreID).length  do
		--加载怪物的资源到下载列表
		TempID=this.m_arrMultiOgreID[index]
		--默认不自动挂机0
		OgreTemplate=CDataStatic.SearchTpl(TempID)
		if (OgreTemplate==nil) then
			return 
		end
		--由index换成怪所在位置序号
		posIndex=this.getOgreTrueIndex(index)
		mapTeam={}
		mapPower={}
		n=0
		while  n < MAX_ARRAYS_POS_NUM  do
			nOgrePartnerID=OgreTemplate.mOgrePartner[n]
			if (nOgrePartnerID==0) then
				continue
			end
			--伙伴怪物伙伴模板
			OgrePartnerTemplate=CDataStatic.SearchTpl(nOgrePartnerID)
			if (OgrePartnerTemplate==nil) then
				continue
			end
			strUrl="config/npc/"..OgrePartnerTemplate.mModelName.."_battle.xml"
			Ogre=CBattleSprite.new()
			Ogre.scaleX=0.5
			Ogre.scaleY=0.5
			Ogre.m_Map=this.m_BattleMap
			Ogre.m_unEntityID=n
			Ogre.mDirection=CharacterSprite2.DIRECTION_LEFT
			Ogre.mTextName.htmlText=""
			Ogre.m_strName=OgrePartnerTemplate.mName
			--boss怪名称为红色
--			if (OgrePartnerTemplate.mOgreType==CTemplateOgrePartner.OGRETYPE_NORMAL_BOSS or OgrePartnerTemplate.mOgreType==CTemplateOgrePartner.OGRETYPE_HREO_BOSS) then
--				Ogre.m_strFullPowerEffectUrl="images/effect/normalbossmanqishi.swf"
--			elseif (OgrePartnerTemplate.mOgreType==CTemplateOgrePartner.OGRETYPE_WORLD_BOSS) then
--				Ogre.m_strFullPowerEffectUrl="images/effect/worldbossmanqishi.swf"
--			else
			end
			Ogre.LoadRoleImage(strUrl)
			Ogre.m_nMetier=OgrePartnerTemplate.mMetierID
			tempMetier=CDataStatic.SearchMetierTpl(OgrePartnerTemplate.mMetierID)
			if (tempMetier~=nil) then
				Ogre.m_strMetierName=tempMetier.m_strMemtier
			else
				Ogre.m_strMetierName=""
			end
			tempSkill=CDataStatic.SearchTpl(OgrePartnerTemplate.mSkillID)
			if (tempSkill~=nil) then
				Ogre.m_strSkillName=tempSkill.m_strSkillName
			else
				Ogre.m_strSkillName=""
			end
			Ogre.m_nLevel=OgrePartnerTemplate.mInitLevel
			Ogre.m_nPower=OgrePartnerTemplate.mPower
			mapPower.put(Ogre.m_unEntityID,{Power:OgrePartnerTemplate.mPower})
			Ogre.SetBattleMoveActionInfo();--战斗中的移动动作信息需要单独设置
			Ogre.m_nMaxHP=OgrePartnerTemplate.mHPMax
			Ogre.m_nCurHP=OgrePartnerTemplate.mHPMax
			Ogre.ShowFullPower()
			--设置人物位置和方向
			pos=this.m_BattleMap.GetMultiPlayerPos(BATTLE_SIDE_POSNUM+posIndex,n);--右侧索引从BATTLE_SIDE_POSNUM开始
			if (pos~=nil) then
				Ogre.Stand(pos.x,pos.y,CharacterSprite2.DIRECTION_LEFT)
			else
				Ogre.Stand(0,0,CharacterSprite2.DIRECTION_LEFT)
			end
			mapTeam.put(Ogre.m_unEntityID,Ogre)
			this.m_BattleMap.AddMapObj(Ogre)
			row=posIndex%3
			Ogre.OnStartAttackCallBack=m_arrPlayerControler[row].OnStartAttack
			Ogre.OnEndAttcakCallBack=m_arrPlayerControler[row].OnEndAttack
			Ogre.OnEndBeatingCallBack=m_arrPlayerControler[row].OnEndBeating
						n=n+1
		end
		this.m_arrTeamMap[BATTLE_SIDE_POSNUM+posIndex]=mapTeam;	--右侧索引从BATTLE_SIDE_POSNUM开始
		m_arrInitValue[BATTLE_SIDE_POSNUM+posIndex]=mapPower
				index=index+1
	end
end
function LuaCMultiBattleManager.getOgreTrueIndex(index)
	local arr2player
	local arr3player={0,1,4,3,6,7}
	arr3player={0,1,2,3,4,5}
	if (this.m_PlayerNum==2) then
		return  arr2player[index]
	end
	return  arr3player[index]
end
	--每帧更新函数
function LuaCMultiBattleManager.Update()
	local i=0
	local mapTeam
	local j=0
	local Mpc
	BattleProcess()
	this.m_BattleMap.Update()
	--更新战斗双方角色
	i=0
	while  i<BATTLE_POS_MAX  do
		mapTeam=this.m_arrTeamMap[i]
		if (mapTeam==nil) then
			continue
		end
		j=0
		while  j<mapTeam.size()  do
			Mpc=mapTeam.getValueAtIndex(j)
			if (Mpc==nil) then
				continue
			end
			Mpc.Update()
						j=j+1
		end
				i=i+1
	end
	--默认自动接受组队邀请0
	ShowBattleRoleInfo()
end
	--显示战斗角色信息界面
function LuaCMultiBattleManager.ShowBattleRoleInfo()
	local selectRole
	local i=0
	local Mpc
	CUIBattlePlayerInfo.gUIBattlePlayerInfo.visible=false
	if (m_nSenceBattleState==CBattleManager.BATTLE_END) then
		return 
	end
	selectRole=nil
	i=this.m_BattleMap.mRoleLayer.numChildren-1
	while  i>=0  do
		Mpc=this.m_BattleMap.mRoleLayer.getChildAt(i)
		if (Mpc==nil) then
			continue
		end
	--				if(Mpc.IsClick(m_BattleMap.mouseX,m_BattleMap.mouseY))
	--				{
	--					selectRole=Mpc;
	--					break;
	--				}
				i=i-1
	end
	--			var selectRole:CBattleSprite=null;
	--			for(var i:int=0;i<BATTLE_POS_MAX;i++)
	--			{
	--默认自动接受入队申请0
	--				if(mapTeam==null)continue;
	--				for(var j:int=0;j<mapTeam.size();j++)
	--				{
	--					var Mpc:CBattleSprite=mapTeam.getValue(j)as CBattleSprite;
	--					if(Mpc==null)
	--					{
	--						continue;
	--					}
	--					if(Mpc.IsClick(m_BattleMap.mouseX,m_BattleMap.mouseY))
	--默认玩家登陆日期0
	--						selectRole=Mpc;
	--						break;
	--					}
	--				}
	--			}
	if (selectRole~=nil and selectRole.visible) then
		CUIBattlePlayerInfo.gUIBattlePlayerInfo.visible=true
		CUIBattlePlayerInfo.gUIBattlePlayerInfo.Update(selectRole)
	end
	if (CUIBattlePlayerInfo.gUIBattlePlayerInfo.visible) then
	--				CUIBattlePlayerInfo.gUIBattlePlayerInfo.x=CUIManager.gUIManager.mouseX+20;
	--				CUIBattlePlayerInfo.gUIBattlePlayerInfo.y=CUIManager.gUIManager.mouseY+20;
	--				var y:int=CUIBattlePlayerInfo.gUIBattlePlayerInfo.y;
	--				var height:int=0;
	--默认自动准备跨服副本0
	--				{
	--					height=CUIBattlePlayerInfo.gUIBattlePlayerInfo.bginfo.height;
	--				}
	--				else
	--				{
	--					height=CUIBattlePlayerInfo.gUIBattlePlayerInfo.height;
	--				}
	--				var stageHeight:int=CUIManager.gUIManager.stage.height;
	--				stageHeight=stageHeight>700?700:stageHeight;
	--记录每个账号登陆过的服务器的角色等级0
	--				{
	--					CUIBattlePlayerInfo.gUIBattlePlayerInfo.y-=(height+20);
	--				}
	end
end
	--战斗流程处理
function LuaCMultiBattleManager.BattleProcess()
	local i=0
	if (this.m_bPause) then
		return 
	end
	if (m_nSenceBattleState==CBattleManager.BATTLE_INIT) then
		return 
	end
	i=0
	while  i<CMultiBattleManager.gCMultiBattleManager.m_PlayerNum  do
		(m_arrPlayerControler[i]).BattleProcess()
				i=i+1
	end
	--(m_arrPlayerControler[0]as CMultiBattlePlayer).BattleProcess();
end
function LuaCMultiBattleManager.CloseBattle()
	local i=0
	local mapTeam
	LuaCProModule.SendReturn2CityRequest(BATTLE_TYPE_OGRE)
	this.m_BattleMap.visible=false
	CGameMap.gGameMap.visible=true
	CUIBattleOgreNum.gUIBattleOgreNum.visible=false
	LuaCActivityModule.multiLoadWinNum=0
	LuaCActivityModule.multiLoadFailNum=0
	CUIMultiPlayerHead.gCUIMultiPlayerHead.visible=false
	m_nSenceBattleState=CBattleManager.BATTLE_END
	this.m_OgreKillPlayer={}
	ClearMap()
	this.m_BattleMapID=0
	i=0
	while  i<String(m_arrPlayerControler).length  do
		(m_arrPlayerControler[i]).CloseBattle()
				i=i+1
	end
	i=0
	while  i<String(this.m_arrTeamMap).length  do
		mapTeam=this.m_arrTeamMap[i]
		if (mapTeam) then
			mapTeam.clear()
		end
				i=i+1
	end
	this.m_arrTeamMap={}
	GameFrameWork.instance.EndBattle(this.m_nBattleType)
	--清除战斗技能
	--			while(m_arrLoadedIamgeData.length>0)
	--			{
	--				var strUrl:String=m_arrLoadedIamgeData.pop();
	--记录该账号当天第一次登录时的战斗力0
	--			}
end
	--显示伤害类型特效
function LuaCMultiBattleManager.ShowDamageTypeEeffct(player,nDamageType)
	local nX=0
	local nY=0
	if (nDamageType==DAMAGE_TYPE_DUCK) then
			if (player.mDirection==CharacterSprite2.DIRECTION_LEFT) then
				nX=player.x+120
				nY=player.y-100
				this.m_BattleMap.AddSceneEffect("images/effect/DuckLeft.swf",nX,nY,CharacterSprite2.DIRECTION_LEFT)
			else
				nX=player.x-120
				nY=player.y-100
				this.m_BattleMap.AddSceneEffect("images/effect/DuckRight.swf",nX,nY,CharacterSprite2.DIRECTION_LEFT)
			end
			player.Duck()
	elseif (nDamageType==DAMAGE_TYPE_CRITICAL_HIT) then
			if (player.mDirection==CharacterSprite2.DIRECTION_LEFT) then
				nX=player.x-80
				nY=player.y-100
			else
				nX=player.x+80
				nY=player.y-100
			end
			this.m_BattleMap.AddSceneEffect("images/effect/CriticalHit.swf",nX,nY,CharacterSprite2.DIRECTION_LEFT)
			this.m_BattleMap.StartShake()
	elseif (nDamageType==DAMAGE_TYPE_PARRY) then
			if (player.mDirection==CharacterSprite2.DIRECTION_LEFT) then
				nX=player.x+80
				nY=player.y-100
			else
				nX=player.x-80
				nY=player.y-100
			end
			this.m_BattleMap.AddSceneEffect("images/effect/Parry.swf",nX,nY,CharacterSprite2.DIRECTION_LEFT)
			player.ShowParryEffect()
	elseif (nDamageType==DAMAGE_TYPE_COUNTER_ATTACK) then
			if (player.mDirection==CharacterSprite2.DIRECTION_LEFT) then
				nX=player.x+30
				nY=player.y-110
				this.m_BattleMap.AddSceneEffect("images/effect/CounterAttackRight.swf",nX,nY,CharacterSprite2.DIRECTION_LEFT)
			else
				nX=player.x-30
				nY=player.y-110
				this.m_BattleMap.AddSceneEffect("images/effect/CounterAttackLeft.swf",nX,nY,CharacterSprite2.DIRECTION_LEFT)
			else
			break
	end
end
	--显示被攻击特效
function LuaCMultiBattleManager.ShowSceneSkillEeffct(strSkill,teamIndex,
	local Pos
									"memberIndex":int,dir:int,
									"nSceneSkillAttackRange":int,
									"OnSceneSkillKeyFrameCallBack":Function):Boolean=false
	--计算特效位置
	if (teamIndex<BATTLE_SIDE_POSNUM) then
			--玩家（位置可能会变到死的玩家那里）
	end
		teamIndex=m_arrPlayerPos[teamIndex]
	else	--保存设置数据0
		teamIndex=teamIndex%3+BATTLE_SIDE_POSNUM;	--可以是6 7 8
	end
	if (nSceneSkillAttackRange==CTemplateSkill.ATTACKRANGE_ENEMYALL) then
		Pos=this.m_BattleMap.GetMultiPlayerPos(teamIndex,4)
	elseif (nSceneSkillAttackRange==CTemplateSkill.ATTACKRANGE_ENEMYLINE) then
		Pos=this.m_BattleMap.GetMultiPlayerPos(teamIndex,memberIndex%3+3)
	elseif (nSceneSkillAttackRange==CTemplateSkill.ATTACKRANGE_ENEMYROW) then
		Pos=this.m_BattleMap.GetMultiPlayerPos(teamIndex,Math.floor(memberIndex/3)*3+1)
	else
		Pos=this.m_BattleMap.GetMultiPlayerPos(teamIndex,memberIndex)
	end
	this.m_BattleMap.AddSceneEffect(strSkill,Pos.x,Pos.y,dir,0.5,true,OnSceneSkillKeyFrameCallBack)
	return  true
end
function LuaCMultiBattleManager.OnBattleEnd()
	if (this.m_nWinNum==String(this.m_arrMultiOgreID).length and this.m_nBattleWinIndex==0) then
		m_nSenceBattleState=CBattleManager.BATTLE_END
		CUIOgreDrop.gUIOgerDrop.ShowUI()
	elseif (this.m_nFail==this.m_PlayerNum and this.m_nBattleWinIndex==1) then
		m_nSenceBattleState=CBattleManager.BATTLE_END
		LuaCUIWorldBossBattleEnd.InitData(0,0,0,0,0,0,false,CProModule.BATTLE_TYPE_MultiFB)
		LuaCUIWorldBossBattleEnd.ShowUI()
	else
		--其他人还没打完
	end
end
	--由战斗到休息区
function LuaCMultiBattleManager.FightToRest(index,waitOgreFight)
	local newPos=0
	local i=0
	local teammap
	local Mpc
	local pos=0
	i=0
	while  i<String(m_arrRestPlayer).length  do
		if (m_arrRestPlayer[i]==-1) then
			m_arrRestPlayer[i]=index
			newPos=i
			break
		end
				i=i+1
	end
	this.m_arrWait[index]=waitOgreFight;	--等待这个怪把别人杀了
	teammap=this.m_arrTeamMap[index]
	i=0
	while  i<teammap.size()  do
		Mpc=teammap.getValueAtIndex(i)
		pos=this.m_BattleMap.GetMultiPlayerPos(newPos+3,Mpc.m_unEntityID)
		Mpc.Stand(pos.x,pos.y,CharacterSprite2.DIRECTION_RIGHT)
				i=i+1
	end
end
	--由休息区进入战斗区，到怪对面
function LuaCMultiBattleManager.RestToFight(index,ogreIndex)
	local i=0
	local teammap
	local j=0
	local Mpc
	local pos
	local orgerow=0
	--在休息,回到战场
	i=0
	while  i<String(m_arrRestPlayer).length  do
		if (m_arrRestPlayer[i]==index) then
				--设置不在休息区了
		end
			m_arrRestPlayer[i]=-1
			break
		end
				i=i+1
	end
	--玩家进入战斗区,到那组怪的对面
	teammap=this.m_arrTeamMap[index]
	j=0
	while  j<teammap.size()  do
		m_arrPlayerPos[index]=ogreIndex%3
		Mpc=teammap.getValueAtIndex(j)
		pos=this.m_BattleMap.GetMultiPlayerPos(ogreIndex%3,Mpc.m_unEntityID)
		Mpc.Stand(pos.x,pos.y,CharacterSprite2.DIRECTION_RIGHT)
				j=j+1
	end
	--怪的函数变换到和这个玩家一样
	orgerow=ogreIndex%3+BATTLE_SIDE_POSNUM;	--游戏公告界面00
	while (orgerow<BATTLE_POS_MAX) do
		teammap=this.m_arrTeamMap[orgerow];	--关闭背景音乐1
		if (teammap and this.isOgreAlive(orgerow)) then
				--这个位置上有怪
		end
			j=0
			while  j<teammap.size()  do
				Mpc=teammap.getValueAtIndex(j)
				--pos=m_BattleMap.GetMultiPlayerPos(nRow,Mpc.m_unEntityID);	//挪到玩家的对面
				--Mpc.Stand(pos.x,pos.y,CharacterSprite2.DIRECTION_LEFT);
				--对手变为第index玩家
				Mpc.OnStartAttackCallBack=m_arrPlayerControler[index].OnStartAttack
				Mpc.OnEndAttcakCallBack=m_arrPlayerControler[index].OnEndAttack
				Mpc.OnEndBeatingCallBack=m_arrPlayerControler[index].OnEndBeating
								j=j+1
			end
		end
		orgerow=orgerow+3;	--怪所在行的下一个组位置
			end
	this.m_arrWait[index]=-1;	--设置玩家没有等待怪物某个怪物，因为已经开始打这个怪了			
end
	--后面的怪往前挪
function LuaCMultiBattleManager.OgreToFirst(index,ogreIndexPos)
	local orgerow=0
	local i=0
	local teammap
	local j=0
	local Mpc
	local pos=ogreIndexPos%3+BATTLE_SIDE_POSNUM;	--怪所在行的第一个位置
	i=orgerow;	--开启背景音乐0
	while (orgerow<BATTLE_POS_MAX) do
		teammap=this.m_arrTeamMap[orgerow]
		if (teammap and this.isOgreAlive(orgerow)) then
			j=0
			while  j<teammap.size()  do
				Mpc=teammap.getValueAtIndex(j)
				pos=this.m_BattleMap.GetMultiPlayerPos(i,Mpc.m_unEntityID);	--挪到玩家的对面第一个
				Mpc.Stand(pos.x,pos.y,CharacterSprite2.DIRECTION_LEFT)
								j=j+1
			end
			i=i+3;	--占用的下一个位置
		end
		orgerow=orgerow+3;	--本行下一个怪的位置
			end
end
	--得到指定队伍
function LuaCMultiBattleManager.getTeam(index)
	return 　this.m_arrTeamMap[index]
end
	--新的战斗，重置气势值等数值
function LuaCMultiBattleManager.valueToInit(index)
	local groupInfo
	local teammap
	local j=0
	local Mpc=m_arrInitValue[index]
	teammap=this.m_arrTeamMap[index]
	if (teammap) then
		j=0
		while  j<teammap.size()  do
			Mpc=teammap.getValueAtIndex(j)
			Mpc.m_nPower=groupInfo.getValue(Mpc.m_unEntityID).Power
			Mpc.ShowFullPower()
						j=j+1
		end
	end
end
function LuaCMultiBattleManager.isPlayerAlive(playerIndex)
	return  m_arrPlayerDead[playerIndex]==0
end
function LuaCMultiBattleManager.isOgreAlive(ogreIndex)
	local i=0
	i=0
	while  i<String(m_arrOgreDead).length  do
		if (m_arrOgreDead[i]==ogreIndex) then
			return  false
		end
				i=i+1
	end
	return  true
end
function LuaCMultiBattleManager.setOgreDead(ogreIndex)
	m_arrOgreDead.push(ogreIndex)
end
	--被怪打死了，让下一个人上场
function LuaCMultiBattleManager.helpFight(ogreIndex,playerIndex)
	local isFind
	local i=0
	--记录玩家死亡
	m_arrPlayerDead[playerIndex]=1
	--该谁打
	isFind=false
	i=0
	while  i<String(this.m_arrWait).length  do
		if (this.m_arrWait[i]==ogreIndex) then
			isFind=true
			break
		end
				i=i+1
	end
	if (isFind==false) then
		return 
	end
	--上场
	CMultiBattleManager.gCMultiBattleManager.RestToFight(i,ogreIndex)
	(m_arrPlayerControler[i]).m_nBattleState=CBattleManager.BATTLE_ATTACK_WAIT
end
