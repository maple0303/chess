namespace ChannelPlatform
{
	using System;

	public class PayInfo
	{
	    public string server_ID = ""; // 充值时的服务器id
		public string gameUser_ID = ""; // 充值时的用户id
		public string role_ID = ""; // 充值时的角色id
		public string product_name = ""; // 商品名称
		public float product_price = 0.1f; // 商品单价
	    public int product_count = 1; // 购买数量
		public string custom_define = ""; // 支付自定义消息
		public string product_ID = ""; // 商品id(个别渠道需要在后台配置,没有配置可以忽略)
	    public int change_rate = 10; // 兑换比例(个别渠道需要配置兑换比例)

		public PayInfo() {
		}
	}
}