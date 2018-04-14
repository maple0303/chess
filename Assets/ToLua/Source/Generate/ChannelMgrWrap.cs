﻿//this source code was auto-generated by tolua#, do not modify it
using System;
using LuaInterface;

public class ChannelMgrWrap
{
	public static void Register(LuaState L)
	{
		L.BeginStaticLibs("ChannelMgr");
		L.RegFunction("UpdateLogoutSrc", UpdateLogoutSrc);
		L.RegFunction("Login", Login);
		L.RegFunction("Logout", Logout);
		L.RegFunction("Pay", Pay);
		L.RegFunction("GetChannel", GetChannel);
		L.RegFunction("GetUid", GetUid);
		L.RegFunction("GetUserName", GetUserName);
		L.RegFunction("GetSessionID", GetSessionID);
		L.RegFunction("GetOrderId", GetOrderId);
		L.RegFunction("GetPlatformOrderId", GetPlatformOrderId);
		L.RegFunction("HideSplash", HideSplash);
		L.RegFunction("HasUserCenter", HasUserCenter);
		L.RegFunction("UserCenter", UserCenter);
		L.RegFunction("CreatRole", CreatRole);
		L.RegFunction("RoleUpgrade", RoleUpgrade);
		L.RegFunction("EnterGame", EnterGame);
		L.RegVar("m_OnLoginCallBack", get_m_OnLoginCallBack, set_m_OnLoginCallBack);
		L.RegVar("m_OnPayCallBack", get_m_OnPayCallBack, set_m_OnPayCallBack);
		L.RegVar("IsUseChannelSDK", get_IsUseChannelSDK, null);
		L.EndStaticLibs();
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int UpdateLogoutSrc(IntPtr L)
	{
		try
		{
			ToLua.CheckArgsCount(L, 0);
			ChannelMgr.UpdateLogoutSrc();
			return 0;
		}
		catch (Exception e)
		{
			return LuaDLL.toluaL_exception(L, e);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int Login(IntPtr L)
	{
		try
		{
			ToLua.CheckArgsCount(L, 0);
			ChannelMgr.Login();
			return 0;
		}
		catch (Exception e)
		{
			return LuaDLL.toluaL_exception(L, e);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int Logout(IntPtr L)
	{
		try
		{
			ToLua.CheckArgsCount(L, 0);
			ChannelMgr.Logout();
			return 0;
		}
		catch (Exception e)
		{
			return LuaDLL.toluaL_exception(L, e);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int Pay(IntPtr L)
	{
		try
		{
			ToLua.CheckArgsCount(L, 1);
			ChannelPlatform.PayInfo arg0 = (ChannelPlatform.PayInfo)ToLua.CheckObject<ChannelPlatform.PayInfo>(L, 1);
			ChannelMgr.Pay(arg0);
			return 0;
		}
		catch (Exception e)
		{
			return LuaDLL.toluaL_exception(L, e);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int GetChannel(IntPtr L)
	{
		try
		{
			ToLua.CheckArgsCount(L, 0);
			string o = ChannelMgr.GetChannel();
			LuaDLL.lua_pushstring(L, o);
			return 1;
		}
		catch (Exception e)
		{
			return LuaDLL.toluaL_exception(L, e);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int GetUid(IntPtr L)
	{
		try
		{
			ToLua.CheckArgsCount(L, 0);
			string o = ChannelMgr.GetUid();
			LuaDLL.lua_pushstring(L, o);
			return 1;
		}
		catch (Exception e)
		{
			return LuaDLL.toluaL_exception(L, e);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int GetUserName(IntPtr L)
	{
		try
		{
			ToLua.CheckArgsCount(L, 0);
			string o = ChannelMgr.GetUserName();
			LuaDLL.lua_pushstring(L, o);
			return 1;
		}
		catch (Exception e)
		{
			return LuaDLL.toluaL_exception(L, e);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int GetSessionID(IntPtr L)
	{
		try
		{
			ToLua.CheckArgsCount(L, 0);
			string o = ChannelMgr.GetSessionID();
			LuaDLL.lua_pushstring(L, o);
			return 1;
		}
		catch (Exception e)
		{
			return LuaDLL.toluaL_exception(L, e);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int GetOrderId(IntPtr L)
	{
		try
		{
			ToLua.CheckArgsCount(L, 0);
			string o = ChannelMgr.GetOrderId();
			LuaDLL.lua_pushstring(L, o);
			return 1;
		}
		catch (Exception e)
		{
			return LuaDLL.toluaL_exception(L, e);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int GetPlatformOrderId(IntPtr L)
	{
		try
		{
			ToLua.CheckArgsCount(L, 0);
			string o = ChannelMgr.GetPlatformOrderId();
			LuaDLL.lua_pushstring(L, o);
			return 1;
		}
		catch (Exception e)
		{
			return LuaDLL.toluaL_exception(L, e);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int HideSplash(IntPtr L)
	{
		try
		{
			ToLua.CheckArgsCount(L, 0);
			ChannelMgr.HideSplash();
			return 0;
		}
		catch (Exception e)
		{
			return LuaDLL.toluaL_exception(L, e);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int HasUserCenter(IntPtr L)
	{
		try
		{
			ToLua.CheckArgsCount(L, 0);
			bool o = ChannelMgr.HasUserCenter();
			LuaDLL.lua_pushboolean(L, o);
			return 1;
		}
		catch (Exception e)
		{
			return LuaDLL.toluaL_exception(L, e);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int UserCenter(IntPtr L)
	{
		try
		{
			ToLua.CheckArgsCount(L, 0);
			ChannelMgr.UserCenter();
			return 0;
		}
		catch (Exception e)
		{
			return LuaDLL.toluaL_exception(L, e);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int CreatRole(IntPtr L)
	{
		try
		{
			ToLua.CheckArgsCount(L, 1);
			ChannelPlatform.RoleInfo arg0 = (ChannelPlatform.RoleInfo)ToLua.CheckObject<ChannelPlatform.RoleInfo>(L, 1);
			ChannelMgr.CreatRole(arg0);
			return 0;
		}
		catch (Exception e)
		{
			return LuaDLL.toluaL_exception(L, e);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int RoleUpgrade(IntPtr L)
	{
		try
		{
			ToLua.CheckArgsCount(L, 1);
			ChannelPlatform.RoleInfo arg0 = (ChannelPlatform.RoleInfo)ToLua.CheckObject<ChannelPlatform.RoleInfo>(L, 1);
			ChannelMgr.RoleUpgrade(arg0);
			return 0;
		}
		catch (Exception e)
		{
			return LuaDLL.toluaL_exception(L, e);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int EnterGame(IntPtr L)
	{
		try
		{
			ToLua.CheckArgsCount(L, 1);
			ChannelPlatform.RoleInfo arg0 = (ChannelPlatform.RoleInfo)ToLua.CheckObject<ChannelPlatform.RoleInfo>(L, 1);
			ChannelMgr.EnterGame(arg0);
			return 0;
		}
		catch (Exception e)
		{
			return LuaDLL.toluaL_exception(L, e);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get_m_OnLoginCallBack(IntPtr L)
	{
		try
		{
			ToLua.Push(L, ChannelMgr.m_OnLoginCallBack);
			return 1;
		}
		catch (Exception e)
		{
			return LuaDLL.toluaL_exception(L, e);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get_m_OnPayCallBack(IntPtr L)
	{
		try
		{
			ToLua.Push(L, ChannelMgr.m_OnPayCallBack);
			return 1;
		}
		catch (Exception e)
		{
			return LuaDLL.toluaL_exception(L, e);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get_IsUseChannelSDK(IntPtr L)
	{
		try
		{
			LuaDLL.lua_pushboolean(L, ChannelMgr.IsUseChannelSDK);
			return 1;
		}
		catch (Exception e)
		{
			return LuaDLL.toluaL_exception(L, e);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int set_m_OnLoginCallBack(IntPtr L)
	{
		try
		{
			OnFuncCallBackDelegate arg0 = (OnFuncCallBackDelegate)ToLua.CheckDelegate<OnFuncCallBackDelegate>(L, 2);
			ChannelMgr.m_OnLoginCallBack = arg0;
			return 0;
		}
		catch (Exception e)
		{
			return LuaDLL.toluaL_exception(L, e);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int set_m_OnPayCallBack(IntPtr L)
	{
		try
		{
			OnFuncCallBackDelegate arg0 = (OnFuncCallBackDelegate)ToLua.CheckDelegate<OnFuncCallBackDelegate>(L, 2);
			ChannelMgr.m_OnPayCallBack = arg0;
			return 0;
		}
		catch (Exception e)
		{
			return LuaDLL.toluaL_exception(L, e);
		}
	}
}

