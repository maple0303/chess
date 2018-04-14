using UnityEngine;

class JsonUtil
{
    public static T parse<T>(string jsonString)
    {
        return JsonUtility.FromJson<T>(jsonString);
    }

    public static string toJson(object jsonObject)
    {
        return JsonUtility.ToJson(jsonObject);
    }
}

