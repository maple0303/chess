//#define ASSETBUNDLE_ENABLE

using System;
using System.Collections;
using System.Collections.Generic;
using System.IO;
#if UNITY_EDITOR
using UnityEditor;
#endif
using UnityEngine;
using LuaInterface;
public class CAssetManager : MonoBehaviour
{
    private class AssetBundleData
    {
        public AssetBundle assetBundle;
        public string strAssetPath;
        public List<string> listUseBundleName;
    }

    private static CAssetManager m_assetManager = null;

    //所有bundle的路径和对应bundle的ID关联信息,  key:资源路径, value:bundle名
    static private Dictionary<string, string> dictAbName = new Dictionary<string, string>();

    //存储所有的bundle， key:bundle的ID
    static private Dictionary<string, AssetBundleData> m_dicAssetBundle = new Dictionary<string, AssetBundleData>();

    // 图集资源表
    static private Dictionary<string, Dictionary<string, Sprite>> m_dicSpriteAtlas = new Dictionary<string, Dictionary<string, Sprite>>();

    //实例化对象引用列表
    static private Dictionary<string, Dictionary<int, bool>> m_dicInsObjMap = new Dictionary<string, Dictionary<int, bool>>();

    static private AssetBundleManifest manifest = null;

    static private List<LoadTaskData> m_listLoadData = new List<LoadTaskData>();
    static private Coroutine m_coroutine = null;
    static private bool m_bIsLoading = false;

    void Awake()
    {
        m_assetManager = this;
        dictAbName = new Dictionary<string, string>();
        m_dicAssetBundle = new Dictionary<string, AssetBundleData>();

        AssetBundle mainBundle = null;
        // 获得更新包路径
        string strPersistentDataPath = string.Empty;
        if (Application.isMobilePlatform)
        {
            strPersistentDataPath = Application.persistentDataPath;
        }
        // 获得原始数据路径
        string strRawPath = string.Empty;
        switch (Application.platform)
        {
            case RuntimePlatform.Android:
                strRawPath = Application.streamingAssetsPath;
                break;
            case RuntimePlatform.IPhonePlayer:
                strRawPath = Application.dataPath + "/Raw";
                break;
            default:
                strRawPath = Application.streamingAssetsPath;
                break;
        }
        if (strPersistentDataPath != string.Empty && File.Exists(Application.persistentDataPath + "/StreamingAssets"))
        {
            mainBundle = AssetBundle.LoadFromFile(strPersistentDataPath + "/StreamingAssets");
        }
        else
        {
            // 没有新版的bundle主文件，则加载安装包里的bundle主文件
            mainBundle = AssetBundle.LoadFromFile(strRawPath + "/StreamingAssets");
        }
        // 构建资源依赖关系
        manifest = mainBundle.LoadAsset<AssetBundleManifest>("AssetBundleManifest");

        string strAssetRelateUrl = "";
        if (strPersistentDataPath != string.Empty && File.Exists(Application.persistentDataPath + "/AssetRelateData"))
        {
            strAssetRelateUrl = strPersistentDataPath + "/AssetRelateData";
        }
        else
        {
            // 没有新版的bundle主文件，则加载安装包里的bundle主文件
            strAssetRelateUrl = strRawPath + "/AssetRelateData";
        }

        string content = File.ReadAllText(strAssetRelateUrl);
        string[] strArr = content.Split('\n');
        foreach(string nameData in strArr)
        {
            string[] arr = nameData.Split('|');
            string[] assetNameList = arr[0].Split(',');
            string strBundleName = arr[1];

            AssetBundleData assetBundleData = new AssetBundleData();
            if (strPersistentDataPath != string.Empty && File.Exists(Application.persistentDataPath + "/" + strBundleName))
            {
                assetBundleData.strAssetPath = strPersistentDataPath + "/" + strBundleName;
            }
            else
            {
                // 没有新版的bundle主文件，则加载安装包里的bundle主文件
                assetBundleData.strAssetPath = strRawPath + "/" + strBundleName;
            }
            assetBundleData.listUseBundleName = new List<string>();

            foreach (string strAssetName in assetNameList)
            {
                if (string.IsNullOrEmpty(strAssetName))
                {
                    continue;
                }
                dictAbName.Add(strAssetName, strBundleName);
            }
            m_dicAssetBundle.Add(strBundleName, assetBundleData);
        }
        mainBundle.Unload(false);
//#endif
    }

