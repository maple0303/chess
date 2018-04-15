LuaCUIFlyTips = {};
local this = LuaCUIFlyTips;
local m_gameObject = nil;
local m_InitPos;

--GameObject初始化时调用
function LuaCUIFlyTips.Awake(gameObject)
	if(gameObject == nil) then
		return;
	end
	m_gameObject = gameObject;
end

function LuaCUIFlyTips.Start()
    if(m_gameObject == nil) then 
		return; 
	end
    m_InitPos = m_gameObject.transform.localPosition;
end

--显示界面
function LuaCUIFlyTips.ShowUI()
    if(m_gameObject == nil) then
        local prefabObj = CAssetManager.GetAsset("Prefabs/UI/Tips/FlyTips.prefab");
        if(prefabObj == nil) then
            return;
        end
        m_gameObject = UnityEngine.GameObject.Instantiate(prefabObj);
        if(m_gameObject == nil) then
        	log("创建预设失败: Prefabs/UI/Tips/FlyTips");
        	return;
        end
        -- 设置到界面相机下
        local uiCanvas = UnityEngine.GameObject.Find("Canvas");
        if (uiCanvas ~= nil) then
            m_gameObject.transform:SetParent(uiCanvas.transform, false);
        end
    else
    	
    end
    m_gameObject:SetActive(true);
    m_gameObject.transform:SetAsLastSibling();
    if(m_InitPos == nil)
    then
        m_InitPos = m_gameObject.transform.localPosition;
    end
    local group = m_gameObject:GetComponent("CanvasGroup");
    if(group ~= nil)
    then
        group.alpha = 1;
    end
    m_gameObject.transform:DOComplete();
    m_gameObject.transform.localPosition = Vector3.New(m_InitPos.x, m_InitPos.y, 0);
    m_gameObject.transform:DOLocalMoveY(m_InitPos.y + 200, 1):OnComplete(this.Complete);
end
function LuaCUIFlyTips.Complete()
    local group = m_gameObject:GetComponent("CanvasGroup");
    if(group ~= nil)
    then
        m_gameObject.transform:DOComplete();
        group.alpha = 1;
        m_gameObject.transform:DOScaleX(1, 2):OnComplete(function() group.alpha = 0 end);
        --group.alpha = 0;
        --DG_Tweening_DOTween.To(DG.Tweening.Core.DOGetter(function () print(222) return group.alpha end),DG.Tweening.Core.DOSetter(function (nAlpha)  print(nAlpha) group.alpha = nAlpha end), 0, 0.1);
    end
end
--隐藏界面
function LuaCUIFlyTips.HideUI()
    if(m_gameObject == nil)
    then
        return;
    end
    m_gameObject:SetActive(false);
    LuaGame.RemovePerFrameFunc("LuaCUIFlyTips");
end

--显示提示内容
function LuaCUIFlyTips.ShowFlyTips(content)
    this.ShowUI();
    local m_nHeight = 0;
    local txt = m_gameObject.transform:FindChild("flyTips1/txt_content")
    if(txt ~= nil)
    then
        local txtContent = txt.gameObject:GetComponent("Text");
        if(txtContent ~= nil)
        then
            txtContent.text = content;
        end
        m_nHeight = txtContent.preferredHeight + 25;
    end
    --背景宽度设定
    local flyTips1 = m_gameObject.transform:FindChild("flyTips1")
    if flyTips1 ~= nil then
        local tipsRect = flyTips1:GetComponent("RectTransform");
        if tipsRect ~= nil then
            tipsRect.sizeDelta = UnityEngine.Vector2.New(tipsRect.rect.width, m_nHeight);
        end    
    end
end

--显示错误码内容
function LuaCUIFlyTips.ShowErrorStr(errorCode)
    this.ShowUI();
    --将错误码由uint转化为int
    local errorCode = errorCode - 2^32;
    local txt = m_gameObject.transform:FindChild("flyTips1/txt_content")
    if(txt ~= nil)
    then
        local txtContent = txt.gameObject:GetComponent("Text");
        if(txtContent ~= nil)
        then
            if(CLanguageData.GetErrorCodeText(errorCode) ~= "")
            then
                txtContent.text = CLanguageData.GetErrorCodeText(errorCode);
            else
                txtContent.text = string.format("%d", errorCode);
            end
        end
    end
end