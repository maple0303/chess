--region *.lua
--Date
--此文件由[BabeLua]插件自动生成
require "UI/Login/LuaCUILoginGame";
require "UI/LuaCUIServerList";
require "UI/LuaCUIManager";
--require "UI/LuaCUICreateCharacter";
--require "UI/LuaCUILoadingPanel"
--require "Logic/GameLogic/LuaCLogicManager";

LuaGameLogin = 
{
    m_strAccountName = "",      -- 用户名
    m_unAccountID = 0,          -- 用户ID
    m_strServerIP = "",         -- 服务器IP地址
    m_nServerPort = 0,          -- 服务器端口
    m_nServerID = 0,            -- 服务器ID
    m_nChanelID = 0,            -- 渠道ID
};

function LuaGameLogin.Init()
    -- 初始游戏逻辑模块
    --LuaCLogicManager.Init();
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
        LuaGameLogin.m_strAccountName = ChannelMgr.GetUserName();
        LuaGameLogin.m_unAccountID = ChannelMgr.GetUid();
        LuaCUIServerList.ShowUI();
    else
       -- 提示登录失败对话框     
    end
end
function LuaGameLogin.ShowUIServerList(strAccountName)
    LuaGameLogin.m_strAccountName = strAccountName;
    LuaGameLogin.m_unAccountID = 0;
    LuaCUIServerList.ShowUI();
end
function LuaGameLogin.LoginServer(strServerIP, nServerPort, nServerID, nChannelID)
    LuaGameLogin.m_strServerIP = strServerIP;            -- 服务器IP地址
    LuaGameLogin.m_nServerPort = nServerPort;            -- 服务器端口
    LuaGameLogin.m_nServerID = nServerID;                -- 服务器ID
    LuaGameLogin.m_nChanelID = nChannelID;               -- 渠道ID
      
    LuaCLogicManager.ConnectServer(strServerIP, nServerPort);
    --临时添加没有服务器时
    LuaGameLogin.OnLoginScene(1);
end
function LuaGameLogin.OnLoginScene(nRoleID)
    LuaCUIServerList.HideUI(); 
    if(nRoleID > 0) then
        --有角色，开始加载游戏资源，登录游戏
        LuaGameLogin.LoginLoadingStart();
    elseif(nRoleID == 0) then
        -- 没有角色，需要显示创建角色界面
        LuaCUICreateCharacter.ShowUI();
    elseif(nRoleID < 0)then
        -- 封号，或者其他异常情况
    end
end
function LuaGameLogin.OnCreateRole()
    LuaCUICreateCharacter.HideUI();
    -- 开始加载游戏资源，登录游戏
    LuaGameLogin.LoginLoadingStart();
end
-- 开始登录加载
function LuaGameLogin.LoginLoadingStart()
    LuaCUILoadingPanel.ShowUI();
    -- 加载实体管理类
    require "Entity/LuaEntityManager";
    -- 加载城镇管理类
    require "Game/LuaCitySceneManager";
    -- 初始化战斗模块
    require "Game/LuaCBattleManager";
    require "Game/LuaCBattleProcessManager";
    -- 加载地图名称
    require "UI/LuaCSceneNameManager";
    --加载剧情管理类
    require "Game/LuaCPlotManager";
    -- 向服务器发送登录游戏的消息
    LuaCCoreModule.SendEnterGameRequest();
    --临时添加没有服务器
    LuaGameLogin.OnYourProDataNotice()
end
-- 获得主角数据
function LuaGameLogin.OnYourProDataNotice()
    -- 收到主角信息，进度完成10%
    LuaCUILoadingPanel.updateProgressBar(10);
    -- 加载登录场景
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

    -- LuaCUIManager.Init();
    --LuaEntityManager.OnInit();
    --LuaCUILoadIng.HideUI();
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
--endregion
