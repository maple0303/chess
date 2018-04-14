namespace ChannelPlatform
{
	using System;

	[Serializable]
	public class RoleInfo
	{
	    public string server_ID = ""; // 服务器id
		public string server_name = ""; // 服务器名字
		public string gameUser_ID = ""; // 用户id
		public string role_ID = ""; // 角色id
		public string role_name = ""; // 角色名称
	    public int role_rank = 1; // 角色等级
        public long role_ctime = 1;//角色创建时间戳，10位数
	}
}