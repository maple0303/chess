using UnityEngine;
using System.Collections;
using LuaInterface;
using System.IO;
public class LuaManager
{
    private static LuaManager instance = null;
    private LuaState lua;
    private LuaLoader loader;

    public static LuaManager GetInstance()
    {
        if (instance == null)
        {
            instance = new LuaManager();
            instance.Initialization();
        }
        return instance;
    }
    void Initialization()
    {
        //new LuaResLoader();
        instance = this;
        loader = new LuaLoader();
        lua = new LuaState();
       
        DelegateFactory.Init();
        this.OpenLibs();
        lua.LuaSetTop(0);

        LuaBinder.Bind(lua);

        //InitLuaPath();
        //InitLuaBundle();
        this.lua.Start();    //启动LUAVM

        GameObject luaGameObject = new GameObject("LuaManger");
        LuaLooper loop = luaGameObject.AddComponent<LuaLooper>();
        loop.luaState = lua;
        Object.DontDestroyOnLoad(luaGameObject);
    }
    public void StartLuaGame()
    {
        lua.DoFile("LuaGame.lua");

        LuaFunction Init = lua.GetFunction("LuaGame.OnInitOK");
        Init.Call();
        Init.Dispose();
        Init = null;
    }
    //cjson 比较特殊，只new了一个table，没有注册库，这里注册一下
    //protected void OpenCJson()
    //{
    //    lua.LuaGetField(LuaIndexes.LUA_REGISTRYINDEX, "_LOADED");
    //    lua.OpenLibs(LuaDLL.luaopen_cjson);
    //    lua.LuaSetField(-2, "cjson");

    //    lua.OpenLibs(LuaDLL.luaopen_cjson_safe);
    //    lua.LuaSetField(-2, "cjson.safe");
    //}
    /// <summary>
    /// 初始化加载第三方库
    /// </summary>
    void OpenLibs()
    {
        lua.OpenLibs(LuaDLL.luaopen_pb);
        //lua.OpenLibs(LuaDLL.luaopen_sproto_core);
        lua.OpenLibs(LuaDLL.luaopen_protobuf_c);
        //lua.OpenLibs(LuaDLL.luaopen_lpeg);
        lua.OpenLibs(LuaDLL.luaopen_bit);
        //lua.OpenLibs(LuaDLL.luaopen_socket_core);

        //this.OpenCJson();
    }

    /// <summary>
    /// 初始化Lua代码加载路径
    /// </summary>
    void InitLuaPath()
    {
#if !UNITY_EDITOR
            // lua.AddSearchPath(AppConst.DataPath + "LuaScript");
           // lua.AddSearchPath(AppConst.DataPath + "ToLua");
		string resPath = "";
		switch (Application.platform)
		{
		case RuntimePlatform.Android:
		resPath = "jar:file://" + Application.dataPath + "!/assets/";
		break;
		case RuntimePlatform.IPhonePlayer:
		resPath = Application.dataPath + "/Raw/";
		break;
		default:
		resPath = Application.dataPath + "/StreamingAssets/";
		break;
		}
		Debug.Log (resPath);
		lua.AddSearchPath(resPath + "Script/Lua");
		lua.AddSearchPath(resPath + "ToLua");
#endif

    }

    /// <summary>
    /// 初始化LuaBundle
    /// </summary>
    void InitLuaBundle()
    {
        string streamDir = AppConst.DataPath + "lua";
        //Debug.Log("文件路径" + streamDir);
        //Debug.Log("路径存在" + Directory.Exists(streamDir));
        //Debug.Log("persistentDataPath" + Application.persistentDataPath);
        //Debug.Log("streamingAssetsPath" + Application.streamingAssetsPath);
        loader.AddBundle("lua/lua_message.unity3d");
        loader.AddBundle("lua/lua_script.unity3d");
        loader.AddBundle("lua/lua_template.unity3d");
        //Debug.Log("lua代码加载完成");
        //if(Directory.Exists(streamDir))
        //{
            //string[] files = Directory.GetFiles(streamDir, "*.unity3d", SearchOption.AllDirectories);
            //Debug.Log("得到的文件长度" + files.Length);
            //for (int i = 0; i < files.Length; i++ )
            //{
                //files[i] = files[i].Replace("\\", "/");
                //Debug.Log("文件名字" + files[i]);
                //string [] file = files[i].Split('/');
                //Debug.Log("文件长度" + file.Length);
                //loader.AddBundle("lua/" + file[file.Length - 1]);
            //}
        //}
    }

    public LuaState GetLuaState()
    {
        return lua;
    }

    public void DoFile(string filename)
    {
        lua.DoFile(filename);
    }

    public void LuaRequire(string filename)
    {
        lua.Require(filename);
    }

    public LuaTable GetLuaTable(string fullPath)
    {
        return lua.GetTable(fullPath);
    }
    public object[] CallFunction(string funcName, params object[] args)
    {
        LuaFunction func = lua.GetFunction(funcName);
        if (func != null)
        {
            return func.LazyCall(args);
        }
        return null;
    }
    public void LuaGC()
    {
        lua.LuaGC(LuaGCOptions.LUA_GCCOLLECT);
    }

    public void Close()
    {
        lua.Dispose();
        lua = null;
        loader = null;
    }
}