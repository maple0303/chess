using UnityEngine;
using System.Collections;
using System.Collections.Generic;
using System.Xml;
using System.IO;
using System.Text;

public class LuaXml
{
    public static string LoadXml(string strXmlPath)
    {
        //TextAsset xmlAsset = Resources.Load<TextAsset>(strXmlPath);
        TextAsset xmlAsset = CAssetManager.GetAsset(strXmlPath + ".xml", typeof(TextAsset)) as TextAsset;
        if (xmlAsset == null)
        {
            return "";
        }

        return LoadXmlForText(xmlAsset.text);
    }
    public static string LoadXmlForText(string strTextContent)
    {
        XmlDocument doc = new XmlDocument();
        doc.LoadXml(strTextContent);

        StringBuilder content = new StringBuilder();
        // 生成数据内容开头
        content.AppendLine("{");
        // 当前缩进量
        int currentLevel = 1;
        XmlElement root = doc.DocumentElement;   //获取根节点  
        //content.Append(GetNodeInfo(root, currentLevel, 0, true));
        content.Append(SetNodeInfo(root, currentLevel));
        content.AppendLine("}");
        string result = content.ToString();
        //try
        //{
        //    string savePath = Application.dataPath + "/Resources/" + strXmlPath + ".lua";
        //    StreamWriter writer = new StreamWriter(savePath, false, new UTF8Encoding(false));
        //    writer.Write(result);
        //    writer.Flush();
        //    writer.Close();
        //}
        //catch
        //{

        //}
        return result;
    }
    private static string SetNodeInfo(XmlNode node, int curLevel)
    {
        StringBuilder content = new StringBuilder();
        if (node != null)
        {
            //添加名称
            //设置缩进
            content.Append(GetLuaTableIndentation(curLevel));
            string strValue = string.Format("\"{0}\"", node.Name);
            content.Append(string.Format("{0} = {1},\n", "Name", strValue));

            //添加属性
            content.Append(GetLuaTableIndentation(curLevel));
            content.Append(string.Format("{0} = ", "Attributes") + "{ \n");
            content.Append(GetAttrbutesInfo(node, curLevel + 1));
            content.Append(GetLuaTableIndentation(curLevel));
            content.Append("},\n");

            //当前节点所有子对象
            content.Append(GetLuaTableIndentation(curLevel));
            content.Append("ChildNodes = { \n");
            curLevel ++;

            //文本内容
            //string textValue = "";
            string textValue = string.Format("\"{0}\"", "");
            XmlNodeList nodeList = node.ChildNodes;
            int index = 1;
            if (nodeList != null && nodeList.Count > 0)
            {
                foreach (XmlNode nodeChild in nodeList)
                {
                    //排除注释
                    if(nodeChild is XmlComment)
                    {
                        continue;
                    }
                    //添加子对象
                    if (!(nodeChild is XmlText))
                    {
                        content.Append(GetLuaTableIndentation(curLevel));

                        content.Append(string.Format("[{0}] = ", index) + "{ \n");

                        content.Append(GetLuaTableIndentation(curLevel));
                        content.Append(SetNodeInfo(nodeChild, curLevel));
                        content.Append(GetLuaTableIndentation(curLevel));
                        content.Append("},\n");

                        index++;
                    }
                    else
                    {
                        nodeChild.Value = nodeChild.Value.Replace("\n", "");
                        nodeChild.Value = nodeChild.Value.Replace("\r", "");
                        textValue = string.Format("\"{0}\"", nodeChild.Value);
                    }
                }
            }
            content.Append(GetLuaTableIndentation(curLevel - 1));
            content.Append("}, \n");

            //添加文本内
            //设置缩进
            content.Append(GetLuaTableIndentation(curLevel - 1));
            content.Append(string.Format("{0} = {1},\n", "InnerText", textValue));
        }
        return content.ToString(); 
    }
    private static string GetLuaTableIndentation(int level)
    {
        StringBuilder stringBuilder = new StringBuilder();
        for (int i = 0; i < level; ++i)
        {
            stringBuilder.Append("\t");
        }
        return stringBuilder.ToString();
    }

    //获取属性信息
    private static string GetAttrbutesInfo(XmlNode node, int curLevel)
    {
        StringBuilder content = new StringBuilder();

        if (node != null && node.Attributes.Count > 0)
        {
            XmlAttributeCollection attrbutes = node.Attributes;
            for (int i = 0; i < attrbutes.Count; ++i)
            {
                XmlAttribute attrbute = attrbutes[i];
                string strName = attrbute.Name;
                string strValue = attrbute.Value;
                content.Append(GetLuaTableIndentation(curLevel));
                strValue = string.Format("\"{0}\"", strValue);
                content.Append(string.Format("{0} = {1},\n", strName, strValue));
            }
        }
        return content.ToString();
    }
}
