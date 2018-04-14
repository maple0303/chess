--region *.lua
--Date
--此文件由[BabeLua]插件自动生成
LuaCGameConfig = 
{
    centerServerUrl = "",
    gmServerUrl = "",
    idfaServerUrl = "",
    WeChatLinkUrl = "",
    iosPayLinkUrl = "",

    optionRecharge = "off",
    optionWeChat = "off",
    optionFacebook = "off",
    optionWrap = "off",
    optionRandomName = "on",
    optionShowRandomNameBtn = "on",
    optionShowBindingPhoneBtn = "on",
    optionPhoto = "off",
    mailDirtyWord = "off",
}

function LuaCGameConfig.Init()
    local xmlData = LoadXmlData("config/GameConfig");
    if(xmlData == nil or xmlData == "") then
        return;
    end
    for i, child in ipairs(xmlData.ChildNodes) do
        if(child.Name == "url") then
            for ii, subChild in ipairs(child.ChildNodes) do
                if(subChild.Name == "centerServer") then
			        LuaCGameConfig.centerServerUrl = subChild.InnerText;
                elseif(subChild.Name == "gmServer") then
			        LuaCGameConfig.gmServerUrl = subChild.InnerText;
                elseif(subChild.Name == "idfaServer") then
			        LuaCGameConfig.idfaServerUrl = subChild.InnerText;
                elseif(subChild.Name == "WeChatLink") then
			        LuaCGameConfig.WeChatLinkUrl = subChild.InnerText;
                elseif(subChild.Name == "IosPayLink") then
                    LuaCGameConfig.iosPayLinkUrl = subChild.InnerText;
                end
            end
        elseif(child.Name == "option") then
            for ii, subChild in ipairs(child.ChildNodes) do
                if(subChild.Name == "recharge") then
                    LuaCGameConfig.optionRecharge = subChild.InnerText;
                elseif(subChild.Name == "WeChat") then
			        LuaCGameConfig.optionWeChat = subChild.InnerText;
                elseif(subChild.Name == "facebook") then
			        LuaCGameConfig.optionFacebook = subChild.InnerText;
                elseif(subChild.Name == "wrap") then
			        LuaCGameConfig.optionPhoto = subChild.InnerText;
                elseif(subChild.Name == "photo") then
			        LuaCGameConfig.optionWrap = subChild.InnerText;
                elseif(subChild.Name == "randomName") then
			        LuaCGameConfig.optionRandomName = subChild.InnerText;
                elseif(subChild.Name == "showRandomNameBtn") then
			        LuaCGameConfig.optionShowRandomNameBtn = subChild.InnerText;
                elseif(subChild.Name == "showBindingPhoneBtn") then
			        LuaCGameConfig.optionShowBindingPhoneBtn = subChild.InnerText;
                elseif(subChild.Name == "mailDirtyWord") then
			        LuaCGameConfig.mailDirtyWord = subChild.InnerText;
                end
            end
        end			
    end
end
--endregion
