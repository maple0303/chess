--region *.lua
--Date
--此文件由[BabeLua]插件自动生成
LuaTimeFormat = {};

--数字只有1位的,前面补0
function LuaTimeFormat.Fix0String(nTimeNum)
	local str = "";
	if (nTimeNum < 10)
	then
		str = "0" .. nTimeNum;
	else
		str = nTimeNum .. "";
	end
	return str;
end 
--将时间显示为 x年x月x日x分x秒 
--参数
-- time:单位秒
function LuaTimeFormat.ShowClock(nSec, bShowYear, bShowMonth, bShowDate, bShowHours, bShowMinutes, bShowSeconds)
	local strYear = "";
	local strMonth = "";
	local strDate = "";
	local strHour = "";
	local strMinutes = "";
	local strSeconds = "";
	local strReturn = "";
	if (bShowYear == true)
	then
		strYear = LuaTimeFormat.Fix0String(tonumber(os.date("%Y", nSec))) .. CLanguageData.GetLanguageText("Com_Year");
	end
	if (bShowMonth == true)
    then
		strMonth = LuaTimeFormat.Fix0String(tonumber(os.date("%m", nSec))) .. CLanguageData.GetLanguageText("Com_Month");
	end
	if (bShowDate == true)
	then
		strDate = LuaTimeFormat.Fix0String(tonumber(os.date("%d", nSec))) .. CLanguageData.GetLanguageText("Com_Date");
	end
	if (bShowHours == true)
	then
		strHour = LuaTimeFormat.Fix0String(tonumber(os.date("%H", nSec))) .. CLanguageData.GetLanguageText("Com_Hour");
	end
	if (bShowMinutes == true)
	then
		strMinutes = LuaTimeFormat.Fix0String(tonumber(os.date("%M", nSec))) .. CLanguageData.GetLanguageText("Com_Minute");
	end
	if (bShowSeconds == true)
	then
		strSeconds = LuaTimeFormat.Fix0String(tonumber(os.date("%S", nSec))) .. CLanguageData.GetLanguageText("Com_Second");
	end
	strReturn = strYear .. strMonth .. strDate .. strHour .. strMinutes .. strSeconds;
	return strReturn;
end
--将时间显示为 2015.12.20
function LuaTimeFormat.ShowNumberClock(nSec)
	local strYear = "";
	local strMonth = "";
	local strDate = "";
	local strReturn = "";		

	strYear = LuaTimeFormat.Fix0String(tonumber(os.date("%Y", nSec))) .. CLanguageData.GetLanguageText("Com_TimeSeparator");
	strMonth = LuaTimeFormat.Fix0String(tonumber(os.date("%m", nSec))) .. CLanguageData.GetLanguageText("Com_TimeSeparator");		
	strDate = LuaTimeFormat.Fix0String(tonumber(os.date("%d", nSec)));
	strReturn = strYear .. strMonth	.. strDate;	
	return strReturn;
end
--显示 小时:分钟 
function LuaTimeFormat.TimerToClock(nSec)
	local strHour = "";
	local strMinutes = "";
    strHour = LuaTimeFormat.Fix0String(tonumber(os.date("%H", nSec)));
    strMinutes = LuaTimeFormat.Fix0String(tonumber(os.date("%M", nSec)));
	local strReturn = strHour .. ":" .. strMinutes;
	return strReturn;
end
--将秒转化为 分钟：秒	如500秒转为08:20
function LuaTimeFormat.TimerToClockMinuteSecond(nSecond)
	local nMinute = math.floor(nSecond / 60);
	local strReturn = LuaTimeFormat.Fix0String(nMinute) .. ":" .. LuaTimeFormat.Fix0String(math.floor(nSecond % 60));
	return strReturn;
end
--返回时间差( 参数秒：当前endTime - 过去startTime的时间差)
--结果类似 7天前 2小时前....
function LuaTimeFormat.TimerEarly(nSec)
	local nWeeks = math.floor(nSec / 86400);	--周
	local nHours = math.floor(nSec / 3600);
	local nMinutes = math.floor(nSec / 60);
	if (nWeeks >= 7)
	then
		return CLanguageData.GetLanguageText("Com_OutOfSeven");
	end
	if (nWeeks >= 2)
	then
		return string.format(CLanguageData.GetLanguageText("Com_DaysAgo"),nWeeks);
	elseif(nWeeks >= 1)
	then
		return CLanguageData.GetLanguageText("Com_Yesterday");
	end
	if (nHours >= 1)
	then
		return string.format(CLanguageData.GetLanguageText("Com_HoursAgo"),nHours);
	end
	if (nMinutes >= 30)
	then
		return CLanguageData.GetLanguageText("Com_HalfHourAgo");
	end
	if (nMinutes <= 0)
	then
		return CLanguageData.GetLanguageText("Com_Current");
	end
	return string.format(CLanguageData.GetLanguageText("Com_MinutesAgo"),nMinutes);
