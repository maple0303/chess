local this = LuaCPreBattleTalent
LuaCPreBattleTalent = { 
	gPreBattleTalent:CPreBattleTalent
	m_arrAllReleaseTalent={},	--存储在本地的文件的名字497
	m_arrAllAttack={},			--游戏公告界面98
	m_arrTalentEffect={},		--更新界面9
	m_arrPreBattleAttack={},	--纹理管理类00
	m_preBattleEnd=false,			--pc1
	m_arrPreTalent={},			--存储战前释放天赋角色（一次攻击）
	m_arrPreDestTalent={},		--存储战前受到伤害的角色（一次攻击）
	m_mapEffectBust={},	--存储胸像特效的数组
}
local m_nBuffCompleteCount:int;				--记录buff释放完成的次数对于被释放伙伴，一个伙伴一次
local m_nBuffCount:int;						--记录释放的buff总数，一次出手动作一次
local m_bBuffComplete=false;		--释放天赋完成
function LuaCPreBattleTalent.ctor()
	this.gPreBattleTalent=this
	FrameEventUtility.add(OnFrame)
end
function LuaCPreBattleTalent.OnFrame()
	AttackProcess()
	this.startMoveBust()
	--实时查看是否还有为释放完成的天赋效果
	CheckBuffComplete()
end
	--new update();//0
function LuaCPreBattleTalent.ShowBeforeBattleEffect(team1Map,team2Map)
	local i=0
	local j=0
	local t=0
	local arrKey1
	local arrKey2
	local mpc
	local targetNpc
	local isMyTeam
	local preBattleAttack
	local nRoleNum=0
	local talenttemp=0
	j=0
	t=0
	arrKey1=team1Map.keys()
	arrKey2=team2Map.keys()
	--战斗前是否触发天赋
	preBattleAttack=false
	nRoleNum=0
	if (String(arrKey1).length>String(arrKey2).length) then
		nRoleNum=String(arrKey1).length
	else
		nRoleNum=String(arrKey2).length
	end
	this.m_arrAllReleaseTalent={}
	this.m_arrAllAttack={}
	m_nBuffCount=0
	m_bBuffComplete=false
	i=0
	while  i<nRoleNum  do
		--队伍一
		mpc=team1Map.getValue(arrKey1[i])
		if (mpc~=nil) then
			if (mpc.m_bShowTalent==true) then
				--找到buff影响的角色
				t=0
				while  t<String(mpc.m_arrPreTalent).length  do
					talenttemp=CDataStatic.SearchTpl(mpc.m_arrPreTalent[t])
					if (talenttemp==nil) then
						continue
					end
					--判断天赋类型是不是buff类型
					if (talenttemp.mEffectType==CTemplatePartnerTalent.talentTypeBuff) then
						this.m_arrTalentEffect.push(SortShowTalent(talenttemp.mTempID,team1Map,team2Map,mpc))
						preBattleAttack=true
					else
						continue
					end
										t=t+1
				end
				--释放buff的角色设置
				if (preBattleAttack) then
					mpc.m_bPreBattleAttack=true
					mpc.OnPreStartAttackCallBack=StartBeat
					this.m_arrPreBattleAttack.push(mpc)
					preBattleAttack=false
				end
			end
		end
		--队伍二
		mpc=team2Map.getValue(arrKey2[i])
		if (mpc~=nil) then
			if (mpc.m_bShowTalent==true) then
				t=0
				while  t<String(mpc.m_arrPreTalent).length  do
					talenttemp=CDataStatic.SearchTpl(mpc.m_arrPreTalent[t])
					if (talenttemp==nil) then
						continue
					end
					--判断天赋类型是不是buff类型
					if (talenttemp.mEffectType==CTemplatePartnerTalent.talentTypeBuff) then
						this.m_arrTalentEffect.push(SortShowTalent(talenttemp.mTempID,team2Map,team1Map,mpc))
						preBattleAttack=true
					else
						continue
					end
										t=t+1
				end
				if (preBattleAttack) then
					mpc.m_bPreBattleAttack=true
					mpc.OnPreStartAttackCallBack=StartBeat
					this.m_arrPreBattleAttack.push(mpc)
					preBattleAttack=false
				end
			end
		end
				i=i+1
	end
	this.m_arrAllReleaseTalent=this.m_arrAllReleaseTalent.concat(this.m_arrTalentEffect)
	this.m_arrAllAttack=this.m_arrAllAttack.concat(this.m_arrPreBattleAttack)
	--是否存在战斗前触发天赋的角色
	if (String(this.m_arrPreBattleAttack).length==0) then
		m_bBuffComplete=true
		CBattleManager.gBattleManager.SetStartBattleState()
	end
