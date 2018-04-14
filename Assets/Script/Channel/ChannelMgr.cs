//#if  !UNITY_EDITOR && (UNITY_ANDROID || UNITY_IOS)
//#define USE_CHANNEL_SDK
//#endif

using UnityEngine;
using System.Collections;
using ChannelPlatform;

public delegate void OnFuncCallBackDelegate(string msg);

public enum LogOutSrc
{
    EnterGame,
    CreateRole,
    ChooseRole,
    InGame,
}
public static class ChannelMgr
{
    ///// <summary>
    ///// 从哪里注销账号
    ///// 1，选服界面
    ///// 2，创建角色、选择角色界面
    ///// 3，进入游戏后
    ///// </summary>
    //private static LogOutSrc mLogoutSrc = LogOutSrc.InGame;

    public static OnFuncCallBackDelegate m_OnLoginCallBack = null;
    public static OnFuncCallBackDelegate m_OnPayCallBack = null;

    /// <summary>
    /// 是否为在登陆界面点击的切换账号
    /// </summary>
    public static void UpdateLogoutSrc()
    {
        //if (LocalData.Instance.CurrGameScene != (int)GAMESCENE.DengLu)
        //{
        //    mLogoutSrc = LogOutSrc.InGame;
        //}
        //else
        //{
        //    if (UIMgr.Instance.IsPanelShow(EUIPanelID.Panel_ChooseRole))
        //    {
        //        mLogoutSrc = LogOutSrc.ChooseRole;
        //    }
        //    else if (UIMgr.Instance.IsPanelShow(EUIPanelID.Panel_CreateRole))
        //    {
        //        mLogoutSrc = LogOutSrc.CreateRole;
        //    }
        //    else
        //    {
        //        mLogoutSrc = LogOutSrc.EnterGame;
        //    }
        //}
    }

    //public static LogOutSrc LogoutSrc
    //{
    //    get
    //    {
    //        return mLogoutSrc;
    //    }
    //}

    public static bool IsUseChannelSDK
    {
        get
        {
#if USE_CHANNEL_SDK
            if(Platform.GetInstance().Plat_GetChannel() == "QKQXZCX")
            {
                return false;
            }
            return true;
#else
            return false;
#endif
        }
    }

    /// <summary>
    /// 登陆
    /// </summary>
    public static void Login()
    {
#if USE_CHANNEL_SDK
        Debug.Log("Login from ChannelMgr");
        Platform.GetInstance().Plat_Login();
#endif
    }


    /// <summary>
    /// 登出
    /// </summary>
    public static void Logout()
    {
#if USE_CHANNEL_SDK
        Debug.Log("Logout from ChannelMgr");
        Platform.GetInstance().Plat_Logout();
#endif
    }
    /// <summary>
    /// 支付
    /// </summary>
    public static void Pay(PayInfo payInfo)
    {
#if USE_CHANNEL_SDK
        Platform.GetInstance().Plat_Pay(payInfo);
#endif
    }
    /// <summary>
    /// 获取渠道标识
    /// </summary>
    public static string GetChannel()
    {
#if USE_CHANNEL_SDK
        return Platform.GetInstance().Plat_GetChannel();
#else
        return "QKQXZCX";
#endif
    }
    /// <summary>
    /// 获取用户id
    /// </summary>
    public static string GetUid()
    {
#if USE_CHANNEL_SDK
        return Platform.GetInstance().Plat_GetUid();
#else
        return string.Empty;
#endif
    }
    /// <summary>
    /// 用户名
    /// </summary>
    /// <returns>The user name.</returns>
    public static string GetUserName()
    {
#if USE_CHANNEL_SDK
        return Platform.GetInstance().Plat_GetUserName();
#else
        return string.Empty;
#endif
    }
    /// <summary>
    /// session ID.
    /// </summary>
    public static string GetSessionID()
    {
#if USE_CHANNEL_SDK
        return Platform.GetInstance().Plat_GetSessionID();
#else
        return string.Empty;
#endif
    }
    /// <summary>
    /// 游戏充值订单号
    /// </summary>
    /// <returns>订单号</returns>
    public static string GetOrderId()
    {
#if USE_CHANNEL_SDK
        return Platform.GetInstance().Plat_GetOrderID();
#else
        return string.Empty;
#endif
    }
    /// <summary>
    /// 平台充值订单号
    /// </summary>
    /// <returns>The platform order I.</returns>
    public static string GetPlatformOrderId()
    {
#if USE_CHANNEL_SDK
        return Platform.GetInstance().Plat_GetPlatformOrderID();
#else
        return string.Empty;
#endif
    }

    public static void HideSplash()
    {
#if !UNITY_EDITOR && !UNITY_STANDALONE
        try
        {
            Platform.GetInstance().Plat_HideSplash();
        }
        catch (System.Exception ex)
        {
            Debug.LogError(ex.Message);
        }

#endif
    }

    public static bool HasUserCenter()
    {
#if USE_CHANNEL_SDK
        return Platform.GetInstance().Plat_HasUserCenter();
#else
        return false;
#endif
    }

    public static void UserCenter()
    {
#if USE_CHANNEL_SDK
        Platform.GetInstance().Plat_UserCenter();
#endif
    }

    public static void CreatRole(RoleInfo roleInfo)
    {
#if USE_CHANNEL_SDK
        try
        {      
            Platform.GetInstance().Plat_CreateRole(roleInfo);
        }
        catch (System.Exception ex)
        {
        	Debug.LogError("CreatRole: " + ex.Message);
        }
#endif
    }

    public static void RoleUpgrade(RoleInfo roleInfo)
    {
#if USE_CHANNEL_SDK
        try
        {
            Platform.GetInstance().Plat_RoleUpgrade(roleInfo);
        }
        catch (System.Exception ex)
        {
        	Debug.LogError("RoleUpgrade: " + ex.Message);
        }
#endif
    }

    public static void EnterGame(RoleInfo roleInfo)
    {
#if USE_CHANNEL_SDK
        try
        {
             Platform.GetInstance().Plat_EnterGame(roleInfo);
        }
        catch (System.Exception ex)
        {
            Debug.LogError("EnterGame: " + ex.Message);        	
        }
#endif
    }
}