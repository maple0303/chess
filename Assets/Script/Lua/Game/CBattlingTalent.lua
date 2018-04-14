LuaCBattlingTalent = { 
--	m_talentPoint=Point.new,	--存储在本地的文件的名字148
--	m_curNpcTalent:CBattleSprite,		--登陆界面49
}
local this = LuaCBattlingTalent

	--欧美IOS0
function LuaCBattlingTalent.ShowBattlingTalent(direction,roleIndex,npc)
	local i=0
	local talentID=0
	local tplTalent
	local strUrl
	local rolePoint
	this.m_curNpcTalent=npc
	--清空上一个胸像的swf
	--			if(CBattleManager.gBattleManager.m_TalentEffect.bust.numChildren)
	--			{
	--				CBattleManager.gBattleManager.m_TalentEffect.bust.removeChildAt(0);
	--			}
	--			//清空上一个天赋名
	--			if(CBattleManager.gBattleManager.m_TalentEffect.talent.numChildren)
	--			{
	--				CBattleManager.gBattleManager.m_TalentEffect.talent.removeChildAt(0);
	--				LuaCUIFlyTips.ShowFlyTips("%U641C%U7D22%U670D%U52A1%U5668%U5931%U8D25",500,300);0
	--加载天赋名称图片
	i=0
	talentID=0
	i=0
	while  i<String(this.m_curNpcTalent.m_arrTalent).length  do
		talentID=this.m_curNpcTalent.m_arrTalent[i]
				i=i+1
	end
	tplTalent=CDataStatic.SearchTpl(talentID)
	if (tplTalent==nil) then
		return 
	end
	strUrl="images/talentname/"..talentID..".png"
	--			CUIImageManager.gUIImageManager.LoadImageData(null,strUrl,
	--				function(obj:Object):void
	--				{
	--					var NameBit:Bitmap=new Bitmap();
	--					NameBit.bitmapData=obj.bitmapdata;
	--					NameBit.scaleX=0.8;
	--					NameBit.scaleY=0.8;
	--					NameBit.smoothing=true;
	--成功获取到服务器列表0
	--				}
	--			);
	--角色在阵法中的中心点
	rolePoint=Point.new
	--左侧阵营
	--			if(direction==CharacterSprite2.DIRECTION_LEFT)
	--			{
	--				CBattleManager.gBattleManager.m_TalentEffect.scaleX=1;
	--				rolePoint=CBattleManager.gBattleManager.m_BattleMap.GetLeftPlayerPos(roleIndex);
	--			}
	--搜索服务器失败0
	--			else
	--			{
	--				CBattleManager.gBattleManager.m_TalentEffect.scaleX=1;
	--				rolePoint=CBattleManager.gBattleManager.m_BattleMap.GetRightPlayerPos(roleIndex);
	--			}
	--			if(CBattleManager.gBattleManager.m_TalentEffect.talent.numChildren)
	--			{
	--				var talentName:Bitmap=CBattleManager.gBattleManager.m_TalentEffect.talent.getChildAt(0);
	--				m_talentPoint.y=rolePoint.y+npc.mTextName.y-talentName.height-10;
	--应用宝平台0
	--			else
	--			{
	--				m_talentPoint.y=rolePoint.y-npc.height;
	--			}
	--			m_talentPoint.x=rolePoint.x;
	--			CBattleManager.gBattleManager.m_TalentEffect.x=m_talentPoint.x+50;
	--			CBattleManager.gBattleManager.m_TalentEffect.y=m_talentPoint.y;
	--			//开始播放天赋图片特效
	--			CBattleManager.gBattleManager.m_TalentEffect.gotoAndStop(1);
	--服务器列表界面00
end
function LuaCBattlingTalent.StopTalentNameEffect()
	--欧美IOS1
	--				&&CBattleManager.gBattleManager.m_TalentEffect.bust.numChildren==0)
	--			{
	--				var totalFrame:int=CBattleManager.gBattleManager.m_TalentEffect.totalFrames;
	--				if(CBattleManager.gBattleManager.m_TalentEffect.currentFrame==totalFrame)
	--				{
	--					CBattleManager.gBattleManager.m_TalentEffect.stop();
	--				}
	--				if(m_curNpcTalent!=null)
	--请求服务器列表失败0
	--					if(CBattleManager.gBattleManager.m_TalentEffect.talent.numChildren)
	--					{
	--						var talentName:Bitmap=CBattleManager.gBattleManager.m_TalentEffect.talent.getChildAt(0);
	--						m_talentPoint.y=m_curNpcTalent.y+m_curNpcTalent.mTextName.y-talentName.height-10;
	--					}
	--					else
	--					{
	--						m_talentPoint.y=m_curNpcTalent.y-m_curNpcTalent.height;
	--					}
	--应用宝平台0
	--					CBattleManager.gBattleManager.m_TalentEffect.x=m_talentPoint.x+50;
	--					CBattleManager.gBattleManager.m_TalentEffect.y=m_talentPoint.y;
	--				}
	--			}
end