end
function LuaCPreBattleTalent.AttackProcess()
	local bRelease
	local npc
	local i=0
	local dest
	local preNpc
	local arrDest
	local arrKey
	local MemberTemplate
	if (String(this.m_arrPreBattleAttack).length<=0) then
		return 
	end
	--pc0
	bRelease=true
	--判断胸像是否正在缩放中
	--			if(CBattleManager.gBattleManager.m_TalentEffect!=null)
	--			{
	--				if(CBattleManager.gBattleManager.m_TalentEffect.isPlaying)
	--				{
	--					return;
	--				}
	--			}
	--判断释放天赋是否完成
	if (String(this.m_arrPreTalent).length>0) then
		npc=this.m_arrPreTalent[0]
		if (npc~=nil and npc.m_nAttackState~=CBattleSprite.ATTACK_NONE) then
			bRelease=false
		end
	end
	if (not bRelease) then
		return 
	end
	bRelease=true
	--android/ios0
	i=0
	while  i<String(this.m_arrPreDestTalent).length  do
		dest=this.m_arrPreDestTalent[i]
		if (dest==nil) then
			continue
		end
		if (dest.m_nAttackState~=CBattleSprite.ATTACK_NONE) then
			bRelease=false
			break
		end
		if (not dest.IsAttackedEnd()) then
			bRelease=false
			break
		end
				i=i+1
	end
	if (not bRelease) then
		return 
	end
	this.m_arrPreTalent={}
	this.m_arrPreDestTalent={}
	--找到准备战前释放天赋的角色，并存储起来
	preNpc=this.m_arrPreBattleAttack.shift()
	this.m_arrPreTalent.push(preNpc)
	--找到一次攻击被上buff的角色存储起来
	arrDest=this.m_arrTalentEffect.shift()
	this.m_arrPreDestTalent=arrDest
	--释放天赋的角色虚影开始放大并渐渐消失
	arrKey=this.m_mapEffectBust.keys()
	i=0
	while  i<String(arrKey).length  do
		--找到伙伴模板
		MemberTemplate=CDataStatic.SearchTpl(preNpc.m_nTempID)
		if (MemberTemplate~=nil) then
			--找到准备战前释放天赋的角色的胸像
			if (String((arrKey[i].toString())).indexOf(MemberTemplate.mModelName)~=-1) then
	--						m_mcBust=m_mapEffectBust.getValue(arrKey[i])as MovieClip;
				break
			end
		end
				i=i+1
	end
	--			if(m_mcBust!=null)
	--			{
	--				//清空上一个胸像的swf
	--检测到有新版本时，回调函数0
	--				{
	--					CBattleManager.gBattleManager.m_TalentEffect.bust.removeChildAt(0);
	--				}
	--				//清空上一个天赋名
	--				if(CBattleManager.gBattleManager.m_TalentEffect.talent.numChildren)
	--				{
	--					CBattleManager.gBattleManager.m_TalentEffect.talent.removeChildAt(0);
	--				}
	--				//确定天赋名称
	--等待配置0
	--				var buffID:int=m_arrPreDestTalent[0]["%62%75%66%66"];
	--				var talentID:int=m_arrPreDestTalent[0]["%74%61%6C%65%6E%74%49%44"];
	--				var strUrl:String="%69%6D%61%67%65%73%2F%74%61%6C%65%6E%74%6E%61%6D%65%2F"+talentID+"%2E%70%6E%67";
	--				//确定胸像的显示位置
	--				//左侧
	--				if(preNpc.mDirection==CharacterSprite2.DIRECTION_RIGHT)
	--				{
	--					bustPoint=CBattleManager.gBattleManager.m_BattleMap.GetBustPoint(CharacterSprite2.DIRECTION_LEFT);
	--					CBattleManager.gBattleManager.m_TalentEffect.scaleX=-1;
	--更新的远程服务器地址0
	--					CUIImageManager.gUIImageManager.LoadImageData(null,strUrl,
	--						function(obj:Object):void
	--						{
	--							var NameBit:Bitmap=new Bitmap();
	--							NameBit.bitmapData=obj.bitmapdata;
	--							NameBit.scaleX=-1;
	--							CBattleManager.gBattleManager.m_TalentEffect.talent.addChild(NameBit);
	--							NameBit.x=NameBit.x+NameBit.width+10;
	--							m_mcBust.x=200;
	--版本数据文件0
	--						}
	--					);
	--				}
	--				//右侧
	--				else
	--				{
	--					bustPoint=CBattleManager.gBattleManager.m_BattleMap.GetBustPoint(CharacterSprite2.DIRECTION_RIGHT);
	--					CBattleManager.gBattleManager.m_TalentEffect.scaleX=1;
	--					CBattleManager.gBattleManager.m_TalentEffect.x=bustPoint.x;
	--更新类型：更新打包资源0
	--						function(obj:Object):void
	--						{
	--							var NameBit:Bitmap=new Bitmap();
	--							NameBit.bitmapData=obj.bitmapdata;
	--							CBattleManager.gBattleManager.m_TalentEffect.talent.addChild(NameBit);
	--							m_mcBust.x=200;
	--							m_mcBust.y=105;
	--						}
	--					);
	--更新类型：更新单个资源0
	--				CBattleManager.gBattleManager.m_TalentEffect.y=bustPoint.y;
	--				CBattleManager.gBattleManager.m_TalentEffect.gotoAndStop(1);
	--				CBattleManager.gBattleManager.m_TalentEffect.bust.addChild(m_mcBust);
	--				CBattleManager.gBattleManager.m_TalentEffect.play();
	--			}
