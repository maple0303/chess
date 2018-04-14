local this = LuaCMultiBattlePlayer
LuaCMultiBattlePlayer = 
{ 
	m_nBattleState = 0,		--存储在本地的文件的名字424
}
local m_unBattleCD:uint;				--游戏公告界面20
local m_unBattleTimeTick:uint;			--停止背景音乐播放1
local m_nBattleProcessIndex:int;				--战斗进度索引
local m_CurBattleDamgeInfo = LuaCBattleDamage:new();		--当前的伤害信息
local m_arrAttacker:Array;		--攻击者
local m_arrAttackeder:Array;		--受到攻击者
local m_bSceneSkill=false;		--是否正在场景技能
local m_bWaitAttackEnd=false;				--是否等待攻击结束再进行新攻击
local m_CurSkillAttacker:CBattleSprite;		--当前使用技能攻击者
local m_nSkillType=0;					--在用户中心点击注销按钮发出的消息0
local m_nSceneSkillAttackRange:int;			--场景技能攻击范围
local m_strNextSkillEffect:String;			--场景技能下一个特效
local _playerIndex=0
local m_objBattleProcess
function LuaCMultiBattlePlayer.ctor(playerIndex)
	_playerIndex=playerIndex
	m_arrAttacker={}
	m_arrAttackeder={}
end
function LuaCMultiBattlePlayer.StartBattle()
	local arr
	this.m_unBattleCD=getTimer();	--记录当前时间
	m_unBattleTimeTick=500
	m_bWaitAttackEnd=true
	m_nBattleProcessIndex=0
	String(m_arrAttacker).length=0
	String(m_arrAttackeder).length=0
	arr=LuaCActivityModule.m_arrMultiBattleProcess[_playerIndex]
	m_objBattleProcess=arr.shift()
end
	--战斗流程处理
