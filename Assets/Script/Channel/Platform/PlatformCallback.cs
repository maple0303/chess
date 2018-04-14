using UnityEngine;
using System.Collections;
using System.Collections.Generic;
using System;
using ChannelPlatform;



public class PlatformCallback : MonoBehaviour
{
 

    void DoUserLogout()
    {
        ChannelMgr.UpdateLogoutSrc();
        //if (ChannelMgr.LogoutSrc == LogOutSrc.EnterGame)
        //{
        //    Debug.Log("onLogoutSuccess:Login");
        //    ChannelMgr.Login();
        //}
        //else if (ChannelMgr.LogoutSrc == LogOutSrc.CreateRole)
        //{
        //    Panel_CreateRole panel = (Panel_CreateRole)UIMgr.Instance.GetPanelScript(EUIPanelID.Panel_CreateRole);
        //    if (panel != null)
        //        panel.OnBackClick();
        //    else
        //        yxyLog.LogError("PanelCreateRole is null");
        //    ChannelMgr.Login();
        //}
        //else if (ChannelMgr.LogoutSrc == LogOutSrc.ChooseRole)
        //{
        //    Panel_ChooseRole panel = (Panel_ChooseRole)UIMgr.Instance.GetPanelScript(EUIPanelID.Panel_ChooseRole);
        //    if (panel != null)
        //        panel.ReturnToServerSelect();
        //    else
        //        yxyLog.LogError("Panel_ChooseRole is null");
        //    ChannelMgr.Login();
        //}
        //else
        //{
        //    //很诡异的bug，必须启用协程，否则切换账号会崩溃!可能是7kSDK的bug
        //    StartCoroutine(SwitchAccountCoroutinue(true));
        //}
    }

    /// <summary>
    /// 用户退出成功回调,与onLogoutSuccess意义一致
    /// </summary>
    void onUserLogout()
    {
        Debug.Log("onUserLogout Logout");
        //
        DoUserLogout();
    }

    /// <summary>
    /// onLogoutSuccess,onLogoutFailed苹果sdk貌似没调用
    /// </summary>
    void onLogoutSuccess()
    {
        //Debug.Log("onLogoutSuccess: " + ChannelMgr.LogoutSrc);
        DoUserLogout();
    }


    void onSwitchUsered(string msg)
    {
        //yxyLog.Log("onSwitchUsered: " + msg);
        //GameConfig.Username = Platform.GetInstance().Plat_GetUid();
        ChannelMgr.UpdateLogoutSrc();
        //if (ChannelMgr.LogoutSrc == LogOutSrc.InGame)
        //{
        //    StartCoroutine(SwitchAccountCoroutinue(true));
        //}
    }

    IEnumerator SwitchAccountCoroutinue(bool showChannelLogin)
    {
        yield return null;
        //MainLogicScript.SwitchAccount(showChannelLogin);
    }
    void onLogoutFailed()
    {
        Debug.Log("onLogoutFailed");
    }

    void onLoginSuccess(string msg)
    {
        //Z_LoginInfo.getInstance().Account_crc = msg;
        //Const.IsLoginToGoGame = true;
        //LZ_GameManager.getInstance().Account_SetEvent(Const.ET_SDKLogin);
        Debug.Log("onLoginSuccess: " + msg);
        //Debug.Log("Platform.GetInstance().GetChannel: " + Platform.GetInstance().Plat_GetChannel());
        //Debug.Log("Platform.GetInstance().GetOrderID: " + Platform.GetInstance().Plat_GetOrderID());
        //Debug.Log("Platform.GetInstance().GetPlatformOrderID: " + Platform.GetInstance().Plat_GetPlatformOrderID());
        //Debug.Log("Platform.GetInstance().GetSessionID: " + Platform.GetInstance().Plat_GetSessionID());
        //Debug.Log("Platform.GetInstance().GetUid: " + Platform.GetInstance().Plat_GetUid());
        //Debug.Log("Platform.GetInstance().GetUserName: " + Platform.GetInstance().Plat_GetUserName());

        //GameConfig.Username = Platform.GetInstance().Plat_GetUid();
        //UIMgr.Instance.HidePanel(EUIPanelID.Panel_EnterGame);
        //UIMgr.Instance.ShowPanel(EUIPanelID.Panel_EnterGame, true, true);
        if (ChannelMgr.m_OnLoginCallBack != null)
        {
            ChannelMgr.m_OnLoginCallBack(msg);
        }
    }

    void onLoginFailed(string msg)
    {
        Debug.Log("onLoginFailed: " + msg);
        //UIMgr.Instance.HidePanel(EUIPanelID.Panel_EnterGame);
        //UIMgr.Instance.ShowPanel(EUIPanelID.Panel_EnterGame, true, false, () =>
        //{
        //    EnterGameCtrl.Instance.ShowTips(LocalizeUtils.GetLocalizedStr(UIStringDefine.id220503134));
        //});
        //
        //ChannelMgr.Login();
        if (ChannelMgr.m_OnLoginCallBack != null)
        {
            ChannelMgr.m_OnLoginCallBack(msg);
        }
    }

    void onPaySuccess(string msg)
    {
        Debug.Log("onPaySuccess: " + msg);
        if (ChannelMgr.m_OnPayCallBack != null)
        {
            ChannelMgr.m_OnPayCallBack(msg);
        }
    }

    void onPayUnknown(string msg)
    {
        Debug.Log("onPayUnknown: " + msg);
        if (ChannelMgr.m_OnPayCallBack != null)
        {
            ChannelMgr.m_OnPayCallBack(msg);
        }
    }

    void onPayFailed(string msg)
    {
        Debug.Log("onPayFailed: " + msg);
        if (ChannelMgr.m_OnPayCallBack != null)
        {
            ChannelMgr.m_OnPayCallBack(msg);
        }
    }

    void onExit(string msg)
    {
        Debug.Log("onExit: " + msg);
        //		Application.Quit();
    }
}
