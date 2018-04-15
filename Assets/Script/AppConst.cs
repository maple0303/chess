using UnityEngine;
using System.Collections;

//更新方式
public enum EnumUpdateType
{
    emUpdateType_Package = 0,       //打包文件更新
    emUpdateType_SingleFile = 1,    //单个文件更新
}

public class AppConst
{
    public const bool DebugMode = true;                       //调试模式-用于pc端测试，移动端设为false
    /// <summary>
    /// 如果想删掉自带的例子，那这个例子模式必须要
    /// 关闭，否则会出现一些错误。
    /// </summary>
    public const bool ResourceBundleMode = false;                       //资源AssetBundle模式模式 若为true,打包资源时会把设置好的资源打包成budnle 

    public static bool UpdateMode = true;                       //使用热更模式-默认关闭
	public const bool LuaByteMode = true;                       //Lua字节码模式-默认关闭 
    public const string LuaTempDir = "Lua/";                    //代码打bundle时的临时目录
    public const string ExtName = ".unity3d";                   //素材扩展名
    public const string AssetDir = "StreamingAssets";           //素材目录 


    /// <summary>
    /// 取得数据存放目录
    /// </summary>
    public static string DataPath
    {
        get
        {
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
            return strRawPath + "/";
        }

        //get
        //{
        //    if (Application.isMobilePlatform)
        //    {
        //        return Application.persistentDataPath + "/";
        //    }
           
        //    return  Application.dataPath + "/" + AppConst.AssetDir + "/";
        //}
    }

    public static string GetRelativePath()
    {
        if (Application.isEditor)
        {
            return "file://" + System.Environment.CurrentDirectory.Replace("\\", "/") + "/Assets/" + AppConst.AssetDir + "/";
        }
        else if (Application.isMobilePlatform || Application.isConsolePlatform)
        {
            return "file:///" + Application.persistentDataPath + "/";
        }
        else
        {
            // For standalone player.
            return "file://" + Application.streamingAssetsPath + "/";
        }
    }

    /// <summary>
    /// 应用程序内容路径
    /// </summary>
    public static string AppContentPath()
    {
        string path = string.Empty;
        switch (Application.platform)
        {
            case RuntimePlatform.Android:
                path = "jar:file://" + Application.dataPath + "!/assets/";
                break;
            case RuntimePlatform.IPhonePlayer:
                path = Application.dataPath + "/Raw/";
                break;
            default:
                path = Application.dataPath + "/" + AppConst.AssetDir + "/";
                break;
        }
        return path;
    }
}
