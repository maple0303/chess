LuaCUIBatTips = {};
local this = LuaCUIBatTips;
local m_gameObject = nil;

local m_imgBg = nil;
local m_listTxt = {};

local SHOW_TIP_MAX_NUM = 5;
local MIN_BG_WIDTH = 320;
local m_nCurIndex = 1;
local m_listStrTips = {};
local m_nFrameDeltaTimer = 0;
local m_Time = 0;

--GameObject初始化时调用
function LuaCUIBatTips.Awake(gameObject)
	if(gameObject == nil) then
		return;
	end
	m_gameObject = gameObject;
end

function LuaCUIBatTips.Start()
    if(m_gameObject ~= nil) 
    then
        m_imgBg = m_gameObject.transform:FindChild("Image").gameObject:GetComponent("Image");
        if(m_imgBg ~= nil)
        then
            local rectTransform = m_imgBg.gameObject:GetComponent("RectTransform");
            if(rectTransform ~= nil)
            then
                rectTransform.sizeDelta = Vector2(rectTransform.sizeDelta.x, 0);
            end
        end
        for i = 0, SHOW_TIP_MAX_NUM - 1 do
            local txt = m_gameObject.transform:FindChild("Panel/content"..i).gameObject:GetComponent("Text");
            if(txt ~= nil)
            then
                txt.gameObject:SetActive(false);
                table.insert(m_listTxt, txt);
            end
        end
    end
end

--显示界面
function LuaCUIBatTips.ShowUI()
    if(m_gameObject == nil) then
        local prefabObj = CAssetManager.GetAsset("Prefabs/UI/Tips/BatTips.prefab");
        if(prefabObj == nil) then
            return;
        end
        m_gameObject = UnityEngine.GameObject.Instantiate(prefabObj);
        if(m_gameObject == nil) then
        	log("创建预设失败: Prefabs/UI/Tips/BatTips");
        	return;
        end
        -- 设置到界面相机下
        local uiCanvas = UnityEngine.GameObject.Find("Canvas");
        if(uiCanvas ~= nil) then
        	m_gameObject.transform:SetParent(uiCanvas.transform, false);
        end
    else
    	
    end
    m_gameObject:SetActive(true);
    m_gameObject.transform:SetAsLastSibling();
    LuaGame.AddPerFrameFunc("LuaCUIBatTips", LuaCUIBatTips.Update);
end
--隐藏界面
function LuaCUIBatTips.HideUI()
    LuaGame.RemovePerFrameFunc("LuaCUIBatTips");
    m_nCurIndex = 1;
    for key, text in pairs(m_listTxt) do
        text.gameObject:SetActive(false);
    end
    m_listStrTips = {};

   if(m_imgBg ~= nil)
    then
        local rectTransform = m_imgBg.gameObject:GetComponent("RectTransform");
        rectTransform.sizeDelta = Vector2(rectTransform.sizeDelta.x, 0);
    end
    m_gameObject:SetActive(false);
end

--设置需要要显示的奖励tips
function LuaCUIBatTips.SetPrizeTips(tipsList, clearWaitInfo)
    if(clearWaitInfo ~= nil and clearWaitInfo == true)
    then
        m_listStrTips = {};
    end
    for key, tips in pairs(tipsList) do
        table.insert(m_listStrTips, tips);
    end
    if(#m_listStrTips > 0)
    then    
        --print("长度",#m_listStrTips)
        if(m_gameObject == nil or m_gameObject.activeSelf == false)
        then
            this.ShowUI();
        end
    end
end

function LuaCUIBatTips.Update()
    
    if(m_nCurIndex > #m_listStrTips)
	then
		--过60帧关闭界面
		m_Time = m_Time + 1;
		if(m_Time > 100)
		then
			m_Time = 0;
			this.HideUI();
		end   
        return;
	end
    --每隔300毫秒再显示下一条信息
    m_nFrameDeltaTimer = m_nFrameDeltaTimer + Time.deltaTime * 1000;
    if (m_nFrameDeltaTimer < 300)
    then
        return;
    end
    m_nFrameDeltaTimer = 0;
    local rectTransform = m_imgBg.gameObject:GetComponent("RectTransform");
    if(rectTransform ~= nil)
    then
        local minWidth = MIN_BG_WIDTH;
        if(m_nCurIndex <= SHOW_TIP_MAX_NUM)
        then
            for i = 1, m_nCurIndex do
                local txt = m_listTxt[i];
                txt.gameObject:SetActive(true);
                local content = m_listStrTips[i];
                txt.text = content;
                if(txt.preferredWidth > minWidth)
                then
                    minWidth = txt.preferredWidth + 10;
                end
            end
            rectTransform.sizeDelta = Vector2(minWidth, 40 * m_nCurIndex);
        else
            for i = 1, SHOW_TIP_MAX_NUM do
                local txt = m_listTxt[i];
                txt.gameObject:SetActive(true);
                local content = m_listStrTips[m_nCurIndex - SHOW_TIP_MAX_NUM + i];
                txt.text = content;
                if(txt.preferredWidth > minWidth)
                then
                    minWidth = txt.preferredWidth + 10;
                end
            end
            rectTransform.sizeDelta = Vector2(minWidth, 40 * SHOW_TIP_MAX_NUM);
        end
    end
    m_nCurIndex = m_nCurIndex + 1;
end