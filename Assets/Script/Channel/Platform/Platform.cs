namespace ChannelPlatform
{
    using UnityEngine;
    using System.Collections;

    public class Platform : IChannelPlatform
    {
        private static Platform ins;
        internal static string oname = "Platform";

        /// <summary>
        /// 机器类型iOS or Android
        /// </summary>
        public PLATFORM type;

        public IChannelPlatform tools;

        private Platform()
        {
            init();
        }

        private void init()
        {
            //GameObject plat = (GameObject)GameObject.Instantiate(Resources.Load ("Prefab/" + oname));            
            //plat.name = oname;
            GameObject plat = new GameObject("Platform");
            plat.AddComponent<PlatformCallback>();
            GameObject.DontDestroyOnLoad(plat);
#if UNITY_ANDROID
            type = PLATFORM.Android;
            tools = new Android(oname);
            Debug.Log("kinside android");
#endif

#if UNITY_IPHONE
			type = PLATFORM.iOS;
			tools = new iOS(oname);
			Debug.Log ("kinside iOS");
#endif

#if UNITY_STANDALONE_WIN

#endif
        }

        public static Platform GetInstance()
        {
            if (ins == null)
                ins = new Platform();
            return ins;
        }

        /// <summary>
        /// 登陆
        /// </summary>
        public void Plat_Login()
        {
            //if (!Const.IsSDK && Application.platform == RuntimePlatform.IPhonePlayer)
            //{
            //    return;
            //}
            tools.Plat_Login();
        }

        /// <summary>
        /// 登出
        /// </summary>
        public void Plat_Logout()
        {
            //if (!Const.IsSDK)
            //{
            //    return;
            //}
            tools.Plat_Logout();
        }

        /// <summary>
        /// 支付
        /// </summary>
        public void Plat_Pay(PayInfo payInfo)
        {
            //if (!Const.IsSDK)
            //{
            //    return;
            //}
            tools.Plat_Pay(payInfo);
        }
        /// <summary>
        /// 获取渠道标识
        /// </summary>
        public string Plat_GetChannel()
        {
            //if (!Const.IsSDK)
            //{
            //    return null;
            //}
            return tools.Plat_GetChannel();
        }
        /// <summary>
        /// 获取用户id
        /// </summary>
        public string Plat_GetUid()
        {
            //if (!Const.IsSDK)
            //{
            //    return null;
            //}
            return tools.Plat_GetUid();
        }
        /// <summary>
        /// 用户名
        /// </summary>
        /// <returns>The user name.</returns>
        public string Plat_GetUserName()
        {
            //if (!Const.IsSDK)
            //{
            //    return null;
            //}
            return tools.Plat_GetUserName();
        }
        /// <summary>
        /// session ID.
        /// </summary>
        public string Plat_GetSessionID()
        {
            //if (!Const.IsSDK)
            //{
            //    return null;
            //}
            return tools.Plat_GetSessionID();
        }
        /// <summary>
        /// 游戏充值订单号
        /// </summary>
        /// <returns>订单号</returns>
        public string Plat_GetOrderID()
        {
            //if (!Const.IsSDK)
            //{
            //    return null;
            //}
            return tools.Plat_GetOrderID();
        }
        /// <summary>
        /// 平台充值订单号
        /// </summary>
        /// <returns>The platform order I.</returns>
        public string Plat_GetPlatformOrderID()
        {
            //if (!Const.IsSDK)
            //{
            //    return null;
            //}
            return tools.Plat_GetPlatformOrderID();
        }
        /// <summary>
        /// 是否有推出页面
        /// </summary>
        public bool Plat_HasExitPage()
        {
            //if (!Const.IsSDK)
            //{
            //    return false;
            //}
            return tools.Plat_HasExitPage();
        }
        /// <summary>
        /// 打开退出页
        /// </summary>
        public void Plat_ExitPage()
        {
            //if (!Const.IsSDK)
            //{
            //    return;
            //}
            tools.Plat_ExitPage();
        }
        /// <summary>
        /// 是否有用户中心
        /// </summary>
        /// <returns>true</returns>
        /// <c>false</c>
        public bool Plat_HasUserCenter()
        {
            //if (!Const.IsSDK)
            //{
            //    return false;
            //}
            return tools.Plat_HasUserCenter();
        }
        /// <summary>
        /// 打开用户中心
        /// </summary>
        public void Plat_UserCenter()
        {
            //if (!Const.IsSDK)
            //{
            //    return;
            //}
            tools.Plat_UserCenter();
        }
        /// <summary>
        /// 防沉迷
        /// </summary>
        public void Plat_AntiAddiction()
        {
            //if (!Const.IsSDK)
            //{
            //    return;
            //}
            tools.Plat_AntiAddiction();
        }
        /// <summary>
        /// 实名注册
        /// </summary>
        public void Plat_RealNameSignIn()
        {
            //if (!Const.IsSDK)
            //{
            //    return;
            //}
            tools.Plat_RealNameSignIn();
        }
        /// <summary>
        /// 现实暂停页
        /// </summary>
        public void Plat_ShowPausePage()
        {
            //if (!Const.IsSDK)
            //{
            //    return;
            //}
            tools.Plat_ShowPausePage();
        }
        /// <summary>
        /// 是否有论坛
        /// </summary>
        /// <returns>true</returns>
        /// <c>false</c>
        public bool Plat_HasBBS()
        {
            //if (!Const.IsSDK)
            //{
            //    return false;
            //}
            return tools.Plat_HasBBS();
        }
        /// <summary>
        /// 打开论坛
        /// </summary>
        public void Plat_EnterBBS()
        {
            //if (!Const.IsSDK)
            //{
            //    return;
            //}
            tools.Plat_EnterBBS();
        }
        /// <summary>
        /// 是否有用户反馈
        /// </summary>
        public bool Plat_HasFeedBack()
        {
            //if (!Const.IsSDK)
            //{
            //    return false;
            //}
            return tools.Plat_HasFeedBack();
        }
        /// <summary>
        /// 打开 用户反馈
        /// </summary>
        public void Plat_UserFeedBack()
        {
            //if (!Const.IsSDK)
            //{
            //    return;
            //}
            tools.Plat_UserFeedBack();
        }
        /// <summary>
        /// 角色创建完成调用（统计
        /// </summary>
        public void Plat_CreateRole(RoleInfo roleInfo)
        {
            //if (!Const.IsSDK)
            //{
            //    return;
            //}
            tools.Plat_CreateRole(roleInfo);
        }
        /// <summary>
        /// 角色升级调用（统计
        /// </summary>
        public void Plat_RoleUpgrade(RoleInfo roleInfo)
        {
            //if (!Const.IsSDK)
            //{
            //    return;
            //}
            tools.Plat_RoleUpgrade(roleInfo);
        }
        /// <summary>
        /// 进入游戏调用（统计
        /// </summary>
        public void Plat_EnterGame(RoleInfo roleInfo)
        {
            //if (!Const.IsSDK)
            //{
            //    return;
            //}
            tools.Plat_EnterGame(roleInfo);
        }

        public void Plat_HideSplash()
        {
#if UNITY_ANDROID
            tools.Plat_HideSplash();
#else
            Debug.Log("iOS平台无Plat_HideSplash函数");
#endif
        }
    }
}
public enum PLATFORM
{
    iOS,
    Android,
    Win
}
