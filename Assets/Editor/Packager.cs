using UnityEditor;
using UnityEngine;
using System.IO;
using System.Text;
using System.Collections;
using System.Collections.Generic;
using System.Diagnostics;
using System;

public class Packager {
    public static string platform = string.Empty;
    static List<AssetBundleBuild> maps = new List<AssetBundleBuild>();

    [MenuItem("Tools/CreatAssetBundle/Build iPhone Resource", false, 100)]
    public static void BuildiPhoneResource() {
        BuildAssetResource(BuildTarget.iOS);
    }

    [MenuItem("Tools/CreatAssetBundle/Build Android Resource", false, 101)]
    public static void BuildAndroidResource() {
        BuildAssetResource(BuildTarget.Android);
    }

    [MenuItem("Tools/CreatAssetBundle/Build Windows Resource", false, 102)]
    public static void BuildWindowsResource() {
        BuildAssetResource(BuildTarget.StandaloneWindows64);
    }

    /// <summary>
    /// 生成绑定素材
    /// </summary>
    public static void BuildAssetResource(BuildTarget target) 
    {
        maps.Clear();
        //设置代码bundle
        HandleLuaBundle();
        //设置资源bundle
        HandleAssetBundle();
        //开始打bundle
        string resPath = "Assets/StreamingAssets";
        UnityEngine.Debug.Log("bundle数量" + maps.ToArray().Length);
        BuildPipeline.BuildAssetBundles(resPath, maps.ToArray(), BuildAssetBundleOptions.ChunkBasedCompression, target);

        //删除设置的代码临时文件夹
        string streamDir = Application.dataPath + "/" + AppConst.LuaTempDir;
        if (Directory.Exists(streamDir))
        {
            Directory.Delete(streamDir, true);
        }

        //生成bundle名和资源名的关联文件
        Packager.CreateBundleRelateFile();

        AssetDatabase.Refresh();
    }
    

