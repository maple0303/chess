LuaLocalDataStorage = {};
--得到本地存储的战斗力数据
function LuaLocalDataStorage.GetLocalCombatPower(nSeverID, nCharID)
    local nYesterdayCombatPower = UnityEngine.PlayerPrefs.GetInt(nSeverID.."_"..nCharID.."_YesterdayCombatPower");
    return nYesterdayCombatPower;
end
--存储战斗力数据到本地
function LuaLocalDataStorage.SetLocalCombatPower(nSeverID, nCharID, nCombatPower)
    UnityEngine.PlayerPrefs.SetInt(nSeverID.."_"..nCharID.."_YesterdayCombatPower", nCombatPower);
end
--得到本地存储的战斗力的存储日期
function LuaLocalDataStorage.GetLocalCombatPowerSaveTime(nSeverID, nCharID)
    local strData = UnityEngine.PlayerPrefs.GetString(nSeverID.."_"..nCharID.."_YesterdayCombatPower_time");
    return strData;
end
--设置本地存储的战斗力的存储日期
function LuaLocalDataStorage.SetLocalCombatPowerSaveTime(nSeverID, nCharID, strCurData)
    UnityEngine.PlayerPrefs.SetString(nSeverID.."_"..nCharID.."_YesterdayCombatPower_time", strCurData);
end
--获取存储在本地的玩家等级数据
function LuaLocalDataStorage.GetLocalPlayerLevel(strUserName, nSeverID, strIP)
    local nLv = UnityEngine.PlayerPrefs.GetInt(strUserName.."_"..nSeverID.."_"..strIP.."_PlayerLevel");
    return nLv;
end
--获取存储在本地的玩家等级数据存储时间
function LuaLocalDataStorage.GetLocalPlayerLevelTime(strUserName, nSeverID, strIP)
    local time = UnityEngine.PlayerPrefs.GetInt(strUserName.."_"..nSeverID.."_"..strIP.."_PlayerLevel_time");
    return time;
end
--获取存储在本地的玩家等级数据
function LuaLocalDataStorage.SetLocalPlayerLevel(strUserName, nSeverID, strIP, nLv)
    UnityEngine.PlayerPrefs.SetInt(strUserName.."_"..nSeverID.."_"..strIP.."_PlayerLevel", nLv);
    UnityEngine.PlayerPrefs.SetInt(strUserName.."_"..nSeverID.."_"..strIP.."_PlayerLevel_time", os.time());
end
--存储私聊好友名单
function LuaLocalDataStorage.SetLocalPChatFriendNameList(nMyCharID, strNameContent)
    UnityEngine.PlayerPrefs.SetString(nMyCharID.."_NameContent", strNameContent);
--    log("进行人名信息存储"..nMyCharID..strNameContent);
end
--获取私聊好友名单
function LuaLocalDataStorage.GetLocalPChatFriendNameList(nMyCharID)
    local m_strPChatFriendNameList = UnityEngine.PlayerPrefs.GetString(nMyCharID.."_NameContent");
    return m_strPChatFriendNameList;
end
--存储私聊的信息
function LuaLocalDataStorage.SetLocalPChatMsg(nMyCharID, nPlayerCharID, strSpeechContent)
    UnityEngine.PlayerPrefs.SetString(nMyCharID.."_"..nPlayerCharID.."_SpeechContent", strSpeechContent);
--    log("进行聊天信息存储"..nMyCharID.."_"..nPlayerCharID..strSpeechContent);
end
--获取玩家私聊信息
function LuaLocalDataStorage.GetLocalPChatMsg(nMyCharID, nPlayerCharID )
    local m_strPChatMsg = UnityEngine.PlayerPrefs.GetString(nMyCharID.."_"..nPlayerCharID.."_SpeechContent");
    return m_strPChatMsg;
end
--存储新获得的伙伴
function LuaLocalDataStorage.SetLocalTavernList(nMyCharID,strTavernList)
    UnityEngine.PlayerPrefs.SetString(nMyCharID.."_TavernList", strTavernList);
end
--获取获取新伙伴本地列表
function LuaLocalDataStorage.getTavernRecord(nMyCharID)
    local m_strTavernList = UnityEngine.PlayerPrefs.GetString(nMyCharID.."_TavernList");
    return m_strTavernList;
end
--存储玩家登录ID
function LuaLocalDataStorage.SetLocalLoginGame(LoginGame,strLoginGameName)
    UnityEngine.PlayerPrefs.SetString(LoginGame.."_LoginGame", strLoginGameName);
end
--获取玩家登录ID
function LuaLocalDataStorage.GetLoginGame(LoginGame)
    local strLoginGameName = UnityEngine.PlayerPrefs.GetString(LoginGame .."_LoginGame");
    return strLoginGameName;
end
--删除玩家登录ID
function LuaLocalDataStorage.DeleteLoginGame(LoginGame)
    local strLoginGameName = UnityEngine.PlayerPrefs.DeleteKey(LoginGame .."_LoginGame");
end
--存储音乐设置 "on" "off"
function LuaLocalDataStorage.SetMusicSwitch(switchState)
    UnityEngine.PlayerPrefs.SetString("musicSwitch", switchState);
end
--获取音乐设置
function LuaLocalDataStorage.GetMusicSwitch()
    return UnityEngine.PlayerPrefs.GetString("musicSwitch");
end
--存储音效设置
function LuaLocalDataStorage.SetMusicEffectSwitch(switchState)
    UnityEngine.PlayerPrefs.SetString("musicEffectSwitch", switchState);
end
--获取音效设置
function LuaLocalDataStorage.GetMusicEffectSwitch()
    return UnityEngine.PlayerPrefs.GetString("musicEffectSwitch");
end
--存储隐藏其他玩家设置
function LuaLocalDataStorage.SetHideOtherPlayerSwitch(switchState)
    UnityEngine.PlayerPrefs.SetString("hideOtherPlayerSwitch", switchState);
end
--获取隐藏其他玩家光效设置
function LuaLocalDataStorage.GetHideOtherPlayerSwitch()
    return UnityEngine.PlayerPrefs.GetString("hideOtherPlayerSwitch");
end
--存储隐藏其他玩家光效设置
function LuaLocalDataStorage.SetHideOtherPlayerSkillSwitch(switchState)
    UnityEngine.PlayerPrefs.SetString("hideOtherPlayerSkillSwitch", switchState);
end
--获取隐藏其他玩家光效设置
function LuaLocalDataStorage.GetHideOtherPlayerSkillSwitch()
    return UnityEngine.PlayerPrefs.GetString("hideOtherPlayerSkillSwitch");
end
--存储玩家设置的在追踪界面不显示的任务
function LuaLocalDataStorage.SetHideTaskList(nMyCharID,strTaskList)
    UnityEngine.PlayerPrefs.SetString(nMyCharID.."_TaskList", strTaskList);
end
--获取玩家设置的在追踪界面不显示的任务
function LuaLocalDataStorage.GetHideTaskList(nMyCharID)
    local m_strTaskList = UnityEngine.PlayerPrefs.GetString(nMyCharID.."_TaskList");
    return m_strTaskList;
end
