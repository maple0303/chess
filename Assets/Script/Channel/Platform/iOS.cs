namespace ChannelPlatform
{
	using UnityEngine;
	using System.Collections;
	using System.Runtime.InteropServices;

	public class iOS : IChannelPlatform
    {

#if USE_CHANNEL_SDK
 		[DllImport("__Internal")]
 		private extern static void Login();
 		[DllImport("__Internal")]
 		private extern static void Logout();
 		[DllImport("__Internal")]
 		private extern static void Pay (string payinfo);
 		[DllImport("__Internal")]
 		private extern static string GetChannel ();
 		[DllImport("__Internal")]
 		private extern static string GetUid ();
 		[DllImport("__Internal")]
 		private extern static string GetUserName ();
 		[DllImport("__Internal")]
 		private extern static string GetSessionID ();
 		[DllImport("__Internal")]
 		private extern static string GetOrderID();
 		[DllImport("__Internal")]
 		private extern static string GetPlatformOrderID ();
 		[DllImport("__Internal")]
 		private extern static bool HasExitPage ();
 		[DllImport("__Internal")]
 		private extern static void ExitPage ();
 		[DllImport("__Internal")]
 		private extern static bool HasUserCenter ();
 		[DllImport("__Internal")]
 		private extern static void UserCenter ();
 		[DllImport("__Internal")]
 		private extern static void RealNameSignIn ();
 		[DllImport("__Internal")]
 		private extern static void AntiAddiction ();
 		//[DllImport("__Internal")]
 		//private extern static void ShowPausePage ();
 		[DllImport("__Internal")]
 		private extern static bool HasBBS();
 		[DllImport("__Internal")]
 		private extern static void EnterBBS();
 		[DllImport("__Internal")]
 		private extern static bool HasFeedBack ();
 		[DllImport("__Internal")]
 		private extern static void UserFeedBack ();
 		[DllImport("__Internal")]
 		private extern static void PostCreateRole(string roleinfo);
 		[DllImport("__Internal")]
 		private extern static void PostRoleUpgrade(string roleinfo);
 		[DllImport("__Internal")]
 		private extern static void PostEnterGame(string roleinfo);
#endif
 
 		public iOS(string callback) {
 
 		}
 
 		public void Plat_Login(){
#if USE_CHANNEL_SDK
 			Login ();
#endif
 		}
 
 		public void Plat_Logout() {
#if USE_CHANNEL_SDK
 			Logout ();
#endif
 		}
 
 		public void Plat_Pay(PayInfo payInfo) {
#if USE_CHANNEL_SDK
			Pay (JsonUtil.toJson (payInfo));
#endif
 		}
 
 		public string Plat_GetChannel() {
#if USE_CHANNEL_SDK
 			return GetChannel ();
#endif
			return string.Empty;
 		}
 
 		public string Plat_GetUid() {
#if USE_CHANNEL_SDK
 			return GetUid ();
#endif
			return string.Empty;
 		}
 
 		public string Plat_GetUserName()
 		{
#if USE_CHANNEL_SDK
 			return GetUserName ();
#endif
			return string.Empty;
 		}
 
 		public string Plat_GetSessionID()
 		{
#if USE_CHANNEL_SDK
 			return GetSessionID ();
#endif
			return string.Empty;
 		}
 
 		public string Plat_GetOrderID() {
#if USE_CHANNEL_SDK
 			return GetOrderID();
#endif
			return string.Empty;
 		}
 
 
 		public string Plat_GetPlatformOrderID() {
#if USE_CHANNEL_SDK
 			return GetPlatformOrderID ();
#endif
			return string.Empty;
 		}
 
 		public bool Plat_HasExitPage() {
#if USE_CHANNEL_SDK
 			return HasExitPage ();
#endif
			return false;
 		}
 
 		public void Plat_ExitPage() {
#if USE_CHANNEL_SDK
 			ExitPage ();
#endif
 		}
 
 		public bool Plat_HasUserCenter() {
#if USE_CHANNEL_SDK
 			return HasUserCenter ();
#endif
			return false;
 		}
 
 		public void Plat_UserCenter() {
#if USE_CHANNEL_SDK
 			UserCenter ();
#endif
 		}
 
 		public void Plat_AntiAddiction() {
#if USE_CHANNEL_SDK
 			AntiAddiction ();
#endif
 		}
 
 		public void Plat_RealNameSignIn() {
#if USE_CHANNEL_SDK
 			RealNameSignIn ();
#endif
 		}
 
 		public  void Plat_ShowPausePage() {
#if USE_CHANNEL_SDK
 			//ShowPausePage ();
#endif
 		}
 
 		public bool Plat_HasBBS() {
#if USE_CHANNEL_SDK
 			return HasBBS ();
#endif
			return false;
 		}
 
 		public void Plat_EnterBBS() {
#if USE_CHANNEL_SDK
 			EnterBBS ();
#endif
 		}
 
 
 		public bool Plat_HasFeedBack(){
#if USE_CHANNEL_SDK
 			return HasFeedBack ();
#endif
			return false;
 		}
 
 		public void Plat_UserFeedBack() {
#if USE_CHANNEL_SDK
 			UserFeedBack ();
#endif
 		}
 
 		public void Plat_CreateRole(RoleInfo roleInfo) {
#if USE_CHANNEL_SDK
            PostCreateRole(JsonUtil.toJson(roleInfo));
#endif
 		}
 
 		public void Plat_RoleUpgrade(RoleInfo roleInfo) {
#if USE_CHANNEL_SDK
            PostRoleUpgrade(JsonUtil.toJson (roleInfo));
#endif
 		}
 
 		public void Plat_EnterGame(RoleInfo roleInfo) {
#if USE_CHANNEL_SDK
            PostEnterGame(JsonUtil.toJson (roleInfo));
#endif
 		}

        public void Plat_HideSplash()
        {

        }
	}
}