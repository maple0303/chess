﻿//this source code was auto-generated by tolua#, do not modify it
using System;
using LuaInterface;

public class ChannelPlatform_PayInfoWrap
{
	public static void Register(LuaState L)
	{
		L.BeginClass(typeof(ChannelPlatform.PayInfo), typeof(System.Object));
		L.RegFunction("New", _CreateChannelPlatform_PayInfo);
		L.RegFunction("__tostring", ToLua.op_ToString);
		L.RegVar("server_ID", get_server_ID, set_server_ID);
		L.RegVar("gameUser_ID", get_gameUser_ID, set_gameUser_ID);
		L.RegVar("role_ID", get_role_ID, set_role_ID);
		L.RegVar("product_name", get_product_name, set_product_name);
		L.RegVar("product_price", get_product_price, set_product_price);
		L.RegVar("product_count", get_product_count, set_product_count);
		L.RegVar("custom_define", get_custom_define, set_custom_define);
		L.RegVar("product_ID", get_product_ID, set_product_ID);
		L.RegVar("change_rate", get_change_rate, set_change_rate);
		L.EndClass();
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int _CreateChannelPlatform_PayInfo(IntPtr L)
	{
		try
		{
			int count = LuaDLL.lua_gettop(L);

			if (count == 0)
			{
				ChannelPlatform.PayInfo obj = new ChannelPlatform.PayInfo();
				ToLua.PushObject(L, obj);
				return 1;
			}
			else
			{
				return LuaDLL.luaL_throw(L, "invalid arguments to ctor method: ChannelPlatform.PayInfo.New");
			}
		}
		catch (Exception e)
		{
			return LuaDLL.toluaL_exception(L, e);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get_server_ID(IntPtr L)
	{
		object o = null;

		try
		{
			o = ToLua.ToObject(L, 1);
			ChannelPlatform.PayInfo obj = (ChannelPlatform.PayInfo)o;
			string ret = obj.server_ID;
			LuaDLL.lua_pushstring(L, ret);
			return 1;
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e, o, "attempt to index server_ID on a nil value");
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get_gameUser_ID(IntPtr L)
	{
		object o = null;

		try
		{
			o = ToLua.ToObject(L, 1);
			ChannelPlatform.PayInfo obj = (ChannelPlatform.PayInfo)o;
			string ret = obj.gameUser_ID;
			LuaDLL.lua_pushstring(L, ret);
			return 1;
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e, o, "attempt to index gameUser_ID on a nil value");
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get_role_ID(IntPtr L)
	{
		object o = null;

		try
		{
			o = ToLua.ToObject(L, 1);
			ChannelPlatform.PayInfo obj = (ChannelPlatform.PayInfo)o;
			string ret = obj.role_ID;
			LuaDLL.lua_pushstring(L, ret);
			return 1;
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e, o, "attempt to index role_ID on a nil value");
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get_product_name(IntPtr L)
	{
		object o = null;

		try
		{
			o = ToLua.ToObject(L, 1);
			ChannelPlatform.PayInfo obj = (ChannelPlatform.PayInfo)o;
			string ret = obj.product_name;
			LuaDLL.lua_pushstring(L, ret);
			return 1;
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e, o, "attempt to index product_name on a nil value");
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get_product_price(IntPtr L)
	{
		object o = null;

		try
		{
			o = ToLua.ToObject(L, 1);
			ChannelPlatform.PayInfo obj = (ChannelPlatform.PayInfo)o;
			float ret = obj.product_price;
			LuaDLL.lua_pushnumber(L, ret);
			return 1;
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e, o, "attempt to index product_price on a nil value");
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get_product_count(IntPtr L)
	{
		object o = null;

		try
		{
			o = ToLua.ToObject(L, 1);
			ChannelPlatform.PayInfo obj = (ChannelPlatform.PayInfo)o;
			int ret = obj.product_count;
			LuaDLL.lua_pushinteger(L, ret);
			return 1;
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e, o, "attempt to index product_count on a nil value");
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get_custom_define(IntPtr L)
	{
		object o = null;

		try
		{
			o = ToLua.ToObject(L, 1);
			ChannelPlatform.PayInfo obj = (ChannelPlatform.PayInfo)o;
			string ret = obj.custom_define;
			LuaDLL.lua_pushstring(L, ret);
			return 1;
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e, o, "attempt to index custom_define on a nil value");
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get_product_ID(IntPtr L)
	{
		object o = null;

		try
		{
			o = ToLua.ToObject(L, 1);
			ChannelPlatform.PayInfo obj = (ChannelPlatform.PayInfo)o;
			string ret = obj.product_ID;
			LuaDLL.lua_pushstring(L, ret);
			return 1;
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e, o, "attempt to index product_ID on a nil value");
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get_change_rate(IntPtr L)
	{
		object o = null;

		try
		{
			o = ToLua.ToObject(L, 1);
			ChannelPlatform.PayInfo obj = (ChannelPlatform.PayInfo)o;
			int ret = obj.change_rate;
			LuaDLL.lua_pushinteger(L, ret);
			return 1;
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e, o, "attempt to index change_rate on a nil value");
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int set_server_ID(IntPtr L)
	{
		object o = null;

		try
		{
			o = ToLua.ToObject(L, 1);
			ChannelPlatform.PayInfo obj = (ChannelPlatform.PayInfo)o;
			string arg0 = ToLua.CheckString(L, 2);
			obj.server_ID = arg0;
			return 0;
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e, o, "attempt to index server_ID on a nil value");
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int set_gameUser_ID(IntPtr L)
	{
		object o = null;

		try
		{
			o = ToLua.ToObject(L, 1);
			ChannelPlatform.PayInfo obj = (ChannelPlatform.PayInfo)o;
			string arg0 = ToLua.CheckString(L, 2);
			obj.gameUser_ID = arg0;
			return 0;
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e, o, "attempt to index gameUser_ID on a nil value");
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int set_role_ID(IntPtr L)
	{
		object o = null;

		try
		{
			o = ToLua.ToObject(L, 1);
			ChannelPlatform.PayInfo obj = (ChannelPlatform.PayInfo)o;
			string arg0 = ToLua.CheckString(L, 2);
			obj.role_ID = arg0;
			return 0;
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e, o, "attempt to index role_ID on a nil value");
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int set_product_name(IntPtr L)
	{
		object o = null;

		try
		{
			o = ToLua.ToObject(L, 1);
			ChannelPlatform.PayInfo obj = (ChannelPlatform.PayInfo)o;
			string arg0 = ToLua.CheckString(L, 2);
			obj.product_name = arg0;
			return 0;
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e, o, "attempt to index product_name on a nil value");
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int set_product_price(IntPtr L)
	{
		object o = null;

		try
		{
			o = ToLua.ToObject(L, 1);
			ChannelPlatform.PayInfo obj = (ChannelPlatform.PayInfo)o;
			float arg0 = (float)LuaDLL.luaL_checknumber(L, 2);
			obj.product_price = arg0;
			return 0;
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e, o, "attempt to index product_price on a nil value");
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int set_product_count(IntPtr L)
	{
		object o = null;

		try
		{
			o = ToLua.ToObject(L, 1);
			ChannelPlatform.PayInfo obj = (ChannelPlatform.PayInfo)o;
			int arg0 = (int)LuaDLL.luaL_checknumber(L, 2);
			obj.product_count = arg0;
			return 0;
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e, o, "attempt to index product_count on a nil value");
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int set_custom_define(IntPtr L)
	{
		object o = null;

		try
		{
			o = ToLua.ToObject(L, 1);
			ChannelPlatform.PayInfo obj = (ChannelPlatform.PayInfo)o;
			string arg0 = ToLua.CheckString(L, 2);
			obj.custom_define = arg0;
			return 0;
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e, o, "attempt to index custom_define on a nil value");
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int set_product_ID(IntPtr L)
	{
		object o = null;

		try
		{
			o = ToLua.ToObject(L, 1);
			ChannelPlatform.PayInfo obj = (ChannelPlatform.PayInfo)o;
			string arg0 = ToLua.CheckString(L, 2);
			obj.product_ID = arg0;
			return 0;
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e, o, "attempt to index product_ID on a nil value");
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int set_change_rate(IntPtr L)
	{
		object o = null;

		try
		{
			o = ToLua.ToObject(L, 1);
			ChannelPlatform.PayInfo obj = (ChannelPlatform.PayInfo)o;
			int arg0 = (int)LuaDLL.luaL_checknumber(L, 2);
			obj.change_rate = arg0;
			return 0;
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e, o, "attempt to index change_rate on a nil value");
		}
	}
}

