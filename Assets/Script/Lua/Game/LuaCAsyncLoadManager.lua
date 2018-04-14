--region *.lua
--Date
--此文件由[BabeLua]插件自动生成

LuaCAsyncLoadManager =
{
    m_loadCallBack = nil,
};
local this = LuaCAsyncLoadManager;

local m_arrTask = { };
local m_nCurIndex = 1;

function LuaCAsyncLoadManager.Start()
    m_nCurIndex = 1;
    coroutine.start(LuaCAsyncLoadManager.StartLoading);
end

function LuaCAsyncLoadManager.StartLoading()
    while(m_nCurIndex <= #m_arrTask) do
        local taskData = m_arrTask[m_nCurIndex];
        LuaCAsyncLoadManager.Load(taskData.func, taskData.params);
        LuaCUILoadingPanel.updateProgressBar(m_nCurIndex / #m_arrTask * 100);
        coroutine.wait(0.1);
        m_nCurIndex = m_nCurIndex + 1;
    end
    coroutine.stop();
    LuaCAsyncLoadManager.LoadComplete();
end

--加载资源
function LuaCAsyncLoadManager.Load(func, ...)
--    local current = coroutine.running();
--    if(current == nil) then
        current = coroutine.create(func);
--    end
    coroutine.resume(current, ...);
end

function LuaCAsyncLoadManager.AddTask(func, params)
    local taskData = {func = func, params = params};
    table.insert(m_arrTask, taskData);
end

function LuaCAsyncLoadManager.LoadComplete()
    if(LuaCAsyncLoadManager.m_loadCallBack ~= nil) then
        LuaCAsyncLoadManager.m_loadCallBack();
        LuaCAsyncLoadManager.m_loadCallBack = nil;
    end
    m_arrTask = {};
end
--endregion
