using UnityEditor;
using UnityEngine;
using System;
using System.IO;
using System.Text;
using System.Diagnostics;
using System.Collections;
using System.Collections.Generic;

/**
 * 生成bundle名和资源名的关联文件
 */
public class CAssetBundleEditor : EditorWindow
{
    [UnityEditor.MenuItem("Tools/Create AssetFile", false, 100)]
    static public void CreateBundleRelateFile()
    {
        AssetBundle mainBundle = AssetBundle.LoadFromFile(Application.streamingAssetsPath + "/StreamingAssets");

        //lua的bundle文件列表
        List<string> arrLuaFileName = new List<string>() { "lua/lua_message.unity3d", "lua/lua_script.unity3d", "lua/lua_template.unity3d" };

        // 构建资源依赖关系
        AssetBundleManifest manifest = mainBundle.LoadAsset<AssetBundleManifest>("AssetBundleManifest");
        string[] arrStrBundle = manifest.GetAllAssetBundles();

        string content = "";
        for (int i = 0; i < arrStrBundle.Length; i++)
        {
            string strBundleName = arrStrBundle[i];
            if (arrLuaFileName.IndexOf(strBundleName) >= 0)
            {
                continue;
            }

            string str = "";
            string strAssetPath = Application.streamingAssetsPath + "/" + strBundleName;
            AssetBundle assetBundle = AssetBundle.LoadFromFile(strAssetPath);

            //bundle里的资源列表
            string[] arrStrName = assetBundle.GetAllAssetNames();
            foreach (string strAssetName in arrStrName)
            {
                if (string.IsNullOrEmpty(str))
                {
                    str += strAssetName;
                }
                else
                {
                    str += ("," + strAssetName);
                }
            }
            if(i == arrStrBundle.Length - 1)
            {
                str += ("|" + assetBundle.name);
            }
            else
            {
                str += ("|" + assetBundle.name + "\n");
            }

            assetBundle.Unload(false);
            content += str;
        }
        //将lua的bundle名添加到列表里，这样游戏就可以加载到lua的bundle文件
        for (int i = 0; i < arrLuaFileName.Count; i++)
        {
            string strBundleName = arrLuaFileName[i];
            string str = "";
            string strAssetPath = Application.streamingAssetsPath + "/" + strBundleName;
            AssetBundle assetBundle = AssetBundle.LoadFromFile(strAssetPath);

            str += ("\n|" + assetBundle.name);

            assetBundle.Unload(false);
            content += str;
        }
        mainBundle.Unload(false);

        File.WriteAllText(Application.streamingAssetsPath + "/AssetRelateData", content);

        EditorUtility.DisplayDialog("成功", "完成！", "确定");
    }
}