using UnityEditor;
using UnityEngine;
using System;
using System.IO;
using System.Text;
using System.Diagnostics;
using System.Collections;
using System.Collections.Generic;

public class CUpdate : EditorWindow
{
    static private string mLocalCacheUrl = "";      //"C:/Users/Administrator/Desktop/tmp.txt";
    static private string mScanUrl = "C:/Users/Administrator/Desktop/Temp/";        //扫描目录
    static private Dictionary<string, string[]> mCurFileDic = new Dictionary<string, string[]>();       //游戏资源所有文件列表
    static private Dictionary<string, string[]> dicCurDiffFiles = new Dictionary<string, string[]>();   //更新文件，差异列表
    static private bool m_bPackage = true;      //是否压缩包更新
    static private string strMsgOutPut = "";    //输出日志
    static private uint m_nCurVer = 1;          //更新前版本
    static private uint m_nPkgVer = 1;          //更新前压缩包版本
    static private string m_strUpdateType = "";
    static private string m_strUpdateSize = "";

    [UnityEditor.MenuItem("Tools/Update", false, 100)]
    static public void CreateUpdateRes()
    {
        CUpdate window = (CUpdate)EditorWindow.GetWindow(typeof(CUpdate));
        window.Show();
    }

    void OnGUI()
    {
        mLocalCacheUrl = Application.temporaryCachePath + "VersionPath.txt";

        if (File.Exists(mLocalCacheUrl))
        {
            mScanUrl = File.ReadAllText(mLocalCacheUrl);
        }
        if (!Directory.Exists(mScanUrl))
        {
            mScanUrl = "";
        }

        EditorGUILayout.BeginVertical();

        GUILayout.Label("输出日志", EditorStyles.boldLabel);
        EditorGUILayout.BeginScrollView(new Vector2(0, 0), GUILayout.Width(300), GUILayout.Height(80));
        EditorGUILayout.TextArea(strMsgOutPut, GUILayout.Width(300), GUILayout.Height(80));
        EditorGUILayout.EndScrollView();

        EditorGUILayout.Space();
        GUILayout.Label("选择目录", EditorStyles.boldLabel);
        EditorGUILayout.BeginHorizontal();
        if (GUILayout.Button("选择目录", GUILayout.Width(65), GUILayout.Height(35)))
        {
            OnSelectScanDirectory();
        }
        GUILayout.Label(mScanUrl);
        EditorGUILayout.EndHorizontal();
        EditorGUILayout.Space();

        EditorGUILayout.BeginToggleGroup("更新方式", true);
        m_bPackage = EditorGUILayout.Toggle("打包", m_bPackage);
        m_bPackage = !EditorGUILayout.Toggle("单文件", !m_bPackage);
        EditorGUILayout.EndToggleGroup();

        EditorGUILayout.EndVertical();
        EditorGUILayout.Space();
        if (GUILayout.Button("Start", GUILayout.Width(75), GUILayout.Height(45)))
        {
            Start();
        }
    }

    static private void OnSelectScanDirectory()
    {
        mScanUrl = EditorUtility.OpenFolderPanel("选择扫描文件夹", "", "");
        File.WriteAllText(mLocalCacheUrl, mScanUrl);
    }

    //开始做更新版本
    static private void Start()
    {
        //获取当前版本信息
        GetCurVerInfo();

        //获取各个版本更新方式和需要更新文件的大小
        GetUpdateSizeType();

        //拷贝文件到更新资源文件夹
        StartCopyFiles();

        //生成更新版本文件
        bool bSuccess = CreateVersionUpdateRes();
        if (!bSuccess)
        {
            return;
        }

        //刷新更新版本号文件数据
        UpdateVerFileInfo();

        EditorUtility.DisplayDialog("成功", "更新完成！", "确定");
    }

