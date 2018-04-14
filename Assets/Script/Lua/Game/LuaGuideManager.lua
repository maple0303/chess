--region *.lua
--Date
--此文件由[BabeLua]插件自动生成
LuaGuideManager = { 
	
}
local this = LuaGuideManager
local m_arrTaskGuide = nil;--任务引导配置
local m_arrOpenFunc = nil; --主界面按钮引导配置（功能开启界面弹出时需要在主界面显示引导的功能）
local m_arrFuncGuide = nil;--功能引导配置

local m_arrNeedGuideFunc = {};--当前需要进行引导的功能列表
local m_nCurGuideFuncID = 0; --当前正在引导的功能
local m_nCurGuideUiIndex = 0; --当前正在引导界面索引（一个功能可能需要引导多个界面，该索引表示当前引导的第几个界面）
local m_nCurGuideStep = 0;--当前引导到的步骤
local m_bGuideOpen = false;

function LuaGuideManager.Init()
    local xmlData = LoadXmlData("config/guide");
	if(xmlData ~= nil)
	then
        if(xmlData.Attributes["open"] == "0")
        then
            return;
        end
        m_arrTaskGuide = {};
        m_arrOpenFunc = {};
        m_arrFuncGuide = {};
		for i, xml in ipairs(xmlData.ChildNodes)
		do
            if(xml.Name == "task")
            then
                m_arrTaskGuide.guideType = tonumber(xml.Attributes["Type"]);
                m_arrTaskGuide.autoHide = tonumber(xml.Attributes["autoHide"]);
                m_arrTaskGuide.uiList = {};
                for j, taskData in ipairs(xml.ChildNodes)
                do
                    local prefabName = taskData.Attributes["prefabName"] .. "(Clone)";
                    m_arrTaskGuide.uiList[prefabName] = {componentPath = prefabName .. "/" .. taskData.Attributes["componentPath"], guideDes = taskData.Attributes["guideDes"], arrowAniType = tonumber(taskData.Attributes["arrowAniType"]), arrowX = this.ToUnityPos(taskData.Attributes["arrowX"]), arrowY = this.ToUnityPos(taskData.Attributes["arrowY"]), arrowRotation = tonumber(taskData.Attributes["arrowRotation"]), desX = this.ToUnityPos(taskData.Attributes["desX"]), desY = this.ToUnityPos(taskData.Attributes["desY"]),moveHide = tonumber(taskData.Attributes["moveHide"]) };
                end
            end

            if(xml.Name == "openFunc")
            then
                m_arrOpenFunc.guideType = tonumber(xml.Attributes["Type"]);
                m_arrOpenFunc.autoHide = tonumber(xml.Attributes["autoHide"]);
                m_arrOpenFunc.funcList = {};
                for j, funcData in ipairs(xml.ChildNodes)
                do
                    local funcID = tonumber(funcData.Attributes["funcID"]);
                    m_arrOpenFunc.funcList[funcID] = {componentPath = funcData.Attributes["prefabName"] .. "(Clone)/" .. funcData.Attributes["componentPath"], guideDes = funcData.Attributes["guideDes"], arrowAniType = tonumber(funcData.Attributes["arrowAniType"]), arrowX = this.ToUnityPos(funcData.Attributes["arrowX"]), arrowY = this.ToUnityPos(funcData.Attributes["arrowY"]), arrowRotation = tonumber(funcData.Attributes["arrowRotation"]), desX = this.ToUnityPos(funcData.Attributes["desX"]), desY = this.ToUnityPos(funcData.Attributes["desY"]),moveHide = tonumber(funcData.Attributes["moveHide"]) };
                end
            end

            if(xml.Name == "funcGuide")
            then
                for j, data in ipairs(xml.ChildNodes)
                do
                    local funcData = {};
                    funcData.guideType = tonumber(data.Attributes["Type"]);
                    funcData.autoHide = tonumber(data.Attributes["autoHide"]);
                    funcData.completeStep = tonumber(data.Attributes["completeStep"]);
                    funcData.uiList = {};
                    local funcID = tonumber(data.Attributes["funcID"]);
                    for k, uiData in ipairs(data.ChildNodes)
                    do
                        table.insert(funcData.uiList, {prefabName = uiData.Attributes["prefabName"] .. "(Clone)", componentPath = uiData.Attributes["prefabName"]  .. "(Clone)/" .. uiData.Attributes["componentPath"], guideDes = uiData.Attributes["guideDes"], arrowAniType = tonumber(uiData.Attributes["arrowAniType"]), arrowX = this.ToUnityPos(uiData.Attributes["arrowX"]), arrowY = this.ToUnityPos(uiData.Attributes["arrowY"]), arrowRotation = tonumber(uiData.Attributes["arrowRotation"]), desX = this.ToUnityPos(uiData.Attributes["desX"]), desY = this.ToUnityPos(uiData.Attributes["desY"]),moveHide = tonumber(uiData.Attributes["moveHide"]) });
                    end
                    if(m_arrFuncGuide[funcID] == nil)
                    then
                        m_arrFuncGuide[funcID] = {};
                    end
                    table.insert(m_arrFuncGuide[funcID], funcData);
                    --m_arrFuncGuide[funcID] = funcData;
                end
            end
        end
    end
