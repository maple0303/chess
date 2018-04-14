
LuaCUIServerList = {};
local m_gameObject = nil;

local EmServerMarkType = 
{
    emServerMarkType_New = 11,--新服
    emServerMarkType_Unblocked = 12,--畅通
    emServerMarkType_WillOpen = 17,--准备中
    emServerMarkType_Maintain = 14,--维护
    emServerMarkType_Commend = 15,--推荐
    emServerMarkType_Blocked = 13--拥挤
};
--服务器状态:正常
local SERVER_TYPE_NORMAL = 2;
local m_nPerGroupServerNum = 10;--每一组显示的服务器的个数
local m_arrServerList = {};	        --存储服务器列表信息
local m_arrLoginServerList = {};	--存储曾经登录过服务器列表信息
local m_arrNewServerList = {};	    --存储新服务器列表信息
local m_objSelectData = nil;--当前选择的服务器信息
local m_nSetlectGrroup = 1;--当前选择的服务器组
--http状态
local m_nHttpStatus = 200;
local mUrlStream;

local serverContainer = nil;

-- GameObject初始化时调用
function LuaCUIServerList.Awake(gameObject)
    if (gameObject == nil) then
        return;
    end
    m_gameObject = gameObject;
end
function LuaCUIServerList.Start()
    if (m_gameObject == nil) then
        return;
    end
    local btn = nil;
    local btnComponent = nil;
    --进入游戏按钮
    btn = m_gameObject.transform:FindChild("enterGame/enter");
    if(btn ~= nil) then
        btnComponent = btn.gameObject:GetComponent("Button");
        if (btnComponent ~= nil) then
            btnComponent.onClick:AddListener(function() LuaCUIServerList.OnLoginIn() end);
        end
    end
    --切换服务器
    btn = m_gameObject.transform:FindChild("enterGame/curServer");
    if(btn ~= nil) then
        btnComponent = btn.gameObject:GetComponent("Button");
        if (btnComponent ~= nil) then
            btnComponent.onClick:AddListener(function() LuaCUIServerList.OnChangeServer() end);
        end
    end

    --切换账号
    btn = m_gameObject.transform:FindChild("enterGame/changeCount");
    if(btn ~= nil) then
        btnComponent = btn.gameObject:GetComponent("Button");
        if (btnComponent ~= nil) then
            btnComponent.onClick:AddListener(function() LuaCUIServerList.OnChangeAccount() end);
        end
    end

    --关闭服务器列表
    btn = m_gameObject.transform:FindChild("seleceServer/closebtn");
    if(btn ~= nil) then
        btnComponent = btn.gameObject:GetComponent("Button");
        if (btnComponent ~= nil) then
            btnComponent.onClick:AddListener(function() LuaCUIServerList.OnCloseServerList() end);
        end
    end
    LuaCUIServerList.LoadServerList();
end
-- 显示界面
function LuaCUIServerList.ShowUI()
    if (m_gameObject == nil) then
        local prefabObj = CAssetManager.GetAsset("Prefabs/UI/serverList/UIServerList.prefab");
        if(prefabObj == nil) then
            return;
        end
        m_gameObject = UnityEngine.GameObject.Instantiate(prefabObj);
        if (m_gameObject == nil) then
            log("创建预设失败: Prefabs/UI/serverList/UIServerList");
            return;
        end
        -- 设置到界面相机下
        local uiCanvas = UnityEngine.GameObject.Find("Canvas");
        if (uiCanvas ~= nil) then
            m_gameObject.transform:SetParent(uiCanvas.transform, false);
        end
    else
        -- 更新界面所有数据
        LuaCUIServerList.LoadServerList();
    end
   
    m_gameObject:SetActive(true);
    m_gameObject.transform:SetAsLastSibling();
end
--隐藏界面
function LuaCUIServerList.HideUI()
    if(m_gameObject == nil) then
       return;
    end
    m_gameObject:SetActive(false);
