
--输出日志--
function log(str)
    CLuaFunction.Log(str);
end

--错误日志--
function logError(str) 
	CLuaFunction.LogError(str);
end

--警告日志--
function logWarn(str) 
	CLuaFunction.LogWarning(str);
end

--判断某个lua文件是否存在
function LuaFileExists(path)
  return CLuaFunction.LuaFileExists(path ..".lua");
end

--判断文件是否存在
function FileExists(path)
  local file = io.open(path, "rb")
  if file then file:close() end
  return file ~= nil
end

--加载xml  path 路径
function LoadXmlData(path)
    local str = CLuaFunction.LoadXml(path);
    if(str == nil) 
    then
        return nil;
    end
    --将string 转化成 table
    local table = loadstring("return "..str)();
    return table;
end

--加载xml  根据文体内容
function LoadXmlDataForText(strTextContent)
    local str = CLuaFunction.LoadXmlForText(strTextContent);
    if(str == nil) 
    then
        return nil;
    end
    --将string 转化成 table
    local table = loadstring("return "..str)();
    return table;
end