end
-- 返回时间 1:13:22 2:11
function LuaTimeFormat.TimeLater(nSec)
	if(nSec < 0)
    then 
        nSec = 0;
    end
	local arrParse = LuaTimeFormat.ParseTimeToArray(nSec);
	local strFixHours = LuaTimeFormat.Fix0String(arrParse[1]);
	local strFixMinuters = LuaTimeFormat.Fix0String(arrParse[2]);
	local strFixSeconds = LuaTimeFormat.Fix0String(arrParse[3]);
	if (arrParse[1] >= 72)
	then
		return CLanguageData.GetLanguageText("ThreeDaysLater");
	elseif(arrParse[1] >= 48)
	then
		return CLanguageData.GetLanguageText("Com_Acquired");
	elseif(arrParse[1] >= 24)		
	then
		return CLanguageData.GetLanguageText("Com_Tomorrow");
	else
        local strReturn = "";
	    if(arrParse[1] > 0)
	    then
		    strReturn = strFixHours;
	    end
	    strReturn = strReturn .. ":" .. strFixMinuters .. ":" .. strFixSeconds;
	    return strReturn;
    end
end
--返回时间  72:23:59  小时：分：秒
function LuaTimeFormat.FullTimeLater(nSec)
	if(nSec < 0)
    then 
        nSec = 0;
    end
	local arrParse = LuaTimeFormat.ParseTimeToArray(nSec);
	local strFixHours = LuaTimeFormat.Fix0String(arrParse[1]);
	local strFixMinuters = LuaTimeFormat.Fix0String(arrParse[2]);
	local strFixSeconds = LuaTimeFormat.Fix0String(arrParse[3]);
	local strReturn = "";
	if(arrParse[1] > 0)
	then
		strReturn = strFixHours;
	end
    --print("输出小时",strReturn);
    if strReturn == nil or strReturn == "" then
        strReturn = "00";
    end
	strReturn = strReturn .. ":" .. strFixMinuters .. ":" .. strFixSeconds;
	return strReturn;
end 
--解析时间 为 小时 分钟 秒 的数组
function LuaTimeFormat.ParseTimeToArray(nSec)
	local nLessTime = nSec;
	local nHours = 0;
	local nMinutes = 0;
	local nSeconds = 0;
	if (nLessTime / 3600 > 0)
	then
		nHours = math.floor(nLessTime / 3600);
		nLessTime = nLessTime - nHours * 3600;
	end
	if (nLessTime / 60 > 0)
	then
		nMinutes = math.floor(nLessTime / 60);
		nLessTime = nLessTime - nMinutes * 60;
	end
	nSeconds = nLessTime;
	return {nHours,nMinutes,nSeconds};
end
--解析时间 为 天 小时 分钟 秒 的数组
function LuaTimeFormat.ParseTimeToArrayDay(nSec)
	local nLessTime = nSec;
	local nDay = 0;
	local nHours = 0;
	local nMinutes = 0;
	local nSeconds = 0;
	if (nLessTime / 86400 > 0)
	then
		nDay = math.floor(nLessTime / 86400);
		nLessTime = nLessTime - nDay * 86400;
	end
    local arr = LuaTimeFormat.ParseTimeToArray(nLessTime);
    table.insert(arr,1,nDay);
	return arr;
end
--转化为时分秒       8时9分12秒
function LuaTimeFormat.ParseTimeToHourMinuteSecond(nSec)
	local arr = LuaTimeFormat.ParseTimeToArray(nSec);
	local str = "";
	if(arr[1] > 0)
	then
		str = arr[1] .. CLanguageData.GetLanguageText("Com_Hour");
	end
	if(arr[2] > 0 or arr[1] > 0)
	then
		str = str .. arr[2] .. CLanguageData.GetLanguageText("Com_Minute");
	end
	str = str .. arr[3] .. CLanguageData.GetLanguageText("Com_Second");
	return str;
end

--endregion
