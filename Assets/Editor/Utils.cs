using System;
using System.IO;
using System.Text;

public class Utils
{
    public static string md5file(string file)
    {
        try
        {
            FileStream fs = new FileStream(file, FileMode.Open);
            System.Security.Cryptography.MD5 md5 = new System.Security.Cryptography.MD5CryptoServiceProvider();
            byte[] retVal = md5.ComputeHash(fs);
            fs.Close();

            StringBuilder sb = new StringBuilder();
            for (int i = 0; i < retVal.Length; i++)
            {
                sb.Append(retVal[i].ToString("x2"));
            }
            return sb.ToString();
        }
        catch (Exception ex)
        {
            throw new Exception("md5file() fail, error:" + ex.Message);
        }
    }

    //string转byte[]
    public static byte[] StringToByteArray(string str)
    {
        byte[] byteArray = System.Text.Encoding.UTF8.GetBytes(str);
        //str = str.Replace(" ", "");
        //byte[] byteArray = new byte[str.Length / 2];
        //for (int i = 0; i < str.Length; i += 2)
        //    byteArray[i / 2] = (byte)Convert.ToByte(str.Substring(i, 2), 16);
        return byteArray;
    }
    //byte[]转string
    public static string ByteToString(byte[] byteArray)
    {
        String str = System.Text.Encoding.UTF8.GetString(byteArray);
        return str;
    }
}
