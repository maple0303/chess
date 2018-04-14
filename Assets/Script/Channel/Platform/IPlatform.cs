namespace ChannelPlatform
{
    using UnityEngine;
    using System.Collections;

    public interface IChannelPlatform
    {
        /// <summary>
        /// 唤起登入控制台
        /// </summary>
        void Plat_Login();

        /// <summary>
        /// 登出
        /// </summary>
        void Plat_Logout();

        /// <summary>
        /// 支付
        /// </summary>
        /// <param name="payInfo">支付信息.</param>
        void Plat_Pay(PayInfo payInfo);

        /// <summary>
        /// 获取渠道标识
        /// </summary>
        /// <returns>渠道标识</returns>
        string Plat_GetChannel();

        /// <summary>
        /// 获取用户id
        /// </summary>
        /// <returns>The uid.</returns>
        string Plat_GetUid();

        /// <summary>
        /// 用户名
        /// </summary>
        /// <returns>The user name.</returns>
        string Plat_GetUserName();

        /// <summary>
        /// session ID.
        /// </summary>
        /// <returns>The session I.</returns>
        string Plat_GetSessionID();

        /// <summary>
        /// 游戏充值订单号
        /// </summary>
        /// <returns>订单号</returns>
        string Plat_GetOrderID();

        /// <summary>
        /// 平台充值订单号
        /// </summary>
        /// <returns>The platform order I.</returns>
        string Plat_GetPlatformOrderID();

        /// <summary>
        /// 是否有推出页面
        /// </summary>
        bool Plat_HasExitPage();

        /// <summary>
        /// 打开退出页
        /// </summary>
        void Plat_ExitPage();

        /// <summary>
        /// 是否有用户中心
        /// </summary>
        /// <returns><c>true</c>, if user center was hased, <c>false</c> otherwise.</returns>
        bool Plat_HasUserCenter();

        /// <summary>
        /// 打开用户中心
        /// </summary>
        void Plat_UserCenter();

        /// <summary>
        /// 防沉迷
        /// </summary>
        void Plat_AntiAddiction();

        /// <summary>
        /// 实名注册
        /// </summary>
        void Plat_RealNameSignIn();

        /// <summary>
        /// 现实暂停页
        /// </summary>
        void Plat_ShowPausePage();

        /// <summary>
        /// 是否有论坛
        /// </summary>
        /// <returns><c>true</c>, if BB was hased, <c>false</c> otherwise.</returns>
        bool Plat_HasBBS();

        /// <summary>
        /// 打开论坛
        /// </summary>
        void Plat_EnterBBS();

        /// <summary>
        /// 是否有用户反馈
        /// </summary>
        /// <returns><c>true</c>, if feed back was hased, <c>false</c> otherwise.</returns>
        bool Plat_HasFeedBack();

        /// <summary>
        /// 打开 用户反馈
        /// </summary>
        void Plat_UserFeedBack();

        /// <summary>
        /// 角色创建完成调用（统计
        /// </summary>
        /// <param name="roleInfo">Role info.</param>
        void Plat_CreateRole(RoleInfo roleInfo);

        /// <summary>
        /// 角色升级调用（统计
        /// </summary>
        /// <param name="roleInfo">Role info.</param>
        void Plat_RoleUpgrade(RoleInfo roleInfo);

        /// <summary>
        /// 进入游戏调用（统计
        /// </summary>
        /// <param name="roleInfo">Role info.</param>
        void Plat_EnterGame(RoleInfo roleInfo);

        /// <summary>
        /// 隐藏Splash界面
        /// </summary>
        void Plat_HideSplash();
    }
}