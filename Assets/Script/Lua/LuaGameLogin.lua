--region *.lua
--Date
--此文件由[BabeLua]插件自动生成
require "UI/LuaCUILoadingPanel"

LuaGameLogin = 
{
    m_strAccountName = "",      -- 用户名（有渠道则是渠道ID）
    m_strServerIP = "",         -- 服务器IP地址
    m_nServerPort = 0,          -- 服务器端口
    m_nServerID = 0,            -- 服务器ID
    m_nChanelID = 0,            -- 渠道ID
};

function LuaGameLogin.Init()
    --  加载登录场景
    --SceneLoadAsyncOperation = UnityEngine.SceneManagement.SceneManager.LoadSceneAsync("GameLogin");
    --LuaGame.AddPerFrameFunc("LuaGameLogin.OnLoadGameLogin", LuaGameLogin.OnLoadGameLogin);
    LuaGameLogin.ShowLoginUI()
end
function LuaGameLogin.OnLoadGameLogin()
    if(SceneLoadAsyncOperation.isDone) then
        LuaGame.RemovePerFrameFunc("LuaGameLogin.OnLoadGameLogin");

        --  显示登录界面
        LuaGameLogin.ShowLoginUI();
    end
end
-- 显示用户登录界面
function LuaGameLogin.ShowLoginUI()
    -- 判断是否是正式渠道登录，还是测试白包登录
    if(ChannelMgr.IsUseChannelSDK) then
        ChannelMgr.m_OnLoginCallBack = LuaGameLogin.OnChannelLoginCallBack;
        ChannelMgr.Login();
    else
         -- 显示测试登录界面
        LuaCUILoginGame.ShowUI();
    end
end
function LuaGameLogin.OnChannelLoginCallBack(strMsg)
    if(strMsg == "LoginSuccess") then
        LuaGameLogin.m_strAccountName = ChannelMgr.GetUid();
        LuaCUIServerList.ShowUI();
    else
       -- 提示登录失败对话框     
       local strContent = CLanguageData.GetLanguageText("UI_Login_Channel_SDK_failed"); 
       local strBtnOKName = CLanguageData.GetLanguageText("UI_Btn_Name_Retry");   
       local strBtnCannelName = CLanguageData.GetLanguageText("UI_Btn_Name_Quit_Game");                                                          
       LuaCUIConfirm.Show(strContent, LuaGameLogin.ShowLoginUI, function() UnityEngine.Application.Quit() end, "", strBtnOKName, strBtnCannelName);
    end
end
function LuaGameLogin.ShowUIServerList(strAccountName)
    package.loaded["UI.Login.LuaCUILoginGame"] = nil;
    LuaGameLogin.m_strAccountName = strAccountName;
end
function LuaGameLogin.LoginServer(strServerIP, nServerPort, nServerID, nChannelID)
    LuaGameLogin.m_strServerIP = strServerIP;            -- 服务器IP地址
    LuaGameLogin.m_nServerPort = nServerPort;            -- 服务器端口
    LuaGameLogin.m_nServerID = nServerID;                -- 服务器ID
    LuaGameLogin.m_nChanelID = nChannelID;               -- 渠道ID
      
    LuaCLogicManager.ConnectServer(strServerIP, nServerPort);
    -- 显示等待界面
    LuaCUIWait.ShowUI();
end
function LuaGameLogin.OnLoginScene(nRoleID)
    -- 隐藏等待界面
    LuaCUIWait.HideUI();
    LuaCUIServerList.HideUI();
    LuaCCoreModule.m_nLevelType = false;
    if (nRoleID > 0) then
        -- 有角色，开始加载游戏资源，登录游戏
        LuaGameLogin.LoginLoadingStart();
    elseif(nRoleID == 0) then
        -- 没有角色，需要显示创建角色界面
        require "UI/LuaCUICreateCharacter";
        LuaCUICreateCharacter.ShowUI();
    elseif(nRoleID < 0)then
        -- 封号，或者其他异常情况
    end
end
function LuaGameLogin.OnCreateRole()
    LuaCUICreateCharacter.HideUI();
    package.loaded["UI.LuaCUICreateCharacter"] = nil;
    -- 开始加载游戏资源，登录游戏
    LuaGameLogin.LoginLoadingStart();
end
-- 开始登录加载
function LuaGameLogin.LoginLoadingStart()
    LuaCUILoadingPanel.ShowUI();
    -- 加载界面管理类
    require "UI/LuaCUIManager";
    -- 加载城镇管理类
    require "Game/LuaCitySceneManager";
