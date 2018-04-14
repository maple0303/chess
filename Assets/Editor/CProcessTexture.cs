using UnityEngine;
using UnityEditor;
using System.IO;
using System.Collections.Generic;

public class CProcessTexture : AssetPostprocessor
{
    void OnPostprocessTexture(Texture2D texture)
    {
        //Debug.Log("PostprocessTexture : " + assetPath);
        TextureImporter txIpter = assetImporter as TextureImporter;
        txIpter.mipmapEnabled = false;
        if (txIpter.spritesheet.Length > 0)
        {
            return;
        }
        // 读取图集信息
        string strTpsheetPath = assetPath.Substring(0, assetPath.LastIndexOf(".")) + ".tpsheet";
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
            fsPivot.Close();
            srPivot.Close();
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
    }
}