    /// <summary>
    /// 处理Lua代码包
    /// </summary>
    static void HandleLuaBundle() 
    {
        string streamDir = Application.dataPath + "/" + AppConst.LuaTempDir;
        if (!Directory.Exists(streamDir)) Directory.CreateDirectory(streamDir);

        string[] srcDirs = { LuaConst.luaDir, LuaConst.toluaDir};
        for (int i = 0; i < srcDirs.Length; i++)
        {
            string sourceDir = srcDirs[i];
            string[] files = Directory.GetFiles(sourceDir, "*.lua", SearchOption.AllDirectories);
            int len = sourceDir.Length;

            if (sourceDir[len - 1] == '/' || sourceDir[len - 1] == '\\')
            {
                --len;
            }

            if (AppConst.LuaByteMode)
            {
                for (int j = 0; j < files.Length; j++)
                {
                    string str = files[j].Remove(0, len);
                    string dest = streamDir + str + ".bytes";
                    string filePath = Path.GetDirectoryName(dest);
                    filePath = filePath.Replace('\\', '/');
                    string fileName = Path.GetFileName(dest);
                    string dir = "";
                    if (filePath.IndexOf("/message") != -1)
                    {
                        dir = streamDir + "message";
                    }
                    else if (filePath.IndexOf("/Template") != -1)
                    {
                        dir = streamDir + "template";
                    }
                    else
                    {
                        dir = streamDir + "script";
                    }
                    Directory.CreateDirectory(dir);
                    string outPath = dir + "/" + fileName;
                    EncodeLuaFile(files[j], outPath);
                }
            }
            else
            {
                for (int k = 0; k < files.Length; k++)
                {
                    string strFile = files[k].Remove(0, len);
                    string destStr = streamDir + strFile + ".bytes";
                    string filePathStr = Path.GetDirectoryName(destStr);
                    filePathStr = filePathStr.Replace('\\', '/');
                    string fileNameStr = Path.GetFileName(destStr);
                    string dirStr = "";
                    if (filePathStr.IndexOf("/message") != -1)
                    {
                        dirStr = streamDir + "message";
                    }
                    else if (filePathStr.IndexOf("/Template") != -1)
                    {
                        dirStr = streamDir + "template";
                    }
                    else
                    {
                        dirStr = streamDir + "script";
                    }
                    Directory.CreateDirectory(dirStr);
                    string outPathStr = dirStr + "/" + fileNameStr;
                    File.Copy(files[k], outPathStr, true);
                }
            }
        }
        
        string[] dirs = Directory.GetDirectories(streamDir, "*", SearchOption.AllDirectories);
        for (int i = 0; i < dirs.Length; i++) 
        {
            string name = dirs[i].Replace(streamDir, string.Empty);
            name = name.Replace('\\', '_').Replace('/', '_');
            name = "lua/lua_" + name.ToLower();

            string path = "Assets" + dirs[i].Replace(Application.dataPath, "");

            string[] allFiles = Directory.GetFiles(path, "*.bytes");
            if (allFiles.Length == 0) continue;

            for (int j = 0; j < allFiles.Length; j++)
            {
                allFiles[j] = allFiles[j].Replace('\\', '/');
            }
            AddBuildMap(name, allFiles);
        }
        AssetDatabase.Refresh();
    }
    static void HandleAssetBundle()
    {
        //打包字体bundle
        HandleFontBundle();
        //打包预设bundle
        HandlePrefabsBundle();
        //打包文理bundle
        HandleTexturesBundle();
        //打包配置bundle
        HandleConfigBundle();
        //打包音效
        //HandleSoundBundle();
    }
    static void HandlePrefabsBundle()
    {
        string sourceDir = "";
        string[] files = { };
        string filePathStr = "";
        string fileNameStr = "";
        string name = "";
        List<string> prefabList = new List<string>();
        //ui路径下的文件夹，一个文件夹一个bundle，
        sourceDir = Application.dataPath + "/prefabs/UI/";
        string[] dirs = Directory.GetDirectories(sourceDir, "*", SearchOption.AllDirectories);
        for (int j = 0; j < dirs.Length; j++)
        {
            prefabList.Clear();
            name = dirs[j].Replace(sourceDir, string.Empty);
            name = name.Replace('\\', '/');
            //根据文件夹名字找到需要和该文件夹打到一起的图片
            GetNeedBundleTexture(name, prefabList);
            name = "prefabs/ui/" + name.ToLower();
            string path = "Assets" + dirs[j].Replace(Application.dataPath, "");
            path = path.Replace('\\', '/');
            string[] allFiles = Directory.GetFiles(path, "*.prefab");
            if (allFiles.Length == 0) continue;
            for (int k = 0; k < allFiles.Length; k++)
            {
                allFiles[k] = allFiles[k].Replace('\\', '/');
                prefabList.Add(allFiles[k]);
                //根据文件名字找到需要和该文件夹打到一起的图片
                string[] str = allFiles[k].Replace(".prefab", "").Split('/');
                GetNeedBundleTexture(str[str.Length - 1], prefabList);
            }
            AddBuildMap(name, prefabList.ToArray());
        }
        //ui路径下的单独文件
        sourceDir = Application.dataPath + "/prefabs/UI/";
        files = Directory.GetFiles(sourceDir, "*.prefab", SearchOption.TopDirectoryOnly);
        for (int j = 0; j < files.Length; j++)
        {
            prefabList.Clear();
            filePathStr = Path.GetDirectoryName(files[j]);
            filePathStr = filePathStr.Replace('\\', '/');
            fileNameStr = Path.GetFileName(files[j]);
            name = filePathStr.Replace(Application.dataPath + "/", "").ToLower() + "/" + fileNameStr.ToLower().Replace(".prefab", "").ToLower();
            prefabList.Add("Assets/" + filePathStr.Replace(Application.dataPath + "/", "") + "/" + fileNameStr.ToLower());
            //根据文件名字找到需要和该文件夹打到一起的图片
            string[] str = name.Replace(".prefab", "").Split('/');
            GetNeedBundleTexture(str[str.Length - 1], prefabList);
            AddBuildMap(name, prefabList.ToArray());
        }
        //这些路径下的文件都是一个文件一个bundle
        string[] singleDirs = {};
        for(int i = 0; i < singleDirs.Length; i++)
        {
            sourceDir = Application.dataPath + "/" + singleDirs[i];
            files = Directory.GetFiles(sourceDir, "*.prefab", SearchOption.AllDirectories);
            for (int j = 0; j < files.Length; j++)
            {
                filePathStr = Path.GetDirectoryName(files[j]);
                filePathStr = filePathStr.Replace('\\', '/');
                fileNameStr = Path.GetFileName(files[j]);
                name = filePathStr.Replace(Application.dataPath + "/", "") + "/" + fileNameStr.ToLower().Replace(".prefab", string.Empty);
                string[] allFiles = { "Assets/" + filePathStr.Replace(Application.dataPath + "/", "") + "/" + fileNameStr.ToLower() };
                AddBuildMap(name, allFiles);
            }
        }
        AssetDatabase.Refresh();
    }
    //得到需要和预设打包到一起的图片
    static void GetNeedBundleTexture(string bundleName, List<string> prefabList)
    {
        bundleName = bundleName.ToLower();
        string[] str = { };
        string[] files = { };
        //找到和预设名字一致的文件夹
        string[] folders = Directory.GetDirectories("Assets/Textures/ui", "*" , SearchOption.TopDirectoryOnly);
        for (int i = 0; i < folders.Length; i++)
        {
            folders[i] = folders[i].Replace('\\', '/');
            str = folders[i].Split('/');
            if (str[str.Length - 1].ToLower() == bundleName)
            {
                files = Directory.GetFiles(folders[i], "*");
                for (int j = 0; j < files.Length; j++ )
                {
                    files[j] = files[j].Replace('\\', '/');
                    if (files[j].EndsWith(".png") || files[j].EndsWith(".jpg"))
                    {
                        if (!prefabList.Contains(files[j]))
                        {
                            prefabList.Add(files[j]);
                        }
                    }
                }
            }
        }
        //找到和预设名字一致的单独文件
        files = Directory.GetFiles("Assets/Textures/ui", "*.png", SearchOption.TopDirectoryOnly);
        for (int i = 0; i < files.Length; i++ )
        {
            files[i] = files[i].Replace('\\', '/');
            str = files[i].Replace(".png", "").Split('/');
            if (str[str.Length - 1].ToLower() == bundleName)
            {
                if (!prefabList.Contains(files[i]))
                {
                    prefabList.Add(files[i]);
                }
            }
        }
    }
    static void HandleConfigBundle()
    {
        //config路径下一个文件夹一个bundle，GameConfig.xml单独一个bundle,其余文件打成一个bundle

        string sourceDir = Application.dataPath + "/config/";
        string[] files = { };
        string filePathStr = "";
        string fileNameStr = "";
        string name = "";
        //打文件夹bundle
        string[] dirs = Directory.GetDirectories(sourceDir, "*", SearchOption.AllDirectories);
        for (int j = 0; j < dirs.Length; j++)
        {
            name = dirs[j].Replace(sourceDir, string.Empty);
            name = name.Replace('\\', '/');
            name = "config/" + name.ToLower();
            string path = "Assets" + dirs[j].Replace(Application.dataPath, "");
            path = path.Replace('\\', '/');
            string[] allFiles = Directory.GetFiles(path, "*.xml");
            if (allFiles.Length == 0) continue;

            for (int k = 0; k < allFiles.Length; k++)
            {
                allFiles[k] = allFiles[k].Replace('\\', '/');
            }
            AddBuildMap(name, allFiles);
        }
        //打文件夹外的bundle
        List<string> xmlList = new List<string>();
        files = Directory.GetFiles(sourceDir, "*.xml", SearchOption.TopDirectoryOnly);
        for (int j = 0; j < files.Length; j++)
        {
            filePathStr = Path.GetDirectoryName(files[j]);
            filePathStr = filePathStr.Replace('\\', '/');
            fileNameStr = Path.GetFileName(files[j]);
            //GameConfig.xml 单独一个bundle 其余打成一个bundel
            if (fileNameStr == "GameConfig.xml")
            {
                name = "config/GameConfig";
                string[] allFiles = { "Assets/config/GameConfig.xml" };
                AddBuildMap(name, allFiles);
            }
            else
            {
                xmlList.Add("Assets/" + filePathStr.Replace(Application.dataPath + "/", "") + "/" + fileNameStr.ToLower());
            }
        }
        AddBuildMap("config/config", xmlList.ToArray());
        AssetDatabase.Refresh();
    }
    static void HandleFontBundle()
    {
        //字体是一个文件一个bundle
        string sourceDir = Application.dataPath + "/font/";
        string[] files = { };
        string filePathStr = "";
        string fileNameStr = "";
        string name = "";
        files = Directory.GetFiles(sourceDir, "*", SearchOption.AllDirectories);
        
        for (int j = 0; j < files.Length; j++)
        {
            filePathStr = Path.GetDirectoryName(files[j]);
            filePathStr = filePathStr.Replace('\\', '/');
            fileNameStr = Path.GetFileName(files[j]);
            if (fileNameStr.EndsWith(".meta")) continue;
            name = "";
            if (fileNameStr.EndsWith(".fontsettings"))
            {
                name = filePathStr.Replace(Application.dataPath + "/", "") + "/" + fileNameStr.ToLower().Replace(".fontsettings", "");
            }
            else if (fileNameStr.EndsWith(".TTF"))
            {
                name = filePathStr.Replace(Application.dataPath + "/", "") + "/" + fileNameStr.ToLower().Replace(".TTF", "");
            }
            if (name == "") continue;
            string[] allFiles = { "Assets/" + filePathStr.Replace(Application.dataPath + "/", "") + "/" + fileNameStr.ToLower() };
            AddBuildMap(name, allFiles);
        }
        AssetDatabase.Refresh();
    }
    static void HandleDragonBoneBundle()
    {
        //DragonBone一个文件夹一个bundle
        string sourceDir = Application.dataPath + "/DragonBone/";
        string name = "";
        //打文件夹bundle
        string[] dirs = Directory.GetDirectories(sourceDir, "*", SearchOption.AllDirectories);
        for (int j = 0; j < dirs.Length; j++)
        {
            name = dirs[j].Replace(sourceDir, string.Empty);
            name = name.Replace('\\', '/');
            name = "DragonBone/" + name.ToLower();
            string path = "Assets" + dirs[j].Replace(Application.dataPath, "");
            path = path.Replace('\\', '/');
            string[] allFiles = Directory.GetFiles(path, "*");
            if (allFiles.Length == 0) continue;
            List<string> fontList = new List<string>();
            for (int k = 0; k < allFiles.Length; k++)
            {
                if (allFiles[k].EndsWith(".meta")) continue;
                allFiles[k] = allFiles[k].Replace('\\', '/');
                fontList.Add(allFiles[k]);
            }
            AddBuildMap(name, fontList.ToArray());
        }
        AssetDatabase.Refresh();
    }
    static void HandleTexturesBundle()
    {
        List<string> imgList = new List<string>();
        string name = "";
        string[] dirs = { };
        string[] files = { };
        //ui路径下需要打成一个bundle的文件夹
        string[] uiFolder = { };
        for (int j = 0; j < uiFolder.Length; j++)
        {
            name = uiFolder[j].ToLower();
            string path = "Assets/" + uiFolder[j];
            string[] allFiles = Directory.GetFiles(path, "*");
            if (allFiles.Length == 0) continue;
            imgList.Clear();
            for (int k = 0; k < allFiles.Length; k++)
            {
                allFiles[k] = allFiles[k].Replace('\\', '/');
                if (allFiles[k].EndsWith(".png") || allFiles[k].EndsWith(".jpg"))
                {
                    imgList.Add(allFiles[k]);
                }
            }
            AddBuildMap(name, imgList.ToArray());
        }

        //ui下需要单独打成一个bundle的图集
        string[] singleDirs = {};
        for (int j = 0; j < singleDirs.Length; j++)
        {
            name = singleDirs[j];
            string[] allFiles = { "Assets/" + singleDirs[j] + ".png" };
            AddBuildMap(name, allFiles);
        }


        //这些文件夹下一个文件夹一个bundle，不在文件夹的打成一个bundle
        string[] folderDirs = { };
        for (int i = 0; i < folderDirs.Length; i++)
        {
            string streamDir = Application.dataPath + "/" + folderDirs[i];
            dirs = Directory.GetDirectories(streamDir, "*", SearchOption.AllDirectories);
            for (int j = 0; j < dirs.Length; j++)
            {
                name = dirs[j].Replace(Application.dataPath + "/", string.Empty).Replace('\\', '/').ToLower();
                string path = "Assets" + dirs[j].Replace(Application.dataPath, "").Replace('\\', '/');

                string[] allFiles = Directory.GetFiles(path, "*");
                if (allFiles.Length == 0) continue;
                imgList.Clear();
                for (int k = 0; k < allFiles.Length; k++)
                {
                    allFiles[k] = allFiles[k].Replace('\\', '/');
                    if (allFiles[k].EndsWith(".png") || allFiles[k].EndsWith(".jpg"))
                    {
                        imgList.Add(allFiles[k]);
                    }
                }
                AddBuildMap(name, imgList.ToArray());
            }

            files = Directory.GetFiles(streamDir, "*");
            if (files.Length == 0) continue;
            imgList.Clear();
            for (int k = 0; k < files.Length; k++)
            {
                files[k] = "Assets" + files[k].Replace('\\', '/').Replace(Application.dataPath, "");
                if (files[k].EndsWith(".png") || files[k].EndsWith(".jpg"))
                {
                    imgList.Add(files[k]);
                }
            }
            AddBuildMap(folderDirs[i], imgList.ToArray());
        }
        //这些文件夹下一个文件一个bundle
        string[] singleDir = { };
        for (int i = 0; i < singleDir.Length; i++)
        {
            string sourceDir = Application.dataPath + "/" + singleDir[i];
            files = Directory.GetFiles(sourceDir, "*.png", SearchOption.AllDirectories);
            for (int j = 0; j < files.Length; j++)
            {
                string filePathStr = Path.GetDirectoryName(files[j]);
                filePathStr = filePathStr.Replace('\\', '/');
                string fileNameStr = Path.GetFileName(files[j]);
                name = filePathStr.Replace(Application.dataPath + "/", "") + "/" + fileNameStr.ToLower().Replace(".png", string.Empty);
                string[] allFiles = { "Assets/" + filePathStr.Replace(Application.dataPath + "/", "") + "/" + fileNameStr.ToLower() };
                AddBuildMap(name, allFiles);
            }
        }
        AssetDatabase.Refresh();
    }
    static void HandleSoundBundle()
    {
        //声音是一个文件一个bundle
        string sourceDir = Application.dataPath + "/Sound/bgm";
        string[] files = { };
        string filePathStr = "";
        string fileNameStr = "";
        string name = "";
        files = Directory.GetFiles(sourceDir, "*.mp3", SearchOption.AllDirectories);

        for (int j = 0; j < files.Length; j++)
        {
            filePathStr = Path.GetDirectoryName(files[j]);
            filePathStr = filePathStr.Replace('\\', '/');
            fileNameStr = Path.GetFileName(files[j]);
            if (fileNameStr.EndsWith(".meta")) continue;
            name = filePathStr.Replace(Application.dataPath + "/", "") + "/" + fileNameStr.ToLower().Replace(".mp3", "");
            if (name == "") continue;
            string[] allFiles = { "Assets/" + filePathStr.Replace(Application.dataPath + "/", "") + "/" + fileNameStr.ToLower() };
            AddBuildMap(name, allFiles);
        }
        AssetDatabase.Refresh();
    }
    static void AddBuildMap(string bundleName, string[] files)
    {
        AssetBundleBuild build = new AssetBundleBuild();
        build.assetBundleName = bundleName.ToLower() + ".unity3d";
        build.assetNames = files;
        maps.Add(build);
    }
    //copy 进度
    //加密成二进制文件
    public static void EncodeLuaFile(string srcFile, string outFile) {
        if (!srcFile.ToLower().EndsWith(".lua")) {
            File.Copy(srcFile, outFile, true);
            return;
        }
        bool isWin = true; 
        string luaexe = string.Empty;
        string args = string.Empty;
        string exedir = string.Empty;
        string currDir = Directory.GetCurrentDirectory();
        if (Application.platform == RuntimePlatform.WindowsEditor) {
            isWin = true;
            luaexe = "luajit.exe";
            args = "-b " + srcFile + " " + outFile;
            exedir = Application.dataPath;
#if UNITY_ANDROID
          exedir = exedir.Replace("Assets", "LuaEncoder/luajit32/"); 
#endif

#if UNITY_STANDALONE_WIN
          exedir = exedir.Replace("Assets", "LuaEncoder/luajit64/");
#endif
            
        } else if (Application.platform == RuntimePlatform.OSXEditor) {
            isWin = false;
            luaexe = "./luajit";
            args = "-b " + srcFile + " " + outFile;
            exedir = Application.dataPath;
			exedir = exedir.Replace("Assets", "LuaEncoder/luajit_mac/");
        }
        Directory.SetCurrentDirectory(exedir);
        ProcessStartInfo info = new ProcessStartInfo();
        info.FileName = luaexe;
        info.Arguments = args;
        info.WindowStyle = ProcessWindowStyle.Hidden;
        info.UseShellExecute = isWin;
        info.ErrorDialog = true;
        //UnityEngine.Debug.Log(info.FileName + " " + info.Arguments);

        Process pro = Process.Start(info);
        pro.WaitForExit();
		pro.Close ();
        Directory.SetCurrentDirectory(currDir);
    }


    /**
     * 生成bundle名和资源名的关联文件
     */
    [UnityEditor.MenuItem("Tools/Create AssetFile", false, 99)]
    static public void CreateBundleRelateFile()
    {
        AssetBundle mainBundle = AssetBundle.LoadFromFile(Application.streamingAssetsPath + "/StreamingAssets");

        //lua的bundle文件列表
        List<string> arrLuaFileName = new List<string>() { "lua/lua_script.unity3d" };

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
            if (i == arrStrBundle.Length - 1)
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