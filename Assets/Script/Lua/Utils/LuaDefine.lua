-- region *.lua
-- Date
-- 此文件由[BabeLua]插件自动生成
-- 游戏中用到的常量

GAMG_STATE_INIT = 0;			-- 初始化状态
GAMG_STATE_CITY = 1;			-- 城镇状态
GAME_STATE_BATTLE = 2;			-- 战斗状态
GAME_STATE_STORY = 3;			-- 剧情状态
GAME_STATE_LOGIN_LOADING = 4;	-- 登录加载
GAME_STATE_SCENE_LOADING = 5;	-- 切换场景加载
GAME_STATE_BATTlE_LOADING = 6;	-- 战斗场景加载
GAME_STATE_BATTLE_PVP = 7;		-- PvP状态
GAME_STATE_MULTI_BATTLE = 8;	-- 多人副本战斗
GAME_STATE_CAMP_BATTLE = 9;	    -- 阵营战
GAME_STATE_BOSS = 10;		    -- boss状态
GAME_STATE_RECONNECT = 11;		-- 断线重连状态



ELOGIN_WEB_CHECK_ACCOUNT_FAILED			= -21001;		-- 登录失败, WEB平台验证失败
ELOGIN_SAME_ACCOUNT_CHECKING			= -21002;		-- 登录失败, 相同账号在验证
ELOGIN_FORBIDDEN_ACCOUNT				= -21003;		-- 登录失败, 被GM封号
ELOGIN_DB_ACCOUNT_VERITY_SQL			= -21003;		-- 登录失败, DB服务器验证执行SQL语句失败
ELOGIN_DB_ACCOUNT_NOT_IN_VERITY_LIST	= -21004;		-- 登录失败, 没有在验证列表中
ELOGIN_DB_ACCOUNT_SESSION				= -21005; 		-- 登录失败, session不同
ELOGIN_DB_ACCOUNT_SQL_RESPONSE_MSG		= -21006; 		-- 登录失败, SQL语句返回消息错误
ELOGIN_DB_ACCOUNT_SQL_RESULT			= -21007; 		-- 登录失败, SQL语句结果错误
ELOGIN_DB_ACCOUNT_DOESNOT_EXIST			= -21008; 		-- 登录失败, 帐号不存在
ELOGIN_DB_ACCOUNT_DOESNOT_MATCH			= -21009;		-- 登录失败, 密码不匹配
ELOGIN_DB_ACCOUNT_NOT_PLAYER			= -21010; 		-- 登录失败, 和玩家账号不同
ELOGIN_DB_ACCOUNT_FCMSTATUS				= -21011;		-- 登出失败, 防沉迷中禁止登录
ELOGIN_ACCOUNT_LIST_IS_FULL				= -21012;		-- 登出失败, 账号列表已满
ELOGIN_DBSESSION_IS_FULL				= -21013;		-- 登录游戏失败, 因为目前系统允许的与数据库的Session达到上线
ELOGIN_VERIFY_BYMYSQL_TIMEOUT			= -21015;		-- 登录游戏失败, 因为数据库验证超时
ELOGIN_VERIFY_BYWEB_TIMEOUT				= -21016;		-- 登录游戏失败, 因为WEB验证超时
ELOGIN_CLIENT_VERSION_NOTMATCH 			= -21017; 		-- 客户端版本与服务器不匹配
ELOGIN_SERVER_BE_MAINTENANCE			= -21018;		-- 服务器维护中，暂时不能登录
ELOGIN_CLIENT_MD5CODE_NOTMATCH 			= -21019; 		-- 客户端传入的MD5不正确
ELOGIN_CLIENT_NEED_MATRIXCODE			= -21020;		-- 需要客户端传入动态密保码
ELOGIN_CLIENT_NEED_STATICMATRIXCODE		= -21021;		-- 需要客户端传入密保卡
ELOGIN_CLIENT_NOTIN_LIMITIP				= -21022;		-- 没有在绑定IP地址登陆
ELOGIN_RECONNECT_TOKEN_INVALID			= -21023;		-- 断线重连时令牌不对
ELOGIN_RECONNECT_OFF_LINE_LONG_TIME		= -21024;		-- 断线重连时下线时间太长

EM_KICKOUT_NONE                     = 0;        -- 没有被踢
EM_KICKOUT_LOCKDATA					= 1;		-- 玩家数据异常，角色被锁定，请联系客服人员 如: 玩家存盘不完整； 玩家数据在新模板里找不到等等，都会锁定玩家，以确保不会让玩家数据丢失
EM_KICKOUT_TIMEOUT					= 2;		-- 客户端连接超时
EM_KICKOUT_SERVERMAINTANCE			= 3;		-- 服务器停机维护
EM_KICKOUT_UNKOWNACTION				= 4;		-- 玩家行为异常( 如：恶意向服务器发大量消息 )
EM_KICKOUT_RELOGIN					= 5;		-- 玩家重复登录踢人
EM_KICKOUT_NOTINGATE				= 6;		-- 玩家的网关数据不存在
EM_KICKOUT_SAVETIMEOUT				= 7;		-- 存盘超时踢人
EM_KICKOUT_ACCOUNTFROZEN			= 8;		-- 冻结帐号踢人
EM_KICKOUT_ANTIBOT_MULTICLIENT		= 9;		-- 反外挂踢人： 客户端多开（大于3个）
EM_KICKOUT_ANTIBOT_VM				= 10;		-- 反外挂踢人： 虚拟桌面		
EM_KICKOUT_ANTIBOT_MULTIUSER		= 11;		-- 反外挂踢人： 多用户
EM_KICKOUT_ANTIADDICTION			= 12;		-- 防沉迷踢人
EM_KICKOUT_SPEEDCHEATING			= 13;		-- 移动速度异常，请离游戏
EM_KICKOUT_SPEEDCHEATING2			= 14;		-- 移动速度异常，请离游戏
EM_KICKOUT_MULTICLIENT				= 15;		-- 单IP登陆玩家过多, 请离游戏
EM_KICKOUT_DATACRASH				= 16;		-- 数据损坏，登陆游戏失败(如：玩家已有数据在模板中找不到；数据库中字段数目不正确)
EM_KICKOUT_ANTIBOT_OTHER			= 17;		-- 反外挂其它错误
EM_KICKOUT_GM_SEAL_IP               = 18;		-- GM封IP
EM_KICKOUT_GM_KICK                  = 19;		-- GM踢人
EM_KICKOUT_GM_DEBUG                 = 20;		-- GM命令



-- endregion