function LuaCMultiBattlePlayer.BattleProcess()
	local curTimer=0
	local bStart
	local attacker
	local i=0
	local dest
	local arr
	local arrBattleProcess
	local SrcMap
	local DestMap
	local SrcTeamIndex=0
	local DestTeamIndex=0
	local strTips
	local Attacker
	local Dest
	local unDestIndex=0
	local unCamp=0
	local Npc
	local teamIndex=0
	local SkillTemplate
	local Attackeder
	local nAddvalue=0
	--if(this._playerIndex==0)return;
	if (this.m_nBattleState==CBattleManager.BATTLE_END) then
		return 
	end
	curTimer=getTimer()-m_unBattleTimeTick
	if (curTimer<this.m_unBattleCD) then
		--超过间隔
	end
		return 
	end
	if (m_bSceneSkill) then
		return 
	end
	if (m_bWaitAttackEnd) then
		if (this.m_nBattleState~=CBattleManager.BATTLE_ATTACK_WAIT) then
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
	end
	--是否后面还有另外一组怪（没有的话也可能是服务器返回慢，还没发战斗过程）总之要return等着
	if (m_objBattleProcess==nil) then
		arr=LuaCActivityModule.m_arrMultiBattleProcess[_playerIndex]
		if (String(arr).length) then
			m_objBattleProcess=arr.shift()
		else
			return 
		end
	end
	arrBattleProcess=m_objBattleProcess.oneBattle
	m_CurBattleDamgeInfo=arrBattleProcess[m_nBattleProcessIndex]
	if (m_CurBattleDamgeInfo==nil) then
		--/////////////////测试相关/////////////////0
		OnBattleEnd()
		return 
	end
	m_nBattleProcessIndex=m_nBattleProcessIndex+1
	m_unBattleTimeTick=getTimer()
	m_bWaitAttackEnd=true
	this.m_unBattleCD=CMultiBattleManager.BATTLE_TIME_PER;--攻击间隔时间
	--
	SrcMap=nil
	DestMap=nil
	SrcTeamIndex=0
	DestTeamIndex=0
	strTips=""
	if (m_CurBattleDamgeInfo.m_unAttackerIndex==0) then
			--左边阵营
	end
		SrcTeamIndex=m_objBattleProcess.playerIndex
		DestTeamIndex=m_objBattleProcess.ogreIndex+CMultiBattleManager.BATTLE_SIDE_POSNUM
		--strTips=this._playerIndex+"%U5DE6%U8FB9%U653B%U51FB%UFF0C";
		strTips=this._playerIndex+LanguageData.gLanguageData.UI_WEBGAME_004.."，"
	else
		SrcTeamIndex=m_objBattleProcess.ogreIndex+CMultiBattleManager.BATTLE_SIDE_POSNUM
		DestTeamIndex=m_objBattleProcess.playerIndex
		--strTips=this._playerIndex+"%U53F3%U8FB9%U653B%U51FB%UFF0C";
		strTips=this._playerIndex+LanguageData.gLanguageData.UI_WEBGAME_005.."，"
	end
	SrcMap=CMultiBattleManager.gCMultiBattleManager.getTeam(SrcTeamIndex)
	DestMap=CMultiBattleManager.gCMultiBattleManager.getTeam(DestTeamIndex)
	--strTips+="%U653B%U51FB%U8005%U4F4D%U7F6E"+m_CurBattleDamgeInfo.m_unSourceIndex+"%2C";
	strTips=strTips+LanguageData.gLanguageData.UI_WEBGAME_006+m_CurBattleDamgeInfo.m_unSourceIndex..","
	--strTips+="%U4F24%U5BB3%U7C7B%U578B"+m_CurBattleDamgeInfo.m_unDamageType+"%2C";
	strTips=strTips+LanguageData.gLanguageData.UI_WEBGAME_007+m_CurBattleDamgeInfo.m_unDamageType..","
	--strTips+="%U4F7F%U7528%U6280%U80FD"+m_CurBattleDamgeInfo.m_unSkillID+"%2C";
	strTips=strTips+LanguageData.gLanguageData.UI_WEBGAME_008+m_CurBattleDamgeInfo.m_unSkillID..","
	--strTips+="%U53CD%U51FB"+m_CurBattleDamgeInfo.m_nCounterHP;
	strTips=strTips+LanguageData.gLanguageData.UI_WEBGAME_009+m_CurBattleDamgeInfo.m_nCounterHP
	--//////////////////游戏配置/////////////////0
	String(m_arrAttacker).length=0
	Attacker=SrcMap.getValue(m_CurBattleDamgeInfo.m_unSourceIndex)
	if (Attacker==nil) then
		return 
	end
	--找到被攻击玩家列表
	--strTips="%U653B%U51FB%U76EE%U6807";
	strTips=LanguageData.gLanguageData.UI_WEBGAME_010
	String(m_arrAttackeder).length=0
	for _Dest in pairs(m_CurBattleDamgeInfo.m_arrDestInfo) do
		local Dest=m_CurBattleDamgeInfo.m_arrDestInfo[_Dest]
		--高16位，0为对方阵营，1为己方阵营
		--低16位位被攻击者的位置索引
		unDestIndex=Dest.m_unIndex&0x0000ffff
		unCamp=Dest.m_unIndex>>16
		teamIndex=0
		if (unCamp==0) then
			--对方阵营
			Npc=DestMap.getValue(unDestIndex)
			teamIndex=DestTeamIndex
			if (Npc==nil) then
				continue
			end
		else
			--已方阵营
			Npc=SrcMap.getValue(unDestIndex)
			teamIndex=SrcTeamIndex
			if (Npc==nil) then
				continue
			end
		end
		Npc.m_nPower=Dest.m_nCurPower
		m_arrAttackeder.push({role:Npc,teamIndex:teamIndex,memberIndex:Npc.m_unEntityID,damgetype:Dest.m_unDamageType,curhp:Dest.m_nCurHP})
		strTips=strTips+Npc.m_unEntityID..","
	end
	Attacker.m_nPower=m_CurBattleDamgeInfo.m_unPower
	m_arrAttacker.push({role:Attacker,skill:m_CurBattleDamgeInfo.m_unSkillID,
		"damgetype":m_CurBattleDamgeInfo.m_unDamageType,
		"counter":m_CurBattleDamgeInfo.m_nCounterHP})
	if (m_CurBattleDamgeInfo.m_nCounterHP>0) then
		Attacker.m_bParryed=true
	end
	--开始攻击
	if (m_CurBattleDamgeInfo.m_unSkillID>0) then
		this.m_nBattleState=CBattleManager.BATTLE_ATTACK_ING
		SkillTemplate=CDataStatic.SearchTpl(m_CurBattleDamgeInfo.m_unSkillID)
		if (SkillTemplate~=nil) then
			Attacker.SkillAttack()
		end
	elseif (String(m_arrAttackeder).length>1) then
		--如果伤害目标是多个，则远程攻击
	end
		Attacker.Attack(nil);--攻击目标为空，则是群体远程攻击
		this.m_nBattleState=CBattleManager.BATTLE_ATTACK_ING
	elseif (String(m_arrAttackeder).length==1) then
		--//////////////游戏字体///////////////0
	end
		Attackeder=m_arrAttackeder[0]["role"]
		if (Attackeder==nil) then
			this.m_unBattleCD=0
			this.m_nBattleState=CBattleManager.BATTLE_ATTACK_WAIT
			return 
		end
		if (Attackeder==Attacker) then
			--被攻击者是这本身
		end
			nAddvalue=Attacker.m_nCurHP-m_arrAttackeder[0]["curhp"]
			Attacker.m_nCurHP=m_arrAttackeder[0]["curhp"]
			if (nAddvalue>0) then
				--不播放被攻击动画
				--Attacker.OnBeatingKeyFrame();
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
			this.m_nBattleState=CBattleManager.BATTLE_ATTACK_ING
		end
	else
		this.m_unBattleCD=0
		this.m_nBattleState=CBattleManager.BATTLE_ATTACK_WAIT
	end
