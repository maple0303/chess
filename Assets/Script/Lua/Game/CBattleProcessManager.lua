local this = LuaCBattleProcessManager
LuaCBattleProcessManager = { 
	BATTLE_INIT=0,	--飘字效果07
	BATTLE_ATTACK_WAIT=1,	--重新请求服务器列表8
	BATTLE_ATTACK_ING=2,	--战斗攻击中
	BATTLE_END=3,	--应用宝平台0
	BATTLE_WIN=4,	--战斗胜利
	m_nBattleState:uint,					--战斗状态
	m_Team1Map:HashMap,						--队伍1表
	m_Team2Map:HashMap,						--队伍2表
	m_RideMap:HashMap,						--坐骑表
	m_BattleProcessData = nil,		--清空游戏数据3
	m_BattleMap:CBattleMap,					--战斗地图层
	OnBattleEndCallBack=null
}
local m_unBattleCD:uint;						--战斗冷却时间，单位：毫秒
local m_unBattleTimeTick:uint;				--战斗计时器
local m_CurBattleDamgeInfo = LuaCBattleDamage:new();	--当前的伤害信息
local m_arrAttacker:Array;					--攻击者
local m_arrAttackeder:Array;					--登出游戏回到选服界面0
local m_arrBuffer:Array;						--受到buff效果角色列表
local m_bSceneSkill=false;			--是否正在场景技能
local m_nSkillBottomEffectState:int;			--技能底部特效状态
local m_BattleStartEffect:CEffectSprite;		--战斗开场特效
local m_nBattleProcessIndex:int;				--战斗进度索引
local m_bWaitAttackEnd=false;				--是否等待攻击结束再进行新攻击
local m_CurSkillAttacker:CBattleSprite;		--当前使用技能攻击者
local m_nSkillType=0;					--技能类型
local m_nSceneSkillAttackRange:int;			--场景技能攻击范围
local m_strNextSkillEffect:String;			--场景技能下一个特效
local m_nPreFrameTime:int;					--上一帧时间
local m_bShowBattleProcess=true
local m_bPause=false
function LuaCBattleProcessManager.ctor()
	this.m_Team1Map={}()
	this.m_Team2Map={}()
	this.m_RideMap={}()
	m_arrAttacker={}()
	m_arrAttackeder={}()
	m_arrBuffer={}()
	this.m_BattleMap=CBattleMap.new
	m_BattleStartEffect=CEffectSprite.new
end
	--开始战斗
