using LuaInterface;
using System;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Events;
using UnityEngine.UI;

public class CLuaTableBehaviour : MonoBehaviour
{
    [SerializeField]
    [Tooltip("要绑定的lua文件,从lua文件夹下的路径开始，不包含扩展名")]
    private string m_strLuaPathFileName = "";

    [SerializeField]
    [Tooltip("是否设置成静态模式，游戏中单例模式和静态类需要设置成静态模式")]
    private bool m_IsStatic = false;

    private LuaTable m_luaTable = null;
    void Awake()
    {
        if (m_strLuaPathFileName != "")
        {
            string strLuaFileName = m_strLuaPathFileName.Substring(m_strLuaPathFileName.LastIndexOf("/") + 1);
            LuaState lua = LuaManager.GetInstance().GetLuaState();


            if (m_IsStatic)
            {
                LuaManager.GetInstance().CallFunction(strLuaFileName + ".Awake", gameObject);
                m_luaTable = lua.GetTable(strLuaFileName);
            }
            else
            {
                lua.Require(m_strLuaPathFileName);  // 加载lua文件
                LuaTable tableClass = lua.GetTable(strLuaFileName);

                LuaFunction func = tableClass.GetLuaFunction("New");
                if (func != null)
                {
                    m_luaTable = func.Invoke<LuaTable, LuaTable>(tableClass);

                    //if (rets.Length != 1)
                    //{
                    //    return;
                    //}

                    //m_luaTable = (LuaTable)rets[0];
                }

                LuaFunction func1 = m_luaTable.GetLuaFunction("Awake");
                if (func1 != null)
                {
                    func1.Call(m_luaTable, gameObject);
                }
            }
        }
    }

    void Start()
    {
        if (m_strLuaPathFileName != "")
        {
            if (m_IsStatic)
            {
                string strLuaFileName = m_strLuaPathFileName.Substring(m_strLuaPathFileName.LastIndexOf("/") + 1);
                LuaManager.GetInstance().CallFunction(strLuaFileName + ".Start");
            }
            else
            {
                LuaFunction func = m_luaTable.GetLuaFunction("Start");
                if (func != null)
                {
                    func.Call(m_luaTable);
                }
            }
        }
    }    

    public LuaTable GetLuaTable()
    {
        return m_luaTable;
    }
    
    void OnDestroy()
    {
        //GC.Collect(); Resources.UnloadUnusedAssets();
        //LuaManager mgr = AppFacade.Instance.GetManager<LuaManager>(ManagerName.Lua);
        //if (mgr != null) mgr.LuaGC();
    }
}