end
	--开始攻击
function LuaCMultiBattlePlayer.OnStartAttack()
	local Attacker
	local nSkillID=0
	local nDamageType=0
	if (m_CurBattleDamgeInfo==nil or String(m_arrAttacker).length==0) then
		trace("攻击失败1")
		return 
	end
	Attacker=m_arrAttacker[0]["role"]
	if (Attacker==nil) then
		trace("攻击失败2")
		return 
	end
	nSkillID=m_arrAttacker[0]["skill"]
	nDamageType=m_arrAttacker[0]["damgetype"]
	--显示伤害类型特效
	CMultiBattleManager.gCMultiBattleManager.ShowDamageTypeEeffct(Attacker,nDamageType)
	--"%41%72%69%61%6C""%U5B8B%U4F53"0
	ProessSkillEffect(nSkillID)
end
	--处理技能特效
function LuaCMultiBattlePlayer.ProessSkillEffect(nSkillID)
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
function LuaCMultiBattlePlayer.OnLoadSkillXml(strSkillKey)
	local xmlData
	local strType=CFileManager.loadXMLData(strSkillKey)
	if (xmlData==nil) then
		return 
	end
	--判断是场景技能还是角色技能
	strType=xmlData.effect_type
	if (strType=="scene") then
		m_strNextSkillEffect=xmlData.next_effect
		ProessSceneSkillEffect(strSkillKey)
	else
		ProessRoleSkillEffect(strSkillKey)
	end
end
function LuaCMultiBattlePlayer.ProessSceneSkillEffect(strSkill)
	local Npc
	if (strSkill=="") then
		return 
	end
	if (String(m_arrAttackeder).length<=0) then
		return 
	end
	Npc=m_arrAttackeder[0]["role"]
	if (Npc==nil) then
		return 
	end
	CMultiBattleManager.gCMultiBattleManager.ShowSceneSkillEeffct(
		strSkill,m_arrAttackeder[0].teamIndex,m_arrAttackeder[0].memberIndex,
		Npc.mDirection,m_nSceneSkillAttackRange,OnSceneSkillKeyFrameCallBack)
	m_bSceneSkill=true
end
function LuaCMultiBattlePlayer.OnSceneSkillKeyFrameCallBack()
	local i=0
	local obj
	local Npc
	local nDamgetype=0
	m_bSceneSkill=false
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
		CMultiBattleManager.gCMultiBattleManager.ShowDamageTypeEeffct(Npc,nDamgetype)
		Npc.m_nCurHP=obj["curhp"]
		if (m_nSkillType==CTemplateSkill.SKILL_DAMAGE_TYPE_RECOVER_HP) then
			Npc.ShowSkillBuffEffect(m_strNextSkillEffect,true)
		else
			Npc.ShowAttackedEffect(m_strNextSkillEffect)
		end
				i=i+1
	end
end
function LuaCMultiBattlePlayer.ProessRoleSkillEffect(strSkill)
	local i=0
	local obj
	local Npc
	local nDamgetype=0
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
		CMultiBattleManager.gCMultiBattleManager.ShowDamageTypeEeffct(Npc,nDamgetype)
		Npc.m_nCurHP=obj["curhp"]
		if (m_nSkillType==CTemplateSkill.SKILL_DAMAGE_TYPE_RECOVER_HP) then
			Npc.ShowSkillBuffEffect(strSkill,true)
		else
			Npc.ShowSkillEffect(strSkill)
		end
				i=i+1
	end
end
	--结束攻击
function LuaCMultiBattlePlayer.OnEndAttack(BattleRole)
	this.m_nBattleState=CBattleManager.BATTLE_ATTACK_WAIT
end
	--受到攻击结束
function LuaCMultiBattlePlayer.OnEndBeating(BattleRole)
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
		--注册字体0
		BattleRole.Attack(nil)
		String(m_arrAttacker).length=0
		m_arrAttacker.push({role:BattleRole,skill:0,
			"damgetype":DAMAGE_TYPE_COUNTER_ATTACK,counter:0})
	end
end
	--战斗结束回调函数
