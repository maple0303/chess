using UnityEngine;
using UnityEditor;
using System.IO;
using System.Text;
using System.Diagnostics;
using System.Collections.Generic;
using System.Xml;
using System;

public class CTexturePackerEditor : Editor
{
    [MenuItem("Tools/TexturePacker/Create All SpriteSheet")]
    public static void CreateAllSpriteSheet()
    {
        //选择并设置TP命令行的参数和参数值
        //string commandText = " --sheet {0}.png --data {1}.tpsheet --format unity-texture2d --trim-mode None --pack-mode Best  --algorithm MaxRects --max-size 2048 --size-constraints POT  --disable-rotation --scale 1 {2}";
        //string inputPath = string.Format("{0}/Images", Application.dataPath);//小图目录
        ////string outputPath = string.Format("{0}/TexturePacker", Application.dataPath);//用TP打包好的图集存放目录
        //string[] imagePath = Directory.GetDirectories(inputPath);
        //for (int i = 0; i < imagePath.Length; i++)
        //{
        //    UnityEngine.Debug.Log(imagePath[i]);
        //    StringBuilder sb = new StringBuilder("");
        //    string[] fileName = Directory.GetFiles(imagePath[i]);
        //    for (int j = 0; j < fileName.Length; j++)
        //    {
        //        string extenstion = Path.GetExtension(fileName[j]);
        //        if (extenstion == ".png")
        //        {
        //            sb.Append(fileName[j]);
        //            sb.Append("  ");
        //        }
        //        UnityEngine.Debug.Log("fileName [j]:" + fileName[j]);
        //    }
        //    string name = Path.GetFileName(imagePath[i]);
        //    string outputName = string.Format("{0}/TexturePacker/{1}/{2}", Application.dataPath, name, name);
        //    string sheetName = string.Format("{0}/SheetsByTP/{1}", Application.dataPath, name);
        //    //执行命令行
        //    processCommand("C:\\Program Files (x86)\\CodeAndWeb\\TexturePacker\\bin\\TexturePacker.exe", string.Format(commandText, sheetName, sheetName, sb.ToString()));
        //}
        //List<string> pathList = new List<string>();
        ////pathList.Add("Assets/Textures/effect/skill");
        ////pathList.Add("Assets/Textures/npc");
        ////pathList.Add("Assets/Textures/ride");
        //pathList.Add("Assets/../TexturePacker_src/npc");
        ////pathList.Add("Assets/Textures/ui");
        //foreach (string strSheetPath in pathList)
        //{
        //    PackSpriteSheetForPath(strSheetPath);
        //}

        string[] arrFiles = Directory.GetFiles("TexturePacker_src/battlemap/", "*.jpg");
        foreach (string strFile in arrFiles)
        {
            string strSheetPath1 = strFile.Substring(0, strFile.LastIndexOf("."));
            UnityEngine.Debug.Log("file : " + strSheetPath1);
            string commandText = " --sheet {0}.png --data {1}.tpsheet --format unity-texture2d --trim-mode None --pack-mode Best  --algorithm MaxRects --max-size 2048 --size-constraints POT --force-squared --disable-rotation --scale 1 {2}";
            processCommand("C:\\Program Files (x86)\\CodeAndWeb\\TexturePacker\\bin\\TexturePacker.exe", string.Format(commandText, strSheetPath1, strSheetPath1, strFile));
        }
        
        AssetDatabase.Refresh();
    }
    private static void PackSpriteSheetForPath(string strSheetPath)
    { 
        // 判断是否有子文件夹
        string[] subPaths = Directory.GetDirectories(strSheetPath);
        if (subPaths.Length > 0)
        {
            foreach (string strSubPath in subPaths)
            {
                PackSpriteSheetForPath(strSubPath);
            }
        }
        else
        { 
            string commandText = " --sheet {0}.png --data {1}.tpsheet --format unity-texture2d --trim-mode None --pack-mode Best  --algorithm MaxRects --max-size 2048 --size-constraints POT --force-squared --disable-rotation --scale 1 {2}";
            processCommand("C:\\Program Files (x86)\\CodeAndWeb\\TexturePacker\\bin\\TexturePacker.exe", string.Format(commandText, strSheetPath, strSheetPath, strSheetPath));
        }
    }
    private static void processCommand(string command, string argument)
    {
        ProcessStartInfo start = new ProcessStartInfo(command);
        start.Arguments = argument;
        start.CreateNoWindow = false;
        start.ErrorDialog = true;
        start.UseShellExecute = false;

        if (start.UseShellExecute)
        {
            start.RedirectStandardOutput = false;
            start.RedirectStandardError = false;
            start.RedirectStandardInput = false;
        }
        else
        {
            start.RedirectStandardOutput = true;
            start.RedirectStandardError = true;
            start.RedirectStandardInput = true;
            start.StandardOutputEncoding = System.Text.UTF8Encoding.UTF8;
            start.StandardErrorEncoding = System.Text.UTF8Encoding.UTF8;
        }

        Process p = Process.Start(start);
        if (!start.UseShellExecute)
        {
            UnityEngine.Debug.Log(argument);
            UnityEngine.Debug.Log(p.StandardOutput.ReadToEnd());
            string strError = p.StandardError.ReadToEnd();
            if (strError != "")
            {
                UnityEngine.Debug.Log(strError);
            }
        }

        p.WaitForExit();
        p.Close();
    }
    [MenuItem("Tools/TexturePacker/Slice All SpriteSheet")]
    public static void SliceAllSpriteSheet()
    {
        string[] arrFiles = Directory.GetFiles("Assets/Textures", "*.tpsheet", SearchOption.AllDirectories);
        int n = 1;
        foreach (string strPath in arrFiles)
        {
            string strTpsheetPath = strPath.Replace("\\", "/");
            string assetPath = strTpsheetPath.Substring(0, strTpsheetPath.LastIndexOf(".")) + ".png";
            float value = n * 1.0f / arrFiles.Length;
            EditorUtility.DisplayProgressBar("slice process", assetPath, value);
            SliceTextureAtlas(assetPath, strTpsheetPath);
            n++;
        }
        EditorUtility.ClearProgressBar();
    }
    [MenuItem("Tools/TexturePacker/Slice Select SpriteSheet")]
    public static void SliceSelectSpriteSheet()
    {
        int n = 1;
        foreach (Texture2D tx2d in Selection.objects)
        {
            string assetPath = AssetDatabase.GetAssetPath(tx2d);
            float value = n * 1.0f / Selection.objects.Length;
            EditorUtility.DisplayProgressBar("slice process", assetPath, value);
            string strTpsheetPath = assetPath.Substring(0, assetPath.LastIndexOf(".")) + ".tpsheet";
            SliceTextureAtlas(assetPath, strTpsheetPath);
            n++;
        }
        EditorUtility.ClearProgressBar();
    }

