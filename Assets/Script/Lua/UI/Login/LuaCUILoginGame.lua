LuaCUILoginGame = {
}
local this = LuaCUILoginGame
local m_gameObject = nil
function LuaCUILoginGame.Awake(gameObject)
	if(gameObject == nil) then 
		return 
	end
	m_gameObject = gameObject 
end
function LuaCUILoginGame.Start()
	if(m_gameObject == nil) then 
		return 
	end
	local loginbtn = m_gameObject.transform:FindChild("btn_login")
	if(loginbtn ~= nil) then 
		local loginComponent = loginbtn:GetComponent("Button") 
		if(loginComponent ~= nil) then 
			loginComponent.onClick:AddListener(this.OnClickLoginBtn);
		end
	end
	this.UpdatePanel()
end
function LuaCUILoginGame.OnClickLoginBtn()
	local agreeToggle = m_gameObject.transform:FindChild("toggle_agree");
	if(agreeToggle ~= nil)
	then
		local toggleComponent = agreeToggle:GetComponent("Toggle");
		if(toggleComponent ~= nil)
		then
			if(toggleComponent.isOn)
			then

			else
				LuaCUIFlyTips.ShowFlyTips(CLanguageData.GetLanguageText("UI_Login_Must_Agree"));
			end
		end
	end
end
function LuaCUILoginGame.ShowUI()
	if(m_gameObject == nil) then
        local prefabObj = CAssetManager.GetAsset("Prefabs/UI/UILogin.prefab");
        if(prefabObj == nil) then
            log("创建预设失败: Prefabs/UI/UILogin") 
            return;
        end 
		m_gameObject = UnityEngine.GameObject.Instantiate(prefabObj) 
		if(m_gameObject == nil) then 
			log("创建预设失败: Prefabs/UI/UILogin") 
			return 
		end
		local uiCanvas = UnityEngine.GameObject.Find("Canvas") 
		if(uiCanvas ~= nil) then 
			m_gameObject.transform:SetParent(uiCanvas.transform, false) 
		end
	else
		this.UpdatePanel()
	end
	m_gameObject:SetActive(true)
end
function LuaCUILoginGame.HideUI()
	if(m_gameObject == nil) then 
		return 
	end
	m_gameObject:SetActive(false)
end
function LuaCUILoginGame.UpdatePanel()
    local input = m_gameObject.transform:FindChild("InputField");
    if (input ~= nil) then
        local fieldInput = input:GetComponent("InputField");
        if (fieldInput ~= nil) 
        then
            fieldInput.text = "";
        end    
    end
end