    static CAssetManager()
    {
    }

    //加载lua文件
    public static byte[] GetLuaScript(string fileName)
    {
#if UNITY_EDITOR && !ASSETBUNDLE_ENABLE
        string path = LuaFileUtils.Instance.FindFile(fileName);
        byte[] str = null;

        if (!string.IsNullOrEmpty(path) && File.Exists(path))
        {
            str = File.ReadAllBytes(path);
        }
        if (str != null)
        {
            return str;
        }
#endif
        AssetBundle assetBundle = null;
        byte[] buffer = null;

        using (CString.Block())
        {
            string strBundleName = "";
            if (fileName.IndexOf("message/") != -1)
            {
                strBundleName = "lua/lua_message.unity3d";
            }
            else if (fileName.IndexOf("Template/") != -1)
            {
                strBundleName = "lua/lua_template.unity3d";
            }
            else
            {
                strBundleName = "lua/lua_script.unity3d";
            }
            int pos = fileName.LastIndexOf('/');
            if (pos > 0)
            {
                fileName = fileName.Substring(pos + 1);
            }
            if (!fileName.EndsWith(".lua"))
            {
                fileName += ".lua";
            }

#if UNITY_5 || UNITY_2017
            fileName += ".bytes";
#endif
            AssetBundleData assetBundleData = null;
            if(m_dicAssetBundle.TryGetValue(strBundleName, out assetBundleData))
            {
                string keyName = "assets/" + fileName.ToLower();
                if (assetBundleData != null)
                {
                    if (assetBundleData.assetBundle == null)
                    {
                        assetBundleData.assetBundle = AssetBundle.LoadFromFile(assetBundleData.strAssetPath);
                    }
                    assetBundle = assetBundleData.assetBundle;
                }
            }
        }

        if (assetBundle != null)
        {
#if UNITY_5 || UNITY_2017
            TextAsset luaCode = assetBundle.LoadAsset<TextAsset>(fileName);
#else
            TextAsset luaCode = assetBundle.Load(fileName, typeof(TextAsset)) as TextAsset;
#endif
            if (luaCode != null)
            {
                buffer = luaCode.bytes;
                Resources.UnloadAsset(luaCode);
            }
        }
        return buffer;
    }

    public static UnityEngine.Object GetAsset(string strAssetUrl, Type type)
    {
        string keyName = "assets/" + strAssetUrl.ToLower();
#if UNITY_EDITOR && !ASSETBUNDLE_ENABLE
        return AssetDatabase.LoadAssetAtPath<UnityEngine.Object>(keyName);
#else
        AssetBundleData assetBundleData = GetAssetBundleDataByPath(keyName);
        if (assetBundleData == null)
        {
            return null;
        }

        //加载依赖的bundle
        string[] arrDependenciesName = GetDependencies(keyName);
        foreach (string strDependenciesName in arrDependenciesName)
        {
            LoadDependenciesBundle(strDependenciesName, keyName);
        }
        if (assetBundleData.assetBundle == null)
        {
            assetBundleData.assetBundle = AssetBundle.LoadFromFile(assetBundleData.strAssetPath);
        }
        //刷新使用者列表中
        if (assetBundleData.listUseBundleName.IndexOf(keyName) == -1)
        {
            assetBundleData.listUseBundleName.Add(keyName);
        }
        return assetBundleData.assetBundle.LoadAsset(keyName, type);
#endif
    }