    public static void SliceTextureAtlas(string assetPath, string strTpsheetPath)
    {
        TextureImporter txIpter = TextureImporter.GetAtPath(assetPath) as TextureImporter;
        if (txIpter == null)
        {
            return;
        }
        // 读取图集信息
        if (!File.Exists(strTpsheetPath))
        {
            return;
        }
        FileStream fs = new FileStream(strTpsheetPath, FileMode.Open);
        StreamReader sr = new StreamReader(fs);
        List<string> silceInfoList = new List<string>();
        while (!sr.EndOfStream)
        {
            string jText = sr.ReadLine();
            if (jText == "")
            {
                continue;
            }
            if (jText.StartsWith("#"))
            {
                continue;
            }
            silceInfoList.Add(jText);
        }
        fs.Close();
        sr.Close();

        // 加载锚点信息
        Dictionary<string, Vector3> dicPivotInfo = new Dictionary<string, Vector3>();
        string strPivotPath = assetPath.Substring(0, assetPath.LastIndexOf(".")) + ".tppivot";
        if (File.Exists(strPivotPath))
        {
            FileStream fsPivot = new FileStream(strPivotPath, FileMode.Open);
            StreamReader srPivot = new StreamReader(fsPivot);
            while (!srPivot.EndOfStream)
            {
                string jText = srPivot.ReadLine();
                if (jText == "")
                {
                    continue;
                }
                if (jText.StartsWith("#"))
                {
                    continue;
                }
                string[] arrValue = jText.Split(';');
                Vector3 pt = new Vector3();
                pt.x = float.Parse(arrValue[1]);
                pt.y = float.Parse(arrValue[2]);
                pt.z = float.Parse(arrValue[3]);
                dicPivotInfo[arrValue[0]] = pt;
            }
            srPivot.Close();
            fsPivot.Close();
        }

        SpriteMetaData[] metaData = new SpriteMetaData[silceInfoList.Count];
        for (int i = 0, size = silceInfoList.Count; i < size; i++)
        {
            string[] arrValue = silceInfoList[i].Split(';');
            Rect rect = new Rect();
            rect.x = int.Parse(arrValue[1]);
            rect.y = int.Parse(arrValue[2]);
            rect.width = int.Parse(arrValue[3]);
            rect.height = int.Parse(arrValue[4]);
            Vector2 pt = new Vector2();
            pt.x = float.Parse(arrValue[5]);
            pt.y = float.Parse(arrValue[6]);
            
            metaData[i].rect = rect;
            metaData[i].name = arrValue[0];
            metaData[i].alignment = (int)SpriteAlignment.Custom;
            string strActionName = metaData[i].name;
            //int nLastIndex = metaData[i].name.LastIndexOf("_");
            //if (nLastIndex != -1)
            //{
            //    strActionName = metaData[i].name.Substring(0, metaData[i].name.LastIndexOf("_"));
            //}
            if (dicPivotInfo.ContainsKey(strActionName))
            {
                if (dicPivotInfo[strActionName].z == 0)
                {
                    metaData[i].pivot.x = dicPivotInfo[strActionName].x / rect.width;
                    metaData[i].pivot.y = (rect.height - dicPivotInfo[strActionName].y) / rect.height;
                }
                else
                {
                    metaData[i].pivot.x = dicPivotInfo[strActionName].x;
                    metaData[i].pivot.y = dicPivotInfo[strActionName].y;
                }
            }
            else
            {
                metaData[i].pivot = pt;
            }
        }
        txIpter.spritesheet = metaData;
        txIpter.textureType = TextureImporterType.Sprite;
        txIpter.spriteImportMode = SpriteImportMode.Multiple;
        txIpter.mipmapEnabled = false;
        txIpter.SaveAndReimport();
    }
    [MenuItem("Tools/TexturePacker/Create Sprite pivot")]
    public static void CreateSpritePivot()
    {
        string[] pathlist = { "Assets/Textures/role/", "Assets/Textures/ride/", "Assets/Textures/npc/", "Assets/Textures/effect/skill/" };
        foreach( string strPath in pathlist)
        {
            string[] arrFiles = Directory.GetFiles(strPath, "*.png");
            foreach (string strPathFile in arrFiles)
            {
                TextureImporter txIpter = TextureImporter.GetAtPath(strPathFile) as TextureImporter;
                if (txIpter == null)
                {
                    continue;
                }
                EditorUtility.DisplayProgressBar("slice process", strPathFile,0);
                int nStartIndex = strPathFile.LastIndexOf("/") + 1;
                int nEndIndex = strPathFile.LastIndexOf(".");
                string strFileName = strPathFile.Substring(nStartIndex, nEndIndex - nStartIndex);
                string strPivotPath = strPathFile.Substring(0, strPathFile.LastIndexOf(".")) + ".tppivot";
                FileStream fsPivot = new FileStream(strPivotPath, FileMode.OpenOrCreate);
                StreamWriter swPivot = new StreamWriter(fsPivot);
                foreach (SpriteMetaData metaData in txIpter.spritesheet)
                {
                    swPivot.WriteLine(metaData.name + ";" + metaData.pivot.x + ";" + metaData.pivot.y + ";1");
                }
                swPivot.Close();
                fsPivot.Close();
            }
        }
        EditorUtility.ClearProgressBar();
        EditorUtility.DisplayDialog("成功", "生产锚点文件完成！", "确定");
    }
}