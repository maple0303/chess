using UnityEngine;
using System.Collections;
using System.Collections.Generic;
using System.Xml;

public class CLanguageData
{
    public static Dictionary<string, string> m_tplMap = new Dictionary<string, string>();
    public static Dictionary<string, string> m_languageMap = new Dictionary<string, string>();
    public static Dictionary<string, string> m_errorMap = new Dictionary<string, string>();
    public static Dictionary<string, string> m_configMap = new Dictionary<string, string>();   //config下含中文的配置文件中的文字
    public static Dictionary<string, string> m_taskMap = new Dictionary<string, string>();   //任务配置里面的文字

    public static void Initialize()
    {
        //加载模板文字
        TextAsset xmlAsset = CAssetManager.GetAsset("config/language/lang_tpl.xml", typeof(TextAsset)) as TextAsset; //Resources.Load<TextAsset>("config/language/lang_tpl");
        XmlDocument xmlDoc = new XmlDocument();
        xmlDoc.LoadXml(xmlAsset.text);

        XmlNode xmlData = xmlDoc.SelectSingleNode("/root/data");
        if (xmlData != null)
        {
            foreach (XmlElement dor in xmlData.ChildNodes)
            {
                m_tplMap.Add(dor.Attributes["id"].Value, dor.Attributes["str"].Value);
            }
        }

        //加载错误码
        //xmlAsset = Resources.Load<TextAsset>("config/language/errorcode");
        xmlAsset = CAssetManager.GetAsset("config/language/errorcode.xml", typeof(TextAsset)) as TextAsset;
        XmlDocument xmlDoc1 = new XmlDocument();
        xmlDoc1.LoadXml(xmlAsset.text);

        XmlNode xmlData1 = xmlDoc1.SelectSingleNode("/errorcode");
        if (xmlData1 != null)
        {
            foreach (XmlElement dor in xmlData1.ChildNodes)
            {
                if (!m_errorMap.ContainsKey(dor.Attributes["id"].Value))
                    m_errorMap.Add(dor.Attributes["id"].Value, dor.Attributes["text"].Value);
            }
        }

        ////加载任务文字
        //xmlAsset = Resources.Load<TextAsset>("config/language/task_txt");
        //XmlDocument xmlDoc2 = new XmlDocument();
        //xmlDoc2.LoadXml(xmlAsset.text);
        //XmlNode xmlData2 = xmlDoc2.SelectSingleNode("/data");
        //if (xmlData2 != null)
        //{
        //    foreach (XmlElement dor in xmlData2.ChildNodes)
        //    {
        //        m_taskMap.Add(dor.Attributes["id"].Value, dor.Attributes["str"].Value);
        //    }
        //}

        InitLanguageData();
        //InitConfigLanguage();
    }

    // 语言配置文件加载
    public static void InitLanguageData()
    {
        TextAsset xmlAsset = CAssetManager.GetAsset("config/language/languagedata.xml", typeof(TextAsset)) as TextAsset; //Resources.Load<TextAsset>("config/language/languagedata");
        XmlDocument xmlDoc1 = new XmlDocument();
        xmlDoc1.LoadXml(xmlAsset.text);

        XmlNode xmlData1 = xmlDoc1.SelectSingleNode("/data");
        if (xmlData1 != null)
        {
            foreach (XmlElement dor in xmlData1.ChildNodes)
            {
                if (!m_languageMap.ContainsKey(dor.Attributes["id"].Value))
                {
                    m_languageMap.Add(dor.Attributes["id"].Value, dor.Attributes["str"].Value);
                }
            }
        }
	}
    //加载配置文字
	public static void InitConfigLanguage()
	{
		TextAsset xmlAsset = Resources.Load<TextAsset>("config/language/config_txt");
        XmlDocument xmlDoc1 = new XmlDocument();
        xmlDoc1.LoadXml(xmlAsset.text);

        XmlNode xmlData1 = xmlDoc1.SelectSingleNode("/data");
        if (xmlData1 != null)
        {
            foreach (XmlElement dor in xmlData1.ChildNodes)
            {
                if (!m_configMap.ContainsKey(dor.Attributes["id"].Value))
                {
                    m_configMap.Add(dor.Attributes["id"].Value, dor.Attributes["str"].Value);
                }
            }
        }        
	}

    //获取语言文字
    public static string GetLanguageText(string strID)
    {
        if (m_languageMap.ContainsKey(strID))
        {
            return m_languageMap[strID];
        }
        return "";
    }

    //获取错误码信息
    public static string GetErrorCodeText(string strID)
    {
        if (m_errorMap.ContainsKey(strID))
        {
            return m_errorMap[strID];
        }
        return "";
    }
    //获取模板文字信息
    public static string GetTplText(string strID)
    {
        if (m_tplMap.ContainsKey(strID))
        {
            return m_tplMap[strID];
        }
        return "";
    }
	//获取配置文字信息
	public static string GetConfigText(string strID)
	{
        if (m_configMap.ContainsKey(strID))
        {
            return m_configMap[strID];
        }
        return "";
	}

    //获取任务文字信息
	public static string GetTaskText(string strID)
	{
        if (m_taskMap.ContainsKey(strID))
        {
            return m_taskMap[strID];
        }
        return "";
	}
}
