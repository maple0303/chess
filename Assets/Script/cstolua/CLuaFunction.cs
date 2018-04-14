
using LuaInterface;
using System;
using System.IO;
using UnityEngine;
public class CLuaFunction
{
    public static string LoadXml(string strXmlPath)
    {
        return LuaXml.LoadXml(strXmlPath);
    }
    public static string LoadXmlForText(string strTextContent)
    {
        return LuaXml.LoadXmlForText(strTextContent);
    }
    public static void LogWarning(object str)
    {
        Debugger.LogWarning(str);
    }
    public static void Log(object str)
    {
        Debugger.Log(str);
    }
    public static void LogError(object str)
    {
        Debugger.LogError(str);
    }
    //判断是否存在某个lua文件
    public static bool LuaFileExists(string path)
    {
        if (File.Exists(Application.dataPath + "/Script/Lua/" + path))
        {
            return true;
        }
        if (File.Exists(AppConst.DataPath + "/LuaScript/" + path))
        {
            return true;
        }
        //Debug.Log("判断存在文件路径  " + AppConst.DataPath + "lua/" + path);
        //Debug.Log(File.Exists(AppConst.DataPath + "lua/" + path));
        //Debug.Log(File.Exists(AppConst.DataPath + "lua/" + path + ".bytes"));
        if (File.Exists(AppConst.DataPath + "lua/" + path))
        {
            return true;
        }
        if (LuaFileUtils.Instance.ReadFile(path) != null)
        {
            return true;
        }
		Debug.Log("无次文件  " + AppConst.DataPath + "lua/" + path);
        return false;
    }
    //创建目录
    public static void CreateDirectory(string path)
    {
        Directory.CreateDirectory(path);
    }

    //判断目录是否存在
    public static bool DirectoryExists(string path)
    {
        return Directory.Exists(path);
    }

    //判断文件是否存在
    public static bool FileExists(string fileName)
    {
        return File.Exists(fileName);
    }

    //删除指定文件
    public static void DeleteFile(string fileName)
    {
        File.Delete(fileName);
    }

    //读取文本文件的所有内容
    public static string FileReadAllText(string fileName)
    {
        return File.ReadAllText(fileName);
    }

    //将字节数据写入到文件，存到指定路径
    public static void WriteAllBytes(string path, byte[] bytes)
    {
        File.WriteAllBytes(path, bytes);
    }

    //创建新文件，写入指定字符串
    public static void WriteAllText(string path, string contents)
    {
        File.WriteAllText(path, contents);
    }

    //通过数据流写入数据
    public static void WriteBytesByFileStream(string path, byte[] bytes)
    {
        FileStream outStream = File.Create(path);
        outStream.Write(bytes, 0, bytes.Length);
    }

    //解压更新文件到指定目录下
    public static void UnpackUpdateFile(string strTempFileUrl, string strTargetDir)
    {
        int nOffset = 0;
        FileStream fs = new FileStream(strTempFileUrl, FileMode.Open, FileAccess.Read);
        while (fs.Position < fs.Length)
        {
            //读到文件名的字节大小
            byte[] bytArr = new byte[2];
            fs.Read(bytArr, 0, 2);
            string strSize = Utils.ByteToString(bytArr);
            int nSize = Convert.ToInt32(strSize, 16);
            nOffset += 2;

            //文件名
            bytArr = new byte[nSize];
            fs.Read(bytArr, 0, nSize);
            string strFileName = Utils.ByteToString(bytArr);

            //文件大小(字节长度)
            bytArr = new byte[8];
            fs.Read(bytArr, 0, 8);
            strSize = Utils.ByteToString(bytArr);
            nSize = Convert.ToInt32(strSize, 16);
            nOffset += 8;

            //文件
            bytArr = new byte[nSize];
            fs.Read(bytArr, 0, nSize);

            //拷贝文件到指定目录下
            string url = strTargetDir + "/" + strFileName;
            string folderUrl = Path.GetDirectoryName(url);
            if (!Directory.Exists(folderUrl))
            {
                Directory.CreateDirectory(folderUrl);
            }
            File.WriteAllBytes(url, bytArr);
        }
        fs.Close();
    }

    //字节码转换成字符串
    public static string ConvertBytesToString(byte[] bytes)
    {
        return Utils.ByteToString(bytes);
    }

    //将数字的字符串表现形式转换成十进制int型整数
    public static int ConvertStrToInt10(string strNum)
    {
        return Convert.ToInt32(strNum, 16);
    }

    public static FileStream CreateFileStream(string path, int fileMode, int fileAccess)
    {
        return new FileStream(path, (FileMode)fileMode, (FileAccess)fileAccess);
    }

    //创建字节数组
    public static byte[] CreateByteArr(int size)
    {
        return new byte[size];
    }
}