    //拷贝文件到更新资源文件夹
    static private void StartCopyFiles()
    {
        string AppDataPath = Application.dataPath + "/StreamingAssets/";
        string curFileList = GetFileList(AppDataPath);
        string strTargetUrl = mScanUrl + "/Res/";

        if (!Directory.Exists(strTargetUrl))
        {
            Directory.CreateDirectory(strTargetUrl);
        }
        //先清空Res文件夹
        DirectoryInfo dir = new DirectoryInfo(strTargetUrl);

        FileSystemInfo[] fileinfo = dir.GetFileSystemInfos();  //返回目录中所有文件和子目录
        foreach (FileSystemInfo i in fileinfo)
        {
            if (i is DirectoryInfo)            //判断是否文件夹
            {
                DirectoryInfo subdir = new DirectoryInfo(i.FullName);
                subdir.Delete(true);          //删除子目录和文件
            }
            else
            {
                File.Delete(i.FullName);      //删除指定文件
            }
        }

        mCurFileDic = new Dictionary<string, string[]>();
        string folderName = "";
        string[] fileArr = curFileList.Split('\n');
        for (int i = 0; i < fileArr.Length; i++)
        {
            if (string.IsNullOrEmpty(fileArr[i]))
            {
                continue;
            }
            string[] fileData = fileArr[i].Split('|');
            string fileUrl = fileData[0];
            string md5 = fileData[1];
            string size = fileData[2];
            mCurFileDic.Add(fileUrl, new string[] { md5, size });

            folderName = Path.GetDirectoryName(strTargetUrl + fileUrl);
            if (!Directory.Exists(folderName))
            {
                Directory.CreateDirectory(folderName);
            }
            File.Copy(AppDataPath + fileUrl, strTargetUrl + fileUrl);
        }

        //生成md5文件列表
        byte[] bytArr = Utils.StringToByteArray(curFileList);
        string strFileUrl = GetMd5Url(m_nCurVer);
        folderName = Path.GetDirectoryName(strFileUrl);
        if (!Directory.Exists(folderName))
        {
            Directory.CreateDirectory(folderName);
        }
        FileStream fs = File.Create(strFileUrl);
        string folderUrl = Path.GetDirectoryName(strFileUrl);
        if (!Directory.Exists(folderUrl))
        {
            Directory.CreateDirectory(folderUrl);
        }
        fs.Write(bytArr, 0, bytArr.Length);
        fs.Close();
    }

    static private void GetUpdateSizeType()
    {
        string strSizeUrl = mScanUrl + "/upgrade/size.txt";
        string strInfo = "|";
        if (File.Exists(strSizeUrl))
        {
            strInfo = File.ReadAllText(strSizeUrl);
        }
        string[] strArr = strInfo.Split('|');
        m_strUpdateType = strArr[0];
        m_strUpdateSize = strArr[1];

        int nType = 0;
        if (m_bPackage)
        {
            nType = (int)EnumUpdateType.emUpdateType_Package;
        }
        else
        {
            nType = (int)EnumUpdateType.emUpdateType_SingleFile;
        }
        if (string.IsNullOrEmpty(m_strUpdateType))
        {
            m_strUpdateType = nType.ToString();
        }
        else
        {
            m_strUpdateType += ("." + nType);
        }
    }

    //获取当前版本信息
    static private void GetCurVerInfo()
    {
        string strVerUrl = mScanUrl + "/upgrade/ver.txt";
        if (!File.Exists(strVerUrl))
        {
            m_nCurVer = 1;
            m_nPkgVer = 1;
        }
        else
        {
            string str = File.ReadAllText(strVerUrl);
            string[] arrStr = str.Split('\n');
            for (int i = 0; i < arrStr.Length; i++)
            {
                string[] arr = arrStr[i].Split(':');
                string name = arr[0];
                uint nVer = uint.Parse(arr[1]);
                if (name == "ver")
                {
                    m_nCurVer = nVer;
                }
                else if (name == "pkgVer")
                {
                    m_nPkgVer = nVer;
                }
            }
            m_nCurVer++;
            if (m_bPackage)
            {
                m_nPkgVer++;
            }
        }
    }

