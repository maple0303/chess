namespace ChannelPlatform
{
    using UnityEngine;
    using System.Collections;

    public class Android : IChannelPlatform
    {
        private AndroidJavaClass javaAccount;

        public Android(string callback)
        {
            try
            {
                javaAccount = new AndroidJavaClass("com.anychannel.framework.Account");
                if (javaAccount != null)
                {
                    javaAccount.CallStatic("registCallback", callback);
                }
            }
            catch (System.Exception e)
            {
                Debug.LogError(e);
            }

        }

        public void Plat_Login()
        {
            try
            {
                //Const.IsSDK = false;//登陆成功，设置为SDK
                javaAccount.CallStatic("login");
            }
            catch (System.Exception e)
            {
                Debug.LogError("Login:" + e);
            }
        }

        public void Plat_Logout()
        {
            javaAccount.CallStatic("logout");
        }

        public void Plat_Pay(PayInfo payInfo)
        {
            javaAccount.CallStatic("pay", JsonUtil.toJson(payInfo));
        }
        public string Plat_GetChannel()
        {
            return javaAccount.CallStatic<string>("getChannel");
        }

        public string Plat_GetUid()
        {
            return javaAccount.CallStatic<string>("getUid");
        }

        public string Plat_GetUserName()
        {
            return javaAccount.CallStatic<string>("getUserName");
        }

        public string Plat_GetSessionID()
        {
            return javaAccount.CallStatic<string>("getSessionID");
        }

        public string Plat_GetOrderID()
        {
            return javaAccount.CallStatic<string>("getOrderID");
        }

        public string Plat_GetPlatformOrderID()
        {
            return javaAccount.CallStatic<string>("getPlatformOrderID");
        }

        public bool Plat_HasExitPage()
        {
            return javaAccount.CallStatic<bool>("hasExitPage");
        }

        public void Plat_ExitPage()
        {
            javaAccount.CallStatic("exitPage");
        }

        public bool Plat_HasUserCenter()
        {
            return javaAccount.CallStatic<bool>("hasUserCenter");
        }

        public void Plat_UserCenter()
        {
            javaAccount.CallStatic("userCenter");
        }

        public void Plat_AntiAddiction()
        {
            javaAccount.CallStatic("antiAddiction");
        }

        public void Plat_RealNameSignIn()
        {
            javaAccount.CallStatic("realNameSignIn");
        }

        public void Plat_ShowPausePage()
        {
            javaAccount.CallStatic("showPausePage");
        }

        public bool Plat_HasBBS()
        {
            return javaAccount.CallStatic<bool>("hasBBS");
        }

        public void Plat_EnterBBS()
        {
            javaAccount.CallStatic("enterBBS");
        }

        public bool Plat_HasFeedBack()
        {
            return javaAccount.CallStatic<bool>("hasFeedBack");
        }

        public void Plat_UserFeedBack()
        {
            javaAccount.CallStatic("userFeedBack");
        }

        public void Plat_CreateRole(RoleInfo roleInfo)
        {
            javaAccount.CallStatic("createRole", JsonUtil.toJson(roleInfo));
        }

        public void Plat_RoleUpgrade(RoleInfo roleInfo)
        {
            javaAccount.CallStatic("roleUpgrade", JsonUtil.toJson(roleInfo));
        }

        public void Plat_EnterGame(RoleInfo roleInfo)
        {
            javaAccount.CallStatic("enterGame", JsonUtil.toJson(roleInfo));
        }
        public void Plat_HideSplash()
        {
            using (AndroidJavaClass jc = new AndroidJavaClass("com.unity3d.player.UnityPlayer"))
            {
                using (AndroidJavaObject jo = jc.GetStatic<AndroidJavaObject>("currentActivity"))
                {
                    Debug.Log(jo);
                    jo.Call("HideSplashView");
                }
            }
        }
        #region 2017.03.20新增

        public string Plat_getNickName()
        {
            return javaAccount.CallStatic<string>("getNickName");
        }


        public string Plat_getEmail()
        {
            return javaAccount.CallStatic<string>("getEmail");
        }

        public string Plat_getUserAvatar()
        {
            return javaAccount.CallStatic<string>("getUserAvatar");
        }

        public string Plat_getCustomData()
        {
            return javaAccount.CallStatic<string>("getCustomData");
        }
        #endregion
    }
}