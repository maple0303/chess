﻿using UnityEngine;
using System.Collections.Generic;
using UnityEditor;
using System.IO;
using System.Xml;

public class BMFont
{
    [MenuItem("Tools/Font")]
    static void CreateFont()
    {
        DirectoryInfo dictorys = new DirectoryInfo("Assets/config/Font/");
        FileInfo[] arrFiles = dictorys.GetFiles("*.fnt");
        foreach(FileInfo fileInfo in arrFiles)
        {
            string fontName = fileInfo.Name.Substring(0, fileInfo.Name.LastIndexOf(".fnt"));;  //字体名称

            Material mtr = AssetDatabase.LoadAssetAtPath<Material>("Assets/materials/Font/" + fontName + ".mat");//Resources.Load<Material>("materials/Font/" + fontName); //把我们创建的材质球加载进来
            if(mtr == null)
            {
                //没有创建的话，自动创建一个空的材质球
                mtr = new Material(Shader.Find("Sprites/Default"));
                AssetDatabase.CreateAsset(mtr, "Assets/materials/Font/" + fontName + ".mat");
            }

            Texture2D texture = AssetDatabase.LoadAssetAtPath<Texture2D>("Assets/Textures/font/" + fontName + ".png");//Resources.Load<Texture2D>("images/Font/" + fontName); //把我们在位图制作工具生成的图片加载进来
            //mtr.SetTexture(0, texture);//把图片赋给材质球
            mtr.mainTexture = texture;

            if(texture == null)
            {
                MonoBehaviour.print("没有找到对应的图片！！" + "Textures/font/" + fontName);
                continue;
            }

            string fontUrl = "Assets/font/" + fontName + ".fontsettings";
            Font font = AssetDatabase.LoadAssetAtPath<Font>(fontUrl);//AssetDatabase.LoadAssetAtPath(fontUrl, typeof(Font)) as Font; //把我们创建的字体加载进来
            if(font == null)
            {
                font = new Font();
                font.material = mtr;
                AssetDatabase.CreateAsset(font, fontUrl);
            }
            XmlDocument xml = new XmlDocument();
            xml.Load(Application.dataPath + "/config/Font/" + fontName + ".fnt");//这是在BMFont里得到的那个.fnt文件,因为是xml文件，所以我们就用xml来解析
            List<CharacterInfo> chtInfoList = new List<CharacterInfo>();
            XmlNode node = xml.SelectSingleNode("font/chars");
            foreach (XmlNode nd in node.ChildNodes)
            {
                XmlElement xe = (XmlElement)nd;
                int x = int.Parse(xe.GetAttribute("x"));
                int y = int.Parse(xe.GetAttribute("y"));
                int width = int.Parse(xe.GetAttribute("width"));
                int height = int.Parse(xe.GetAttribute("height"));
                int advance = int.Parse(xe.GetAttribute("xadvance"));
                CharacterInfo chtInfo = new CharacterInfo();
                float texWidth = texture.width;
                float texHeight = texture.width;

                chtInfo.glyphHeight = texture.height;
                chtInfo.glyphWidth = texture.width;
                chtInfo.index = int.Parse(xe.GetAttribute("id"));
                //这里注意下UV坐标系和从BMFont里得到的信息的坐标系是不一样的哦，前者左下角为（0,0），
                //右上角为（1,1）。而后者则是左上角上角为（0,0），右下角为（图宽，图高）
                chtInfo.uvTopLeft = new Vector2((float)x / texture.width, 1 - (float)y / texture.height);
                chtInfo.uvTopRight = new Vector2((float)(x + width) / texture.width, 1 - (float)y / texture.height);
                chtInfo.uvBottomLeft = new Vector2((float)x / texture.width, 1 - (float)(y + height) / texture.height);
                chtInfo.uvBottomRight = new Vector2((float)(x + width) / texture.width, 1 - (float)(y + height) / texture.height);

                chtInfo.minX = 0;
                chtInfo.minY = -height;
                chtInfo.maxX = width;
                chtInfo.maxY = 0;

                chtInfo.advance = advance;

                chtInfoList.Add(chtInfo);
            }
            font.characterInfo = chtInfoList.ToArray();

            MonoBehaviour.print(fontName + "字体生成成功！");
        }
        AssetDatabase.Refresh();

        //EditorUtility.DisplayDialog("成功", fontName + "字体生成成功！", "确定");
    }
}