function LuaCBattleProcessManager.StartBattle()
	--			if(m_SkillNameEffect!=null)
	--			{
	--				m_SkillNameEffect.x=650;
	--如果是PC进入PC的登陆界面0
	--				m_SkillNameEffect.gotoAndStop(1);
	--				m_SkillNameEffect.visible=false;
	--			}
	--			if(m_SkillBottomEffect!=null)
	--			{
	--				m_SkillBottomEffect.x=0;
	--				m_SkillBottomEffect.y=0;
	--				m_SkillBottomEffect.gotoAndStop(1);
	--				m_SkillBottomEffect.visible=false;
	--登出游戏0
	m_nPreFrameTime=0
	m_nBattleProcessIndex=0
	m_bWaitAttackEnd=true
	String(m_arrAttacker).length=0
	String(m_arrAttackeder).length=0
	this.m_BattleMap.addChild(m_BattleStartEffect)
	m_BattleStartEffect.x=this.m_BattleMap.GetVisualWidth()/2
	m_BattleStartEffect.y=this.m_BattleMap.GetVisualHeight()/2
	--			m_BattleStartEffect.mAnimationFrameInterval=4;
	--			m_BattleStartEffect.LoadEffectSwf("%69%6D%61%67%65%73%2F%65%66%66%65%63%74%2F%62%61%74%74%6C%65%73%74%61%72%74%2E%73%77%66");
	--			m_BattleStartEffect.OnEffectPlayEndCallBack=OnPlayEndBattleStartEffect;
	--			CUIBattlePlayerInfo.gUIBattlePlayerInfo.Initialize();
	--			CUIManager.gUIManager.addChild(CUIBattlePlayerInfo.gUIBattlePlayerInfo);
	return 
end
function LuaCBattleProcessManager.OnPlayEndBattleStartEffect()
	this.m_nBattleState=BATTLE_ATTACK_WAIT
	this.m_BattleMap.removeChild(m_BattleStartEffect)
end
	--每帧更新函数
function LuaCBattleProcessManager.Update()
	local nCurTime=0
	local nTimer=0
	local nNum=0
	local arrKeys
	local i=0
	local Mpc
	local Ride
	local Npc
	if (m_nPreFrameTime==0) then
		m_nPreFrameTime=getTimer()
	end
	nCurTime=getTimer()
	nTimer=nCurTime-m_nPreFrameTime
	nNum=Math.round(nTimer/33)
	m_nPreFrameTime=nCurTime
	--trace("%U6218%U6597%U5E27%UFF1A"+nNum+"%U3001%U65F6%U95F4%UFF1A"+nTimer);
	BattleProcess()
	this.m_BattleMap.Update()
	--更新战斗双方角色
	arrKeys=this.m_Team1Map.keys()
	i=0
	while  i<String(arrKeys).length  do
		Mpc=this.m_Team1Map.getValue(arrKeys[i])
		if (Mpc==nil) then
			continue
		end
		Mpc.Update()
				i=i+1
	end
	arrKeys=this.m_Team2Map.keys()
	i=0
	while  i<String(arrKeys).length  do
		Ride=this.m_Team2Map.getValue(arrKeys[i])
		if (Ride==nil) then
			continue
		end
		Ride.Update()
				i=i+1
	end
	arrKeys=this.m_RideMap.keys()
	i=0
	while  i<String(arrKeys).length  do
		Npc=this.m_RideMap.getValue(arrKeys[i])
		if (Npc==nil) then
			continue
		end
		Npc.UpdateAnimation()
				i=i+1
	end
	--			if(m_SkillNameEffect!=null&&m_SkillNameEffect.visible)
	--log.debug("%6C%6F%67%6F%75%74%48%61%6E%64%6C%65%72%3A"+e.type);0
	--				if(m_SkillNameEffect.currentFrame==m_SkillNameEffect.totalFrames)
	--				{
	--					if(m_SkillNameEffect.skillname.numChildren>0)
	--					{
	--						m_SkillNameEffect.skillname.removeChildAt(0);
	--					}
	--					m_SkillNameEffect.gotoAndStop(1);
	--					m_SkillNameEffect.visible=false;
	--					m_CurSkillAttacker.SkillAttack();
	--清空游戏数据0
	--			}
	--			if(m_SkillBottomEffect!=null&&m_SkillBottomEffect.visible)
	--			{
	--				if(m_nSkillBottomEffectState==1)
	--				{
	--					if(m_SkillBottomEffect.currentFrame==5)
	--					{
	--						m_SkillBottomEffect.gotoAndStop(5);
	--						m_nSkillBottomEffectState=2;
	--应用宝平台0
	--				}
	--				else if(m_nSkillBottomEffectState==3)
	--				{
	--					if(m_SkillBottomEffect.currentFrame==m_SkillBottomEffect.totalFrames)
	--					{
	--						m_SkillBottomEffect.gotoAndStop(1);
	--						m_SkillBottomEffect.visible=false;
	--						m_nBattleState=BATTLE_ATTACK_WAIT;
	--					}
	--欧美IOS0
	--			}
	--			if(m_BattleStartEffect!=null)
	--			{
	--				m_BattleStartEffect.UpdateAnimation();
	--			}
	ShowBattleRoleInfo()
end
	--显示战斗角色信息界面
function LuaCBattleProcessManager.ShowBattleRoleInfo()
	local selectRole
	local i=0
	local Mpc
	CUIBattlePlayerInfo.gUIBattlePlayerInfo.visible=false
	if (this.m_nBattleState==BATTLE_END) then
		return 
	end
	selectRole=nil
	i=this.m_BattleMap.mRoleLayer.numChildren-1
	while  i>=0  do
		Mpc=this.m_BattleMap.mRoleLayer.getChildAt(i)
		if (Mpc==nil) then
			continue
		end
		if (Mpc.m_strName=="") then
			continue
		end
	--				if(Mpc.IsClick(m_BattleMap.mouseX,m_BattleMap.mouseY))
	--				{
	--					selectRole=Mpc;
	--存储在本地的文件的名字000
	--确认提示框01
				i=i-1
	end
	if (selectRole~=nil and selectRole.visible) then
		CUIBattlePlayerInfo.gUIBattlePlayerInfo.visible=true
		CUIBattlePlayerInfo.gUIBattlePlayerInfo.Update(selectRole)
	end
	if (CUIBattlePlayerInfo.gUIBattlePlayerInfo.visible) then
	--如果是PC进入PC的登陆界面2
	--				CUIBattlePlayerInfo.gUIBattlePlayerInfo.y=CUIManager.gUIManager.mouseY+20;
	--				var y:int=CUIBattlePlayerInfo.gUIBattlePlayerInfo.y;
	--				var height:int=0;
	--				if(CUIBattlePlayerInfo.gUIBattlePlayerInfo.bginfo!=null)
	--				{
	--					height=CUIBattlePlayerInfo.gUIBattlePlayerInfo.bginfo.height;
	--				}
	--清空游戏数据0
	--				{
	--					height=CUIBattlePlayerInfo.gUIBattlePlayerInfo.height;
	--				}
	--				var stageHeight:int=CUIManager.gUIManager.stage.height;
	--				stageHeight=stageHeight>700?700:stageHeight;
	--				if(y+height>stageHeight)
	--				{
	--					CUIBattlePlayerInfo.gUIBattlePlayerInfo.y-=(height+20);
	--				}
	end
end
	--显示登录界面0
function LuaCBattleProcessManager.BattleProcess()
	local curTimer=0
	local bStart
	local attacker
	local i=0
	local dest
	local arrBattleProcess
	local nNextProcessIndex=0
	local NewDamgeInfo
	local SrcMap
	local DestMap
	local strTips
	local Dest
	local unDestIndex=0
	local unCamp=0
	local Npc
	local arrBuff
	local nIndex=0
	local nCurHp=0
	local nAttackerIndex=0
	local objAttackeder
	local npcTemp
	local Attacker
	local nBuffID=0
	local Attackeder
	local nAddvalue=0
	if (m_bPause) then
		return 
	end
	if (this.m_BattleProcessData==nil) then
		return 
	end
	if (this.m_nBattleState==BATTLE_INIT) then
		return 
	elseif (this.m_nBattleState==BATTLE_END) then
		return 
	end
	if (not m_bShowBattleProcess) then
		--不显示战斗过程，调试时用
	end
		BattleEnd()
		return 
	end
	curTimer=getTimer()-m_unBattleTimeTick
	if (curTimer<m_unBattleCD) then
		--超过间隔
	end
		return 
	end
	if (m_bSceneSkill) then
		return 
	end
	if (m_bWaitAttackEnd) then
		if (this.m_nBattleState~=BATTLE_ATTACK_WAIT) then
			return 
		end
		bStart=true
		--查看攻击者是否攻击完成
		if (String(m_arrAttacker).length>0) then
			attacker=m_arrAttacker[0]["role"]
			if (attacker~=nil and attacker.m_nAttackState~=CBattleSprite.ATTACK_NONE) then
				bStart=false
			end
		end
		if (not bStart) then
			return 
		end
		bStart=true
		--查看受到攻击是否动画完成
		i=0
		while  i<String(m_arrAttackeder).length  do
			dest=m_arrAttackeder[i]["role"]
			if (dest==nil) then
				continue
			end
			if (dest.m_nAttackState~=CBattleSprite.ATTACK_NONE) then
				bStart=false
				break
			end
			if (not dest.IsAttackedEnd()) then
				bStart=false
				break
			end
						i=i+1
		end
		if (not bStart) then
			return 
		end
	--				if(m_SkillBottomEffect!=null&&m_SkillBottomEffect.visible)
	--				{
	--					if(m_nSkillBottomEffectState!=3)
	--					{
	--						m_SkillBottomEffect.gotoAndPlay(6);
	--应用宝平台0
	--					}
	--					return;
	--				}
	end
	--m_CurAttacker=null;
	--是否战斗结束
	arrBattleProcess=this.m_BattleProcessData.m_arrBattleProcess
	if (m_nBattleProcessIndex>=String(arrBattleProcess).length) then
		BattleEnd()
		return 
	end
	m_CurBattleDamgeInfo=arrBattleProcess[m_nBattleProcessIndex]
	m_nBattleProcessIndex=m_nBattleProcessIndex+1
	if (m_CurBattleDamgeInfo==nil) then
		return 
	end
	m_unBattleTimeTick=getTimer()
	--trace("%U6218%U6597%U95F4%U9694%UFF1A"+curTimer);
	--计算攻击间隔，如果下一次攻击是对方攻击则间隔1秒
	--如下一次攻击是已方成员则间隔500毫秒
	m_bWaitAttackEnd=true
	nNextProcessIndex=m_nBattleProcessIndex
	if (nNextProcessIndex>=String(arrBattleProcess).length) then
		--最后一次攻击
	end
		m_unBattleCD=1000;--欧美IOS0
	else
		NewDamgeInfo=arrBattleProcess[m_nBattleProcessIndex]
		if (NewDamgeInfo==nil) then
			m_unBattleCD=1000;--攻击间隔时间	
		else
			if (NewDamgeInfo.m_unAttackerIndex~=m_CurBattleDamgeInfo.m_unAttackerIndex) then
				m_unBattleCD=1000;--攻击间隔时间
			else
				m_unBattleCD=1000;--攻击间隔时间
				--m_bWaitAttackEnd=false;
			end
		end
	end
	--
	SrcMap=nil
	DestMap=nil
	strTips=""
	if (m_CurBattleDamgeInfo.m_unAttackerIndex==0) then
			--左边阵营
	end
		SrcMap=this.m_Team1Map
		DestMap=this.m_Team2Map
		--strTips="%U5DE6%U8FB9%U653B%U51FB%UFF0C";
		strTips=LanguageData.gLanguageData.UI_WEBGAME_004.."，"
	else
		SrcMap=this.m_Team2Map
		DestMap=this.m_Team1Map
		--strTips="%U53F3%U8FB9%U653B%U51FB%UFF0C";
		strTips=LanguageData.gLanguageData.UI_WEBGAME_005.."，"
	end
	--strTips+="%U653B%U51FB%U8005%U4F4D%U7F6E"+m_CurBattleDamgeInfo.m_unSourceIndex+"%2C";
	strTips=strTips+LanguageData.gLanguageData.UI_WEBGAME_006+m_CurBattleDamgeInfo.m_unSourceIndex..","
	--应用宝平台登出0
	strTips=strTips+LanguageData.gLanguageData.UI_WEBGAME_007+m_CurBattleDamgeInfo.m_unDamageType..","
	--strTips+="%U4F7F%U7528%U6280%U80FD"+m_CurBattleDamgeInfo.m_unSkillID+"%2C";
	strTips=strTips+LanguageData.gLanguageData.UI_WEBGAME_008+m_CurBattleDamgeInfo.m_unSkillID..","
	--strTips+="%U53CD%U51FB"+m_CurBattleDamgeInfo.m_nCounterHP;
	strTips=strTips+LanguageData.gLanguageData.UI_WEBGAME_009+m_CurBattleDamgeInfo.m_nCounterHP
	--trace(strTips);
	--找到被攻击玩家列表
	String(m_arrAttackeder).length=0
	for _Dest in pairs(m_CurBattleDamgeInfo.m_arrDestInfo) do
		local Dest=m_CurBattleDamgeInfo.m_arrDestInfo[_Dest]
		--高16位，0为对方阵营，1为己方阵营
		--低16位位被攻击者的位置索引
		unDestIndex=Dest.m_unIndex&0x0000ffff
		unCamp=Dest.m_unIndex>>16
		if (unCamp==0) then
			--对方阵营
			Npc=DestMap.getValue(unDestIndex)
			if (Npc==nil) then
				continue
			end
		else
			--已方阵营
			Npc=SrcMap.getValue(unDestIndex)
			if (Npc==nil) then
				continue
			end
		end
		Npc.m_nPower=Dest.m_nCurPower
		m_arrAttackeder.push({role:Npc,damgetype:Dest.m_unDamageType,curhp:Dest.m_nCurHP,ClearBuff:Dest.m_arrBuffClear})
	end
	--受到buff影响的玩家
	String(m_arrBuffer).length=0
	for _arrBuff in pairs(m_CurBattleDamgeInfo.m_arrBuff) do
		local arrBuff=m_CurBattleDamgeInfo.m_arrBuff[_arrBuff]
		nIndex=arrBuff[0]
		nBuffID=arrBuff[1]
		nCurHp=arrBuff[2]
		--清空游戏数据0
		--低16位位被攻击者的位置索引
		unDestIndex=nIndex&0x0000ffff
		unCamp=nIndex>>16
		if (unCamp==0) then
			--对方阵营
			Npc=DestMap.getValue(unDestIndex)
			if (Npc==nil) then
				continue
			end
			--如果buff列表中存在的目标同时也存在伤害列表中，血值以伤害列表为准
			nAttackerIndex=0
			while  nAttackerIndex<String(m_arrAttackeder).length  do
				objAttackeder=m_arrAttackeder[nAttackerIndex]
				npcTemp=objAttackeder.role
				if (npcTemp==nil) then
					continue
				end
				if (npcTemp==Npc) then
					nCurHp=m_arrAttackeder[nAttackerIndex].curhp
				end
								nAttackerIndex=nAttackerIndex+1
			end
		else
			--已方阵营
			Npc=SrcMap.getValue(unDestIndex)
			if (Npc==nil) then
				continue
			end
		end
		m_arrBuffer.push({role:Npc,buff:nBuffID,curhp:nCurHp})
	end
	--找到准备攻击的角色，播放攻击的动作
	String(m_arrAttacker).length=0
	Attacker=SrcMap.getValue(m_CurBattleDamgeInfo.m_unSourceIndex)
	if (Attacker==nil) then
		return 
	end
	Attacker.m_nPower=m_CurBattleDamgeInfo.m_unPower
	m_arrAttacker.push({role:Attacker,skill:m_CurBattleDamgeInfo.m_unSkillID,
		"damgetype":m_CurBattleDamgeInfo.m_unDamageType,
		"counter":m_CurBattleDamgeInfo.m_nCounterHP})
	if (m_CurBattleDamgeInfo.m_nCounterHP>0) then
		Attacker.m_bParryed=true
	end
	--先清除buff特效
	i=0
	while  i<String(m_CurBattleDamgeInfo.m_arrBuffClear).length  do
		nBuffID=m_CurBattleDamgeInfo.m_arrBuffClear[i]
		Attacker.ClearBuffEffect(nBuffID)
				i=i+1
	end
	--开始攻击
	if (m_CurBattleDamgeInfo.m_unSkillID>0) then
		this.m_nBattleState=BATTLE_ATTACK_ING
		--没有显示技能名称特效，则直接播放技能攻击
	--				if(m_SkillNameEffect==null)
	--显示激活码界面0
	--					Attacker.Attack(null);
	--				}
	--				else
	--				{
	--					var SkillTemplate:CTemplateSkill=CDataStatic.SearchTpl(m_CurBattleDamgeInfo.m_unSkillID)as CTemplateSkill;
	--					if(SkillTemplate!=null)
	--					{
	--						m_CurSkillAttacker=Attacker;
	--						
	--登陆成功，开始请求服务器列表0
	--						m_SkillNameEffect.play();
	--						//角色和BOSS要显示技能黑幕
	--						if(m_CurSkillAttacker.m_nBattleSpriteType==CBattleSprite.BATTLE_SPRITE_TYPE_PLAYER
	--							||m_CurSkillAttacker.m_nBattleSpriteType==CBattleSprite.BATTLE_SPRITE_TYPE_BOSS
	--							||m_CurSkillAttacker.m_nBattleSpriteType==CBattleSprite.BATTLE_SPRITE_TYPE_WORLD_BOSS)
	--						{
	--							m_SkillBottomEffect.visible=true;
	--							m_SkillBottomEffect.play();
	--							m_nSkillBottomEffectState=1;
	--应用宝平台0
	--						
	--						var strUrl:String="%69%6D%61%67%65%73%2F%73%6B%69%6C%6C%6E%61%6D%65%2F"+SkillTemplate.mTempID+"%2E%70%6E%67";
	--						CUIImageManager.gUIImageManager.LoadImageData(null,strUrl,OnLoadSkillNameComplete);
	--					}
	--				}
	elseif (String(m_arrAttackeder).length>1) then
		--如果伤害目标是多个，则远程攻击
	end
		Attacker.Attack(nil);--攻击目标为空，则是群体远程攻击
		this.m_nBattleState=BATTLE_ATTACK_ING
	elseif (String(m_arrAttackeder).length==1) then
		--就一个攻击目标，根据技能判断是近程还是远程攻击
	end
		Attackeder=m_arrAttackeder[0]["role"]
		if (Attackeder==nil) then
			m_unBattleCD=0
			this.m_nBattleState=BATTLE_ATTACK_WAIT
			return 
		end
		if (Attackeder==Attacker) then
			--被攻击者是这本身
		end
			nAddvalue=Attacker.m_nCurHP-m_arrAttackeder[0]["curhp"]
			Attacker.m_nCurHP=m_arrAttackeder[0]["curhp"]
			if (nAddvalue>0) then
				--登陆界面00
				--登陆失败1
				Attacker.ShowHpChangeEffect(true)
			else
				--播放被攻击动画
				Attacker.Beating()
			end
		else
			--根据职业判断是远程攻击，还是进程攻击
			if (Attacker.m_nMetier==CTemplateMetier.METIER_BREATH or Attacker.m_nMetier==CTemplateMetier.METIER_FINGER) then
				--气宗和指宗为远程攻击
				Attacker.Attack(nil)
			else
				Attacker.Attack(Attackeder);--攻击目标
			end
			this.m_nBattleState=BATTLE_ATTACK_ING
		end
	else
		m_unBattleCD=0
		this.m_nBattleState=BATTLE_ATTACK_WAIT
	end
end
function LuaCBattleProcessManager.OnLoadSkillNameComplete(obj)
	--			if(!m_SkillNameEffect.visible)
	--			{
	--				return
	--			}
	--清空游戏数据0
	--			NameBit.bitmapData=obj.bitmapdata;
	--			m_SkillNameEffect.skillname.addChild(NameBit);
end
	--开始攻击
function LuaCBattleProcessManager.OnStartAttack()
	local Attacker
	local nSkillID=0
	local nDamageType=0
	if (m_CurBattleDamgeInfo==nil or String(m_arrAttacker).length==0) then
		return 
	end
	Attacker=m_arrAttacker[0]["role"]
	if (Attacker==nil) then
		return 
	end
	nSkillID=m_arrAttacker[0]["skill"]
	nDamageType=m_arrAttacker[0]["damgetype"]
	--显示伤害类型特效
	ShowDamageTypeEeffct(Attacker,nDamageType)
	--显示技能特效
	ProessSkillEffect(nSkillID)
	--显示buff特效
	ProessBuffEffect()
end
	--处理技能特效
function LuaCBattleProcessManager.ProessSkillEffect(nSkillID)
	local strSkillKey
	local SkillTemplate="config/effect/skill/6500.xml"
	m_nSceneSkillAttackRange=CTemplateSkill.ATTACKRANGE_ENEMYSINGLE
	m_nSkillType=CTemplateSkill.SKILL_DAMAGE_TYPE_NORMAL_STUNT
	if (nSkillID>0) then
		--判断是否是技能攻击
	end
		SkillTemplate=CDataStatic.SearchTpl(nSkillID)
		if (SkillTemplate~=nil) then
			m_nSkillType=SkillTemplate.m_nSkillDamageType
			m_nSceneSkillAttackRange=SkillTemplate.m_nAttackRange
			strSkillKey="config/effect/skill/"..SkillTemplate.m_strSkillAction..".xml"
		end
	end
	--加载技能配置文件
	OnLoadSkillXml(strSkillKey)
end
function LuaCBattleProcessManager.OnLoadSkillXml(strUrl)
	local xmlData
	local strType=CFileManager.loadXMLData(strUrl)
	if (xmlData==nil) then
		return 
	end
	--				var content:String="%U5E73%U53F0%U767B%U9646%U5931%U8D25%UFF0C%U9519%U8BEF%U7801%20"+e.type+"%2C%U662F%U5426%U91CD%U65B0%U767B%U9646%UFF1F";0
	strType=xmlData.effect_type
	if (strType=="scene") then
		m_strNextSkillEffect=xmlData.next_effect
		ProessSceneSkillEffect(strUrl)
	else
		ProessRoleSkillEffect(strUrl)
	end
end
function LuaCBattleProcessManager.ProessSceneSkillEffect(strSkill)
	local Pos
	local Npc
	local nDir=0
	if (strSkill=="") then
		return 
	end
	--计算特效位置
	--查看是否有攻击目标
	Npc=nil
	if (String(m_arrAttackeder).length>0) then
		Npc=m_arrAttackeder[0]["role"]
	elseif (String(m_arrBuffer).length>0) then
		--没有攻击目标，判断是否有buff目标
		Npc=m_arrBuffer[0]["role"]
	end
	--目标为空，则退出
	if (Npc==nil) then
		return 
	end
	if (this.m_BattleMap==nil) then
		return 
	end
	nDir=Npc.mDirection
	if (m_nSceneSkillAttackRange==CTemplateSkill.ATTACKRANGE_ENEMYALL) then
		Pos=this.m_BattleMap.GetRoleArrayCentre(Npc.x,Npc.y)
	elseif (m_nSceneSkillAttackRange==CTemplateSkill.ATTACKRANGE_ENEMYLINE) then
		Pos=this.m_BattleMap.GetRoleArrayLineCentre(Npc.x,Npc.y)
	elseif (m_nSceneSkillAttackRange==CTemplateSkill.ATTACKRANGE_ENEMYROW) then
		Pos=this.m_BattleMap.GetRoleArrayRowCentre(Npc.x,Npc.y)
	end
	if (Pos~=nil) then
		this.m_BattleMap.AddSceneEffect(strSkill,Pos.x,Pos.y,nDir,1,true,OnSceneEffectKeyFrame,OnSceneEffectEnd)
	else
		this.m_BattleMap.AddSceneEffect(strSkill,Npc.x,Npc.y,nDir,1,true,OnSceneEffectKeyFrame,OnSceneEffectEnd)
	end
	m_bSceneSkill=true
end
function LuaCBattleProcessManager.OnSceneEffectKeyFrame()
	local i=0
	local obj
	local Npc
	local nDamgetype=0
	local nCurHP=0
	local arrClearBuff
	local nBuffid=0
	i=0
	while  i<String(m_arrAttackeder).length  do
		obj=m_arrAttackeder[i]
		if (obj==nil) then
			continue
		end
		Npc=obj["role"]
		if (Npc==nil) then
			continue
		end
		nDamgetype=obj["damgetype"]
		ShowDamageTypeEeffct(Npc,nDamgetype)
		nCurHP=obj["curhp"]
		Npc.m_nCurHP=nCurHP
		if (m_nSkillType==CTemplateSkill.SKILL_DAMAGE_TYPE_RECOVER_HP) then
			Npc.ShowSkillBuffEffect(m_strNextSkillEffect,true)
		else
			Npc.ShowAttackedEffect(m_strNextSkillEffect)
		end
		arrClearBuff=obj["ClearBuff"]
		if (arrClearBuff~=nil) then
			for _nBuffid in pairs(arrClearBuff) do
				local nBuffid=arrClearBuff[_nBuffid]
				Npc.ClearBuffEffect(nBuffid)
			end
		end
				i=i+1
	end
end
	--场景特效播放结束
function LuaCBattleProcessManager.OnSceneEffectEnd()
	m_bSceneSkill=false
end
function LuaCBattleProcessManager.ProessRoleSkillEffect(strSkill)
	local obj
	local Npc
	local nDamgetype=0
	local nCurHP=0
	local arrClearBuff
	local nBuffid=0
	--如果有攻击目标
	if (String(m_arrAttackeder).length>0) then
		for _obj in pairs(m_arrAttackeder) do
			local obj=m_arrAttackeder[_obj]
			Npc=obj["role"]
			if (Npc==nil) then
				continue
			end
			nDamgetype=obj["damgetype"]
			ShowDamageTypeEeffct(Npc,nDamgetype)
			nCurHP=obj["curhp"]
			Npc.m_nCurHP=nCurHP
			if (m_nSkillType==CTemplateSkill.SKILL_DAMAGE_TYPE_RECOVER_HP) then
				Npc.ShowSkillBuffEffect(strSkill,true)
			else
				Npc.ShowSkillEffect(strSkill)
			end
			arrClearBuff=obj["ClearBuff"]
			if (arrClearBuff~=nil) then
				for _nBuffid in pairs(arrClearBuff) do
					local nBuffid=arrClearBuff[_nBuffid]
					Npc.ClearBuffEffect(nBuffid)
				end
			end
		end
	end
	if (String(m_arrBuffer).length>0) then
		--没有攻击目标，则判断是否有BUFF目标
	end
		for _obj in pairs(m_arrBuffer) do
			local obj=m_arrBuffer[_obj]
			Npc=obj["role"]
			nCurHP=obj["curhp"]
			Npc.m_nCurHP=nCurHP
			Npc.ShowSkillBuffEffect(strSkill)
		end
	end
end
function LuaCBattleProcessManager.ProessBuffEffect()
	local obj
	local Npc
	local nBuffID=0
	local BuffTemp
	local strSkillimage
	local nCurHP=0
	--buff特效
	for _obj in pairs(m_arrBuffer) do
		local obj=m_arrBuffer[_obj]
		Npc=obj["role"]
		nBuffID=obj["buff"]
		BuffTemp=CDataStatic.SearchTpl(nBuffID)
		if (BuffTemp==nil) then
			continue
		end
		if (BuffTemp.m_sBuffEffect=="") then
			continue
		end
		strSkillimage="config/effect/skill/"..BuffTemp.m_sBuffEffect..".xml"
		Npc.ShowBuffEffect(nBuffID,strSkillimage)
		trace("buff id "..nBuffID.." "..strSkillimage)
		--处理buff加血、吸血特效
		nCurHP=obj["curhp"]
		Npc.m_nCurHP=nCurHP
		if (m_nSkillType==CTemplateSkill.SKILL_DAMAGE_TYPE_NORMAL_STUNT) then
			Npc.ShowSkillBuffEffect("")
		end
	end
end
	--应用宝平台0
function LuaCBattleProcessManager.OnEndAttack(BattleRole)
	this.m_nBattleState=BATTLE_ATTACK_WAIT
end
	--受到攻击开始
function LuaCBattleProcessManager.OnStartBeating(BattleRole)
	if (this.m_Team1Map.containsValue(BattleRole)) then
			--左边阵营
	end
		CUIBattleHead.gUIBatteHead.UpdateCurHP(BattleRole.m_nChangeHP)
		if (BattleRole.m_nCurHP<=0) then
			CUIBattleMemberHead.gUIBattleMemberHead.SetDeadState(BattleRole.m_unEntityID)
		end
	else
		if (CUIBattleHead2.gUIBatteHead2.visible) then
			CUIBattleHead2.gUIBatteHead2.UpdateCurHP(BattleRole.m_nChangeHP)
			if (BattleRole.m_nCurHP<=0) then
				CUIBattleMemberHead2.gUIBattleMemberHead2.SetDeadState(BattleRole.m_unEntityID)
			end
		elseif (CUIBattleBossHead.gUIBattleBossHead.visible) then
			CUIBattleBossHead.gUIBattleBossHead.UpdateCurHP(BattleRole.m_nChangeHP)
		end
	end
end
	--受到攻击结束
function LuaCBattleProcessManager.OnEndBeating(BattleRole)
	local nCounterHP=0
	local Npc
	local nCurHP=0
	if (BattleRole==nil) then
		return 
	end
	if (m_CurBattleDamgeInfo==nil) then
		return 
	end
	if (BattleRole.m_nCurHP<=0) then
		--死亡后没有反击
	end
		return 
	end
	--有反击
	nCounterHP=m_arrAttacker[0]["counter"]
	if (nCounterHP>0) then
		--攻击者成为反击目标
		Npc=m_arrAttacker[0]["role"]
		if (Npc==nil) then
			return 
		end
		nCurHP=Npc.m_nCurHP-nCounterHP
		String(m_arrAttackeder).length=0
		m_arrAttackeder.push({role:Npc,damgetype:0,curhp:nCurHP})
		--被攻击者成为攻击者
		BattleRole.Attack(nil)
		String(m_arrAttacker).length=0
		m_arrAttacker.push({role:BattleRole,skill:0,
			"damgetype":DAMAGE_TYPE_COUNTER_ATTACK,counter:0})
		--没有BUFF效果
		String(m_arrBuffer).length=0
	end
end
	--战斗结束
function LuaCBattleProcessManager.BattleEnd()
	this.m_nBattleState=BATTLE_END
	--应用宝平台0
	if (OnBattleEndCallBack~=nil) then
		OnBattleEndCallBack()
	end
end
	--是否战胜
function LuaCBattleProcessManager.IsBattleWin()
	local isIWin=false
	if (this.m_BattleProcessData.m_nBattlePlayerID1==LuaCHeroProperty.mCharID and this.m_BattleProcessData.m_nBattleWinIndex==0) then
		isIWin=true
	elseif (this.m_BattleProcessData.m_nBattlePlayerID2==LuaCHeroProperty.mCharID and this.m_BattleProcessData.m_nBattleWinIndex==1) then
		isIWin=true
	end
	return  isIWin
end
	--显示伤害类型特效
function LuaCBattleProcessManager.ShowDamageTypeEeffct(player,nDamageType)
	local nX=0
	local nY=0
	if (this.m_BattleMap==nil) then
		return 
	end
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