    private static string[] GetDependencies(string keyName)
    {
        string strAbName = string.Empty;
        if (dictAbName.ContainsKey(keyName))
        {
            strAbName = dictAbName[keyName];
            return manifest.GetAllDependencies(strAbName);
        }
        return new string[]{};
    }

    // Get an AssetBundle
    public static UnityEngine.Object GetAsset(string strAssetUrl)
    {
        string keyName = "assets/" + strAssetUrl.ToLower();
#if UNITY_EDITOR && !ASSETBUNDLE_ENABLE
        return AssetDatabase.LoadAssetAtPath<UnityEngine.Object>(keyName);
#else
        AssetBundleData assetBundleData = GetAssetBundleDataByPath(keyName);

        if (assetBundleData == null)
        {
            return null;
        }

        //加载依赖的bundle
        string[] arrDependenciesName = GetDependencies(keyName);
        foreach (string strDependenciesName in arrDependenciesName)
        {
            LoadDependenciesBundle(strDependenciesName, keyName);
        }
        if (assetBundleData.assetBundle == null)
        {
            assetBundleData.assetBundle = AssetBundle.LoadFromFile(assetBundleData.strAssetPath);
        }
        //刷新使用者列表中
        if (assetBundleData.listUseBundleName.IndexOf(keyName) == -1)
        {
            assetBundleData.listUseBundleName.Add(keyName);
        }
        return assetBundleData.assetBundle.LoadAsset(keyName);
#endif
    }

    //加载依赖的bundle文件
    private static void LoadDependenciesBundle(string keyName, string useName)
    {
        AssetBundleData assetBundleData = GetAssetBundleByName(keyName);
        if (assetBundleData == null)
        {
            return;
        }
        if (assetBundleData.assetBundle == null)
        {
            assetBundleData.assetBundle = AssetBundle.LoadFromFile(assetBundleData.strAssetPath);
        }

        //将依赖这个资源的bundle名字，加入到使用者列表中
        if (assetBundleData.listUseBundleName.IndexOf(useName) == -1)
        {
            assetBundleData.listUseBundleName.Add(useName);
        }
        //加载依赖的bundle
        string[] arrDependenciesName = GetDependencies(keyName);
        foreach (string strDependenciesName in arrDependenciesName)
        {
            LoadDependenciesBundle(strDependenciesName, keyName);
        }
    }
    
    public static Sprite GetAssetSprite(string strAssetUrl, string strAssetAtlas = "")
    {
        string keyName = "assets/" + strAssetUrl.ToLower();
        if (strAssetAtlas != "")
        {
            keyName = "assets/" + strAssetAtlas.ToLower();
        }

#if UNITY_EDITOR && !ASSETBUNDLE_ENABLE
        if (strAssetAtlas != "")
        {
            Dictionary<string, Sprite> dicSprite = null;
            m_dicSpriteAtlas.TryGetValue(keyName, out dicSprite);
            if(dicSprite == null)
            {
                dicSprite = new Dictionary<string, Sprite>();
                UnityEngine.Object[] arrObj = AssetDatabase.LoadAllAssetsAtPath(keyName);
                for (int i = 0; i < arrObj.Length; i++)
                {
                    if(arrObj[i].GetType() == typeof(UnityEngine.Sprite))
                    {
                        dicSprite[arrObj[i].name] = arrObj[i] as Sprite;
                    }
                }
                m_dicSpriteAtlas[keyName] = dicSprite;
            }
            Sprite sprite = null;
            dicSprite.TryGetValue(strAssetUrl, out sprite);
            return sprite;
        }

        return AssetDatabase.LoadAssetAtPath<Sprite>(keyName);
#else
        AssetBundleData assetBundleData = GetAssetBundleDataByPath(keyName);
        if (assetBundleData == null)
        {
            return null;
        }
        if (assetBundleData.assetBundle == null)
        {
            assetBundleData.assetBundle = AssetBundle.LoadFromFile(assetBundleData.strAssetPath);
        }
        if (strAssetAtlas != "")
        {
            Dictionary<string, Sprite> dicSprite = null;
            m_dicSpriteAtlas.TryGetValue(keyName, out dicSprite);
            if (dicSprite == null)
            {
                dicSprite = new Dictionary<string, Sprite>();
                Sprite[] arrSprites = assetBundleData.assetBundle.LoadAllAssets<Sprite>();
                for (int i = 0; i < arrSprites.Length; i++)
                {
                    dicSprite[arrSprites[i].name] = arrSprites[i];
                }
                m_dicSpriteAtlas[keyName] = dicSprite;
            }
            Sprite sprite = null;
            dicSprite.TryGetValue(strAssetUrl, out sprite);
            return sprite;
        }
        return assetBundleData.assetBundle.LoadAsset<Sprite>(keyName);
#endif
    }