end
function LuaCPreBattleTalent.startMoveBust()
	--			if(CBattleManager.gBattleManager.m_TalentEffect==null)
	--			{
	--				return;
	--			}
	--请求服务器列表的URL流00
	--小包的名称1
	--			&&CBattleManager.gBattleManager.m_TalentEffect.bust.numChildren>0)
	--			{
	--				var totalFrame:int=CBattleManager.gBattleManager.m_TalentEffect.totalFrames;
	--				if(CBattleManager.gBattleManager.m_TalentEffect.currentFrame==totalFrame)
	--				{
	--					CBattleManager.gBattleManager.m_TalentEffect.stop();
	--					playMoveEnd();
	--				}
	--界面显示基础像素宽0
end
function LuaCPreBattleTalent.playMoveEnd()
	local preNpc=this.m_arrPreTalent[0]
	if (preNpc~=nil) then
		--开始释放天赋
		preNpc.Attack(nil)
	end
end
	--受到攻击
function LuaCPreBattleTalent.StartBeat()
	--显示buff特效
	ShowBuffEffect()
	Beat()
end
	--被攻击
function LuaCPreBattleTalent.Beat()
	local obj
	local Npc
	local nCurHP=0
	for _obj in pairs(this.m_arrPreDestTalent) do
		local obj=this.m_arrPreDestTalent[_obj]
		--增益buff不显示被攻击动作
		if (obj["isGain"]) then
			continue
		end
		Npc=obj["role"]
		if (Npc~=nil) then
			nCurHP=obj["curhp"]
			Npc.m_nCurHP=nCurHP
			Npc.Beating()
		end
	end
end
	--显示buff特效
function LuaCPreBattleTalent.ShowBuffEffect()
	local obj
	local Npc
	local nBuffID=0
	local BuffTemp
	local strSkillimage
	m_nBuffCount=m_nBuffCount+1
	m_nBuffCompleteCount=0
	for _obj in pairs(this.m_arrPreDestTalent) do
		local obj=this.m_arrPreDestTalent[_obj]
		Npc=obj["role"]
		nBuffID=obj["buff"]
		BuffTemp=CDataStatic.SearchTpl(nBuffID)
		if (BuffTemp==nil) then
			continue
		end
		if (BuffTemp.m_sBuffEffect=="") then
			continue
		end
		m_nBuffCompleteCount=m_nBuffCompleteCount+1
		strSkillimage="config/effect/skill/"..BuffTemp.m_sBuffEffect..".xml"
		Npc.ShowBuffEffect(nBuffID,strSkillimage)
		--处理buff加血、吸血特效
	--				var nCurHP:int=obj["%63%75%72%68%70"];
	--				Npc.m_nCurHP=nCurHP;
	--界面显示的基础像素高0
	--				{
	--					Npc.ShowSkillBuffEffect("");
	--				}
	end
end
function LuaCPreBattleTalent.CheckBuffComplete()
	local arr_DestNpc
	local obj
	local Npc
	local nBuffID=0
	local effect
	local isFlag
	local i=0
	local objBuff
	local nNpcBuffID=0
	local endNpc
	--战前天赋处理完成
	if (String(this.m_arrTalentEffect).length==0) then
		if (m_bBuffComplete==true) then
			return 
		end
		if (String(this.m_arrAllReleaseTalent).length==0) then
			return 
		end
		arr_DestNpc=this.m_arrAllReleaseTalent[String(this.m_arrAllReleaseTalent).length-1]
		if (arr_DestNpc==nil) then
			return 
		end
		if (String(arr_DestNpc).length==0) then
			return 
		end
		if (m_nBuffCount~=String(this.m_arrAllReleaseTalent).length) then
			return 
		end
		--天赋释放次数完成
		if (m_nBuffCompleteCount==String(arr_DestNpc).length) then
			obj=arr_DestNpc[String(arr_DestNpc).length-1]
			if (obj~=nil) then
				--最后一个上buff的角色
				Npc=obj["role"]
				--最后一个上的buffID
				nBuffID=obj["buff"]
				if (Npc~=nil) then
					Npc.m_arrBuffEffect
					effect=CEffectSprite.new
					--是否还存在此buff
					isFlag=false
					i=0
					while  i<String(Npc.m_arrBuffEffect).length  do
						objBuff=Npc.m_arrBuffEffect[i]
						--最后一个角色身上的buff ID
						nNpcBuffID=objBuff["buffid"]
						if (nBuffID==nNpcBuffID) then
							isFlag=true
							effect=objBuff["effect"]
						end
												i=i+1
					end
					if (isFlag) then
						--已更新过的文件0
						if (effect.m_strPlayType==CEffectSprite.PLAY_TYPE_CIRCLE) then
							--判断释放buff的角色是否释放完成
							endNpc=this.m_arrAllAttack[String(this.m_arrAllAttack).length-1]
							if (endNpc~=nil) then
								if (endNpc.m_nAttackState==CBattleSprite.ATTACK_NONE) then
									OnEndBeatingBuff()
								end
							end
						end
					else
						OnEndBeatingBuff()
					end
				end
			end
		end
	end
end
	--战前最后一个受到buff伤害的角色显示结束后的操作
function LuaCPreBattleTalent.OnEndBeatingBuff()
	--在两个队伍的所有buff显示完毕后设置战斗开始状态
	m_nBuffCompleteCount=0
	m_bBuffComplete=true
	CBattleManager.gBattleManager.SetStartBattleState()
end
	--整理要显示天赋特效的角色
function LuaCPreBattleTalent.SortShowTalent(talentID,team1Map,team2Map,mpc)
	local j=0
	local targetNpc
	local arrTalentEffect
	local arrKey1
	local arrKey2
	local talenttemp
	local talentEffect
	local buffID=0
	local tplBuff=0
	--天赋特效数组
	arrTalentEffect={}
	arrKey1=team1Map.keys()
	arrKey2=team2Map.keys()
	talenttemp=CDataStatic.SearchTpl(mpc.m_arrPreTalent[j])
	if (talenttemp==nil) then
		return  arrTalentEffect
	end
	for _talentEffect in pairs(talenttemp.mTalentEffect) do
		local talentEffect=talenttemp.mTalentEffect[_talentEffect]
		--得到buff ID
		buffID=talentEffect.mEffectValue
		tplBuff=CDataStatic.SearchTpl(buffID)
		if (tplBuff~=nil) then
			if (tplBuff.m_nBuffType==BUFF_TYPE.BUFF_INC) then
						--增益buff
			end
				if (talenttemp.mFriendRange==CTemplatePartnerTalent.emTplAttackRange_EnemyAll) then
					continue
				elseif (talenttemp.mFriendRange==CTemplatePartnerTalent.emTplAttackRange_FriendAll) then
					j=0
					while  j<String(arrKey1).length  do
						targetNpc=team1Map.getValue(arrKey1[j])
						if (targetNpc==nil) then
							continue
						end
						arrTalentEffect.push({role:targetNpc,talentID:talentID,buff:buffID,curhp:targetNpc.m_nCurHP,isGain:true})
												j=j+1
					end
				elseif (talenttemp.mFriendRange==CTemplatePartnerTalent.emTplAttackRange_FriendSelf) then
					j=0
					while  j<String(arrKey1).length  do
						targetNpc=team1Map.getValue(arrKey1[j])
						if (targetNpc==nil) then
							continue
						end
						if (mpc==nil) then
							continue
						end
						if (targetNpc.m_nTempID~=mpc.m_nTempID) then
							continue
						end
						arrTalentEffect.push({role:targetNpc,talentID:talentID,buff:buffID,curhp:targetNpc.m_nCurHP,isGain:true})
												j=j+1
					end
				end
			else														--减损buff
				if (talenttemp.mAttactRange==CTemplatePartnerTalent.emTplAttackRange_EnemyAll) then
					j=0
					while  j<String(arrKey2).length  do
						targetNpc=team2Map.getValue(arrKey2[j])
						if (targetNpc==nil) then
							continue
						end
						arrTalentEffect.push({role:targetNpc,talentID:talentID,buff:buffID,curhp:targetNpc.m_nCurHP,isGain:false})
												j=j+1
					end
				elseif (talenttemp.mAttactRange==CTemplatePartnerTalent.emTplAttackRange_FriendAll) then
					continue
				elseif (talenttemp.mAttactRange==CTemplatePartnerTalent.emTplAttackRange_FriendSelf) then
					continue
				end
			end
		end
	end
	return  arrTalentEffect
end
	--战斗前是否触发的天赋
function LuaCPreBattleTalent.CheckPartnerTalent(mapTeam1,mapTeam2)
	local i=0
	local j=0
	local arrKey1
	local arrKey2
	local mpc
	local talenttemp
	local flag
	local isShowBuff=0
	j=0
	arrKey1=mapTeam1.keys()
	arrKey2=mapTeam2.keys()
	flag=false
	isShowBuff=false
	i=0
	while  i<String(arrKey1).length  do
		mpc=mapTeam1.getValue(arrKey1[i])
		if (mpc==nil) then
			continue
		end
		--本地数据0
		j=0
		while  j<String(mpc.m_arrPreTalent).length  do
			talenttemp=CDataStatic.SearchTpl(mpc.m_arrPreTalent[j])
			if (talenttemp==nil) then
				continue
			end
			--确定天赋时战前的天赋
			if (talenttemp.mTalentTriggerTime==CTemplatePartnerTalent.emTalentTriggerTime_StartBattle) then
				mpc.m_bShowTalent=true
				isShowBuff=true
			end
						j=j+1
		end
				i=i+1
	end
	i=0
	while  i<String(arrKey2).length  do
		mpc=mapTeam2.getValue(arrKey2[i])
		if (mpc==nil) then
			continue
		end
		--判断是否存在战前天赋
		j=0
		while  j<String(mpc.m_arrPreTalent).length  do
			talenttemp=CDataStatic.SearchTpl(mpc.m_arrPreTalent[j])
			if (talenttemp==nil) then
				continue
			end
			if (talenttemp.mTalentTriggerTime==CTemplatePartnerTalent.emTalentTriggerTime_StartBattle) then
				mpc.m_bShowTalent=true
				isShowBuff=true
			end
						j=j+1
		end
				i=i+1
	end
	return  isShowBuff
end
	--检查匹配和敌对天赋是否起作用
function LuaCPreBattleTalent.CheckTeamPartner(nPartnerID,mapTeam)
	local arrKey
	local i=0
	local mpc=mapTeam.keys()
	i=0
	if (nPartnerID==0) then
		return  false
	end
	i=0
	while  i<String(arrKey).length  do
		mpc=mapTeam.getValue(arrKey[i])
		if (mpc==nil) then
			continue
		end
		if (mpc.m_nTempID==nPartnerID) then
			return  true
		end
				i=i+1
	end
	return  false
end
function LuaCPreBattleTalent.CheckTeamEnemyPartner(nPartnerID,mapTeam)
	local arrKey
	local i=0
	local j=0
	local mpc
	local enemyData=mapTeam.keys()
	i=0
	j=0
	if (nPartnerID==0) then
		return  false
	end
	i=0
	while  i<String(arrKey).length  do
		mpc=mapTeam.getValue(arrKey[i])
		if (mpc==nil) then
			continue
		end
		j=0
		while  j<String(mpc.m_arrEnemyData).length  do
			enemyData=mpc.m_arrEnemyData[j]
			if (enemyData==nil) then
				continue
			end
			if (enemyData.mPartnerID==nPartnerID) then
				return  true
			end
						j=j+1
		end
				i=i+1
	end
	return  false
end