end
--根据预设名字得到任务引导配置
function LuaGuideManager.GetTaskGuideData(prefabName)
    if(m_arrTaskGuide ~= nil)
    then
        return m_arrTaskGuide.uiList[prefabName];
    end
    return nil;
end
function LuaGuideManager.ToUnityPos(str)
    local num = tonumber(str)
    if(num == nil)
    then
        return 0;
    end
    return num / 100
end
--加入一个需要引导的功能
function LuaGuideManager.AddOneNeedGideFunc(funcID)
    if(m_arrFuncGuide == nil)
    then
        return;
    end
    local guideList = m_arrFuncGuide[funcID];
    if(guideList ~= nil)
    then
        if(m_arrNeedGuideFunc[funcID] == nil)
        then
            m_arrNeedGuideFunc[funcID] = {};
        end
        for i = 1, #guideList
        do
            local guideData = guideList[i];
            if(guideData ~= nil and guideData.uiList ~= nil and #guideData.uiList > 0)
            then
                --记录该功能引导需要打开的界面
                --print(guideData.uiList[1].prefabName)
                table.insert(m_arrNeedGuideFunc[funcID], guideData.uiList[1].prefabName);
            end
        end
    end
end
--移除一个需要引导的功能
function LuaGuideManager.RemoveOneNeedGideFunc(funcID)
    if(m_arrNeedGuideFunc[funcID] ~= nil and #m_arrNeedGuideFunc[funcID] >= m_nCurGuideUiIndex)
    then
        m_arrNeedGuideFunc[funcID][m_nCurGuideUiIndex] = "-1";
    end
end
--界面打开时检查是否有需要引导的功能
function LuaGuideManager.CheckFuncGuide(prefabName)
    m_nCurGuideFuncID = -1;
    m_nCurGuideStep = 0;
    m_nCurGuideUiIndex = 0;
    --print(prefabName)
    for k, data in pairs(m_arrNeedGuideFunc)
    do
        for i = 1, #data
        do
            --print(i, data[i])
            if(data[i] ~= nil and data[i] == prefabName)
            then
                 m_nCurGuideFuncID = k;
                 m_nCurGuideStep = 1;
                 m_nCurGuideUiIndex = i;
            end
        end
    end
    LuaGuideManager.ShowFuncGuide()
end
--显示功能引导
function LuaGuideManager.ShowFuncGuide()
    if(m_arrFuncGuide == nil)
    then
        return;
    end
    --print(m_nCurGuideFuncID, m_nCurGuideUiIndex, m_nCurGuideStep)
    if(m_nCurGuideFuncID ~= -1)
    then
        local guideList = m_arrFuncGuide[m_nCurGuideFuncID];
        if(guideList ~= nil and #guideList >= m_nCurGuideUiIndex)
        then
            local funcData = guideList[m_nCurGuideUiIndex];
            if(funcData ~= nil)
            then
                --print("引导1")
                LuaCUIGuide.ShowUI(funcData.guideType, funcData.autoHide, funcData.uiList[m_nCurGuideStep]);
            end
        end
    end
end
--关闭界面时隐藏功能引导
function LuaGuideManager.HideFuncGuide(prefabName)
    for k, data in pairs(m_arrNeedGuideFunc)
    do
        for i = 1, #data 
        do
            if(data[i] ~= nil and data[i] == prefabName)
            then
               LuaCUIGuide.HideUI();
               m_nCurGuideFuncID = -1;
               m_nCurGuideStep = 0;
               m_nCurGuideUiIndex = 0;
               LuaCPlotManager.TrggerGuidePlot();--引导结束时如果有要触发的剧情
               break;
            end
        end
    end
    LuaGuideManager.ShowTaskGuide();
end
--点击引导之后的处理
function LuaGuideManager.OnClickGuide()
    if(m_arrFuncGuide == nil)
    then
        LuaCUIGuide.HideUI();
        return;
    end
    local guideList = m_arrFuncGuide[m_nCurGuideFuncID];
    if(guideList ~= nil and #guideList >= m_nCurGuideUiIndex)
    then
        local funcData = guideList[m_nCurGuideUiIndex];
        if(funcData ~= nil)
        then
            if(m_nCurGuideStep >= funcData.completeStep)
            then
                this.RemoveOneNeedGideFunc(m_nCurGuideFuncID);
            end

            if(m_nCurGuideStep < #funcData.uiList)
            then
                --这里是布阵引导，需要布阵成功后再进行下一步
                if(m_nCurGuideFuncID == LuaCMainFunctionType.MAIN_FUNCTION_ARRAY)
                then
                    if(LuaCHeroProperty.GetPlayerPartnerOnArray() > 0)
                    then
                        m_nCurGuideStep = m_nCurGuideStep + 1;
                        --print("引导2")
                        LuaCUIGuide.ShowUI(funcData.guideType, funcData.autoHide, funcData.uiList[m_nCurGuideStep]);
                    end
                --这里是心法装备引导，需要装备成功后再进行下一步 （m_nCurGuideUiIndex == 2 代表当前是心法装备界面引导）
                elseif(m_nCurGuideFuncID == LuaCMainFunctionType.MAIN_FUNCTION_HEARTMAGEIC and m_nCurGuideUiIndex == 2)
                then
                    local BagBox = LuaCItemModule.GetItemBox(ITEM_WHERE_WISDOM_EQUIP);
                    if(BagBox ~= nil)
                    then
                        if(BagBox:GetSpaceTotalNum() < BagBox.releaseIndex)
                        then
                            m_nCurGuideStep = m_nCurGuideStep + 1;
                            --print("引导3")
                            LuaCUIGuide.ShowUI(funcData.guideType, funcData.autoHide, funcData.uiList[m_nCurGuideStep]);
                        end
                    end
                else
                    m_nCurGuideStep = m_nCurGuideStep + 1;
                    --print("引导4")
                    LuaCUIGuide.ShowUI(funcData.guideType, funcData.autoHide, funcData.uiList[m_nCurGuideStep]);
                end
            else
                LuaCUIGuide.HideUI();
                LuaCPlotManager.TrggerGuidePlot();
            end
        else
            LuaCUIGuide.HideUI();
        end
    end
    
end
--显示任务引导
function LuaGuideManager.ShowTaskGuide(componentName)
    if(m_arrTaskGuide == nil)
    then
        return;
    end
    --print("显示任务引导")
    --任务引导到华山论剑功能开启
    if(LuaCMainFunction.HasFunction(LuaCMainFunctionType.MAIN_FUNCTION_ARENA))
    then
        LuaCUIGuide.HideUI();
        return;
    end
    local taskConfig = LuaCAutoTraceManager.NextGuideTask();
    if(LuaCUINpcDlg.GetVisible())--任务对话引导
    then
        --print("对话界面任务引导")
        guideData = m_arrTaskGuide.uiList["npcDialog(Clone)"];
        if(guideData ~= nil)
        then
            if(taskConfig ~= nil)
            then
                if(LuaCTaskManager.CanTaskComplete(taskConfig.mTaskID))
                then
                    guideData.guideDes = CLanguageData.GetLanguageText("UI_Guide_Complete_Task")
                elseif(LuaCTaskManager.IsTaskOnProcess(taskConfig.mTaskID))
                then
                    guideData.guideDes = CLanguageData.GetLanguageText("UI_Guide_Do_Task")
                else
                    guideData.guideDes = CLanguageData.GetLanguageText("UI_Guide_Accept_Task")
                end
            end

            if(componentName ~= nil)
            then
                guideData.inScroPath = componentName;
                --print("引导5")
                LuaCUIGuide.ShowUI(m_arrTaskGuide.guideType, m_arrTaskGuide.autoHide, guideData);
            end
        end
    elseif(LuaCUICommonFB.IsShow()) --副本界面引导
    then
        --print("副本界面任务引导")
        guideData = m_arrTaskGuide.uiList["MainFb(Clone)"];
        if(guideData ~= nil)
        then
            if(componentName ~= nil)
            then
                guideData.inScroPath = componentName;
                --print("引导6")
                LuaCUIGuide.ShowUI(m_arrTaskGuide.guideType, m_arrTaskGuide.autoHide, guideData);
            end
        end
    else --主界面任务引导
        --print("显示主界面任务引导")
        guideData = m_arrTaskGuide.uiList["MainUI_topbar(Clone)"];
        if(guideData ~= nil)
        then
            if(taskConfig ~= nil)
            then
                --print("检测1");
                if(LuaCTaskManager.CanTaskComplete(taskConfig.mTaskID))
                then
                    --print("完成");
                    guideData.guideDes = CLanguageData.GetLanguageText("UI_Guide_Complete_Task")
                elseif(LuaCTaskManager.IsTaskOnProcess(taskConfig.mTaskID))
                then
                    --print("继续");
                    guideData.guideDes = CLanguageData.GetLanguageText("UI_Guide_Do_Task")
                else
                    --print("接任务");
                    guideData.guideDes = CLanguageData.GetLanguageText("UI_Guide_Accept_Task")
                end
            end
--            if guideData.guideDes == "" then
--                guideData.guideDes = CLanguageData.GetLanguageText("UI_Guide_Do_Task");
--            end
            --print("引导7".. guideData.guideDes)
            LuaCUIGuide.ShowUI(m_arrTaskGuide.guideType, m_arrTaskGuide.autoHide, guideData, false);
        end
    end
end
--功能开启后主界面功能按钮引导
function LuaGuideManager.ShowOpenFuncGuideInMainUI(funcID)
    if(m_arrOpenFunc == nil)
    then
        return;
    end
    local funcData = m_arrOpenFunc.funcList[funcID];
    if(funcData ~= nil)
    then
        --print("引导8")
        LuaCUIGuide.ShowUI(m_arrOpenFunc.guideType, m_arrOpenFunc.autoHide, funcData);
    end
end
--根据功能id判断功能开启时是否需要在主界面引导功能按钮
function LuaGuideManager.NeedShowOpenFuncGuideInMainUI(funcID)
    if(m_arrOpenFunc == nil)
    then
        return false;
    end
    return m_arrOpenFunc.funcList[tonumber(funcID)] ~= nil;
end
--endregion