function LuaCMultiBattlePlayer.OnBattleEnd()
	local mapPlayerTeam
	local npcIndex=0
	local mpc
	local arrProcess
	local objProcess
	local arrkill
	local otherfighting=0
	local i=0
	if (m_objBattleProcess.victoryIndex==0) then
			--赢了
	end
		CMultiBattleManager.gCMultiBattleManager.m_OgreLess=CMultiBattleManager.gCMultiBattleManager.m_OgreLess-1
		CUIBattleOgreNum.gUIBattleOgreNum.UpdateOgreNum(CMultiBattleManager.gCMultiBattleManager.m_OgreLess,String(CMultiBattleManager.gCMultiBattleManager.m_arrMultiOgreID).length)
		CMultiBattleManager.gCMultiBattleManager.m_nWinNum=CMultiBattleManager.gCMultiBattleManager.m_nWinNum+1
		--把怪删了
		CMultiBattleManager.gCMultiBattleManager.setOgreDead(m_objBattleProcess.ogreIndex+CMultiBattleManager.BATTLE_SIDE_POSNUM)
	else
		--可能是总回合数限制到了，所有人隐藏
		mapPlayerTeam=CMultiBattleManager.gCMultiBattleManager.m_arrTeamMap[this._playerIndex]
		npcIndex=0
		while  npcIndex<mapPlayerTeam.size()  do
			mpc=mapPlayerTeam.getValueAtIndex(npcIndex)
			if (mpc.alpha>0) then
				mpc.m_nAttackedState=CBattleSprite.ATTACKED_DISAPPEAR
			end
						npcIndex=npcIndex+1
		end
		--失败计数
		CMultiBattleManager.gCMultiBattleManager.m_nFail=CMultiBattleManager.gCMultiBattleManager.m_nFail+1
		--界面头像变灰
		CUIMultiPlayerHead.gCUIMultiPlayerHead.setGray(this._playerIndex)
		--死了，让别人帮我打
		CMultiBattleManager.gCMultiBattleManager.valueToInit(m_objBattleProcess.ogreIndex+CMultiBattleManager.BATTLE_SIDE_POSNUM)
		CMultiBattleManager.gCMultiBattleManager.helpFight(m_objBattleProcess.ogreIndex,this._playerIndex)
	end
	arrProcess=LuaCActivityModule.m_arrMultiBattleProcess[this._playerIndex]
	if (String(arrProcess).length>0) then
			--还有战斗
	end
		objProcess=arrProcess[0]
		if (objProcess.ogreIndex%3~=this._playerIndex and objProcess.ogreIndex%3~=CMultiBattleManager.gCMultiBattleManager.m_arrWait[_playerIndex]%3) then
				--不是我对面的怪,准备上场
		end
			--更新界面0
			arrkill=CMultiBattleManager.gCMultiBattleManager.m_OgreKillPlayer[objProcess.ogreIndex]
			otherfighting=-1
			if (arrkill~=nil) then
				i=0
				while  i<String(arrkill).length  do
					if (CMultiBattleManager.gCMultiBattleManager.isPlayerAlive(arrkill[i])) then
							--是活着的玩家
					end
						otherfighting=arrkill[i]
						break
					end
										i=i+1
				end
			end
			if (otherfighting~=-1 and otherfighting~=this._playerIndex) then
				--这个怪还在打别人呢，等一等
				--退到休息区
				m_nBattleProcessIndex=0
				m_objBattleProcess=(LuaCActivityModule.m_arrMultiBattleProcess[this._playerIndex]).shift()
				CMultiBattleManager.gCMultiBattleManager.FightToRest(this._playerIndex,objProcess.ogreIndex)
				this.m_nBattleState=CBattleManager.BATTLE_END
				return 
			end
			--上场
			CMultiBattleManager.gCMultiBattleManager.RestToFight(this._playerIndex,objProcess.ogreIndex)
			CMultiBattleManager.gCMultiBattleManager.OgreToFirst(this._playerIndex,objProcess.ogreIndex)
		else	--把这组怪放在对面第一个
			CMultiBattleManager.gCMultiBattleManager.OgreToFirst(this._playerIndex,objProcess.ogreIndex)
		end
		CMultiBattleManager.gCMultiBattleManager.valueToInit(objProcess.ogreIndex)
	else
		if (m_objBattleProcess.victoryIndex==0) then
			--活着则退到休息区
		end
			CMultiBattleManager.gCMultiBattleManager.FightToRest(this._playerIndex,-1)
		end
		this.m_nBattleState=CBattleManager.BATTLE_END
		CMultiBattleManager.gCMultiBattleManager.OnBattleEnd()
	end
	m_nBattleProcessIndex=0
	m_objBattleProcess=(LuaCActivityModule.m_arrMultiBattleProcess[this._playerIndex]).shift()
	CMultiBattleManager.gCMultiBattleManager.valueToInit(this._playerIndex)
end
function LuaCMultiBattlePlayer.CloseBattle()
	String(m_arrAttacker).length=0
	String(m_arrAttackeder).length=0
end