    static public void GetAssetSpriteAsync(string strAssetUrl, string strAssetAtlas = "", Action<UnityEngine.Object> callBack = null)
    {
        string keyName = "assets/" + strAssetUrl.ToLower();
        if (strAssetAtlas != "")
        {
            keyName = "assets/" + strAssetAtlas.ToLower();
        }
        LoadResAsync(strAssetAtlas, callBack, true);
    }

    static public void LoadResAsync(string url, Action<UnityEngine.Object> callBack)
    {
        LoadResAsync(url, callBack, false);
    }

    static private void LoadResAsync(string url, Action<UnityEngine.Object> callBack, bool bSprite)
    {
        if (m_bIsLoading)
        {
            LoadTaskData data = new LoadTaskData();
            data.url = url;
            data.func = callBack;
            data.bSprite = bSprite;
            m_listLoadData.Add(data);
        }
        else
        {
            if (bSprite)
            {
                m_coroutine = m_assetManager.StartCoroutine(GetAssetAsync<Sprite>(url, callBack));
            }
            else
            {
                m_coroutine = m_assetManager.StartCoroutine(GetAssetAsync<UnityEngine.Object>(url, callBack));
            }
        }
    }

    //清空所有异步加载的任务
    static public void ClearAsyncLoadingTask()
    {
        m_bIsLoading = false;
        StopCurAsyncLoading();
        m_listLoadData.Clear();
    }

    static public void StopCurAsyncLoading()
    {
        if (m_coroutine != null)
        {
            m_assetManager.StopCoroutine(m_coroutine);
        }
    }

    static private void CheckAsyncLoad()
    {
        if (m_listLoadData.Count == 0)
        {
            return;
        }
        LoadTaskData data = m_listLoadData[0];
        m_listLoadData.RemoveAt(0);

        if (data.bSprite)
        {
            m_coroutine = m_assetManager.StartCoroutine(GetAssetAsync<Sprite>(data.url, data.func));
        }
        else
        {
            m_coroutine = m_assetManager.StartCoroutine(GetAssetAsync<UnityEngine.Object>(data.url, data.func));
        }
    }