    //生成更新版本文件
    static private bool CreateVersionUpdateRes()
    {
        if (m_nCurVer == 1)
        {
            return true;
        }

        //上个版本文件列表
        string strFileUrl = GetMd5Url(m_nCurVer - 1);
        string strLastVerFilesInfo = File.ReadAllText(strFileUrl);

        string[] fileArr = strLastVerFilesInfo.Split('\n');
        Dictionary<string, string> dicLastVerFiles = new Dictionary<string, string>();
        for (int i = 0; i < fileArr.Length; i++)
        {
            if (string.IsNullOrEmpty(fileArr[i]))
            {
                continue;
            }
            string[] fileData = fileArr[i].Split('|');
            dicLastVerFiles.Add(fileData[0], fileData[1]);
        }

        string strDiffFilesInfo = m_nCurVer.ToString() + "\n";
        //获取差异文件列表
        dicCurDiffFiles = new Dictionary<string, string[]>();
        foreach (var pairs in mCurFileDic)
        {
            if (dicLastVerFiles.ContainsKey(pairs.Key) == false)
            {
                dicCurDiffFiles.Add(pairs.Key, pairs.Value);
                strDiffFilesInfo += (pairs.Key + "\n");
            }
            else
            {
                string strMd5 = dicLastVerFiles[pairs.Key];
                if (strMd5.Equals(pairs.Value[0]) == false)
                {
                    dicCurDiffFiles.Add(pairs.Key, pairs.Value);
                    strDiffFilesInfo += (pairs.Key + "\n");
                }
            }
        }
        if (dicCurDiffFiles.Count == 0)
        {
            EditorUtility.DisplayDialog("警告", "没有差异文件，无法创建新的版本！", "确定");
            return false;
        }

        //保存差异文件信息
        strFileUrl = GetDownloadFileUrl(m_nCurVer);
        string folderUrl = Path.GetDirectoryName(strFileUrl);
        if (!Directory.Exists(folderUrl))
        {
            Directory.CreateDirectory(folderUrl);
        }
        File.WriteAllText(strFileUrl, strDiffFilesInfo);

        int nUpdateSize = 0;    //更新资源大小
        //需要打包
        if (m_bPackage)
        {
            string strPkgUrl = PackageUrl + "package" + (m_nPkgVer - 1) + "/pkg.bytes";
            folderUrl = Path.GetDirectoryName(strPkgUrl);
            if (!Directory.Exists(folderUrl))
            {
                Directory.CreateDirectory(folderUrl);
            }

            //更新文件都写入到包中
            FileStream fs = File.Create(strPkgUrl);
            int nOffset = 0;
            foreach (var pairs in dicCurDiffFiles)
            {
                //文件名长度(16进制)
                byte[] nameByt = Utils.StringToByteArray(pairs.Key);
                byte[] bytesArr = Utils.StringToByteArray(nameByt.Length.ToString("X2"));//十进制的话，由于位数不同，字节数也不同，读取比较麻烦，所以统一转成换2位的16进制
                fs.Write(bytesArr, 0, bytesArr.Length);
                nOffset += bytesArr.Length;

                //文件名
                fs.Write(nameByt, 0, nameByt.Length);
                nOffset += nameByt.Length;

                //文件大小
                byte[] fileByt = File.ReadAllBytes(mScanUrl + "/Res/" + pairs.Key);
                byte[] sizeByt = Utils.StringToByteArray(fileByt.Length.ToString("X8"));
                fs.Write(sizeByt, 0, sizeByt.Length);
                nOffset += sizeByt.Length;

                //文件
                fs.Write(fileByt, 0, fileByt.Length);
                nOffset += fileByt.Length;
            }
            nUpdateSize = (int)fs.Length;
            fs.Close();
        }
        else
        {
            foreach (var pairs in dicCurDiffFiles)
            {
                //文件大小
                byte[] fileByt = File.ReadAllBytes(mScanUrl + "/Res/" + pairs.Key);
                nUpdateSize += fileByt.Length;
            }
        }

        //刷新更新文件大小信息
        if (string.IsNullOrEmpty(m_strUpdateSize))
        {
            m_strUpdateSize = nUpdateSize.ToString();
        }
        else
        {
            m_strUpdateSize += ("." + nUpdateSize);
        }
        if (m_nCurVer > 1)
        {
            //刷新更新方式和更新文件大小
            SaveUpdateSizeType();
        }

        //string url = mScanUrl + "/md5/files_" + m_nCurVer + ".txt";
        //strLastVerFilesInfo = File.ReadAllText(url);

        //fileArr = strLastVerFilesInfo.Split('\n');
        //Dictionary<string, string> dicTargetFiles = new Dictionary<string, string>();
        //for (int i = 0; i < fileArr.Length; i++)
        //{
        //    if (string.IsNullOrEmpty(fileArr[i]))
        //    {
        //        continue;
        //    }
        //    string[] fileData = fileArr[i].Split('|');
        //    dicTargetFiles.Add(fileData[0], fileData[1]);
        //}

        uint nVer = m_nCurVer - 2;
        while (nVer > 0)
        {
            CreateDiffFilesList(nVer);
            nVer--;
        }


        //解压包测试代码
        //nOffset = 0;
        //fs = new FileStream(mScanUrl + "pkg.bytes", FileMode.Open, FileAccess.Read);
        //while (fs.Position < fs.Length)
        //{
        //    //读到文件名的字节大小
        //    byte[] bytArr = new byte[2];
        //    fs.Read(bytArr, 0, 2);
        //    string strSize = Utils.ByteToString(bytArr);
        //    int nSize = Convert.ToInt32(strSize, 16);
        //    nOffset += 2;

        //    //文件名
        //    bytArr = new byte[nSize];
        //    fs.Read(bytArr, 0, nSize);
        //    string strFileName = Utils.ByteToString(bytArr);

        //    //文件大小(字节长度)
        //    bytArr = new byte[8];
        //    fs.Read(bytArr, 0, 8);
        //    strSize = Utils.ByteToString(bytArr);
        //    nSize = Convert.ToInt32(strSize, 16);
        //    nOffset += 8;

        //    //文件
        //    bytArr = new byte[nSize];
        //    fs.Read(bytArr, 0, nSize);

        //    string url = mOutPutUrl + strFileName;
        //    string folderUrl = Path.GetDirectoryName(url);
        //    if (!Directory.Exists(folderUrl))
        //    {
        //        Directory.CreateDirectory(folderUrl);
        //    }
        //    File.WriteAllBytes(url, bytArr);
        //}
        return true;
    }

