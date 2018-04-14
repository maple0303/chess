require "Utils/LuaFunction";
require "UI/Login/LuaCUILoginGame";
--require "Common/LuaDefine";
--require "Utils/LuaDataStatic";
require "Utils/LuaCommonMethod";
require "LuaGameLogin";
--require "UI/Tips/LuaCUIFlyTips";
--require "UI/confirm/LuaCUIConfirm";
--require "Logic/CoreModule/LuaCCoreModule";
require "Utils/LuaLocalDataStorage";
require "Utils/LuaTimeFormat";
require "Game/LuaCGameConfig";

luabit = require"bit";

SceneLoadAsyncOperation = UnityEngine.AsyncOperation.New();

LuaGame = {};

local m_arrPerFrameFunc = {};--每帧执行一次的函数
local m_arrAddPreFrameFunc = {}; -- 添加帧函数表
local m_arrDelPerFameFunc = {}; -- 删除帧函数表
local m_arrPerSecondFunc = {};--每秒执行一次的函数
local m_arrAddPerSecondFunc = {}; -- 添加每秒函数表
local m_arrDelPerSecondFunc = {}; -- 删除每秒函数表
local m_nLastFrameTime = 0; -- 上一帧的时间
local m_nDeltaTime = 0; --每帧的时间变化量
local m_nLastSecondTime = 0; -- 上一秒的时间

-- 游戏启动，入口函数

function LuaGame.Start()
    -- 注册每帧更新函数
    UpdateBeat:Add(LuaGame.OnFrameUpdate, self); 
    m_nLastFrameTime = UnityEngine.Time.time * 1000;
    
    -- 找到主相机，设置成永久保留
    local mainCamera = UnityEngine.GameObject.Find("Main Camera");
    if(mainCamera ~= nil) then
         UnityEngine.Object.DontDestroyOnLoad(mainCamera);
    end
    local UICamera = UnityEngine.GameObject.Find("Canvas");
    if(UICamera ~= nil) then
         UnityEngine.Object.DontDestroyOnLoad(UICamera);
    end
    local eventSystem = UnityEngine.GameObject.Find("EventSystem");
    if(eventSystem ~= nil) then
         UnityEngine.Object.DontDestroyOnLoad(eventSystem);
    end
    -- 初始化语言数据
    CLanguageData.Initialize();
    -- 初始化登录模块
    --log("LuaGame 初始化登录模块")
    LuaGameLogin.Init();
    -- 设置配置文件读取
    LuaCGameConfig.Init();
end
--每帧执行一次
function LuaGame.OnFrameUpdate()
    local curtime = UnityEngine.Time.time * 1000;
    m_nDeltaTime = curtime - m_nLastFrameTime;
    m_nLastFrameTime = curtime;

    if(#m_arrAddPreFrameFunc > 0) then
        for i, add in ipairs(m_arrAddPreFrameFunc) do
            m_arrPerFrameFunc[add.n] = add.f;
        end
        m_arrAddPreFrameFunc = {};
    end
    
    for key, func in pairs(m_arrPerFrameFunc) do
        func();
    end

    if(#m_arrDelPerFameFunc > 0) then
        for i, name in ipairs(m_arrDelPerFameFunc) do
            m_arrPerFrameFunc[name] = nil;
        end
        m_arrDelPerFameFunc = {};
    end

    if(#m_arrAddPerSecondFunc > 0) then
        for i, add in ipairs(m_arrAddPerSecondFunc) do
            m_arrPerSecondFunc[add.n] = add.f;
        end
        m_arrAddPerSecondFunc = {};
    end
    --已经过了1000毫秒（1秒）
    if(curtime - m_nLastSecondTime >= 1000)
    then
        m_nLastSecondTime = curtime;
        for key, func in pairs(m_arrPerSecondFunc) do
            func();
        end
    end
    if(#m_arrDelPerSecondFunc > 0) then
        for i, name in ipairs(m_arrDelPerSecondFunc) do
            m_arrPerSecondFunc[name] = nil;
        end
        m_arrDelPerSecondFunc = {};
    end
end
function LuaGame.GetDeltaTime()
    return m_nDeltaTime;
end
--添加每帧执行的函数
function LuaGame.AddPerFrameFunc(name, func)
    --m_arrPerFrameFunc[name] = func;
   table.insert(m_arrAddPreFrameFunc, {n = name, f = func});
end
--移除每帧执行的函数
function LuaGame.RemovePerFrameFunc(name)
    --m_arrPerFrameFunc[name] = nil;
    -- 先存到删除表里
    table.insert(m_arrDelPerFameFunc, name);
end
--添加每秒执行的函数
function LuaGame.AddPerSecondFunc(name, func)
    --m_arrPerSecondFunc[name] = func;
    table.insert(m_arrAddPerSecondFunc, {n = name, f = func});
end
--移除每每秒执行的函数
function LuaGame.RemovePerSecondFunc(name)
    --m_arrPerSecondFunc[name] = nil;
    table.insert(m_arrDelPerSecondFunc, name);
end
-- 游戏销毁处理函数
function LuaGame.Destroy()
    log("game destroy");
    if(LuaCLogicManager ~= nil) then
        LuaCLogicManager.Destroy();
    end
    m_arrPerFrameFunc = {};
    m_arrAddPreFrameFunc = {};
    m_arrDelPerFameFunc = {};
    m_arrPerSecondFunc = {};
    m_arrAddPerSecondFunc = {};
    m_arrDelPerSecondFunc = {};
end

function LoadResAsync(url, callBack)
    local GameMain = UnityEngine.GameObject.Find("GameMain");
    local assetManager = GameMain:GetComponent("CAssetManager");
    assetManager:LoadResAsync(url, callBack, false);
end

function ExeCoroutineTask(startFunc, callBack, params)
    local GameMain = UnityEngine.GameObject.Find("GameMain");
    local assetManager = GameMain:GetComponent("CAssetManager");
    assetManager:ExeCoroutineTask(startFunc, callBack, params);
end

function GetAssetSpriteAsync(url, strAssetAtlas, callBack)
    local GameMain = UnityEngine.GameObject.Find("GameMain");
    local assetManager = GameMain:GetComponent("CAssetManager");
    assetManager:GetAssetSpriteAsync(url, strAssetAtlas, callBack);
end