    // 异步加载资源
    static public IEnumerator GetAssetAsync<T>(string strAssetUrl, Action<UnityEngine.Object> callBack) where T : UnityEngine.Object
    {
        m_bIsLoading = true;

        string keyName = "assets/" + strAssetUrl.ToLower();
#if UNITY_EDITOR && !ASSETBUNDLE_ENABLE
        UnityEngine.Object obj = AssetDatabase.LoadAssetAtPath<T>(keyName);
        yield return obj;
        m_bIsLoading = false;
        callBack(obj);
        CheckAsyncLoad();
#else
        AssetBundleData assetBundleData = GetAssetBundleDataByPath(keyName);
        if (assetBundleData == null)
        {
            m_bIsLoading = false;
            callBack(null);
            CheckAsyncLoad();
            yield break;
        }
        //加载依赖的bundle
        string[] arrDependenciesName = GetDependencies(keyName);
        foreach (string strDependenciesName in arrDependenciesName)
        {
            m_coroutine = m_assetManager.StartCoroutine(LoadAsyncDependenciesBundle(strDependenciesName, keyName));
            yield return null;
        }

        if (assetBundleData.assetBundle == null)
        {
            AssetBundleCreateRequest abcr = AssetBundle.LoadFromFileAsync(assetBundleData.strAssetPath);
            yield return new WaitUntil(() => abcr.isDone == true);
            assetBundleData.assetBundle = abcr.assetBundle;
        }

        //刷新使用者列表中
        if (assetBundleData.listUseBundleName.IndexOf(keyName) == -1)
        {
            assetBundleData.listUseBundleName.Add(keyName);
        }

        AssetBundleRequest assetLoadRequest = assetBundleData.assetBundle.LoadAssetAsync<T>(keyName);
        yield return new WaitUntil(() => assetLoadRequest.isDone == true);
        UnityEngine.Object obj = assetLoadRequest.asset;
        m_bIsLoading = false;
        callBack(obj);
        CheckAsyncLoad();
#endif
    }
    //加载依赖的bundle文件
    static private IEnumerator LoadAsyncDependenciesBundle(string keyName, string useName)
    {
        AssetBundleData assetBundleData = GetAssetBundleByName(keyName);
        if (assetBundleData == null)
        {
            yield break;
        }
        if (assetBundleData.assetBundle == null)
        {
            m_coroutine = m_assetManager.StartCoroutine(LoadFromFileAsync(assetBundleData));
            //AssetBundleCreateRequest abcr = AssetBundle.LoadFromFileAsync(assetBundleData.strAssetPath);
            //yield return new WaitUntil(() => abcr.isDone == true);
            //assetBundleData.assetBundle = abcr.assetBundle;
        }

        //将依赖这个资源的bundle名字，加入到使用者列表中
        if (assetBundleData.listUseBundleName.IndexOf(keyName) == -1)
        {
            assetBundleData.listUseBundleName.Add(keyName);
        }

        string[] arrDependenciesName = GetDependencies(keyName);
        //加载依赖的bundle
        int i = 0;
        while (i < arrDependenciesName.Length)
        {
            string strDependenciesName = arrDependenciesName[i];
            m_coroutine = m_assetManager.StartCoroutine(LoadAsyncDependenciesBundle(strDependenciesName, keyName));
            i++;
        }
        yield break;
    }
    static private IEnumerator LoadFromFileAsync(AssetBundleData assetBundleData)
    {
        AssetBundleCreateRequest abcr = AssetBundle.LoadFromFileAsync(assetBundleData.strAssetPath);
        yield return new WaitUntil(() => abcr.isDone == true);
        assetBundleData.assetBundle = abcr.assetBundle;
        yield break;
    }