end
--  加载服务器列表
function LuaCUIServerList.LoadServerList()
    -- 正式包需要向服务器请求服务器列表
    if(ChannelMgr.IsUseChannelSDK) then
        coroutine.start(LuaCUIServerList.ReqeusetServerList);
    else
        -- 测试包则直接读取本地测试文件
        local xmlData = LoadXmlData("config/isTest");
        LuaCUIServerList.UpdateData(xmlData);
    end
end
-- 请求服务器列表
function LuaCUIServerList.ReqeusetServerList()
    local strrequestUrl = "http://" .. LuaCGameConfig.centerServerUrl .. "/serverlist_configs/serverlist_" .. ChannelMgr.GetChannel() .. ".xml";
    local www = UnityEngine.WWW(strrequestUrl);
    coroutine.www(www);
    if(www.error == nil) then
        -- 下载服务器列表成功
        local xmlData = LoadXmlDataForText(www.text);
        LuaCUIServerList.UpdateData(xmlData);
    else
        log("error " .. tostring(www.error));
    end
end
--刷新界面
function LuaCUIServerList.UpdateData(xmlData)      
    m_arrServerList = {};
    m_arrLoginServerList = {};
    m_arrNewServerList = {};

    if(xmlData ~= nil and xmlData ~= "") then
        if(xmlData.Attributes["serverNum"] ~= nil) then
            m_nPerGroupServerNum = tonumber(xmlData.Attributes["serverNum"]);
        end
        for i = 1, #xmlData.ChildNodes do
            local data = { };
            data.name = tostring(xmlData.ChildNodes[i].Attributes["name"] or "");
            data.id = tonumber(xmlData.ChildNodes[i].Attributes["id"] or 0);
            data.ip = tostring(xmlData.ChildNodes[i].Attributes["ip"] or "");
            data.port = tostring(xmlData.ChildNodes[i].Attributes["port"] or "");
            data.channel = tonumber(xmlData.ChildNodes[i].Attributes["channel"] or 0);
            data.status = tonumber(xmlData.ChildNodes[i].Attributes["status"] or 0);
            data.mark = tonumber(xmlData.ChildNodes[i].Attributes["mark"] or 0);
            data.world = tonumber(xmlData.ChildNodes[i].Attributes["world"] or 0);
            data.placard = tostring(xmlData.ChildNodes[i].Attributes["placard"] or "");
            data.index = i;
            local nLv = LuaLocalDataStorage.GetLocalPlayerLevel(LuaGameLogin.m_strAccountName, data.id, data.ip);
            data.lv = nLv;
            table.insert(m_arrServerList, data);
        end
    end    
   
	local serverData = {};
	for i = 1, #m_arrServerList do	
		serverData = m_arrServerList[i];
		if(serverData.mark == EmServerMarkType.emServerMarkType_New) then
			table.insert(m_arrNewServerList,serverData);
        end

        --该服记录的等级大于0代表登录过
        local nLevel = LuaLocalDataStorage.GetLocalPlayerLevel(LuaGameLogin.m_strAccountName, serverData.id, serverData.ip);
        if(nLevel > 0) then
            serverData.time = LuaLocalDataStorage.GetLocalPlayerLevelTime(LuaGameLogin.m_strAccountName, serverData.id, serverData.ip);
            table.insert(m_arrLoginServerList,serverData);
        end
    end	

   -- 对登录过的服务器列表进行排序;
    table.sort(m_arrLoginServerList, LuaCUIServerList.SortSeverList);
    --登陆过的玩家(老玩家)默认选择最近登录的服务器
    if(#m_arrLoginServerList > 0) then	
		m_objSelectData = m_arrLoginServerList[1];
	end
			
	if(m_objSelectData == nil)	then --新玩家
		--新玩家默认随机选择一个推荐服
		if(#m_arrNewServerList > 0) then
			local svIdx = math.random(1,#m_arrNewServerList);
			m_objSelectData = m_arrNewServerList[svIdx];
		else
			--如果后台没有配推荐服，则默认选择服务器列表第一个
			m_objSelectData = m_arrServerList[#m_arrServerList];
		end
	end
    --设置默认选择服务器
    if(m_objSelectData ~= nil) then
        m_nSetlectGrroup = math.floor((m_objSelectData.index - 1) / m_nPerGroupServerNum) + 1;
        LuaCUIServerList.OnSelectServer(m_objSelectData);
    end
    --刷新左侧服务器列表
    LuaCUIServerList.UpdateLeftPanel();
end
function LuaCUIServerList.SortSeverList(a, b)
    local aTime = a.time;
    local bTime = b.time
    if(aTime ~= bTime)
    then
        return aTime > bTime
    end
    return false;
end
--刷新左侧服务器列表
function LuaCUIServerList.UpdateLeftPanel()
    if(m_gameObject == nil) then
       return;
    end
     local toggleContainer = m_gameObject.transform:FindChild("seleceServer/leftScro/Viewport/Content");
    if(toggleContainer == nil)
    then
        return;
    end
    local toggleGroup = toggleContainer.gameObject:GetComponent("ToggleGroup");
    if(toggleGroup == null)
    then
        return;
    end
    --服务器的组数（每组显示 m_nPerGroupServerNum 个）
    local leng = math.floor(#m_arrServerList / m_nPerGroupServerNum) + 1;
    local index = 1;
    --如果之前登录过服务器，则增加一组我的服务器列表,显示在最前面
    if(#m_arrLoginServerList > 0)
    then
        index = 0;
    end
    local toggle
    local toggleObj = nil;
    local toggleComponent = nil;
    for i = leng, index, -1 do
        toggle = toggleContainer.transform:FindChild("toggle"..i);
        if(toggle ~= nil)
        then
            toggleObj = toggle.gameObject;
            toggleComponent = toggleObj:GetComponent("Toggle");
        else  
            local prefabObj = CAssetManager.GetAsset("Prefabs/UI/serverList/serverToggle.prefab");
            if(prefabObj == nil) then
                return;
            end
            toggleObj = UnityEngine.GameObject.Instantiate(prefabObj);
            toggleObj.name = ("toggle"..i);
            toggleComponent = toggleObj:GetComponent("Toggle");
            if(toggleComponent ~= nil)
            then
                toggleComponent.group = toggleGroup;
		        toggleComponent.onValueChanged:AddListener(function() LuaCUIServerList.OnTouchServerToggle(i) end);
            end
            toggleObj.transform:SetParent(toggleContainer.transform, false);
            toggleObj.transform.localScale = Vector3.one;
        end
        if(i == m_nSetlectGrroup)
        then
            toggleComponent.isOn = true;
        end
        local component = nil;
        --名字
        local toggleTxt = toggleObj.transform:FindChild("Background/Text");
        if(toggleTxt ~= nil)
        then
            component = toggleTxt:GetComponent("Text")
            if(component ~= nil)
            then
                component.text = LuaCUIServerList.GetServerGroupName(i);
            end
        end
        local toggleTxt = toggleObj.transform:FindChild("Checkmark/Text");
        if(toggleTxt ~= nil)
        then
            component = toggleTxt:GetComponent("Text")
            if(component ~= nil)
            then
                component.text = LuaCUIServerList.GetServerGroupName(i);
            end
        end
        --新服标识
        local newImg = toggleObj.transform:FindChild("newServer");
        if(newImg ~= nil)
        then
            newImg.gameObject:SetActive(LuaCUIServerList.IsHaveNewServer(i));
        end
    end
end
--得到该组需要显示的服务器名称
function LuaCUIServerList.GetServerGroupName(index)
    if(index == 0)
    then
        return CLanguageData.GetLanguageText("UI_ServerList_My_Server")
    else
        local first = (index - 1) * m_nPerGroupServerNum + 1;
        local last = index * m_nPerGroupServerNum;
        if(last > #m_arrServerList)
        then
            last = (index - 1) * m_nPerGroupServerNum + math.floor(#m_arrServerList % m_nPerGroupServerNum);
        end
        local str = string.format(CLanguageData.GetLanguageText("UI_ServerList_Server_Group_Name"),LuaCUIServerList.GetServerIdStr(first),LuaCUIServerList.GetServerIdStr(last));
        return str;
    end
end
--得到组对应的服务器列表
function LuaCUIServerList.GetGroupServerList(index)
    local serverList = {};
    if(index == 0)
    then
        serverList = m_arrLoginServerList;
    else
        local first = (index - 1) * m_nPerGroupServerNum + 1;
        local last = index * m_nPerGroupServerNum;
        if(last > #m_arrServerList)
        then
            last = (index - 1) * m_nPerGroupServerNum + math.floor(#m_arrServerList % m_nPerGroupServerNum);
        end
        for i = 1, (last - first + 1) do
            table.insert(serverList, m_arrServerList[i]);
        end
    end
    return serverList;
end
--得到该组是否有新服
function LuaCUIServerList.IsHaveNewServer(index)
    local arr = nil;
    local serverData = nil;
    if(index == 0)
    then
        for i = 1, #m_arrNewServerList do
            serverData = m_arrNewServerList[i];
            if(serverData.mark == EmServerMarkType.emServerMarkType_New)
            then
                return true;
            end
        end
    else
        local first = (index - 1) * m_nPerGroupServerNum + 1;
        local last = index * m_nPerGroupServerNum;
        if(last > #m_arrServerList)
        then
            last = (index - 1) * m_nPerGroupServerNum + math.floor(#m_arrServerList / m_nPerGroupServerNum);
        end
        for i = first, last do
            serverData = m_arrServerList[i];
            if(serverData.mark == EmServerMarkType.emServerMarkType_New)
            then
                return true;
            end
        end
    end
    return false;
end
--刷新当前选择的组的服务器列表（右侧服务器列表）
function LuaCUIServerList.OnTouchServerToggle(group)
    if(m_gameObject == nil) then
       return;
    end
    local serverContainer = m_gameObject.transform:FindChild("seleceServer/rightScro/Viewport/Content");
    if(serverContainer == nil)
    then
        return;
    end
    m_nSetlectGrroup = group;
    local serverList = LuaCUIServerList.GetGroupServerList(group);
    local server = nil;
    local serverObj = nil;
    local btnComponent = nil;
    local serverData = nil;
    for i = 1, m_nPerGroupServerNum do
        server = serverContainer.transform:FindChild("server"..i);
        if(server ~= nil)
        then
            serverObj = server.gameObject;
            btnComponent = serverObj:GetComponent("Button");
        else  
            local prefabObj = CAssetManager.GetAsset("Prefabs/UI/serverList/oneServer.prefab");
            if(prefabObj == nil) then
                return;
            end
            serverObj = UnityEngine.GameObject.Instantiate(prefabObj);
            serverObj.name = ("server"..i);
            btnComponent = serverObj:GetComponent("Button");
            if(btnComponent ~= nil)
            then
		        btnComponent.onClick:AddListener(function() LuaCUIServerList.OnTouchServer(i) end);
            end
            serverObj.transform:SetParent(serverContainer.transform, false);
            serverObj.transform.localScale = Vector3.one;
        end
        if(i <= #serverList)
        then
            serverObj:SetActive(true);
            serverData = serverList[i];
            local component = nil;
            --名字
            local serverTxt = serverObj.transform:FindChild("Text");
            if(serverTxt ~= nil)
            then
                component = serverTxt:GetComponent("Text")
                if(component ~= nil)
                then
                    component.text = LuaCUIServerList.GetShowName(serverData);
                end
            end
            --新服标识
            local newImg = serverObj.transform:FindChild("newServer");
            if(newImg ~= nil)
            then
                newImg.gameObject:SetActive(serverData.mark == EmServerMarkType.emServerMarkType_New);
            end

            --状态标识
            local stateImg = serverObj.transform:FindChild("state");
            if(stateImg ~= nil)
            then
                local imgComponent = stateImg.gameObject:GetComponent("Image");
                if(imgComponent ~= nil)
                then
                     local texture2d = CAssetManager.GetAssetSprite(LuaCUIServerList.GetMarkTexture(serverData.mark) , "Textures/ui/serverList.png");
                    if(texture2d ~= nil)
                    then
			            imgComponent.sprite = texture2d;
                    end
                end
            end
        else
            serverObj:SetActive(false);
        end
    end
end
--点击选择服务器
function LuaCUIServerList.OnTouchServer(index)
    local serverList = LuaCUIServerList.GetGroupServerList(m_nSetlectGrroup);
    if(#serverList >= index)
    then 
        local serverData = serverList[index];
        LuaCUIServerList.OnSelectServer(serverData);
    end
end
--玩家等级改变，更新本地数据
function LuaCUIServerList.UpdateUserLvData(lv)
	LuaLocalDataStorage.SetLocalPlayerLevel(LuaGameLogin.m_strAccountName, LuaGameLogin.m_nServerID, LuaGameLogin.m_strServerIP, lv);
end
--保存登陆本地数据,id + "_" + ip
function LuaCUIServerList.GetSaveObject(id,ip)
	return {id = id,ip = ip};
end
--根据服务器状态，获取对应状态标识的图片材质
function LuaCUIServerList.GetMarkTexture(nMark)
	local m = LuaCUIServerList.GetShowMark(nMark);
	local strUrl = "";
	if(m == EmServerMarkType.emServerMarkType_Commend or m == EmServerMarkType.emServerMarkType_WillOpen 
        or m == EmServerMarkType.emServerMarkType_New) then
		strUrl = "state_" .. EmServerMarkType.emServerMarkType_Commend;
	elseif(m == EmServerMarkType.emServerMarkType_Unblocked) then
		strUrl = "state_" .. EmServerMarkType.emServerMarkType_Unblocked;
	elseif(m == EmServerMarkType.emServerMarkType_Maintain) then
		strUrl = "state_" .. EmServerMarkType.emServerMarkType_Maintain;
	else
		strUrl = "state_" .. EmServerMarkType.emServerMarkType_Unblocked;
	end
	return strUrl;
end
		
--获取服务器ID字符串
function LuaCUIServerList.GetTxtColor(mark)
	local m = LuaCUIServerList.GetShowMark(mark);
	if(m == EmServerMarkType.emServerMarkType_Commend or m == EmServerMarkType.emServerMarkType_New) then	--推荐，新服
		return "#ffea00";
	elseif(m == EmServerMarkType.emServerMarkType_Blocked) then
		return "#ff0000";
	elseif(m == EmServerMarkType.emServerMarkType_Unblocked) then	--流畅
		return "#ffffff";
	elseif(m == EmServerMarkType.emServerMarkType_Maintain)	then --维护
		return "#012334";
	elseif(m == EmServerMarkType.emServerMarkType_WillOpen)	then --准备中
		return "#f6ff00";
	end	

	return "#ffea00";
end
		
--获取服务器ID字符串
function LuaCUIServerList.GetServerIdStr(id)
	local str = tostring(id);
	local len = string.len(str);
	for i = len,2 do
		str = "0" .. str;
	end
	return str;
end
		
--获取需要显示的服务器名称文本内容
function LuaCUIServerList.GetShowName(serverData)
	local str = string.format(CLanguageData.GetLanguageText("UI_ServerList_ServerOrder"), LuaCUIServerList.GetServerIdStr(serverData.index)) .. " " .. serverData.name;
	local lv = tonumber(serverData.lv);
	if(LuaCUIServerList.GetShowMark(serverData.mark) == EmServerMarkType.emServerMarkType_WillOpen) then
		str = str .. CLanguageData.GetLanguageText("UI_ServerList_Ready");
	elseif(lv ~= nil and lv > 0) then
		str = str .. "(" .. string.format(CLanguageData.GetLanguageText("UI_ServerList_UserLevel"),lv) .. ")";
	end
	return "<color=" .. LuaCUIServerList.GetTxtColor(serverData.mark) ..">".. str .."</color>";
end
        
--获取服务器状态
function LuaCUIServerList.GetShowMark(nMark)
	local str = tostring(nMark);
	local arr = {};
	for i = 1, string.len(str) do
	    local num = tonumber(string.sub(str,i,i+2));
        if(num ~= nil) then
		    arr[num] = 1;
        end
	end
	if(arr[EmServerMarkType.emServerMarkType_Maintain] ~= nil) 
    then
		return EmServerMarkType.emServerMarkType_Maintain;
	elseif(arr[EmServerMarkType.emServerMarkType_Commend] ~= nil) 
    then
		return EmServerMarkType.emServerMarkType_Commend;
	elseif(arr[EmServerMarkType.emServerMarkType_New] ~= nil) 
    then
		return EmServerMarkType.emServerMarkType_New;
	elseif(arr[EmServerMarkType.emServerMarkType_Blocked] ~= nil) 
    then
		return EmServerMarkType.emServerMarkType_Blocked;
	elseif(arr[EmServerMarkType.emServerMarkType_Unblocked] ~= nil) 
    then
		return EmServerMarkType.emServerMarkType_Unblocked;
	elseif(arr[EmServerMarkType.emServerMarkType_WillOpen] ~= nil) 
    then
		return EmServerMarkType.emServerMarkType_WillOpen;
	end
	return 0;
end
--选择服务器
function LuaCUIServerList.OnSelectServer(data)
    local m = LuaCUIServerList.GetShowMark(data.mark);
    if(m == EmServerMarkType.emServerMarkType_Maintain)
    then
        --CLanguageData.GetLanguageText("UI_ServerList_Server_Is_Maintain")
    elseif(m == EmServerMarkType.emServerMarkType_WillOpen)
    then
        --CLanguageData.GetLanguageText("UI_ServerList_Ready")
    else
        m_objSelectData = data;
        LuaCUIServerList.OnCloseServerList();
	    LuaCUIServerList.UpdateSelectServerData(data);
    end
end

--点击登陆按钮
function LuaCUIServerList.OnLoginIn()
    if(m_objSelectData == nil) then
        return;
    end
    LuaGameLogin.LoginServer(m_objSelectData.ip, m_objSelectData.port, m_objSelectData.id, m_objSelectData.channel);
end

--刷新当前选择服的信息
function LuaCUIServerList.UpdateSelectServerData(data)
    if (data == nil) then
        return;
    end
    if(m_gameObject == nil) then
       return;
    end
    local child = m_gameObject.gameObject.transform:FindChild("enterGame/curServer/serverName");
    if (child ~= nil) then
        local txtName = child.gameObject:GetComponent("Text");
        if (txtName ~= nil) then
            txtName.text = LuaCUIServerList.GetServerIdStr(data.index) .. " " .. data.name;
        end
    end
    --状态标识
    local stateImg = m_gameObject.transform:FindChild("enterGame/curServer/state");
    if(stateImg ~= nil)
    then
        local imgComponent = stateImg.gameObject:GetComponent("Image");
        if(imgComponent ~= nil)
        then
            local texture2d = CAssetManager.GetAssetSprite(LuaCUIServerList.GetMarkTexture(data.mark), "Textures/ui/serverList.png");
            if(texture2d ~= nil)
            then
			    imgComponent.sprite = texture2d;
            end
        end
    end
end
--关闭服务器列表
function LuaCUIServerList.OnCloseServerList()
    if (m_gameObject == nil) then
        return;
    end
    local serverList = m_gameObject.transform:FindChild("seleceServer");
    if(serverList ~= nil)
    then
        serverList.gameObject:SetActive(false);
    end
end
--切换账号
function LuaCUIServerList.OnChangeAccount()
    LuaCUIServerList.HideUI();
    LuaCUILoginGame.ShowUI();
end
--切换服务器
function LuaCUIServerList.OnChangeServer()
    if (m_gameObject == nil) then
        return;
    end
    local serverList = m_gameObject.transform:FindChild("seleceServer");
    if(serverList ~= nil)
    then
        serverList.gameObject:SetActive(true);
    end
end

  

