using UnityEngine;
using System.Collections;
using LuaInterface;
using System.IO;

public class CGameMain : MonoBehaviour
{
    void Awake()
    {
        Screen.sleepTimeout = SleepTimeout.NeverSleep;  //不会锁屏
        UnityEngine.Object.DontDestroyOnLoad(this.gameObject);
    }

    // Use this for initializationsplash
    void Start()
    {
        ScreenAdapt();

        GameObject mainCamera = UnityEngine.GameObject.Find("Main Camera");
        if (mainCamera != null)
        {
            UnityEngine.Object.DontDestroyOnLoad(mainCamera);
        }
        GameObject UICanvas = UnityEngine.GameObject.Find("Canvas");
        if (UICanvas != null)
        {
            UnityEngine.Object.DontDestroyOnLoad(UICanvas);
        }
        GameObject topCanvas = UnityEngine.GameObject.Find("topCanvas");
        if (topCanvas != null)
        {
            UnityEngine.Object.DontDestroyOnLoad(topCanvas);
        }
        GameObject eventSystem = UnityEngine.GameObject.Find("EventSystem");
        if (eventSystem != null)
        {
            UnityEngine.Object.DontDestroyOnLoad(eventSystem);
        }

        OnInitialize();
    }

    void ScreenAdapt()
    {
        Debug.Log("Screen.width  " + Screen.width + "   Screen.height   " + Screen.height);

        if (Camera.main == null)
        {
            return;
        }

#if !UNITY_EDITOR
		if(Application.isMobilePlatform)
		{
			Debug.Log("根据屏幕分辨率设置相机的size");
			// 计算设备的宽高比
			float fDeviceAspect = Screen.width * 1.0f / Screen.height;
		    if(fDeviceAspect >= 1.5) // 大于等于1.5属于宽屏手机
		    {
		        Camera.main.orthographicSize = 3.2f;
		    }
		    else
		    {
		        Camera.main.orthographicSize = 3.84f;
		    }
		}
		else
		{
			Debug.Log("手动设置分辨率大小 1136x640");
			Screen.SetResolution(1136, 640, false);
		}
#endif
        Debug.Log("相机size " + Camera.main.orthographicSize);
    }

    void OnInitialize()
    {
        //Debug.Log("CGameMain:初始化开始啦");
        LuaState lua = LuaManager.GetInstance().GetLuaState();
        lua.Require("LuaGame");  // 加载lua文件
        LuaManager.GetInstance().CallFunction("LuaGame.Start");
    }
    // Update is called once per frame
    void Update()
    {

    }

    void OnDestroy()
    {
        LuaManager.GetInstance().CallFunction("LuaGame.Destroy");
    }
}