end
-- 获得主角数据
function LuaGameLogin.OnYourProDataNotice()
    -- 加载游戏场景
    SceneLoadAsyncOperation = UnityEngine.SceneManagement.SceneManager.LoadSceneAsync(tostring(LuaCMapModule.mCurMapID));
    LuaGame.AddPerFrameFunc("LuaGameLogin.OnLoadSceneing", LuaGameLogin.OnLoadSceneing);
end

function LuaGameLogin.OnLoadSceneing()
    log(tostring(SceneLoadAsyncOperation.progress));
    LuaCUILoadingPanel.updateProgressBar(10 + SceneLoadAsyncOperation.progress * 100 * 0.9);
    if(SceneLoadAsyncOperation.isDone) then
        LuaGame.RemovePerFrameFunc("LuaGameLogin.OnLoadSceneing");
        LuaGameLogin.SceneLoadEnd();
    end
end
-- 加载场景结束
function LuaGameLogin.SceneLoadEnd()
     -- 先清空登录相关资源
    package.loaded["UI.LuaCUIServerList"] = nil;

    -- 根据地图的大小，设置相机移动的范围
    local mapGameObject = UnityEngine.GameObject.Find("citymap");
    if (mapGameObject ~= nil) then
        local bc2d = mapGameObject:GetComponent("BoxCollider2D");
        if (bc2d ~= null) then
            local cameraFollow =  UnityEngine.Camera.main:GetComponent("CCameraFollow");
            if(cameraFollow ~= nil) then
                cameraFollow:SetCameraMoveRcet(bc2d.size.x, bc2d.offset.y - bc2d.size.y * 0.5);
            end
        end
    end

    local LoginBG = UnityEngine.GameObject.Find("GameLoginBg");
    if(LoginBG ~= nil) then
        LoginBG.gameObject:SetActive(false);
    end
    -- 创建主角
    LuaEntityManager.CreateHero();
    -- 创建所有实体
    LuaEntityManager.CreaterAllEntity();
    LuaCUIManager.Init();
    LuaCSceneNameManager.Init();
    LuaCPlotManager.Init();

    LuaCUILoadingPanel.HideUI();
    if(LuaCMapModule.IsInPlotMap()) then
        LuaEntityManager.m_hero.gameObject:SetActive(false);
    end
end
-- 返回到登录界面
function LuaGameLogin.ReturnLogin()
    LuaGameLogin.m_strAccountName = "";      -- 用户名
    LuaGameLogin.m_strServerIP = "";         -- 服务器IP地址
    LuaGameLogin.m_nServerPort = 0;          -- 服务器端口
    LuaGameLogin.m_nServerID = 0;            -- 服务器ID
    LuaGameLogin.m_nChanelID = 0;            -- 渠道ID
    LuaGame.ClearData();
    LuaCUILoadingPanel.HideUI();
    if(UnityEngine.SceneManagement.SceneManager.GetActiveScene().name == "GameLogin") then
        LuaCUIServerList.HideUI();
        LuaCUICreateCharacter.HideUI();
        --  显示登录界面
        LuaGameLogin.ShowLoginUI();
    else
    if (UnityEngine.Camera.main ~= nil) then
        UnityEngine.Camera.main.transform.position = UnityEngine.Vector3.New(0, 0, UnityEngine.Camera.main.transform.position.z);
    end
    SceneLoadAsyncOperation = UnityEngine.SceneManagement.SceneManager.LoadSceneAsync("GameLogin");
    LuaGame.AddPerFrameFunc("LuaGameLogin.OnLoadGameLogin", LuaGameLogin.OnLoadGameLogin);
    end
end
-- 返回到服务器列表界面
function LuaGameLogin.ReturnServerList()
    LuaGame.ClearData();
    -- 判断是还在登录场景中    
    if(UnityEngine.SceneManagement.SceneManager.GetActiveScene().name == "GameLogin") then
        LuaCUILoadingPanel.HideUI();
        LuaCUIServerList.ShowUI();
    else
        require "UI/LuaCUIServerList";
        SceneLoadAsyncOperation = UnityEngine.SceneManagement.SceneManager.LoadSceneAsync("GameLogin");
        LuaGame.AddPerFrameFunc("LuaGameLogin.OnReturnServerList", LuaGameLogin.OnReturnServerList);
       
    end
end
--endregion