    //生成差异文件列表
    static private void CreateDiffFilesList(uint nVer)
    {
        int nTotalSize = 0;
        EnumUpdateType emUpdateType = GetUpdateType(nVer);
        if (emUpdateType == EnumUpdateType.emUpdateType_Package)
        {
            uint nBeginVer = nVer;
            while (nBeginVer < m_nCurVer)
            {
                EnumUpdateType emType = GetUpdateType(nBeginVer);
                if (emType == EnumUpdateType.emUpdateType_Package)
                {
                    int nSize = GetUpdateSize(nBeginVer);
                    nTotalSize += nSize;
                    nBeginVer++;
                }
                else
                {
                    int nSize = GetUpdateSize(nBeginVer);
                    nTotalSize += nSize;
                    string strDownloadInfo = File.ReadAllText(mScanUrl + "/upgrade/single/downloadList_" + nBeginVer + ".txt");
                    string[] arr = strDownloadInfo.Split('\n');
                    nBeginVer = uint.Parse(arr[0]);
                }
            }
            //修改更新文件大小
            UpdateSize(nVer, nTotalSize);
            return;
        }

        uint nCompareVer = m_nCurVer;
        for (uint i = nVer + 1; i < m_nCurVer; i++)
        {
            EnumUpdateType emType = GetUpdateType(i);
            if (emType == EnumUpdateType.emUpdateType_Package)
            {
                nCompareVer = i;
                break;
            }
        }
        if (nVer == nCompareVer)
        {
            return;
        }

        string strCurFilesInfo = File.ReadAllText(mScanUrl + "/md5/files_" + nVer + ".txt");
        string strCompareFilesInfo = File.ReadAllText(mScanUrl + "/md5/files_" + nCompareVer + ".txt");

        string[] fileArr = strCurFilesInfo.Split('\n');
        Dictionary<string, string[]> dicCurFiles = new Dictionary<string, string[]>();
        for (int i = 0; i < fileArr.Length; i++)
        {
            if (string.IsNullOrEmpty(fileArr[i]))
            {
                continue;
            }
            string[] fileData = fileArr[i].Split('|');
            dicCurFiles.Add(fileData[0], new string[] { fileData[1], fileData[2] });
        }

        fileArr = strCompareFilesInfo.Split('\n');
        Dictionary<string, string[]> dicCompareFiles = new Dictionary<string, string[]>();
        for (int i = 0; i < fileArr.Length; i++)
        {
            if (string.IsNullOrEmpty(fileArr[i]))
            {
                continue;
            }
            string[] fileData = fileArr[i].Split('|');
            dicCompareFiles.Add(fileData[0], new string[] { fileData[1], fileData[2] });
        }

        //生成差异文件列表
        Dictionary<string, string[]> dicDiffFiles = new Dictionary<string, string[]>();
        foreach (var pairs in dicCompareFiles)
        {
            if (dicCurFiles.ContainsKey(pairs.Key) == false)
            {
                dicDiffFiles.Add(pairs.Key, pairs.Value);
            }
            else
            {
                string[] arr = dicCurFiles[pairs.Key];
                string strMd5 = arr[0];
                if (strMd5.Equals(pairs.Value[0]) == false)
                {
                    dicDiffFiles.Add(pairs.Key, pairs.Value);
                }
            }
        }

        nTotalSize = 0;  //更新包大小(字节数)
        if (nCompareVer != m_nCurVer)
        {
            foreach (var pairs in dicDiffFiles)
            {
                //如果最新的版本中没有这个文件，则从差异列表中删除，避免更新无用文件
                if (!mCurFileDic.ContainsKey(pairs.Key))
                {
                    dicDiffFiles.Remove(pairs.Key);
                    continue;
                }
                //最新更新包中有这个资源，则从差异列表中删除，避免重复更新资源
                if (dicCurDiffFiles.ContainsKey(pairs.Key))
                {
                    dicDiffFiles.Remove(pairs.Key);
                }
            }
            uint nBeginVer = nCompareVer;
            while (nBeginVer < m_nCurVer)
            {
                EnumUpdateType emType = GetUpdateType(nBeginVer);
                if (emType == EnumUpdateType.emUpdateType_Package)
                {
                    int nSize = GetUpdateSize(nBeginVer);
                    nTotalSize += nSize;
                    nBeginVer++;
                }
                else
                {
                    int nSize = GetUpdateSize(nBeginVer);
                    nTotalSize += nSize;
                    string strDownloadInfo = File.ReadAllText(mScanUrl + "/upgrade/single/downloadList_" + nBeginVer + ".txt");
                    string[] arr = strDownloadInfo.Split('\n');
                    nBeginVer = uint.Parse(arr[0]);
                }
            }
        }

        string strFileList = nCompareVer.ToString() + "\n";
        foreach (var pairs in dicDiffFiles)
        {
            if (dicCurFiles.ContainsKey(pairs.Key) == false)
            {
                strFileList += (pairs.Key + "\n");
                string[] arr = dicDiffFiles[pairs.Key];
                int nSize = int.Parse(arr[1]);
                nTotalSize += nSize;
            }
            else
            {
                string[] arr = dicCurFiles[pairs.Key];
                int nSize = int.Parse(arr[1]);
                string strMd5 = arr[0];
                if (strMd5.Equals(pairs.Value[0]) == false)
                {
                    strFileList += (pairs.Key + "\n");
                    nTotalSize += nSize;
                }
            }
        }

        //写文件
        File.WriteAllText(mScanUrl + "/upgrade/single/downloadList_" + nVer + ".txt", strFileList);

        //修改更新文件大小
        UpdateSize(nVer, nTotalSize);
    }

