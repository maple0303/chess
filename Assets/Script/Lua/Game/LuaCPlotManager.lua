--region *.lua
--Date
--此文件由[BabeLua]插件自动生成
LuaCPlotManager = {
    m_nTrggerFBPlotID = 0,
    m_nTrggerGuidePlotID = 0,
};
this = LuaCPlotManager;
local m_PlotList = {};
function LuaCPlotManager.Init()
    local plotListConfig = LoadXmlData("config/plot");
	if (plotListConfig == nil) then
		return;
	end
    m_PlotList = {};
    for i, xml in ipairs(plotListConfig.ChildNodes)
    do
        local TaskStatus = {};
		TaskStatus.mTaskID = tonumber(xml.Attributes["ID"]);
		TaskStatus.mAcceptPlotMapId = tonumber(xml.Attributes["AcceptPlotMapId"]);
		TaskStatus.mFBPlotMapId = tonumber(xml.Attributes["FBPlotMapId"]);
        TaskStatus.mGuidePlotMapId = tonumber(xml.Attributes["GuidePlotMapId"]);
        TaskStatus.mNextPlotMapId = tonumber(xml.Attributes["Param1"]);
        TaskStatus.mFBMapID = tonumber(xml.Attributes["MapID"]);
        TaskStatus.mFBIndex = tonumber(xml.Attributes["Index"]);
        TaskStatus.mFBType = tonumber(xml.Attributes["Type"]);
        m_PlotList[TaskStatus.mTaskID] = TaskStatus;
    end
end
--设置目标任务完成后要触发的副本或者引导剧情
function LuaCPlotManager.SetTrggerPlotIDByTaskID(nTaskID)
    if(LuaCTaskManager.GetProcessMainTask() ~= nTaskID) then return end;
    local TaskStatus = m_PlotList[nTaskID];
    if(TaskStatus ~= nil) then
        this.m_nTrggerFBPlotID = TaskStatus.mFBPlotMapId;
        this.m_nTrggerGuidePlotID = TaskStatus.mGuidePlotMapId;
    else
        this.m_nTrggerFBPlotID = 0;
        this.m_nTrggerGuidePlotID = 0;
    end
end
--触发接任务后的剧情
function LuaCPlotManager.TrggerAcceptPlotByTaskID(nTaskID)
    local TaskStatus = m_PlotList[nTaskID];
    if(TaskStatus ~= nil) then
        if(TaskStatus.mAcceptPlotMapId > 0) then
            LuaCTaskModule.SendMessagePlotBeginRequest();
        end
    end
end
--触发副本播放结束后的剧情
function LuaCPlotManager.TrggerFBPlot()
    if(this.m_nTrggerFBPlotID > 0) then
        LuaCTaskModule.SendMessagePlotBeginRequest();
        return true;
    end
    return false;
end
--触发引导结束后的剧情
function LuaCPlotManager.TrggerGuidePlot()
    if(this.m_nTrggerGuidePlotID > 0) then
        LuaCTaskModule.SendMessagePlotBeginRequest();
    end
end
--得到当前剧情结束后后触发的剧情id
function LuaCPlotManager.GetNextPlotID(nTaskID)
    local TaskStatus = m_PlotList[nTaskID];
    if(TaskStatus ~= nil) then
        if(TaskStatus.mNextPlotMapId ~= LuaCMapModule.mCurMapID) then
            return TaskStatus.mNextPlotMapId;
        end
    end
    return 0;
end
function LuaCPlotManager.BeginPlayPlot()
    LuaCUIManager.CloseAllUI();
end
function LuaCPlotManager.EndPlayPlot()
    LuaCTaskModule.SendMessagePoltEndRequest();
    this.m_nTrggerFBPlotID = 0;
    this.m_nTrggerGuidePlotID = 0;
    local TaskStatus = m_PlotList[LuaCTaskManager.GetProcessMainTask()];
    if(TaskStatus ~= nil) then
        if(LuaCMapModule.mCurMapID ~= TaskStatus.mAcceptPlotMapId)then return end;
        if(TaskStatus.mFBType == BATTLE_TYPE_OGRE) then
            LuaCBattleManager.EnterCommonFB(TaskStatus.mFBMapID, TaskStatus.mFBIndex)
        elseif(TaskStatus.mFBType == BATTLE_TYPE_HERO_OGRE) then
            local m_HeroMapXml = LoadXmlData("config/herofb/" .. TaskStatus.mFBMapID);
	        if (m_HeroMapXml == nil) then
		        return;
	        end
	        if (TaskStatus.mFBMapID > LuaCProModule.m_nOpenedHeroMap) then
		        return;
	        end
	        local i = 0;
	        local nFBindex = 0;
            for key, childxml in ipairs(m_HeroMapXml.ChildNodes) do
                if(nFBindex == TaskStatus.mFBIndex) then
                    local gridData = {
                                FBindex = nFBindex,
                                FBOgreID = 0,
                                BattleMapID = 0,
                                nameurl = "",
                            };
                    local ogreXml = nil;--childxml.OgreList[0].Ogre[0];
                    local rewardXml = nil;--childxml.RewardID[0];
		            local strOgrename = "";
                    local strOgreImgName = "";
                    local strNameUrl = "";
                    for key1, childxml1 in ipairs(childxml.ChildNodes) do
                        if(childxml1.Name == "OgreList" and ogreXml == nil) then
                            for key2, childOgreXml in ipairs(childxml1.ChildNodes) do
                                if(childOgreXml.Name == "Ogre") then
                                    ogreXml = childOgreXml;
                                    break;
                                end
                            end
                        elseif(childxml1.Name == "RewardID" and rewardXml == nil) then
                            rewardXml = childxml1;
                        elseif(childxml1.Name == "nameurl") then
                            strNameUrl = childxml1.InnerText;
                        elseif(childxml1.Name == "ogrename") then
                            strOgrename = childxml1.InnerText;
                        elseif(childxml1.Name == "ogreimagename") then
                            strOgreImgName = childxml1.InnerText;
                        end
                    end
                    if(ogreXml ~= nil) then
                        local nOgreID = tonumber(ogreXml.Attributes["id"]);
			            gridData.FBOgreID = nOgreID;
                    end
                    gridData.BattleMapID = childxml.Attributes["mapid"];
		            gridData.nameurl = strNameUrl;
                    --print(TaskStatus.mFBMapID,TaskStatus.mFBIndex,gridData.BattleMapID,gridData.nameurl,gridData.FBOgreID);
                    LuaCBattleManager.EnterHeroFB(TaskStatus.mFBMapID,TaskStatus.mFBIndex,gridData.BattleMapID,gridData.nameurl,gridData.FBOgreID);
                    return;
	            end
		        nFBindex = nFBindex + 1;
            end
        end
    end
end
function LuaCPlotManager.GetRoleClothesUrl()
    return LuaCHeroProperty:GetRoleClothesUrl();
end
function LuaCPlotManager.GetHeroClothesUrl()
    return LuaCHeroProperty:GetRoleBattleClothesUrl();
end
function LuaCPlotManager.GetHeroBustUrl()
    return LuaCHeroProperty:GetRoleBustUrl();
end
--endregion