    //卸载资源
    public static void UnloadAsset(string strAssetUrl)
    {
#if !UNITY_EDITOR || ASSETBUNDLE_ENABLE
        string keyName = "assets/" + strAssetUrl.ToLower();
        AssetBundleData assetBundleData = GetAssetBundleDataByPath(keyName);
        if (assetBundleData == null)
        {
            return;
        }

        //将依赖这个资源的bundle名字，从使用者列表中移除
        int nIndex = assetBundleData.listUseBundleName.IndexOf(keyName);
        if (nIndex >= 0)
        {
            assetBundleData.listUseBundleName.RemoveAt(nIndex);
        }
        //资源处于空闲状态下，卸载bundle(使用者数量为0)
        if (assetBundleData.listUseBundleName.Count == 0)
        {
            //卸载依赖的bundle
            string[] arrDependenciesName = GetDependencies(keyName);
            foreach (string strDependenciesName in arrDependenciesName)
            {
                UnloadDependenciesBundle(strDependenciesName, keyName);
            }
            if (assetBundleData.assetBundle != null)
            {
                string[] arrStrName = assetBundleData.assetBundle.GetAllAssetNames();
                foreach (string strAssetName in arrStrName)
                {
                    if (Path.GetExtension(strAssetName) == ".png")   //释放图集内存
                    {
                        string atlasName = strAssetName.ToLower();
                        Dictionary<string, Sprite> dicSprite = null;
                        m_dicSpriteAtlas.TryGetValue(atlasName, out dicSprite);
                        if (dicSprite != null)
                        {
                            m_dicSpriteAtlas.Remove(atlasName);
                        }
                    }
                }
                assetBundleData.assetBundle.Unload(true);
            }
        }
#endif
    }
    //卸载依赖的bundle文件
    private static void UnloadDependenciesBundle(string keyName, string useName)
    {
        AssetBundleData assetBundleData = GetAssetBundleByName(keyName);
        if (assetBundleData == null)
        {
            return;
        }

        //将依赖这个资源的bundle名字，从使用者列表中移除
        int nIndex = assetBundleData.listUseBundleName.IndexOf(useName);
        if (nIndex >= 0)
        {
            assetBundleData.listUseBundleName.RemoveAt(nIndex);
        }
        //资源处于空闲状态下，卸载bundle(使用者数量为0)
        if (assetBundleData.listUseBundleName.Count == 0)
        {
            if (assetBundleData.assetBundle != null)
            {
                assetBundleData.assetBundle.Unload(true);
            }
        }
        //加载依赖的bundle
        string[] arrDependenciesName = GetDependencies(keyName);
        foreach (string strDependenciesName in arrDependenciesName)
        {
            UnloadDependenciesBundle(strDependenciesName, keyName);
        }
    }

    /*
     * 实例化对象
     ** prefabObj：预设
     ** strAssetUrl：预设的资源路径(带后缀名)
     */
    static public GameObject InstantiateGameObject(GameObject prefabObj, string strAssetUrl)
    {
        GameObject gameObj = GameObject.Instantiate<GameObject>(prefabObj);
        if (gameObj == null)
        {
            return null;
        }
        //int nInstanceID = prefabObj.GetInstanceID();
        Dictionary<int, bool> dicUseList;
        if (!m_dicInsObjMap.TryGetValue(strAssetUrl, out dicUseList))
        {
            dicUseList = new Dictionary<int, bool>();
            dicUseList.Add(gameObj.GetInstanceID(), true);
            m_dicInsObjMap.Add(strAssetUrl, dicUseList);
        }
        return gameObj;
    }

    /*
     * 卸载实例化的对象
     ** strAssetUrl:预设资源路径
     ** nInstanceID:卸载对象的实体ID
     */
    static public void UnloadInsObj(string strAssetUrl, int nInstanceID)
    {
#if !UNITY_EDITOR || ASSETBUNDLE_ENABLE
        bool bUnload = false;
        Dictionary<int, bool> dicUseList;
        if (m_dicInsObjMap.TryGetValue(strAssetUrl, out dicUseList))
        {
            if (dicUseList.ContainsKey(nInstanceID))
            {
                dicUseList.Remove(nInstanceID);
                if (dicUseList.Count == 0)
                {
                    m_dicInsObjMap.Remove(strAssetUrl);
                    bUnload = true;
                }
            }
        }
        if (!bUnload)
        {
            return;
        }
        CAssetManager.UnloadAsset(strAssetUrl);
#endif
    }

    //通过资源路径获取对应的bundle数据
    static private AssetBundleData GetAssetBundleDataByPath(string strAssetPath)
    {
        //获取bundle名称
        string strAbName = string.Empty;
        if (!dictAbName.ContainsKey(strAssetPath))
        {
            return null;
        }
        strAbName = dictAbName[strAssetPath];

        AssetBundleData abData = GetAssetBundleByName(strAbName);
        return abData;
    }

    //通过bundle名获取对应的bundle数据
    static private AssetBundleData GetAssetBundleByName(string strAbName)
    {
        AssetBundleData abData = null;
        m_dicAssetBundle.TryGetValue(strAbName, out abData);
        return abData;
    }

    struct LoadTaskData
    {
        public string url;
        public Action<UnityEngine.Object> func;
        public bool bSprite;
    }
}