    //刷新更新版本号文件数据
    static private void UpdateVerFileInfo()
    {
        string strVerInfo = "ver:" + m_nCurVer + "\n" + "pkgVer:" + m_nPkgVer;
        string fileUrl = mScanUrl + "/upgrade/ver.txt";
        string folderName = Path.GetDirectoryName(fileUrl);
        if (!Directory.Exists(folderName))
        {
            Directory.CreateDirectory(folderName);
        }
        File.WriteAllText(fileUrl, strVerInfo);
    }

    static private void UpdateSize(uint nVer, int nSize)
    {
        string[] arr = m_strUpdateSize.Split('.');
        arr[nVer - 1] = nSize.ToString();
        m_strUpdateSize = "";
        for (int i = 0; i < arr.Length; i++)
        {
            if (i != arr.Length - 1)
            {
                m_strUpdateSize += arr[i] + ".";
            }
            else
            {
                m_strUpdateSize += arr[i];
            }
        }
        SaveUpdateSizeType();
    }

    static private void SaveUpdateSizeType()
    {
        string strInfo = m_strUpdateType + "|" + m_strUpdateSize;
        File.WriteAllText(mScanUrl + "/upgrade/size.txt", strInfo);
    }


    //获取bundle文件列表
    static private string GetFileList(string resPath)
    {
        List<string> files = new List<string>();
        AddFilesToList(resPath, files);

        string strFileList = "";
        for (int i = 0; i < files.Count; i++)
        {
            string file = files[i];
            if (file.EndsWith(".meta") || file.Contains(".DS_Store") || file.Contains(".tpsheet"))
            {
                continue;
            }

            string md5 = Utils.md5file(file);
            string value = file.Replace(resPath, string.Empty);
            string size = File.ReadAllBytes(file).Length.ToString();
            strFileList += (value + "|" + md5 + "|" + size + "\n");
        }
        return strFileList;
    }
    // 遍历目录及其子目录
    static private void AddFilesToList(string path, List<string> files)
    {
        string[] names = Directory.GetFiles(path);
        string[] dirs = Directory.GetDirectories(path);
        foreach (string filename in names)
        {
            string ext = Path.GetExtension(filename);
            if (ext.Equals(".meta"))
            {
                continue;
            }
            files.Add(filename.Replace('\\', '/'));
        }
        foreach (string dir in dirs)
        {
            AddFilesToList(dir, files);
        }
    }
    //打包文件目录
    static private string PackageUrl
    {
        get
        {
            return mScanUrl + "/upgrade/package/";
        }
    }

    static private string GetMd5Url(uint nVer)
    {
        return mScanUrl + "/md5/files_" + nVer + ".txt";
    }

    static private string GetDownloadFileUrl(uint nVer)
    {
        return mScanUrl + "/upgrade/single/downloadList_" + (nVer - 1) + ".txt";
    }

    static private EnumUpdateType GetUpdateType(uint nVer)
    {
        uint nIndex = nVer - 1;
        string[] arr = m_strUpdateType.Split('.');
        int nType = int.Parse(arr[nIndex]);
        return (EnumUpdateType)nType;
    }
    static private int GetUpdateSize(uint nVer)
    {
        uint nIndex = nVer - 1;
        string[] arr = m_strUpdateSize.Split('.');
        int nSize = int.Parse(arr[nIndex]);
        return nSize;
    }
    //输出信息
    static private void ShowMsg(string msg)
    {
        strMsgOutPut += msg + "\n";
    }
}