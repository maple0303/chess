LuaCommonMethod = { };
local this = LuaCommonMethod;

    
--时装背包空间不足
function LuaCommonMethod.NoFashionBagSpace()
    LuaCUIConfirm.Show(CLanguageData.GetLanguageText("Com_noFashionBag"), 
    function() LuaCUIFashion.ShowUI() end,
    function() end);
end

-- 背包空间不足
function LuaCommonMethod.NoBagSpace()
    --[[
        string tipStr = CLanguageData.GetLanguageText("Com_Bag_Full");
        CUIConfirm.gUIConfirm.Show(tipStr,
            delegate
            {
                CUIMyRole.gUIMyRole.ShowUI();
            }, delegate { });
        //UnityEngine.Debug.Log("背包空间不足");

        //var btnTexture:Texture = CTextureManager.gTextureManager.loadTexture("images/ui/com/word_dkbb.png");
        //CUIConfirm.gCUIConfirm.setBtnTextureOK(btnTexture,btnTexture);--]]
        LuaCUIConfirm.Show(CLanguageData.GetLanguageText("Com_bag_not_enough_space"), function() LuaCUIMyRole.ShowUI() end, function() end);
end

-- 钻石不足
function LuaCommonMethod.NoYuanBao()
    --LuaCUIConfirm.Show(CLanguageData.GetLanguageText("Com_Yuanbao"),function() LuaCUIVIP.ShowVIPRechargeUI() end, function() end);
    LuaCUIConfirm.Show(CLanguageData.GetLanguageText("Com_Yuanbao"),function() LuaCUIFlyTips.ShowFlyTips(CLanguageData.GetLanguageText("UI_COMMON_221")) end, function() end);
end

-- 金币不足
function LuaCommonMethod.NoMoney()
    LuaCUIConfirm.Show(CLanguageData.GetLanguageText("Com_NoMoney"), 
        function()
            LuaCUIMoneySymbol.ShowUI();
        end,
        function()end
    );
end
--品质对应文字的描边颜色
function LuaCommonMethod.GetQualityOutlineColor(quality)
    if(quality == TmItemQuality.emItemQuality_Gray)
    then
		return UnityEngine.Color(17/255,59/255,10/255,1);-- 灰色品质
	elseif(quality == TmItemQuality.emItemQuality_Red)
    then
		return UnityEngine.Color(50/255,21/255,10/255,1);-- 红色品质
	elseif(quality == TmItemQuality.emItemQuality_White)
    then
		return UnityEngine.Color(17/255,59/255,10/255,1);-- 白色品质
	elseif(quality == TmItemQuality.emItemQuality_Green)
    then
	    return UnityEngine.Color(17/255,59/255,10/255,1);-- 绿色品质
	elseif(quality == TmItemQuality.emItemQuality_Blue)
    then
		return UnityEngine.Color(6/255,18/255,33/255,1);-- 蓝色品质
	elseif(quality == TmItemQuality.emItemQuality_Purple)
    then
		return UnityEngine.Color(25/255,6/255,38/255,1);-- 紫色品质
	elseif(quality == TmItemQuality.emItemQuality_Orange)
    then
		return UnityEngine.Color(246/255,1,0,1);-- 橙色品质
	elseif(quality == TmItemQuality.emItemQuality_Yellow)
    then
		return UnityEngine.Color(42/255,37/255,7/255,1);-- 黄色品质
	elseif(quality == TmItemQuality.emItemQuality_Revere)
    then
		return UnityEngine.Color(246/255,1,0,1);-- 黄色品质
	end
	return UnityEngine.Color(17/255,59/255,10/255,1);
end
-- 品质对应文字颜色
function LuaCommonMethod.GetQualityColor(quality)
    if(quality == TmItemQuality.emItemQuality_Gray)
    then
		return "#b2b2b2";-- 灰色品质
	elseif(quality == TmItemQuality.emItemQuality_Red)
    then
		return "#FF2501";-- 红色品质
	elseif(quality == TmItemQuality.emItemQuality_White)
    then
		return "#FFFFFF";-- 白色品质
	elseif(quality == TmItemQuality.emItemQuality_Green)
    then
	    return "#55FF5d";-- 绿色品质
	elseif(quality == TmItemQuality.emItemQuality_Blue)
    then
		return "#00d8FF";-- 蓝色品质
	elseif(quality == TmItemQuality.emItemQuality_Purple)
    then
		return "#ff3aea";-- 紫色品质
	elseif(quality == TmItemQuality.emItemQuality_Orange)
    then
		return "#FFA800";-- 橙色品质
	elseif(quality == TmItemQuality.emItemQuality_Yellow)
    then
		return "#F6ff00";-- 黄色品质
	elseif(quality == TmItemQuality.emItemQuality_Revere)
    then
		return "#FFA800";-- 黄色品质
	end
	return "#FFFFFF";
end
-- 物品类型对应的文字
function LuaCommonMethod.GetItemTypeNameByType(nType)
    local strTypeName = "";
    if (nType == ITEMTYPE.ITEM_BEAUTY) then
        strTypeName = CLanguageData.GetLanguageText("Com_118");
    elseif (nType == ITEMTYPE.ITEM_SUIT) then
        strTypeName = CLanguageData.GetLanguageText("Com_119");
    elseif (nType == ITEMTYPE.ITEM_FASHION) then
        strTypeName = CLanguageData.GetLanguageText("Com_120");
    elseif (nType == ITEMTYPE.ITEM_GEM_STONE) then
        strTypeName = CLanguageData.GetLanguageText("Com_121");
    elseif (nType == ITEMTYPE.ITEM_RANDOM_GIFT_PACKAGE) then
        strTypeName = CLanguageData.GetLanguageText("Com_122");
    elseif (nType == ITEMTYPE.ITEM_GIFT_PACKAGE) then
        strTypeName = CLanguageData.GetLanguageText("Com_123");
    elseif (nType == ITEMTYPE.ITEM_EQUIP_SCROLL) then
        strTypeName = CLanguageData.GetLanguageText("Com_124");
    elseif (nType == ITEMTYPE.ITEM_MATERIAL_ITEM) then
        strTypeName = CLanguageData.GetLanguageText("Com_125");
    elseif (nType == ITEMTYPE.ITEM_HEARTMAGIC) then
        strTypeName = CLanguageData.GetLanguageText("Com_126");
    elseif (nType == ITEMTYPE.ITEM_PHYSIC) then
        strTypeName = CLanguageData.GetLanguageText("Com_127");
    elseif (nType == ITEMTYPE.ITEM_EQUIP) then
        strTypeName = CLanguageData.GetLanguageText("Com_128");
    elseif (nType == ITEMTYPE.ITEM_FUNCTION) then
        strTypeName = CLanguageData.GetLanguageText("Com_129");
    else
        strTypeName = CLanguageData.GetLanguageText("Com_130");
    end
    return strTypeName;
end
-- 根据装备类型和装备部位得到装备部位名称
function LuaCommonMethod.GetEquipPartNameByPartAndType(nPart, nType)
    local strName = "";
    if (nPart == TmTplEquipPart.emTplEquipPart_Hat) then
        strName = CLanguageData.GetLanguageText("Com_207");
    elseif (nPart == TmTplEquipPart.emTplEquipPart_Ring) then
        strName = CLanguageData.GetLanguageText("Com_208");
    elseif (nPart == TmTplEquipPart.emTplEquipPart_Clothes) then
        strName = CLanguageData.GetLanguageText("Com_209");
    elseif (nPart == TmTplEquipPart.emTplEquipPart_Necklace) then
        if (nType == ITEMTYPE.ITEM_EQUIP) then
            strName = CLanguageData.GetLanguageText("Com_210");
        elseif (nType == ITEMTYPE.ITEM_FASHION) then
            strName = CLanguageData.GetLanguageText("Com_211");
        end
    elseif (nPart == TmTplEquipPart.emTplEquipPart_Cloak) then
        strName = CLanguageData.GetLanguageText("Com_212");
    elseif (nPart == TmTplEquipPart.emTplEquipPart_Accessory) then
        strName = CLanguageData.GetLanguageText("Com_213");
    elseif (nPart == TmTplEquipPart.emTplEquipPart_Weapon) then
        strName = CLanguageData.GetLanguageText("Com_214");
    elseif (nPart == TmTplEquipPart.emTplEquipPart_Gloves) then
        strName = CLanguageData.GetLanguageText("Com_215");
    elseif (nPart == TmTplEquipPart.emTplEquipPart_MinorWeapon) then
        strName = CLanguageData.GetLanguageText("Com_216");
    elseif (nPart == TmTplEquipPart.emTplEquipPart_Shoes) then
        strName = CLanguageData.GetLanguageText("Com_217");
    end
    return strName;
end
function LuaCommonMethod.GetEquipMetierRequireName(byMetierRequire)
    local strMetierRequireName = "";
    local byMask = byMetierRequire;
    for i = 0, 5 do
        local r = luabit.band(byMask, 0x0001);
        if (r > 0) then
            if(strMetierRequireName == "") then
                strMetierRequireName = LuaCommonMethod.GetMetierName(i);
            else
                strMetierRequireName = strMetierRequireName .. " " .. LuaCommonMethod.GetMetierName(i);
            end
        end
        byMask = luabit.rshift(byMask, 1);
    end
    return strMetierRequireName;
end
-- 得到穿装备所需职业名称
function LuaCommonMethod.GetMetierName(nImage)
        if(nImage == IMAGE_FIRST)
        then
            return CLanguageData.GetLanguageText("UI_COMMON_026");
        elseif(nImage == IMAGE_SECOND)
        then
            return CLanguageData.GetLanguageText("UI_COMMON_027");
        elseif(nImage == IMAGE_THIRD)
        then
            return CLanguageData.GetLanguageText("UI_COMMON_028");
		end
    return "";
end
--[[/**整理背包（此处只整理数据
     * 参数 box	物品来源处的物品管理类CBox
     * 返回 一个object的数组[object,...]
     * object中有：
     * itemID	int，这个物品的模板ID
     * mPileLimit	int，最大可叠加数
     * itemIndex	array，整理后，占用的格子索引
     * itemNum	array，整理后，占用的格子上的物品数量
     * itemSrcIndex 	array，此ID物品在整理前，使用的格子
     */--]]
function LuaCommonMethod.ArrayItems(box)
    local arrTemp = { };
    local mapItemInfo = { };

    -- 统计每种物品的来源(在背包中的索引)，总数，最大叠加数。key为单个物品的模板id
    for nIndex = 0, box.releaseIndex - 1 do
        local ItemObejct = box:GetItemObjectByIndex(nIndex);
        if (ItemObejct ~= nil) then
            local pItem = LuaDataStatic.SearchItemTpl(ItemObejct.mItemID);
            if (pItem ~= nil) then
                if (mapItemInfo[pItem.TempID] ~= nil) then
                    local objItemSrc = mapItemInfo[pItem.TempID];
                    -- 来源
                    table.insert(objItemSrc.ItemSrcIndex, nIndex);
                    -- 数量
                    objItemSrc.ItemNum = objItemSrc.ItemNum + ItemObejct.mItemNumber;
                    mapItemInfo[pItem.TempID] = objItemSrc;
                else
                    local objItem = { };
                    objItem.ItemSrcIndex = { nIndex };
                    objItem.ItemNum = ItemObejct.mItemNumber;
                    objItem.ItemID = pItem.TempID;
                    objItem.mPileLimit = pItem.PileLimit;
                    mapItemInfo[pItem.TempID] = objItem;
                end
            end
        end
    end

    local idList = {};
    for i, objItemSrc in pairs(mapItemInfo) do
        if(objItemSrc ~= nil) 
        then
            table.insert(idList, i);
        end
    end
    table.sort(idList);
    -- 结果数据，根据排序后的模板id顺序，按每个id分配整理后占用的格子，每格数量
    local arrResult = { };
    local useIndex = 0;
    for i, id in pairs(idList) do
        local objItemSrc = mapItemInfo[id];
        if (objItemSrc ~= nil) 
        then
            local num = objItemSrc.ItemNum;
            local max = objItemSrc.mPileLimit;
            local itemNum = { };
            local itemIndex = { };
            while (num > 0) do
                if (num > max) then
                    -- 一组最大叠加
                    table.insert(itemNum, max);
                    num = num - max;
                else
                    table.insert(itemNum, num);
                    num = 0;
                end
                table.insert(itemIndex, useIndex);
                useIndex = useIndex + 1;
            end
            local sortResultData = { };
            sortResultData.ItemID = id;
            sortResultData.mPileLimit = max;
            sortResultData.ItemIndex = itemIndex;
            sortResultData.ItemNum = itemNum;
            sortResultData.ItemSrcIndex = objItemSrc.ItemSrcIndex;
            table.insert(arrResult, sortResultData);
        end
    end
    return arrResult;
end
function LuaCommonMethod.Compare(A, B)
    -- 类型，升序排列
    if (A.mType > B.mType) then
        return 1;
    elseif (A.mType < B.mType) then
        return -1;
    else
        -- 品质，降序排列
        if (A.quality > B.quality) then
            return -1;
        elseif (A.quality < B.quality) then
            return 1;
        else
            -- ID，降序排列
            if (A.ItemID > B.ItemID) then
                return -1;
            elseif (A.ItemID < B.ItemID) then
                return 1;
            end
        end
    end
    return 0;
end 
-- 装备属性对应的文字
function LuaCommonMethod.GetPropertyTypeName(nType)
    if (nType == TmTplPropertyFunc.emTplPropertyFunc_MaxHPFixed) then
        -- 生命最大值固定加成
        return CLanguageData.GetLanguageText("Module_Item_HP");
    elseif (nType == TmTplPropertyFunc.emTplPropertyFunc_MaxHPPer) then
        -- 血量最大值百分比加成
        return CLanguageData.GetLanguageText("Module_Item_Per");
    elseif (nType == TmTplPropertyFunc.emTplPropertyFunc_NoramlAttackFixed) then
        -- 外功攻击固定加成
        return CLanguageData.GetLanguageText("Module_Item_NoramlAttack");
    elseif (nType == TmTplPropertyFunc.emTplPropertyFunc_NoramlAttackPer) then
        -- 外功攻击百分比加成
        return CLanguageData.GetLanguageText("Module_Item_NoramlAttack");
    elseif (nType == TmTplPropertyFunc.emTplPropertyFunc_NormalDefenseFixed) then
        -- 外功防御固定加成
        return CLanguageData.GetLanguageText("Module_Item_NormalDefense");
    elseif (nType == TmTplPropertyFunc.emTplPropertyFunc_NormalDefensePer) then
        -- 外功防御百分比加成
        return CLanguageData.GetLanguageText("Module_Item_NormalDefense");
    elseif (nType == TmTplPropertyFunc.emTplPropertyFunc_CriticalHitFixed) then
        -- 暴击固定值加成
        return CLanguageData.GetLanguageText("Module_Item_CriticalHit");
    elseif (nType == TmTplPropertyFunc.emTplPropertyFunc_ToughnessFixed) then
        -- 防暴固定值加成
        return CLanguageData.GetLanguageText("Module_Item_Toughness");
    elseif (nType == TmTplPropertyFunc.emTplPropertyFunc_DuckFixed) then
        -- 闪避固定值加成
        return CLanguageData.GetLanguageText("Module_Item_Duck");
    elseif (nType == TmTplPropertyFunc.emTplPropertyFunc_BreakHit) then
        -- 破防固定值加成
        return CLanguageData.GetLanguageText("Module_Item_BreakHit");
    elseif (nType == TmTplPropertyFunc.emTplPropertyFunc_Parry) then
        -- 格挡固定值加成
        return CLanguageData.GetLanguageText("Module_Item_Parry");
    elseif (nType == TmTplPropertyFunc.emTplPropertyFunc_DeathHit) then
        -- 必杀固定值加成
        return CLanguageData.GetLanguageText("Module_Item_DeathHit");
    elseif (nType == TmTplPropertyFunc.emTplPropertyFunc_SpeedFixed) then
        -- 移动速度固定值加成
        return CLanguageData.GetLanguageText("Module_Item_Speed");
    elseif (nType == TmTplPropertyFunc.emTplPropertyFunc_SpeedPer) then
        -- 移动速度百分比加成
        return CLanguageData.GetLanguageText("Module_Item_Speed");
    elseif (nType == TmTplPropertyFunc.emTplPropertyFunc_PowerFixed) then
        -- 气势值加成
        return CLanguageData.GetLanguageText("Module_Item_Power");
    elseif (nType == TmTplPropertyFunc.emTplPropertyFunc_MayhemPer) then
        -- 伤害加成百分比
        return CLanguageData.GetLanguageText("Module_Item_MayhemPer");
    elseif (nType == TmTplPropertyFunc.emTplPropertyFunc_DamageReductionPer) then
        -- 伤害减免百分比
        return CLanguageData.GetLanguageText("Module_Item_DamageReductionr");
    elseif(nType == TmTplPropertyFunc.emTplPropertyFunc_Unarmed) then
        return  CLanguageData.GetLanguageText("Module_Item_Unarmed");		-- 拳掌值加成
    elseif(nType == TmTplPropertyFunc.emTplPropertyFunc_Sword) then			
        return  CLanguageData.GetLanguageText("Module_Item_Sword");		-- 御剑值加成
    elseif(nType == TmTplPropertyFunc.emTplPropertyFunc_Knife) then			
        return  CLanguageData.GetLanguageText("Module_Item_Knife");		-- 耍刀值加成
    elseif(nType == TmTplPropertyFunc.emTplPropertyFunc_Special) then			
        return  CLanguageData.GetLanguageText("Module_Item_Special");		-- 特殊值加成
    elseif(nType == TmTplPropertyFunc.emTplPropertyFunc_SkillMagic) then			
        return  CLanguageData.GetLanguageText("Module_Item_SkillMagic");		-- 内功值加成
    elseif(nType == TmTplPropertyFunc.emTplPropertyFunc_AttackSpeed) then
        return  CLanguageData.GetLanguageText("Module_Item_AttackSpeed");		-- 身法
    elseif(nType == TmTplPropertyFunc.emTplPropertyFunc_DoubleHit) then
        return  CLanguageData.GetLanguageText("Module_Item_DoubleHit");		-- 连击
    elseif(nType == TmTplPropertyFunc.emTplPropertyFunc_DoubleSkill) then
        return  CLanguageData.GetLanguageText("Module_Item_DoubleSkill");		-- 连招
    elseif(nType == TmTplPropertyFunc.emTplPropertyFunc_Counter) then
        return  CLanguageData.GetLanguageText("Module_Item_Counter");		-- 反击
    elseif(nType == TmTplPropertyFunc.emTplPropertyFunc_Poison) then
        return  CLanguageData.GetLanguageText("Module_Item_Poison");		-- 施毒
    elseif(nType == TmTplPropertyFunc.emTplPropertyFunc_BloodLetting) then
        return  CLanguageData.GetLanguageText("Module_Item_BloodLetting");		-- 流血
    elseif(nType == TmTplPropertyFunc.emTplPropertyFunc_SealedHit) then
        return  CLanguageData.GetLanguageText("Module_Item_SealedHit");		-- 封招
    elseif(nType == TmTplPropertyFunc.emTplPropertyFunc_Acupuncture) then
        return  CLanguageData.GetLanguageText("Module_Item_Acupuncture");		-- 点穴
    elseif(nType == TmTplPropertyFunc.emTplPropertyFunc_Trance) then
        return  CLanguageData.GetLanguageText("Module_Item_Trance");		-- 昏迷
    elseif(nType == TmTplPropertyFunc.emTplPropertyFunc_Weak) then
        return  CLanguageData.GetLanguageText("Module_Item_Weak");		-- 虚弱
    elseif(nType == TmTplPropertyFunc.emTplPropertyFunc_Disorder) then
        return  CLanguageData.GetLanguageText("Module_Item_Disorder");		-- 混乱
    elseif(nType == TmTplPropertyFunc.emTplPropertyFunc_Disarm) then
        return  CLanguageData.GetLanguageText("Module_Item_Disarm");		-- 缴械
    elseif(nType == TmTplPropertyFunc.emTplPropertyFunc_ArmorBreak) then
        return  CLanguageData.GetLanguageText("Module_Item_ArmorBreak");		-- 破甲
    elseif(nType == TmTplPropertyFunc.emTplPropertyFunc_Slow) then
        return  CLanguageData.GetLanguageText("Module_Item_Slow");		-- 迟钝
    elseif(nType == TmTplPropertyFunc.emTplPropertyFunc_Cure) then
        return  CLanguageData.GetLanguageText("Module_Item_Cure");		--治疗
    elseif(nType == TmTplPropertyFunc.emTplPropertyFunc_UnarmedDamagePer) then
        return  CLanguageData.GetLanguageText("Module_Item_UnarmedDamagePer");		-- 对徒手伤害固定加成
    elseif(nType == TmTplPropertyFunc.emTplPropertyFunc_SwordDamagePer) then
        return  CLanguageData.GetLanguageText("Module_Item_SwordDamagePer");		-- 对用剑伤害固定加成
    elseif(nType == TmTplPropertyFunc.emTplPropertyFunc_KnifeDamagePer) then
        return  CLanguageData.GetLanguageText("Module_Item_KnifeDamagePer");		-- 对用刀伤害固定加成
    elseif(nType == TmTplPropertyFunc.emTplPropertyFunc_SpecialDamagePer) then
        return  CLanguageData.GetLanguageText("Module_Item_SpecialDamagePer");		--对奇门伤害固定加成
    elseif(nType == 200) then
        return  CLanguageData.GetLanguageText("Module_Item_Powerer");		-- 战斗力
    end
    return "";
end

-- 装备属性对应的缩写文字
function LuaCommonMethod.GetPropertyTypeShortName(nType)
    if (nType == TmTplPropertyFunc.emTplPropertyFunc_IncMaxHPFix) then
        -- 增加最大血量固定值
        return CLanguageData.GetLanguageText("Com_131");
    elseif (nType == TmTplPropertyFunc.emTplPropertyFunc_IncMaxMPFix) then
        -- 血量最大值百分比加成
        return CLanguageData.GetLanguageText("Com_133");
    elseif (nType == TmTplPropertyFunc.emTplPropertyFunc_IncPhysicAttackFix) then
        -- 增加物理攻击固定值
        return CLanguageData.GetLanguageText("Com_135");
    elseif (nType == TmTplPropertyFunc.emTplPropertyFunc_IncMagicAttackFix) then
        -- 增加魔法攻击固定值
        return CLanguageData.GetLanguageText("Com_137");
    elseif (nType == TmTplPropertyFunc.emTplPropertyFunc_IncPhysicDefenseFix) then
        -- 增加物理防御固定值
        return CLanguageData.GetLanguageText("Com_139");
    elseif (nType == TmTplPropertyFunc.emTplPropertyFunc_IncMagicDefenseFix) then
        -- 增加魔法防御固定值
        return CLanguageData.GetLanguageText("Com_141");
    elseif (nType == TmTplPropertyFunc.emTplPropertyFunc_IncHitFix) then
        -- 增加命中固定值
        return CLanguageData.GetLanguageText("Com_143");
    elseif (nType == TmTplPropertyFunc.emTplPropertyFunc_IncDuckFix) then
        -- 增加闪避固定值
        return CLanguageData.GetLanguageText("Com_145");
    elseif (nType == TmTplPropertyFunc.emTplPropertyFunc_IncCriticalHitFix) then
        -- 增加暴击固定值
        return CLanguageData.GetLanguageText("Com_147");
    elseif (nType == TmTplPropertyFunc.emTplPropertyFunc_IncCriticalDelPer) then
        -- 加暴击减伤百分比
        return CLanguageData.GetLanguageText("Com_149")
    elseif (nType == TmTplPropertyFunc.emTplPropertyFunc_IncSpeedFix) then
        -- 增加速度固定值
        return CLanguageData.GetLanguageText("Com_150");
    elseif (nType == TmTplPropertyFunc.emTplPropertyFunc_IncJumpFix) then
        -- 增加跳跃固定值
        return CLanguageData.GetLanguageText("Com_152");
    elseif (nType == TmTplPropertyFunc.emTplPropertyFunc_IncMayhemPer) then
        -- 增加伤害减免百分比
        return CLanguageData.GetLanguageText("Com_154");
    elseif (nType == TmTplPropertyFunc.emTplPropertyFunc_IncDamageReductionPer) then
        -- 增加伤害减免百分比
        return CLanguageData.GetLanguageText("Com_155");
    elseif (nType == TmTplPropertyFunc.emTplPropertyFunc_DecMaxHPFix) then
        -- 减少最大血量固定值
        return CLanguageData.GetLanguageText("Com_156");
    elseif (nType == TmTplPropertyFunc.emTplPropertyFunc_DecMaxMPFix) then
        -- 减少最大魔法固定值
        return CLanguageData.GetLanguageText("Com_157");
    elseif (nType == TmTplPropertyFunc.emTplPropertyFunc_DecPhysicAttackFix) then
        -- 减少物理攻击固定值
        return CLanguageData.GetLanguageText("Com_158");
    elseif (nType == TmTplPropertyFunc.emTplPropertyFunc_DecMagicAttackFix) then
        -- 减少魔法攻击固定值
        return CLanguageData.GetLanguageText("Com_159");
    elseif (nType == TmTplPropertyFunc.emTplPropertyFunc_DecPhysicDefenseFix) then
        -- 减少物理防御固定值
        return CLanguageData.GetLanguageText("Com_160");
    elseif (nType == TmTplPropertyFunc.emTplPropertyFunc_DecMagicDefenseFix) then
        -- 减少魔法防御固定值
        return CLanguageData.GetLanguageText("Com_161");
    elseif (nType == TmTplPropertyFunc.emTplPropertyFunc_DecHitFix) then
        -- 减少命中固定值
        return CLanguageData.GetLanguageText("Com_162");
    elseif (nType == TmTplPropertyFunc.emTplPropertyFunc_DecDuckFix) then
        -- 减少闪避固定值
        return CLanguageData.GetLanguageText("Com_163");
    elseif (nType == TmTplPropertyFunc.emTplPropertyFunc_DecCriticalHitFix) then
        -- 减少暴击固定值
        return CLanguageData.GetLanguageText("Com_164");
    elseif (nType == TmTplPropertyFunc.emTplPropertyFunc_DecCriticalDelPer) then
        -- 减少暴击减伤百分比
        return CLanguageData.GetLanguageText("Com_165");
    elseif (nType == TmTplPropertyFunc.emTplPropertyFunc_DecSpeedFix) then
        -- 减少速度固定值
        return CLanguageData.GetLanguageText("Com_166");
    elseif (nType == TmTplPropertyFunc.emTplPropertyFunc_DecJumpFix) then
        -- 减少跳跃固定值
        return CLanguageData.GetLanguageText("Com_167");
    elseif (nType == TmTplPropertyFunc.emTplPropertyFunc_DecMayhemPer) then
        -- 减少伤害加深百分比
        return CLanguageData.GetLanguageText("Com_168");
    elseif (nType == TmTplPropertyFunc.emTplPropertyFunc_DecDamageReductionPer) then
        -- 减少伤害减免百分比
        return CLanguageData.GetLanguageText("Com_169");
    elseif (nType == TmTplPropertyFunc.emTplPropertyFunc_Exanimation) then
        -- 昏迷状态
        return CLanguageData.GetLanguageText("Com_170");
    elseif (nType == TmTplPropertyFunc.emTplPropertyFunc_Deformation) then
        -- 变形状态
        return CLanguageData.GetLanguageText("Com_171");
    elseif (nType == TmTplPropertyFunc.emTplPropertyFunc_Invincible) then
        -- 无敌状态
        return CLanguageData.GetLanguageText("Com_172");
    elseif (nType == TmTplPropertyFunc.emTplPropertyFunc_CounterAttack) then
        -- 反击伤害状态
        return CLanguageData.GetLanguageText("Com_173");
    elseif (nType == TmTplPropertyFunc.emTplPropertyFunc_DamageAbsorption) then
        -- 伤害吸收状态
        return CLanguageData.GetLanguageText("Com_174");
    elseif (nType == TmTplPropertyFunc.emTplPropertyFunc_IncHP) then
        -- 加血
        return CLanguageData.GetLanguageText("Com_175");
    elseif (nType == TmTplPropertyFunc.emTplPropertyFunc_DecHP) then
        -- 减血
        return CLanguageData.GetLanguageText("Com_176");
    elseif (nType == TmTplPropertyFunc.emTplPropertyFunc_IncMP) then
        -- 加魔
        return CLanguageData.GetLanguageText("Com_177");
    elseif (nType == TmTplPropertyFunc.emTplPropertyFunc_DecMP) then
        -- 减魔
        return CLanguageData.GetLanguageText("Com_178");
    elseif (nType == TmTplPropertyFunc.emTplPropertyFunc_IncCriticalAddPer) then
        -- 增加暴击增伤百分比
        return CLanguageData.GetLanguageText("Com_179");
    elseif (nType == TmTplPropertyFunc.emTplPropertyFunc_DecCriticalAddPer) then
        -- 减少暴击增伤百分比
        return CLanguageData.GetLanguageText("Com_180");
    elseif (nType == TmTplPropertyFunc.emTplPropertyFunc_IncMaxHPPer) then
        -- 增加最大血量百分比
        return CLanguageData.GetLanguageText("Com_181");
    elseif (nType == TmTplPropertyFunc.emTplPropertyFunc_IncMaxMPPer) then
        -- 增加最大魔法百分比
        return CLanguageData.GetLanguageText("Com_182");
    elseif (nType == TmTplPropertyFunc.emTplPropertyFunc_IncPhysicAttackPer) then
        -- 增加物理攻击百分比
        return CLanguageData.GetLanguageText("Com_183");
    elseif (nType == TmTplPropertyFunc.emTplPropertyFunc_IncMagicAttackPer) then
        -- 增加魔法攻击百分比
        return CLanguageData.GetLanguageText("Com_184");
    elseif (nType == TmTplPropertyFunc.emTplPropertyFunc_NormalAttackVampireHPPer) then
        -- 普通攻击吸收HP百分比
        return CLanguageData.GetLanguageText("Com_185");
    elseif (nType == TmTplPropertyFunc.emTplPropertyFunc_NormalAttackVampireMPPer) then
        -- 普通攻击吸收MP百分比
        return CLanguageData.GetLanguageText("Com_186");
    elseif (nType == TmTplPropertyFunc.emTplPropertyFunc_DecSkillCDPer) then
        -- 技能CD减少百分比
        return CLanguageData.GetLanguageText("Com_187");
    elseif (nType == TmTplPropertyFunc.emTplPropertyFunc_DecMPConsumePer) then
        -- 魔法消耗减少百分比
        return CLanguageData.GetLanguageText("Com_188");
    elseif (nType == TmTplPropertyFunc.emTplPropertyFunc_IncToughnessFix) then
        return CLanguageData.GetLanguageText("Com_189");
    elseif (nType == TmTplPropertyFunc.emTplPropertyFunc_DecToughnessFix) then
        return CLanguageData.GetLanguageText("Com_190");
    elseif (nType == TmTplPropertyFunc.emTplPropertyFunc_AddSkillLevel) then
        -- 增加指定技能等级 （音速斩效果 +1）
        return CLanguageData.GetLanguageText("Com_191");
    elseif (nType == TmTplPropertyFunc.emTplPropertyFunc_AddAllSkillLevel) then
        -- 增加所有技能等级  （技能效果 +1）
        return CLanguageData.GetLanguageText("Com_192");
    elseif (nType == TmTplPropertyFunc.emTplPropertyFunc_AddSkill) then
        -- 增加技能
        return "";
    elseif (nType == TmTplPropertyFunc.emTplPropertyFunc_FactionExp) then
        -- 公会经验加成
        return CLanguageData.GetLanguageText("Com_193");
    elseif (nType == TmTplPropertyFunc.emTplPropertyFunc_FactionMoney) then
        -- 公会经验加成
        return CLanguageData.GetLanguageText("Com_194");
    elseif (nType == TmTplPropertyFunc.emTplPropertyFunc_GodnessExp) then
        -- 公会经验加成
        return CLanguageData.GetLanguageText("Com_Buff_Goddess");
    end;

    return "";
end

-- 装备属性、星座属性对应属性值
function LuaCommonMethod.GetPropertyValue(nType, nValue)
    if(nValue == nil) then
        nValue = 0;
    end
	if(nType == TmTplPropertyFunc.emTplPropertyFunc_None) then				
        return  "";		-- 无属性加成
	elseif(nType == TmTplPropertyFunc.emTplPropertyFunc_MaxHPFixed) then			
        return tostring(nValue);		-- 血量最大值固定加成
	elseif(nType == TmTplPropertyFunc.emTplPropertyFunc_MaxHPPer) then			
        return tostring(nValue) .. "%";		-- 血量最大值百分比加成
	elseif(nType == TmTplPropertyFunc.emTplPropertyFunc_NoramlAttackFixed) then	
        return tostring(nValue);		-- 外功攻击固定加成
	elseif(nType == TmTplPropertyFunc.emTplPropertyFunc_NoramlAttackPer) then		
        return tostring(nValue / 100) .. "%";		-- 外功攻击百分比加成
	elseif(nType == TmTplPropertyFunc.emTplPropertyFunc_NormalDefenseFixed) then	
        return tostring(nValue);		-- 外功防御固定加成
	elseif(nType == TmTplPropertyFunc.emTplPropertyFunc_NormalDefensePer) then	
        return tostring(nValue / 100) .. "%";		-- 外功防御百分比加成
	elseif(nType == TmTplPropertyFunc.emTplPropertyFunc_CriticalHitFixed) then
        return tostring(nValue / 100) .. "%";		-- 暴击固定值加成
	elseif(nType == TmTplPropertyFunc.emTplPropertyFunc_ToughnessFixed) then		
        return tostring(nValue / 100) .. "%";		-- 防暴固定值加成
	elseif(nType == TmTplPropertyFunc.emTplPropertyFunc_DuckFixed) then
        return tostring(nValue / 100) .. "%";		-- 闪避固定值加成
	elseif(nType == TmTplPropertyFunc.emTplPropertyFunc_BreakHit) then				
        return  tostring(nValue / 100) .. "%";		-- 破防固定值加成
	elseif(nType == TmTplPropertyFunc.emTplPropertyFunc_Parry) then				
        return tostring(nValue / 100) .. "%";		-- 格挡固定值加成
	elseif(nType == TmTplPropertyFunc.emTplPropertyFunc_DeathHit) then			
        return tostring(nValue / 100) .. "%";		-- 必杀固定值加成
	elseif(nType == TmTplPropertyFunc.emTplPropertyFunc_SpeedFixed) then			
        return tostring(nValue);		-- 移动速度固定值加成
	elseif(nType == TmTplPropertyFunc.emTplPropertyFunc_SpeedPer) then			
        return tostring(nValue / 100) .. "%";		-- 移动速度百分比加成
	elseif(nType == TmTplPropertyFunc.emTplPropertyFunc_PowerFixed) then			
        return tostring(nValue);		-- 气势值加成
	elseif(nType == TmTplPropertyFunc.emTplPropertyFunc_MayhemPer) then
        return tostring(nValue / 100) .. "%";		-- 伤害加成百分比
	elseif(nType == TmTplPropertyFunc.emTplPropertyFunc_DamageReductionPer) then 
        return tostring(nValue / 100) .. "%";		-- 伤害减免百分比
    elseif(nType == TmTplPropertyFunc.emTplPropertyFunc_Unarmed) then			
        return  tostring(nValue);		-- 拳掌值加成
    elseif(nType == TmTplPropertyFunc.emTplPropertyFunc_Sword) then			
        return  tostring(nValue);		-- 御剑值加成
    elseif(nType == TmTplPropertyFunc.emTplPropertyFunc_Knife) then			
        return  tostring(nValue);		-- 耍刀值加成
    elseif(nType == TmTplPropertyFunc.emTplPropertyFunc_Special) then			
        return  tostring(nValue);		-- 特殊值加成
    elseif(nType == TmTplPropertyFunc.emTplPropertyFunc_SkillMagic) then			
        return  tostring(nValue);		-- 内功值加成
    elseif(id == TmTplPropertyFunc.emTplPropertyFunc_AttackSpeed) then
        return  tostring(nValue);		-- 身法
    elseif(id == TmTplPropertyFunc.emTplPropertyFunc_DoubleHit) then
        return  tostring(nValue/ 100);	-- 连击
    elseif(id == TmTplPropertyFunc.emTplPropertyFunc_DoubleSkill) then
        return  tostring(nValue/ 100);		-- 连招
    elseif(id == TmTplPropertyFunc.emTplPropertyFunc_Counter) then
        return  tostring(nValue/ 100);		-- 反击
    elseif(id == TmTplPropertyFunc.emTplPropertyFunc_Poison) then
        return  tostring(nValue);		-- 施毒
    elseif(id == TmTplPropertyFunc.emTplPropertyFunc_BloodLetting) then
        return  tostring(nValue);		-- 流血
    elseif(id == TmTplPropertyFunc.emTplPropertyFunc_SealedHit) then
        return  tostring(nValue);	-- 封招
    elseif(id == TmTplPropertyFunc.emTplPropertyFunc_Acupuncture) then
        return  tostring(nValue);		-- 点穴
    elseif(id == TmTplPropertyFunc.emTplPropertyFunc_Trance) then
        return  tostring(nValue);		-- 昏迷
    elseif(id == TmTplPropertyFunc.emTplPropertyFunc_Weak) then
        return  tostring(nValue);	-- 虚弱
    elseif(id == TmTplPropertyFunc.emTplPropertyFunc_Disorder) then
        return  tostring(nValue);		-- 混乱
    elseif(id == TmTplPropertyFunc.emTplPropertyFunc_Disarm) then
        return  tostring(nValue);		-- 缴械
    elseif(id == TmTplPropertyFunc.emTplPropertyFunc_ArmorBreak) then
        return  tostring(nValue);		-- 破甲
    elseif(id == TmTplPropertyFunc.emTplPropertyFunc_Slow) then
        return  tostring(nValue);		-- 迟钝
    end
	return CLanguageData.GetLanguageText("UI_Equip_NoNameProperty") .. nType;
end
-- 品质对应文字
function LuaCommonMethod.GetQualityName(eQuality)
    if (eQuality == TmItemQuality.emItemQuality_Gray) then
        -- 灰色品质
        return CLanguageData.GetLanguageText("Com_055");
    elseif (eQuality == TmItemQuality.emItemQuality_Red) then
        -- 红色品质
        return CLanguageData.GetLanguageText("Com_056");
    elseif (eQuality == TmItemQuality.emItemQuality_White) then
        -- 白色品质
        return CLanguageData.GetLanguageText("Com_057");
    elseif (eQuality == TmItemQuality.emItemQuality_Green) then
        -- 绿色品质
        return CLanguageData.GetLanguageText("Com_058");
    elseif (eQuality == TmItemQuality.emItemQuality_Blue) then
        -- 蓝色品质
        return CLanguageData.GetLanguageText("Com_059");
    elseif (eQuality == TmItemQuality.emItemQuality_Purple) then
        -- 紫色品质
        return CLanguageData.GetLanguageText("Com_060");
    elseif (eQuality == TmItemQuality.emItemQuality_Orange) then
        -- 橙色品质
        return CLanguageData.GetLanguageText("Com_061");
    elseif (eQuality == TmItemQuality.emItemQuality_Yellow) then
        -- 黄色品质
        return CLanguageData.GetLanguageText("Com_062");
    end
    return "";
end

-- 检查背包空间是否足够
function LuaCommonMethod.CheckBagSpaceIsEnough(itemData, callFunc)
    local bagNoSpace = false;
    local useEmptyGridNum = 0;
    --//背包剩余空格子数量
	local spaceNum = 0;			
    local strBagType = "";
    local bagType = 0;
    --//循环插入的物品，检查背包空间是否足够
    if(itemData ~= nil) then
		for itemID, itemNum in pairs(itemData) do
		    local tplItem = require("Template/Item/" .. tostring(itemID));
			if(tplItem == nil) then
                return bagNoSpace;
            end
			spaceNum = 0;
			bagType = ESlotType.SLOT_COMMON_BAGGAGE;
            --//套装礼包特殊处理
			if(tplItem.ItemType == ITEMTYPE.ITEM_SUIT) then					
				if(#tplItem.EquipID > 0) then
					local tplSuitPart = require("Template/Item/" .. tostring(tplItem.EquipID[1]));
                    --//普通装备进入普通背包
					if(tplSuitPart.ItemType == ITEMTYPE.ITEM_EQUIP) then		
						spaceNum = LuaCItemModule.GetBagBoxSpaceNumByType(ESlotType.SLOT_COMMON_BAGGAGE);
					    bagType = ESlotType.SLOT_COMMON_BAGGAGE;
                    --//时装道具进入时装背包
                    elseif(tplSuitPart.ItemType == ITEMTYPE.ITEM_FASHION) then		
						spaceNum = LuaCItemModule.GetBagBoxSpaceNumByType(ESlotType.SLOT_FASHION_BAGGAGE);
						strBagType = CLanguageData.GetLanguageText("Com_120");
						bagType = ESlotType.SLOT_FASHION_BAGGAGE;
					end
				end
			else
                --//星座
				if(tplItem.ItemType == ITEMTYPE.ITEM_HEARTMAGIC) then			
					spaceNum = LuaCItemModule.GetBagBoxSpaceNumByType(ESlotType.SLOT_COMMON_BAGGAGE);
					strBagType = CLanguageData.GetLanguageText("Com_126");
					bagType = ESlotType.SLOT_HEART_MAGIC_BAGGAGE;
				--//时装、美容道具
				elseif(tplItem.ItemType == ITEMTYPE.ITEM_FASHION	
				    or tplItem.ItemType == ITEMTYPE.ITEM_BEAUTY) then
					    --//判断是否请求时装背包数据
                        --//bool isFashionBagData = true;
                        spaceNum = LuaCItemModule.GetBagBoxSpaceNumByType(ESlotType.SLOT_FASHION_BAGGAGE);
						if(spaceNum == 0) then
							bagNoSpace = false;
							return bagNoSpace;
						end
						strBagType = CLanguageData.GetLanguageText("Com_120");
						bagType = ESlotType.SLOT_FASHION_BAGGAGE;
				--//普通物品进入普通背包
				else																								
					spaceNum = LuaCItemModule.GetBagBoxSpaceNumByType(ESlotType.SLOT_COMMON_BAGGAGE);
				end
			end

            --//物品是否可叠加
			if(tplItem.PileLimit > 1) then	
                local numGrid = math.ceil((itemNum / tplItem.PileLimit));
				useEmptyGridNum = useEmptyGridNum + numGrid;
			else
				useEmptyGridNum = itemNum + useEmptyGridNum;
			end

            if(spaceNum < useEmptyGridNum) then
				bagNoSpace = true;
			end
		end
    else
        spaceNum = LuaCItemModule.GetBagBoxSpaceNumByType(ESlotType.SLOT_COMMON_BAGGAGE);
        if (spaceNum == 0) then
            bagNoSpace = true;
        end
    end
    
    if (bagNoSpace == true) then
        local strInfo = strBagType .. CLanguageData.GetLanguageText("Com_Bag_Full");
        if (callFunc == nil) then
            LuaCUIConfirm.Show(strInfo,
                function ()
                    if (bagType == ESlotType.SLOT_COMMON_BAGGAGE) then
                        LuaCUIMyRole.ShowUI();
                    elseif (bagType == ESlotType.SLOT_FASHION_BAGGAGE) then
                        --//CUIFashionShop.gUIFactionShop.ShowUI();
                    elseif (bagType == ESlotType.SLOT_HEART_MAGIC_BAGGAGE) then
                        --//CUIAstrology.gUIAstrology.ShowUI();
                    end
                end,
                function () end,"",CLanguageData.GetLanguageText("Com_SortBag")
            );
        else
            LuaCUIConfirm.Show(strInfo,
                function ()
                    if (bagType == ESlotType.SLOT_COMMON_BAGGAGE) then
                        LuaCUIMyRole.ShowUI();
                    elseif (bagType == ESlotType.SLOT_FASHION_BAGGAGE) then
                        --//CUIFashionShop.gUIFactionShop.ShowUI();
                    elseif (bagType == ESlotType.SLOT_HEART_MAGIC_BAGGAGE) then
                        --//CUIAstrology.gUIAstrology.ShowUI();
                    end
                end,
                function () 
                    callFunc();
                end,"",CLanguageData.GetLanguageText("Com_ClearBag")
            );
        end
    end
    return bagNoSpace;
end


-- //得到NPC的服务类型
function LuaCommonMethod.GetNpcServiceType(ServiceType)
    -- // 判断是否是传送NPC
    if (luabit.band(ServiceType, TmNpcServiceType.emNpcServiceType_ArenaPlace) > 0) then
        return TmNpcServiceType.emNpcServiceType_ArenaPlace;
    elseif (luabit.band(ServiceType, TmNpcServiceType.emNpcServiceType_BossScene) > 0) then
        return TmNpcServiceType.emNpcServiceType_BossScene;
    elseif (luabit.band(ServiceType, TmNpcServiceType.emNpcServiceType_Collect) > 0) then
        return TmNpcServiceType.emNpcServiceType_Collect;
    elseif (luabit.band(ServiceType, TmNpcServiceType.emNpcServiceType_CommonInstance) > 0) then
        return TmNpcServiceType.emNpcServiceType_CommonInstance;
    elseif (luabit.band(ServiceType, TmNpcServiceType.emNpcServiceType_EnterWorldField) > 0) then
        return TmNpcServiceType.emNpcServiceType_EnterWorldField;
    elseif (luabit.band(ServiceType, TmNpcServiceType.emNpcServiceType_EnterWorldWar) > 0) then
        return TmNpcServiceType.emNpcServiceType_EnterWorldWar;
    elseif (luabit.band(ServiceType, TmNpcServiceType.emNpcServiceType_EquipSmelt) > 0) then
        return TmNpcServiceType.emNpcServiceType_EquipSmelt;
    elseif (luabit.band(ServiceType, TmNpcServiceType.emNpcServiceType_ExtraInstance) > 0) then
        return TmNpcServiceType.emNpcServiceType_ExtraInstance;
    elseif (luabit.band(ServiceType, TmNpcServiceType.emNpcServiceType_FindInstance) > 0) then
        return TmNpcServiceType.emNpcServiceType_FindInstance;
    elseif (luabit.band(ServiceType, TmNpcServiceType.emNpcServiceType_Item) > 0) then
        return TmNpcServiceType.emNpcServiceType_Item;
    elseif (luabit.band(ServiceType, TmNpcServiceType.emNpcServiceType_LeaveWorldWar) > 0) then
        return TmNpcServiceType.emNpcServiceType_LeaveWorldWar;
    elseif (luabit.band(ServiceType, TmNpcServiceType.emNpcServiceType_Money) > 0) then
        return TmNpcServiceType.emNpcServiceType_Money;
    elseif (luabit.band(ServiceType, TmNpcServiceType.emNpcServiceType_TangledWarfare) > 0) then
        return TmNpcServiceType.emNpcServiceType_TangledWarfare;
    elseif (luabit.band(ServiceType, TmNpcServiceType.emNpcServiceType_TaskPoint) > 0) then
        return TmNpcServiceType.emNpcServiceType_TaskPoint;
    elseif (luabit.band(ServiceType, TmNpcServiceType.emNpcServiceType_Teleport) > 0) then
        return TmNpcServiceType.emNpcServiceType_Teleport;
    elseif (luabit.band(ServiceType, TmNpcServiceType.emNpcServiceType_WorldFieldBox) > 0) then
        return TmNpcServiceType.emNpcServiceType_WorldFieldBox;
    else
        return 0;
    end
end
-- 判断身上的装备是否显示套装特效
function LuaCommonMethod.GetEquipSuitEffect(arrEquipList)
    -- local suitEquip = System.Collections.ArrayList.New();
    local suitEquip = { };
    for i = 0, #arrEquipList do
        local equip = arrEquipList[i];
        if (equip ~= nil) then
            local tplEquipItem = LuaDataStatic.SearchItemTpl(equip.mItemID);
            if (tplEquipItem ~= nil) then
                if (tplEquipItem.mEquipSuitID > 0) then
                    local arrIndex;
                    if (suitEquip[tplEquipItem.SuitID] ~= nil) then
                        arrIndex = suitEquip[tplEquipItem.SuitID];
                        arrIndex:Add(i);
                    else
                        arrIndex = System.Collections.ArrayList.New();
                        arrIndex:Add(i);
                        suitEquip[tplEquipItem.mEquipSuitID] = arrIndex;
                    end
                end
            end
        end
    end
    -- 判断套装是否完整
    local arrSuit = suitEquip;
    for k, arrEquip in pairs(arrSuit) do
        local tplSuit = LuaDataStatic.SearchItemTpl(k);
        -- 得到套装的全部数量
        if (tplSuit ~= nil) then
            local nSuitNum = tplSuit.TotalPieces;
            if (arrEquip.Count < nSuitNum) then
                suitEquip[k] = nil;
            end
        end
    end
    return suitEquip;
end

-- 根据NpC功能类型得到功能开启的等级
function LuaCommonMethod.GetOpenLevelByFuncType(func)
    local openLv = 0;
    if (func == TmNpcServiceType.emNpcServiceType_ArenaPlace) then
        openLv = LuaCommonMethod.GetMainFuncOpenLevel(TmMainFunction.emMainFunction_Arena);
    elseif (func == TmNpcServiceType.emNpcServiceType_ExtraInstance) then
        local openLevel = 0;
        openLv = LuaCommonMethod.GetMainFuncOpenLevel(TmMainFunction.emMainFunction_SpriteInstance);
        openLevel = LuaCommonMethod.GetMainFuncOpenLevel(TmMainFunction.emMainFunction_MaterialInstance);
        if (openLv > openLevel) then
            openLv = openLevel;
        end
        openLevel = LuaCommonMethod.GetMainFuncOpenLevel(TmMainFunction.emMainFunction_ExpInstance);
        if (openLv > openLevel) then
            openLv = openLevel;
        end
        openLevel = LuaCommonMethod.GetMainFuncOpenLevel(TmMainFunction.emMainFunction_MoneyInstance);
        if (openLv > openLevel) then
            openLv = openLevel;
        end
    end
    openLv = mainFuncConfig.PlayerLevel[funcIndex]
    return openLv;
end

-- 更具主功能获得功能开启的等级
function LuaCommonMethod.GetMainFuncOpenLevel(funcID)
    local mainFuncConfig = require("Template/MainFunctionUnlockConfig");
    for index, mainFunc in pairs(mainFuncConfig.MainFunctionType) do
        if (mainFunc == funcID) then
            funcIndex = index;
            break;
        end
    end
    local openLv = mainFuncConfig.PlayerLevel[funcIndex]
    return openLv;
end

-- 获取中文汉字数字
function LuaCommonMethod.GetNums(num)
    if (num == 1) then
        return CLanguageData.GetLanguageText("Com_195");
    elseif (num == 2) then
        return CLanguageData.GetLanguageText("Com_196");
    elseif (num == 3) then
        return CLanguageData.GetLanguageText("Com_197");
    elseif (num == 4) then
        return CLanguageData.GetLanguageText("Com_198");
    elseif (num == 5) then
        return CLanguageData.GetLanguageText("Com_199");
    elseif (num == 6) then
        return CLanguageData.GetLanguageText("Com_200");
    elseif (num == 7) then
        return CLanguageData.GetLanguageText("Com_201");
    elseif (num == 8) then
        return CLanguageData.GetLanguageText("Com_202");
    elseif (num == 9) then
        return CLanguageData.GetLanguageText("Com_203");
    elseif (num == 10) then
        return CLanguageData.GetLanguageText("Com_204");
    end
    return "";
end
--得到骑乘累计增加的属性，和下一阶段累加到的属性
function LuaCommonMethod.GetHorsePropertyByPhaseAndStarLevel(nPhase, nStarLevel, nStarExp, isNextProperty)
	if(isNextProperty == nil) then
        isNextProperty = true;
    end
	if(nPhase == 0) then
        return {};
    end
	local i = 0;
	local j = 0;
	local mapPropertyCloneData = {};	--下一次培养后的属性加成
	local mapPropertyData = {};
	--当前阶累加的基础属性
	for i = 0, nPhase - 1 do
		mapPropertyData = LuaCommonMethod.GetHorsePhaseBaseProperty(i,mapPropertyData);
		mapPropertyCloneData = LuaCommonMethod.GetHorsePhaseBaseProperty(i,mapPropertyCloneData);
	end
	--当前星级累加的属性
	if(nPhase > 1) then
		for i = 0, nPhase - 2 do
			for j = 0, MAX_HORSE_LEVEL_PER_PHASE-1 do
				mapPropertyData = LuaCommonMethod.GetHorseStarProperty(i,j,mapPropertyData);
				mapPropertyCloneData = LuaCommonMethod.GetHorseStarProperty(i,j,mapPropertyCloneData);
			end
		end
		for i = 0, nStarLevel do
			mapPropertyData = LuaCommonMethod.GetHorseStarProperty(nPhase - 1,i,mapPropertyData);
			mapPropertyCloneData = LuaCommonMethod.GetHorseStarProperty(nPhase - 1,i,mapPropertyCloneData);
		end
	else
		for j = 0, nStarLevel do
			mapPropertyData = LuaCommonMethod.GetHorseStarProperty(nPhase - 1,j,mapPropertyData);
			mapPropertyCloneData = LuaCommonMethod.GetHorseStarProperty(nPhase - 1,j,mapPropertyCloneData);
		end
	end
	--当前阶下一星级计算加上多余的星级经验属性
	if(nStarLevel < MAX_HORSE_LEVEL_PER_PHASE - 1) then
		mapPropertyData = LuaCommonMethod.GetHorseStarProperty(nPhase - 1,nStarLevel + 1,mapPropertyData,nStarExp);
	end
	local spHorsePropertyConfig = LuaDataStatic.SearchTplForName("HorseConfig");		
	local nTrainExp = spHorsePropertyConfig.TrainItemExp;
	local objPhaseData = spHorsePropertyConfig.PhaseConfig[nPhase];
	--判断是否满阶，满星
	if(nStarLevel == MAX_HORSE_LEVEL_PER_PHASE-1 and
	     nPhase == MAX_HORSE_PHASE) then
				
	elseif(nStarLevel == MAX_HORSE_LEVEL_PER_PHASE-1 and
	     nPhase < MAX_HORSE_PHASE) then --判断是否满星,未满阶
		mapPropertyCloneData = LuaCommonMethod.GetHorsePhaseBaseProperty(nPhase,mapPropertyCloneData);
		mapPropertyCloneData = LuaCommonMethod.GetHorseStarProperty(nPhase,0,mapPropertyCloneData);
	else
		--培养一次经验+当前经验 大于 星级满经验    且  星级小于9星
		if(nTrainExp + nStarExp >= objPhaseData.StarExp and nStarLevel < MAX_HORSE_LEVEL_PER_PHASE - 2) then
			nStarExp = nTrainExp + nStarExp - objPhaseData.StarExp;
			mapPropertyCloneData = LuaCommonMethod.GetHorseStarProperty(nPhase - 1,nStarLevel + 1,mapPropertyCloneData);
			mapPropertyCloneData = LuaCommonMethod.GetHorseStarProperty(nPhase - 1,nStarLevel + 2,mapPropertyCloneData,nStarExp);
		elseif(nTrainExp + nStarExp >= objPhaseData.StarExp and nStarLevel == MAX_HORSE_LEVEL_PER_PHASE - 2) then
			mapPropertyCloneData = LuaCommonMethod.GetHorseStarProperty(nPhase - 1,nStarLevel + 1,mapPropertyCloneData);
		else
			mapPropertyCloneData = LuaCommonMethod.GetHorseStarProperty(nPhase - 1,nStarLevel + 1,mapPropertyCloneData,nTrainExp + nStarExp);
		end
	end
			
	if(isNextProperty == true) then
		--整合数据，把下一阶段的数据放入当前数据中
		for i,arrNextProperty in pairs(mapPropertyCloneData) do
			if(mapPropertyData[i] ~= nil) then
				local arrProperty = mapPropertyData[i];
                table.insert(arrProperty,arrNextProperty[1]);
                table.insert(arrProperty,arrNextProperty[2]);
				mapPropertyData[i] = arrProperty;
			else
			    table.insert(arrNextProperty,1,0);
                table.insert(arrNextProperty,1,0);
				mapPropertyData[i] = arrNextProperty;
			end
		end
	end
	return mapPropertyData;
end
--得到骑术每阶对应的基础属性
function LuaCommonMethod.GetHorsePhaseBaseProperty(nPhase,mapPropertyData)
	local arrProperty;
	if(nPhase < 0 or nPhase >= MAX_HORSE_PHASE) then
        return {};
    end
    local spHorsePropertyConfig = LuaDataStatic.SearchTplForName("HorseConfig");
	local arrUpPhaseData = spHorsePropertyConfig.PhaseConfig;
	local objUpPhaseData = arrUpPhaseData[nPhase + 1];
	local arrPhaseProperty = objUpPhaseData.TrainProperty;
	for j = 1,#arrPhaseProperty do
		local objUpPhaseProperty = arrPhaseProperty[j];
		if(objUpPhaseProperty.PropertyType ~= 0) then
		    if(mapPropertyData[objUpPhaseProperty.PropertyType] ~= nil) then
			    arrProperty = mapPropertyData[objUpPhaseProperty.PropertyType];
			    arrProperty[1] =  arrProperty[1] + objUpPhaseProperty.PlayerPropertyValue;
			    arrProperty[2] = arrProperty[2] + objUpPhaseProperty.SpritePropertyValue;
			    mapPropertyData[objUpPhaseProperty.PropertyType] = arrProperty;
		    else
			    mapPropertyData[objUpPhaseProperty.PropertyType] = {objUpPhaseProperty.PlayerPropertyValue,objUpPhaseProperty.SpritePropertyValue};
		    end
        end
	end
	return mapPropertyData;
end
--得到骑术每星对应的属性,参数nStarExp默认为取星级满经验数值
function LuaCommonMethod.GetHorseStarProperty(nPhase, nStar, mapPropertyData, nStarExp)
	if(nStarExp == nil) then
        nStarExp = -1;
    end

	if(nPhase < 0 
		or nStar < 0 
		or nPhase >= MAX_HORSE_PHASE
		or nStar >= MAX_HORSE_LEVEL_PER_PHASE) then
		return mapPropertyData;
	end
    local spHorsePropertyConfig = LuaDataStatic.SearchTplForName("HorseConfig");
	local arrUpPhaseData = spHorsePropertyConfig.PhaseConfig;
	local objUpPhaseData = arrUpPhaseData[nPhase + 1];
    local arrStarProperty = {};
    --每阶每星对应增加的属性
	local nStarIndex = 1;
	local nPhaseIndex = 1;
	for k,upStarData in ipairs(spHorsePropertyConfig.HorseStarConfig) do
		if(nStarIndex == MAX_HORSE_LEVEL_PER_PHASE) then
			nStarIndex = 1;
			nPhaseIndex = nPhaseIndex + 1;
		end
        if(nPhase + 1 == nPhaseIndex) then
			--升星后增加的属性
			for v,upStarPropertyData in ipairs(upStarData.TrainProperty) do
				local nStarPropertyType = upStarPropertyData.PropertyType;	--/属性类型
				local nStarPlayerPropertyValue = upStarPropertyData.PlayerPropertyValue;--玩家增加的属性
				local nStarSpritePropertyValue = upStarPropertyData.SpritePropertyValue;	--精灵增加的属性
				local objUpStarProperty = {};
				objUpStarProperty.nPropertyType = nStarPropertyType;
				objUpStarProperty.nPlayerPropertyValue = nStarPlayerPropertyValue;
				objUpStarProperty.nSpritePropertyValue = nStarSpritePropertyValue;
                table.insert(arrStarProperty, objUpStarProperty);
			end
			nStarIndex = nStarIndex + 1;
            break;
		end
    end
	for i= 1,#arrStarProperty do
		local objStarProperty = arrStarProperty[i];
		if(objStarProperty.nPropertyType ~= 0) then
		    if(mapPropertyData[objStarProperty.nPropertyType] ~= nil) then
			    arrProperty = mapPropertyData[objStarProperty.nPropertyType];
			    if(nStarExp == -1) then
				    arrProperty[1] = arrProperty[1] + objStarProperty.nPlayerPropertyValue;
				    arrProperty[2] = arrProperty[2] + objStarProperty.nSpritePropertyValue;
			    else
				    arrProperty[1] = arrProperty[1] + math.floor(objStarProperty.nPlayerPropertyValue * nStarExp / objUpPhaseData.StarExp * 0.8);
				    arrProperty[2] = arrProperty[2] + math.floor(objStarProperty.nSpritePropertyValue * nStarExp / objUpPhaseData.StarExp * 0.8);
			    end
			    mapPropertyData[objStarProperty.nPropertyType] = arrProperty;
		    else
			    if(nStarExp == -1) then
				    mapPropertyData[objStarProperty.nPropertyType] = {objStarProperty.nPlayerPropertyValue,objStarProperty.nSpritePropertyValue};
			    else
				    local nProperty0 = math.floor(objStarProperty.nPlayerPropertyValue * nStarExp / objUpPhaseData.StarExp * 0.8);
				    local nProperty1 = math.floor(objStarProperty.nSpritePropertyValue * nStarExp / objUpPhaseData.StarExp * 0.8);
				    mapPropertyData[objStarProperty.nPropertyType] = {nProperty0, nProperty1};
			    end
		    end
        end
	end		
	return mapPropertyData;
end

--获取满足当前等级段，可以杀的野外地图ID和对应地图里的怪物ID
function LuaCommonMethod.GotoKillAssignMonster()
	if(LuaCMapModule.IsInCityMap() or LuaCMapModule.IsInWildMap() or LuaCMapModule.IsInPVPMap())
	then
        local tplBegin = LuaDataStatic.SearchTplForName("Beginner");
        if(tplBegin == nil)
        then
            return nil;
        end
		local lv = tplBegin.DailyTaskMosterLevel;
		local xmlData = LoadXmlData("config/selectTargetMap");
		if(xmlData == nil) then
            return nil;
        end
		local mapArr = {};--拥有满足条件怪的地图
		local monsterArr = {};--满足条件的怪物id
		for key, childxml in ipairs(xmlData.ChildNodes)
		do
            if(childxml.Name == "LevelArea")
            then
			    local beginLv = childxml.Attributes["startLv"] + 0;
			    local endLv = childxml.Attributes["endLv"] + 0;
			    local mLev = m_SpcProperty.m_nLevel;
                if(mLev >= beginLv and mLev <= endLv) --是自己等级段的地图
			    then
				    for key, xml in ipairs(childxml.ChildNodes)
				    do
					    local maplev = xml.Attributes["level"] + 0;
					    local len = mLev - maplev;
					    if(len <= 5 and len >= 0)
					    then
						    local mapid = xml.Attributes["mapid"] + 0;
						    if(LuaCMapModule.IsWildMap(mapid))
						    then
                                --该地图所有的怪
							    local arr = LuaCommonMethod.GetMonsterArrBySceneId(mapid);
							    for i = 1, #arr, 1
							    do
								    local MonsterID = arr[i];
								    local ptpl = LuaDataStatic.SearchFightData(MonsterID);
								    if(ptpl ~= nil)
                                    then
                                        if(ptpl.InitLevel > mLev - lv and ptpl.InitLevel < mLev + 2) --如果有符合条件的怪
								        then
                                            table.insert(monsterArr,MonsterID);
                                            table.insert(mapArr,mapid);
                                            if(mapid == LuaCMapModule.m_nCurMapID)
                                            then
                                                return {mapID = mapid, monsterID = MonsterID}
                                            else
									            break;
                                            end
								        end
                                    end
							    end
						    end
					    end
				    end
			    end
            end
		end
		--local index = mapArr.indexOf(LuaCMapModule.m_nCurMapID);
		--if(index == -1)
		--{
			--index = LuaCTaskUIManager.searchRecentMapIDIndex(mapArr); 
		--}
        if(#mapArr > 1 and #monsterArr > 1)
        then
            return {mapID = mapArr, monsterID = monsterArr};
        end
	end
	return nil;
end

--根据地图id得到所有的怪物
function LuaCommonMethod.GetMonsterArrBySceneId(sceneID)
	local monsterArr = {};
	local xmlData = LoadXmlData("config/scene/" .. sceneID .. "_refresh");
	if(xmlData == nil)
	then
		return monsterArr;
	end
	for key, xml in ipairs(xmlData.ChildNodes)
	do	
        if(xml.Name == "monster")
        then
            for key, childxml in ipairs(xml.ChildNodes)
	        do	
                local monsterID = childxml.Attributes["id"] + 0;
		        local tplMonster = LuaDataStatic.SearchFightData(monsterID);
                if(tplMonster ~= nil)
                then
                    table.insert(monsterArr, monsterID);
                end
            end
        end
	end
	return monsterArr;
end

--将秒数转化为时、分、秒    second  秒
function LuaCommonMethod.ChangeTimeToHourMinuteSecond(second)
    local timeHour  = math.fmod(math.floor(second / 3600), 24);
    local timeMinute = math.fmod(math.floor(second / 60), 60);
    local timeSecond = math.fmod(second, 60);
    return {hours = timeHour, minute = timeMinute, second = timeSecond};
end;
--table转字符串
function LuaCommonMethod.TableToString(objTable)
    local str = "{";
    for i,v in pairs(objTable) do
        str = LuaCommonMethod.DoTableToString(str, i, v);
    end
    str = str .. "}";
    return str;
end
function LuaCommonMethod.DoTableToString(szRet,key,value)
    local mStr = tostring(szRet);
    if "number" == type(key) then
        mStr = mStr .. "[" .. key .. "] = "
        if "number" == type(value) then
            mStr = mStr .. value .. ","
        elseif "string" == type(value) then
            mStr = mStr .. '"' .. value .. '"' .. ","
        elseif "table" == type(value) then
            local newValue = value;
            local str = LuaCommonMethod.TableToString(newValue);
            mStr = mStr .. tostring(str) .. ",";
        else
            mStr = mStr .. "nil,"
        end
    elseif "string" == type(key) then
        mStr = mStr .. '["' .. key .. '"] = '
        if "number" == type(value) then
            mStr = mStr .. value .. ","
        elseif "string" == type(value) then
            mStr = mStr .. '"' .. value .. '"' .. ","
        elseif "table" == type(value) then
            local newValue1 = value;
            local str = LuaCommonMethod.TableToString(newValue1);
            mStr = mStr .. tostring(str) .. ",";
        else
            mStr = mStr .. "nil,"
        end
    end
    return mStr;
end

--字符串分隔功能 str是需要查分的对象 d是分界符
function LuaCommonMethod.Split(str, d) 
    local lst = { }
    local n = string.len(str)--长度
    local start = 1
    while start <= n do
        local i = string.find(str, d, start)
        if i == nil then 
            table.insert(lst, string.sub(str, start, n))
            break
        end
        table.insert(lst, string.sub(str, start, i-1))
        if i == n then
            table.insert(lst, "")
            break
        end
        start = i + 1
    end
    return lst
end
-- 获得装备附加属性品质
function LuaCommonMethod.GetEquipAddProperQuality(id, value)
	if(value == nil) then
        value = 0;
    end
	local nQuality = 0; -- 绿色
    local spEquipRefreshConfig = LuaDataStatic.SearchTplForName("EquipRefreshConfig");
	if (spEquipRefreshConfig == nil) then
		return nQuality;
	end
	-- 查找此属性的基础值
	local nBaseValue = -1; 
	for i = 1,#spEquipRefreshConfig.EquipPropertyData do
		local equipProperty = spEquipRefreshConfig.EquipPropertyData[i];
		if(equipProperty.PropertyType == id)
		then
			nBaseValue = equipProperty.PropertyValue;
			break;
		end
	end
	-- 没有找到，则退出
	if(nBaseValue == -1)
	then
		return nQuality;
	end
	-- 减去基础值获得增加系数
	local nAddValue = math.floor(value / nBaseValue * 10000);
	-- 根据增加系数查找品质表，获取品质颜色
	local arrEquipQualityData = spEquipRefreshConfig.EquipQualityData;
	for i = #arrEquipQualityData,1,-1 do
		local equipQuality = arrEquipQualityData[i];
		-- 如果小于当前品阶的最小值，则取
		if(nAddValue >= equipQuality.PropertyValueMin)
		then
			nQuality = i;
			break;
		end
	end
	return nQuality-1;
end  
--品阶对应名称描述
function LuaCommonMethod.GetEquipQualityStepString(nRank)
	local returnString = "";
	if(nRank == EQUIP_RANK_COMMON) then
		--returnString = "普通";
		returnString = CLanguageData.GetLanguageText("Com_Common");
	elseif(nRank == EQUIP_RANK_GOOD) then
		--returnString = "良好";
		returnString = CLanguageData.GetLanguageText("Com_Fine");
	elseif(nRank == EQUIP_RANK_WONDERFUL) then
		--returnString = "优秀";
		returnString = CLanguageData.GetLanguageText("Com_Excellent");
	elseif(nRank == EQUIP_RANK_PERFECT) then
		--returnString = "完美";
		returnString = CLanguageData.GetLanguageText("Com_Perfect");
	elseif(nRank == EQUIP_RANK_EXCELLENT) then
		--returnString = "卓越";
		returnString = CLanguageData.GetLanguageText("Com_Brilliant");
	elseif(nRank == EQUIP_RANK_LEGEND) then
		--returnString = "传说";
		returnString = CLanguageData.GetLanguageText("Com_Legend");
	elseif(nRank == EQUIP_RANK_EPIC) then
		--returnString = "史诗";
		returnString = CLanguageData.GetLanguageText("Com_Epic");
	end
	return returnString;
end
--品阶对应名称颜色
function LuaCommonMethod.GetEquipQualityColor(nRank)
	local returnString = "#FFFFFF";
	if(nRank == EQUIP_RANK_COMMON) then
		--returnString = "普通";
		returnString = "#FFFFFF";
	elseif(nRank == EQUIP_RANK_GOOD) then
		--returnString = "良好";
		returnString = "#55FF5D";
	elseif(nRank == EQUIP_RANK_WONDERFUL) then
		--returnString = "优秀";
		returnString = "#45FFFD";
	elseif(nRank == EQUIP_RANK_PERFECT) then
		--returnString = "完美";
		returnString = "#1890D4";
	elseif(nRank == EQUIP_RANK_EXCELLENT) then
		--returnString = "卓越";
		returnString = "#F6FF00";
	elseif(nRank == EQUIP_RANK_LEGEND) then
		--returnString = "传说";
		returnString = "#C621CC";
	elseif(nRank == EQUIP_RANK_EPIC) then
		--returnString = "史诗";
		returnString = "#EA3517";
	end
	return returnString;
end
function LuaCommonMethod.GetEquipQualityPropertyMaxNum(nQuality)
    local spEquipRefreshConfig = LuaDataStatic.SearchTplForName("EquipRefreshConfig");
	if(spEquipRefreshConfig == nil)
	then
		return 0;
	end
	if(nQuality == TmItemQuality.emItemQuality_Gray)	-- 灰色品质
    then
		return 0;
	elseif(nQuality == TmItemQuality.emItemQuality_Red)	-- 红色品质
    then
		return 0;
	elseif(nQuality == TmItemQuality.emItemQuality_White)	-- 白色品质
    then
		return 0;
	elseif(nQuality == TmItemQuality.emItemQuality_Green)	-- 绿色品质
    then
		return spEquipRefreshConfig.EquipQualityPropertyNum[1];
	elseif(nQuality == TmItemQuality.emItemQuality_Blue)	-- 蓝色品质
    then
		return spEquipRefreshConfig.EquipQualityPropertyNum[2];
	elseif(nQuality == TmItemQuality.emItemQuality_Purple)	-- 紫色品质
    then
		return spEquipRefreshConfig.EquipQualityPropertyNum[3];
	elseif(nQuality == TmItemQuality.emItemQuality_Orange)	-- 橙色品质
    then
		return spEquipRefreshConfig.EquipQualityPropertyNum[3];
	elseif(nQuality == TmItemQuality.emItemQuality_Yellow)	-- 黄色品质
    then
		return spEquipRefreshConfig.EquipQualityPropertyNum[3];
	end
	return 0;
end
-- 获得装备附加属性颜色
function LuaCommonMethod.GetEquipAddProperColor(id, value)
	if(value == nil) then
        value = 0;
    end
	local strColor = "#ffffff";
	local nQuality = LuaCommonMethod.GetEquipAddProperQuality(id, value);
	if(nQuality == 0) then --绿色
		strColor = "#5AFF00";
	elseif(nQuality == 1) then	-- 蓝色
		strColor = "#00A2FF";
	elseif(nQuality == 2) then -- 紫色
		strColor = "#FC00FF";
	elseif(nQuality == 3) then -- 金色
		strColor = "#FFE400";
	end
	return strColor;
end
--钱数，大于万时有万字
function LuaCommonMethod.GetMoneyString(money)
	if(money >= 50000) then
		local moneyText = math.floor(money / 10000);
		--return moneyText + "万";
		return string.format(CLanguageData.GetLanguageText("Com_TenThousand"),moneyText);
	end
	return money .. "";
end
--装备属性对应的文字和属性值
function LuaCommonMethod.GetPropertyTypeNameValue(id, value)
	if(id == TmTplPropertyFunc.emTplPropertyFunc_None) then
        return  "";		-- 无属性加成
	elseif(id == TmTplPropertyFunc.emTplPropertyFunc_MaxHPFixed) then			
        return  CLanguageData.GetLanguageText("UI_COMMON_145") .. " +" .. value;		-- 血量最大值固定加成
	elseif(id == TmTplPropertyFunc.emTplPropertyFunc_MaxHPPer) then			
        return  CLanguageData.GetLanguageText("UI_COMMON_145") .. " +" .. value .. "%";		-- 血量最大值百分比加成
	elseif(id == TmTplPropertyFunc.emTplPropertyFunc_NoramlAttackFixed) then	
        return  CLanguageData.GetLanguageText("Module_Item_NoramlAttack") .. " +" .. value;		-- 外功攻击固定加成
	elseif(id == TmTplPropertyFunc.emTplPropertyFunc_NoramlAttackPer) then		
        return  CLanguageData.GetLanguageText("Module_Item_NoramlAttack") .. " +" ..(value / 100) .. "%";		-- 外功攻击百分比加成
	elseif(id == TmTplPropertyFunc.emTplPropertyFunc_NormalDefenseFixed) then	
        return  CLanguageData.GetLanguageText("Module_Item_NormalDefense") .. " +" .. value;		-- 外功防御固定加成
	elseif(id == TmTplPropertyFunc.emTplPropertyFunc_NormalDefensePer) then	
        return  CLanguageData.GetLanguageText("Module_Item_NormalDefense") .. " +" ..(value / 100) .. "%";		-- 外功防御百分比加成
	elseif(id == TmTplPropertyFunc.emTplPropertyFunc_CriticalHitFixed) then
        return  CLanguageData.GetLanguageText("Module_Item_CriticalHit") .. " +" ..(value / 100) .. "%";		-- 暴击固定值加成
	elseif(id == TmTplPropertyFunc.emTplPropertyFunc_ToughnessFixed) then		
        return  CLanguageData.GetLanguageText("Module_Item_Toughness") .. " +" ..(value / 100) .. "%";		-- 防暴固定值加成
	elseif(id == TmTplPropertyFunc.emTplPropertyFunc_DuckFixed) then
        return  CLanguageData.GetLanguageText("Module_Item_Duck") .. " +" ..(value / 100) .. "%";		-- 闪避固定值加成
	elseif(id == TmTplPropertyFunc.emTplPropertyFunc_BreakHit) then				
        return  CLanguageData.GetLanguageText("Module_Item_BreakHit") .. " +" ..(value / 100) .. "%";		-- 破防固定值加成
	elseif(id == TmTplPropertyFunc.emTplPropertyFunc_Parry) then				
        return  CLanguageData.GetLanguageText("Module_Item_Parry") .. " +" ..(value / 100) .. "%";		-- 格挡固定值加成
	elseif(id == TmTplPropertyFunc.emTplPropertyFunc_DeathHit) then			
        return  CLanguageData.GetLanguageText("Module_Item_DeathHit") .. " +" ..(value / 100) .. "%";		-- 必杀固定值加成
	elseif(id == TmTplPropertyFunc.emTplPropertyFunc_SpeedFixed) then			
        return  CLanguageData.GetLanguageText("Module_Item_Speed") .. " +" .. value;		-- 移动速度固定值加成
	elseif(id == TmTplPropertyFunc.emTplPropertyFunc_SpeedPer) then			
        return  CLanguageData.GetLanguageText("Module_Item_Speed") .. " +" ..(value / 100) .. "%";		-- 移动速度百分比加成
	elseif(id == TmTplPropertyFunc.emTplPropertyFunc_PowerFixed) then			
        return  CLanguageData.GetLanguageText("Module_Item_Power") .. " +" .. value;		-- 气势值加成
	elseif(id == TmTplPropertyFunc.emTplPropertyFunc_MayhemPer) then
        return  CLanguageData.GetLanguageText("Module_Item_MayhemPer") .. " +" ..(value / 100) .. "%";		-- 伤害加成百分比
	elseif(id == TmTplPropertyFunc.emTplPropertyFunc_DamageReductionPer) then 
        return CLanguageData.GetLanguageText("Module_Item_DamageReductionr") .. " +" ..(value / 100) .. "%";		-- 伤害减免百分比
    elseif(id == TmTplPropertyFunc.emTplPropertyFunc_Unarmed) then			
        return  CLanguageData.GetLanguageText("Module_Item_Unarmed") .. " +" .. value;		-- 拳掌值加成
    elseif(id == TmTplPropertyFunc.emTplPropertyFunc_Sword) then			
        return  CLanguageData.GetLanguageText("Module_Item_Sword") .. " +" .. value;		-- 御剑值加成
    elseif(id == TmTplPropertyFunc.emTplPropertyFunc_Knife) then			
        return  CLanguageData.GetLanguageText("Module_Item_Knife") .. " +" .. value;		-- 耍刀值加成
    elseif(id == TmTplPropertyFunc.emTplPropertyFunc_Special) then			
        return  CLanguageData.GetLanguageText("Module_Item_Special") .. " +" .. value;		-- 特殊值加成
    elseif(id == TmTplPropertyFunc.emTplPropertyFunc_SkillMagic) then			
        return  CLanguageData.GetLanguageText("Module_Item_SkillMagic") .. " +" .. value;		-- 内功值加成
    elseif(id == TmTplPropertyFunc.emTplPropertyFunc_AttackSpeed) then
        return  CLanguageData.GetLanguageText("Module_Item_AttackSpeed") .. " +" .. value;-- 身法
    elseif(id == TmTplPropertyFunc.emTplPropertyFunc_DoubleHit) then
        return  CLanguageData.GetLanguageText("Module_Item_DoubleHit") .. " +" .. value;		-- 连击
    elseif(id == TmTplPropertyFunc.emTplPropertyFunc_DoubleSkill) then
        return  CLanguageData.GetLanguageText("Module_Item_DoubleSkill") .. " +" .. value;	-- 连招
    elseif(id == TmTplPropertyFunc.emTplPropertyFunc_Counter) then
        return  CLanguageData.GetLanguageText("Module_Item_Counter") .. " +" .. value;	-- 反击
    elseif(id == TmTplPropertyFunc.emTplPropertyFunc_Poison) then
        return  CLanguageData.GetLanguageText("Module_Item_Poison") .. " +" .. value;	-- 施毒
    elseif(id == TmTplPropertyFunc.emTplPropertyFunc_BloodLetting) then
        return  CLanguageData.GetLanguageText("Module_Item_BloodLetting") .. " +" .. value;	-- 流血
    elseif(id == TmTplPropertyFunc.emTplPropertyFunc_SealedHit) then
        return  CLanguageData.GetLanguageText("Module_Item_SealedHit") .. " +" .. value;	-- 封招
    elseif(id == TmTplPropertyFunc.emTplPropertyFunc_Acupuncture) then
        return  CLanguageData.GetLanguageText("Module_Item_Acupuncture") .. " +" .. value;	-- 点穴
    elseif(id == TmTplPropertyFunc.emTplPropertyFunc_Trance) then
        return  CLanguageData.GetLanguageText("Module_Item_Trance") .. " +" .. value;	-- 昏迷
    elseif(id == TmTplPropertyFunc.emTplPropertyFunc_Weak) then
        return  CLanguageData.GetLanguageText("Module_Item_Weak") .. " +" .. value;	-- 虚弱
    elseif(id == TmTplPropertyFunc.emTplPropertyFunc_Disorder) then
        return  CLanguageData.GetLanguageText("Module_Item_Disorder") .. " +" .. value;	-- 混乱
    elseif(id == TmTplPropertyFunc.emTplPropertyFunc_Disarm) then
        return  CLanguageData.GetLanguageText("Module_Item_Disarm") .. " +" .. value;	-- 缴械
    elseif(id == TmTplPropertyFunc.emTplPropertyFunc_ArmorBreak) then
        return  CLanguageData.GetLanguageText("Module_Item_ArmorBreak") .. " +" .. value;	-- 破甲
    elseif(id == TmTplPropertyFunc.emTplPropertyFunc_Slow) then
        return  CLanguageData.GetLanguageText("Module_Item_Slow") .. " +" .. value;	-- 迟钝
    end
	return CLanguageData.GetLanguageText("UI_COMMON_144") .. id;
end
--装备属性对应的属性值
function LuaCommonMethod.GetPropertyValueById(id, value)
    if(id == TmTplPropertyFunc.emTplPropertyFunc_None) then
        return  "";		-- 无属性加成
    elseif(id == TmTplPropertyFunc.emTplPropertyFunc_MaxHPFixed) then
        return  value;		-- 血量最大值固定加成
    elseif(id == TmTplPropertyFunc.emTplPropertyFunc_MaxHPPer) then
        return  value .. "%";		-- 血量最大值百分比加成
    elseif(id == TmTplPropertyFunc.emTplPropertyFunc_NoramlAttackFixed) then
        return  value;		-- 外功攻击固定加成
    elseif(id == TmTplPropertyFunc.emTplPropertyFunc_NoramlAttackPer) then
        return  (value / 100) .. "%";		-- 外功攻击百分比加成
    elseif(id == TmTplPropertyFunc.emTplPropertyFunc_NormalDefenseFixed) then
        return  value;		-- 外功防御固定加成
    elseif(id == TmTplPropertyFunc.emTplPropertyFunc_NormalDefensePer) then
        return  (value / 100) .. "%";		-- 外功防御百分比加成
    elseif(id == TmTplPropertyFunc.emTplPropertyFunc_CriticalHitFixed) then
        return  (value / 100) .. "%";		-- 暴击固定值加成
    elseif(id == TmTplPropertyFunc.emTplPropertyFunc_ToughnessFixed) then
        return  (value / 100) .. "%";		-- 防暴固定值加成
    elseif(id == TmTplPropertyFunc.emTplPropertyFunc_DuckFixed) then
        return  (value / 100) .. "%";		-- 闪避固定值加成
    elseif(id == TmTplPropertyFunc.emTplPropertyFunc_BreakHit) then
        return  (value / 100) .. "%";		-- 破防固定值加成
    elseif(id == TmTplPropertyFunc.emTplPropertyFunc_Parry) then
        return  (value / 100) .. "%";		-- 格挡固定值加成
    elseif(id == TmTplPropertyFunc.emTplPropertyFunc_DeathHit) then
        return  (value / 100) .. "%";		-- 必杀固定值加成
    elseif(id == TmTplPropertyFunc.emTplPropertyFunc_SpeedFixed) then
        return  value;		-- 移动速度固定值加成
    elseif(id == TmTplPropertyFunc.emTplPropertyFunc_SpeedPer) then
        return  (value / 100) .. "%";		-- 移动速度百分比加成
    elseif(id == TmTplPropertyFunc.emTplPropertyFunc_PowerFixed) then
        return  value;		-- 气势值加成
    elseif(id == TmTplPropertyFunc.emTplPropertyFunc_MayhemPer) then
        return  (value / 100) .. "%";		-- 伤害加成百分比
    elseif(id == TmTplPropertyFunc.emTplPropertyFunc_DamageReductionPer) then
        return (value / 100) .. "%";		-- 伤害减免百分比
    elseif(id == TmTplPropertyFunc.emTplPropertyFunc_Unarmed) then
        return  value;		-- 拳掌值加成
    elseif(id == TmTplPropertyFunc.emTplPropertyFunc_Sword) then
        return  value;		-- 御剑值加成
    elseif(id == TmTplPropertyFunc.emTplPropertyFunc_Knife) then
        return  value;		-- 耍刀值加成
    elseif(id == TmTplPropertyFunc.emTplPropertyFunc_Special) then
        return  value;		-- 特殊值加成
    elseif(id == TmTplPropertyFunc.emTplPropertyFunc_SkillMagic) then
        return  value;		-- 内功值加成
    elseif(id == TmTplPropertyFunc.emTplPropertyFunc_AttackSpeed) then
        return  value;		-- 身法
    elseif(id == TmTplPropertyFunc.emTplPropertyFunc_DoubleHit) then
        return  (value / 100) .. "%";	-- 连击
    elseif(id == TmTplPropertyFunc.emTplPropertyFunc_DoubleSkill) then
        return  (value / 100) .. "%";		-- 连招
    elseif(id == TmTplPropertyFunc.emTplPropertyFunc_Counter) then
        return  (value / 100) .. "%";		-- 反击
    elseif(id == TmTplPropertyFunc.emTplPropertyFunc_Poison) then
        return  value;		-- 施毒
    elseif(id == TmTplPropertyFunc.emTplPropertyFunc_BloodLetting) then
        return  value;		-- 流血
    elseif(id == TmTplPropertyFunc.emTplPropertyFunc_SealedHit) then
        return  value;	-- 封招
    elseif(id == TmTplPropertyFunc.emTplPropertyFunc_Acupuncture) then
        return  value;		-- 点穴
    elseif(id == TmTplPropertyFunc.emTplPropertyFunc_Trance) then
        return  value;		-- 昏迷
    elseif(id == TmTplPropertyFunc.emTplPropertyFunc_Weak) then
        return  value;	-- 虚弱
    elseif(id == TmTplPropertyFunc.emTplPropertyFunc_Disorder) then
        return  value;		-- 混乱
    elseif(id == TmTplPropertyFunc.emTplPropertyFunc_Disarm) then
        return  value;		-- 缴械
    elseif(id == TmTplPropertyFunc.emTplPropertyFunc_ArmorBreak) then
        return  value;		-- 破甲
    elseif(id == TmTplPropertyFunc.emTplPropertyFunc_Slow) then
        return  value;		-- 迟钝
    end
    return id;
end
--装备属性对应的文字
function LuaCommonMethod.GetPropertyTypeNameById(id)
    if(id == TmTplPropertyFunc.emTplPropertyFunc_None) then
        return  "";		-- 无属性加成
    elseif(id == TmTplPropertyFunc.emTplPropertyFunc_MaxHPFixed) then
        return  CLanguageData.GetLanguageText("UI_COMMON_145");		-- 血量最大值固定加成
    elseif(id == TmTplPropertyFunc.emTplPropertyFunc_MaxHPPer) then
        return  CLanguageData.GetLanguageText("UI_COMMON_145");		-- 血量最大值百分比加成
    elseif(id == TmTplPropertyFunc.emTplPropertyFunc_NoramlAttackFixed) then
        return  CLanguageData.GetLanguageText("Module_Item_NoramlAttack");		-- 外功攻击固定加成
    elseif(id == TmTplPropertyFunc.emTplPropertyFunc_NoramlAttackPer) then
        return  CLanguageData.GetLanguageText("Module_Item_NoramlAttack");		-- 外功攻击百分比加成
    elseif(id == TmTplPropertyFunc.emTplPropertyFunc_NormalDefenseFixed) then
        return  CLanguageData.GetLanguageText("Module_Item_NormalDefense");		-- 外功防御固定加成
    elseif(id == TmTplPropertyFunc.emTplPropertyFunc_NormalDefensePer) then
        return  CLanguageData.GetLanguageText("Module_Item_NormalDefense");		-- 外功防御百分比加成
    elseif(id == TmTplPropertyFunc.emTplPropertyFunc_CriticalHitFixed) then
        return  CLanguageData.GetLanguageText("Module_Item_CriticalHit");		-- 暴击固定值加成
    elseif(id == TmTplPropertyFunc.emTplPropertyFunc_ToughnessFixed) then
        return  CLanguageData.GetLanguageText("Module_Item_Toughness");		-- 防暴固定值加成
    elseif(id == TmTplPropertyFunc.emTplPropertyFunc_DuckFixed) then
        return  CLanguageData.GetLanguageText("Module_Item_Duck");		-- 闪避固定值加成
    elseif(id == TmTplPropertyFunc.emTplPropertyFunc_BreakHit) then
        return  CLanguageData.GetLanguageText("Module_Item_BreakHit");		-- 破防固定值加成
    elseif(id == TmTplPropertyFunc.emTplPropertyFunc_Parry) then
        return  CLanguageData.GetLanguageText("Module_Item_Parry");		-- 格挡固定值加成
    elseif(id == TmTplPropertyFunc.emTplPropertyFunc_DeathHit) then
        return  CLanguageData.GetLanguageText("Module_Item_DeathHit");		-- 必杀固定值加成
    elseif(id == TmTplPropertyFunc.emTplPropertyFunc_SpeedFixed) then
        return  CLanguageData.GetLanguageText("Module_Item_Speed");		-- 移动速度固定值加成
    elseif(id == TmTplPropertyFunc.emTplPropertyFunc_SpeedPer) then
        return  CLanguageData.GetLanguageText("Module_Item_Speed");		-- 移动速度百分比加成
    elseif(id == TmTplPropertyFunc.emTplPropertyFunc_PowerFixed) then
        return  CLanguageData.GetLanguageText("Module_Item_Power");		-- 气势值加成
    elseif(id == TmTplPropertyFunc.emTplPropertyFunc_MayhemPer) then
        return  CLanguageData.GetLanguageText("Module_Item_MayhemPer");		-- 伤害加成百分比
    elseif(id == TmTplPropertyFunc.emTplPropertyFunc_DamageReductionPer) then
        return CLanguageData.GetLanguageText("Module_Item_DamageReductionr");		-- 伤害减免百分比
    elseif(id == TmTplPropertyFunc.emTplPropertyFunc_Unarmed) then
        return  CLanguageData.GetLanguageText("Module_Item_Unarmed");		-- 拳掌值加成
    elseif(id == TmTplPropertyFunc.emTplPropertyFunc_Sword) then
        return  CLanguageData.GetLanguageText("Module_Item_Sword");		-- 御剑值加成
    elseif(id == TmTplPropertyFunc.emTplPropertyFunc_Knife) then
        return  CLanguageData.GetLanguageText("Module_Item_Knife");		-- 耍刀值加成
    elseif(id == TmTplPropertyFunc.emTplPropertyFunc_Special) then
        return  CLanguageData.GetLanguageText("Module_Item_Special");		-- 特殊值加成
    elseif(id == TmTplPropertyFunc.emTplPropertyFunc_SkillMagic) then
        return  CLanguageData.GetLanguageText("Module_Item_SkillMagic");		-- 内功值加成
    elseif(id == TmTplPropertyFunc.emTplPropertyFunc_AttackSpeed) then
        return  CLanguageData.GetLanguageText("Module_Item_AttackSpeed");		-- 身法
    elseif(id == TmTplPropertyFunc.emTplPropertyFunc_DoubleHit) then
        return  CLanguageData.GetLanguageText("Module_Item_DoubleHit");		-- 连击
    elseif(id == TmTplPropertyFunc.emTplPropertyFunc_DoubleSkill) then
        return  CLanguageData.GetLanguageText("Module_Item_DoubleSkill");		-- 连招
    elseif(id == TmTplPropertyFunc.emTplPropertyFunc_Counter) then
        return  CLanguageData.GetLanguageText("Module_Item_Counter");		-- 反击
    elseif(id == TmTplPropertyFunc.emTplPropertyFunc_Poison) then
        return  CLanguageData.GetLanguageText("Module_Item_Poison");		-- 施毒
    elseif(id == TmTplPropertyFunc.emTplPropertyFunc_BloodLetting) then
        return  CLanguageData.GetLanguageText("Module_Item_BloodLetting");		-- 流血
    elseif(id == TmTplPropertyFunc.emTplPropertyFunc_SealedHit) then
        return  CLanguageData.GetLanguageText("Module_Item_SealedHit");		-- 封招
    elseif(id == TmTplPropertyFunc.emTplPropertyFunc_Acupuncture) then
        return  CLanguageData.GetLanguageText("Module_Item_Acupuncture");		-- 点穴
    elseif(id == TmTplPropertyFunc.emTplPropertyFunc_Trance) then
        return  CLanguageData.GetLanguageText("Module_Item_Trance");		-- 昏迷
    elseif(id == TmTplPropertyFunc.emTplPropertyFunc_Weak) then
        return  CLanguageData.GetLanguageText("Module_Item_Weak");		-- 虚弱
    elseif(id == TmTplPropertyFunc.emTplPropertyFunc_Disorder) then
        return  CLanguageData.GetLanguageText("Module_Item_Disorder");		-- 混乱
    elseif(id == TmTplPropertyFunc.emTplPropertyFunc_Disarm) then
        return  CLanguageData.GetLanguageText("Module_Item_Disarm");		-- 缴械
    elseif(id == TmTplPropertyFunc.emTplPropertyFunc_ArmorBreak) then
        return  CLanguageData.GetLanguageText("Module_Item_ArmorBreak");		-- 破甲
    elseif(id == TmTplPropertyFunc.emTplPropertyFunc_Slow) then
        return  CLanguageData.GetLanguageText("Module_Item_Slow");		-- 迟钝
    end
    return CLanguageData.GetLanguageText("UI_COMMON_144") .. id;
end
--得到丹药的增加功力的类型
function LuaCommonMethod.GetMedicineType(ntype)
	if(ntype == 0)
	then
		--return "外功";
		return CLanguageData.GetLanguageText("UI_COMMON_186");
	elseif(ntype == 2)
	then
		--return "绝技";
		return CLanguageData.GetLanguageText("UI_COMMON_187");
	elseif(ntype == 1)
	then
		--return "奇术";
		return CLanguageData.GetLanguageText("UI_COMMON_188");
	else
		return "";
	end
end
--得到成员的名字
function LuaCommonMethod.GetMemberName(partnerIndex)
	local strName = "";
	local pMemberProperty = LuaCHeroProperty.GetMemberProperty(partnerIndex);
	if(partnerIndex == 0)
	then
		strName = LuaCHeroProperty.mName;
		return strName;
	else
		local tempPartner = LuaDataStatic.SearchPlayerPartnerTpl(pMemberProperty.m_nTempID);
		if(tempPartner ~= nil)
		then
			strName = CLanguageData.GetTplText(tempPartner.Name);
			return strName;
		end
	end
	return strName;
end
--酒馆伙伴品质对应文字颜色
function LuaCommonMethod.GetTavernQualityColor(quality)
	if (quality==TmItemQuality.emItemQuality_Blue) then
			return "'#209EE5'";--蓝色品质
	elseif (quality==TmItemQuality.emItemQuality_Purple) then
			return "'#c621cc'";--紫色品质
	elseif (quality==TmItemQuality.emItemQuality_Yellow) then
			return "'#ffe329'";--黄色品质
	end
	return ""
end

--获取下一个某个数值有增加的vip等级
function LuaCommonMethod.getNextVipNum(vip,flag,str1,str2,str3,str4,str5)
	if flag == nil then flag="" end
	if str1 == nil then str1="" end
	if str2 == nil then str2="" end
	if str3 == nil then str3="" end
	if str4 == nil then str4="" end
	if str5 == nil then str5="" end
	local num = -1;
	local ci = 0
	local nowVipFuncParam = LuaDataStatic.SearchVIPConfigForViplevel(vip+1);
	for i = vip+1,12 do
		local vipFuncParam = LuaDataStatic.SearchVIPConfigForViplevel(i+1);
		if (flag=="moneySysbolTimes") then --下一个摇钱次数增加的vip等级
			if (vipFuncParam.MoneySysbolTimes > nowVipFuncParam.MoneySysbolTimes) then
				num = i;
				ci = vipFuncParam.MoneySysbolTimes;
                break;
			end
		elseif (flag=="heartMagicSummonTimes") then --下一个召唤张三丰次数增加的vip等级
			if (vipFuncParam.HeartMagicSummonTimes > nowVipFuncParam.HeartMagicSummonTimes) then
				num = i;
				ci = vipFuncParam.HeartMagicSummonTimes;
				break;
			end
		elseif (flag=="purchaseStrengthTimes") then			--下一个购买体力次数增加的vip等级
			if (vipFuncParam.PurchaseStrengthTimes > nowVipFuncParam.PurchaseStrengthTimes) then
				num = i;
				ci = vipFuncParam.PurchaseStrengthTimes;
				break;
			end
		elseif (flag=="purchaseMoneySeedTimes") then --下一个购买铜钱种子数增加的vip等级
			if (vipFuncParam.PurchaseMoneySeedTimes > nowVipFuncParam.PurchaseMoneySeedTimes) then
				num = i;
				ci = vipFuncParam.PurchaseMoneySeedTimes;
				break;
			end
		elseif (flag == "refreshMazeTimes") then  --下一个寻宝刷新次数增加的vip等级
			if (vipFuncParam.RefreshMazeTimes > nowVipFuncParam.RefreshMazeTimes) then
				num = i;
				ci = vipFuncParam.RefreshMazeTimes;
				break;
			end
		elseif (flag == "resetHeroInstanceTimes") then --下一个名人录重置次数次数增加的vip等级
			if (vipFuncParam.ResetHeroInstanceTimes > nowVipFuncParam.ResetHeroInstanceTimes) then
				num = i;
				ci = vipFuncParam.ResetHeroInstanceTimes;
				break;
			end
		elseif (flag == "purchaseJXZTimes") then --下一个聚贤庄购买挑战次数次数增加的vip等级
			if (vipFuncParam.PurchaseJXZTimes > nowVipFuncParam.PurchaseJXZTimes) then
				num = i;
				ci = vipFuncParam.PurchaseJXZTimes;
				break;
			end
		elseif (flag == "purchaseJXZNirvanaTimes") then --下一个聚贤庄乾坤一掷次数次数增加的vip等级
			if (vipFuncParam.PurchaseJXZNirvanaTimes > nowVipFuncParam.PurchaseJXZNirvanaTimes) then
				num = i;
				ci = vipFuncParam.PurchaseJXZNirvanaTimes;
				break;
			end
		elseif (flag == "purchaseRecoverHPTimes") then--下一个聚贤庄黑玉断续膏次数增加的vip等级
			--武当派0
			if (vipFuncParam.PurchaseRecoverHPTimes > nowVipFuncParam.PurchaseRecoverHPTimes) then
				num = i;
				ci = vipFuncParam.PurchaseRecoverHPTimes;
				break;
			end
		elseif (flag == "purchaseSummonQiaoFengTimes") then --下一个聚贤庄黑玉断续膏次数增加的vip等级
			if (vipFuncParam.PurchaseSummonQiaoFengTimes > nowVipFuncParam.PurchaseSummonQiaoFengTimes) then
				num = i;
				ci = vipFuncParam.PurchaseSummonQiaoFengTimes;
				break;
			end
		end
	end
	--var nameFlag:String="VIP";
	local nameFlag = CLanguageData.GetLanguageText("UI_COMMON_218");
    local nameFlag1 = CLanguageData.GetLanguageText("UI_COMMON_220");
	--var moneyFlag:String="元宝";
	local moneyFlag = CLanguageData.GetLanguageText("COMMON_STRING_004");
	--var btnFlag:String="充点小钱";
	local btnFlag = CLanguageData.GetLanguageText("UI_COMMON_219");
	if (num ~= -1) then
		local totalYuanBao1 = LuaDataStatic.SearchVIPConfigForViplevel(num+1).VIPLevelYuanBao;
		local needYuanBao1 = totalYuanBao1 - LuaCHeroProperty.mTotalRechargeYuanBao;
		--local str = "<color=#ffffff>"..str1.."</color>";
        str = str1;
		if (needYuanBao1 <= 500) then
			--str+="\n充值<font size = '13' color = '#FFE400' align='center'>"+needYuanBao1+"</font>"+moneyFlag
				--+"达到<font size = '13' color = '#FFE400' align='center'>"+nameFlag+num+"</font>，\n"
				--+"<font size = '13' color = '#FFE400' align='center'>"+nameFlag+num+"</font>"+str2
				--+"<font size = '13' color = '#00ff00' align='center'>"+ci+"</font>次"
            str = str .. string.format(CLanguageData.GetLanguageText("UI_COMMON_223"),"<color='#e68e1c'>"..needYuanBao1.."</color>",moneyFlag,
            "<color='#e68e1c'>"..(nameFlag..num..nameFlag1).."</color>","<color='#e68e1c'>"..(nameFlag..num..nameFlag1).."</color>",str2,"<color='#e68e1c'>"..ci.."</color>");

		else
			--str+="充值达到<font size = '13' color = '#FFE400' align='center'>"+nameFlag+num+"</font>，\n"
				--+"<font size = '13' color = '#FFE400' align='center'>"+nameFlag+num+"</font>"+str2
				--+"<font size = '13' color = '#00ff00' align='center'>"+ci+"</font>次"
            str = str .. string.format(CLanguageData.GetLanguageText("UI_COMMON_224"),"<color='#e68e1c'>"..(nameFlag..num..nameFlag1).."</color>",
            "<color='#e68e1c'>"..(nameFlag..num..nameFlag1).."</color>",str2,"<color='#e68e1c'>"..ci.."</color>");
		end
		LuaCUIConfirm.Show(str,function()end,
			function()end,nil,nil,CLanguageData.GetLanguageText("COMMON_STRING_002"));
	else
		local tempStr="<color=#000135>"..str3.."</color>"
			.."<color=#000135>"..str4.."</color>"
			.."<color=#000135>"..str5.."</color>";
		LuaCUIConfirm.Show(tempStr,function()end,
			function()end,nil,CLanguageData.GetLanguageText("COMMON_STRING_001"),CLanguageData.GetLanguageText("COMMON_STRING_002"));
	end
end
--vip等级不足
--@param vip 可参与的最低VIP等级
--@param flag	flag为引号内容。
--提示：VIP等级不足，充值XX元宝到达 XX VIP，“可参与超级团购，得到超值奖励！”
function LuaCommonMethod.noEnoughVIP(vip,flag,num)
	if num == nil then num=0 end
	local nameFlag
	local moneyFlag
	local btnFlag
	local totalYuanBao = 0
	local needYuanBao = 0
    local str = "";
	nameFlag = CLanguageData.GetLanguageText("UI_COMMON_218");
    local nameFlag1 = CLanguageData.GetLanguageText("UI_COMMON_220");
	moneyFlag = CLanguageData.GetLanguageText("COMMON_STRING_004");
	btnFlag = CLanguageData.GetLanguageText("UI_COMMON_219");
	if (vip > LuaCHeroProperty.mVipLevel) then
		totalYuanBao = LuaDataStatic.SearchVIPConfigForViplevel(vip).VIPLevelYuanBao;
		needYuanBao = totalYuanBao - LuaCHeroProperty.mTotalRechargeYuanBao;
        str = string.format(CLanguageData.GetLanguageText("UI_COMMON_231"),flag,"\n",
        "<color='#e68e1c'>"..nameFlag .. vip ..nameFlag1.."</color>");
		LuaCUIConfirm.Show(str,
			function()LuaCUIVIP.ShowVIPRechargeUI() end,
			function()end,nil,btnFlag,CLanguageData.GetLanguageText("COMMON_STRING_014"));
		return  true;
	end
	return  false;
end
--得到药王谷的类型
 function LuaCommonMethod.GetTreeName(nType,qua)
	if(nType == emSeedType_Exp)	--经验树
	then
		if(qua == 0)
		then
			return "<color=" .. this.GetQualityColor(TmItemQuality.emItemQuality_Green) .. ">" .. CLanguageData.GetLanguageText("UI_COMMON_189") .. "</color>";
		elseif(qua == 1)
		then
			return "<color=" .. this.GetQualityColor(TmItemQuality.emItemQuality_Blue) .. ">" .. CLanguageData.GetLanguageText("UI_COMMON_190") .. "</color>";
		elseif(qua == 2)
		then
			return "<color=" .. this.GetQualityColor(TmItemQuality.emItemQuality_Purple) .. ">" ..CLanguageData.GetLanguageText("UI_COMMON_191") .. "</color>";
		elseif(qua == 3)
		then
			return "<color=" .. this.GetQualityColor(TmItemQuality.emItemQuality_Yellow) .. ">" .. CLanguageData.GetLanguageText("UI_COMMON_192") .. "</color>";
		elseif(qua == 4)
		then
			return "<color=" .. this.GetQualityColor(TmItemQuality.emItemQuality_Red) .. ">" .. CLanguageData.GetLanguageText("UI_COMMON_193") .. "</color>";
		end
	elseif(nType == emSeedType_Money)
	then
		if(qua == 0)
		then
			return "<color=" .. this.GetQualityColor(TmItemQuality.emItemQuality_Green) .. ">" ..CLanguageData.GetLanguageText("UI_COMMON_194") .. "</color>";
		elseif(qua == 1)
		then
			return "<color=" .. this.GetQualityColor(TmItemQuality.emItemQuality_Blue) .. ">" .. CLanguageData.GetLanguageText("UI_COMMON_195") .. "</color>";
		elseif(qua == 2)
		then
			return "<color=" .. this.GetQualityColor(TmItemQuality.emItemQuality_Purple) .. ">" .. CLanguageData.GetLanguageText("UI_COMMON_196") .. "</color>";
		elseif(qua == 3)
		then
			return "<color=" .. this.GetQualityColor(TmItemQuality.emItemQuality_Yellow) .. ">" .. CLanguageData.GetLanguageText("UI_COMMON_197") .. "</color>";
		elseif(qua == 4)
		then
			return "<color=" .. this.GetQualityColor(TmItemQuality.emItemQuality_Red) .. ">" .. CLanguageData.GetLanguageText("UI_COMMON_198") .. "</color>";
		end
	elseif(nType == emSeedType_Talent)
	then
		if(qua == 0)
		then
			return "<color=" .. this.GetQualityColor(TmItemQuality.emItemQuality_Green) .. ">" .. CLanguageData.GetLanguageText("UI_COMMON_199") .. "</color>";
		elseif(qua == 1)
		then
			return "<color=" .. this.GetQualityColor(TmItemQuality.emItemQuality_Blue) .. ">" .. CLanguageData.GetLanguageText("UI_COMMON_200") .. "</color>";
		elseif(qua == 2)
		then
			return "<color=" .. this.GetQualityColor(TmItemQuality.emItemQuality_Purple) .. ">" .. CLanguageData.GetLanguageText("UI_COMMON_201") .. "</color>";
		elseif(qua == 3)
		then
			return "<color=" .. this.GetQualityColor(TmItemQuality.emItemQuality_Yellow) .. ">" .. CLanguageData.GetLanguageText("UI_COMMON_202") .. "</color>";
		elseif(qua == 4)
		then
			return "<color=" .. this.GetQualityColor(TmItemQuality.emItemQuality_Red) .. ">" .. CLanguageData.GetLanguageText("UI_COMMON_203") .. "</color>";
		end
	end
	return "";
end
--镖车品质对应文字颜色
function LuaCommonMethod.GetDartQualityColor(quality)
	if(quality == 0) then
		return "#FFFFFF";-- 白色品质
	elseif(quality == 1) then
		return "#5AFF00";-- 绿色品质
	elseif(quality == 2) then
		return "#00A2FF";-- 蓝色品质
	elseif(quality == 3) then
		return "#FC00FF";-- 紫色品质
	elseif(quality == 4) then
		return "#FFA800";-- 橙色品质
	end
	return "";
end
--镖车颜色对应的名字
function LuaCommonMethod.GetDartName(dartQuality)
	if (dartQuality==0) then
			
			return  CLanguageData.GetLanguageText("UI_YUNBIAO_020")
	elseif (dartQuality==1) then
			
			return  CLanguageData.GetLanguageText("UI_YUNBIAO_021")
	elseif (dartQuality==2) then
			
			return  CLanguageData.GetLanguageText("UI_YUNBIAO_022")
	elseif (dartQuality==3) then
			
			return  CLanguageData.GetLanguageText("UI_YUNBIAO_023")
	elseif (dartQuality==4) then
			
			return  CLanguageData.GetLanguageText("UI_YUNBIAO_024")
	end
	
	return  CLanguageData.GetLanguageText("UI_YUNBIAO_025")
end
--获得门派称号
function LuaCommonMethod.getSchoolDesignation(schooltype,rank,official)
    local xmdData = LoadXmlData("config/school_designation");
	if(xmdData ~= nil) then
        for i, xml in ipairs(xmdData.ChildNodes) do
            if(xml.Name == "designation")then
			    if(tonumber(xml.Attributes["schooltype"]) == schooltype) then
                     for j, onexml in ipairs(xml.ChildNodes) do
                        if(onexml.Name == "quality") then
                            if(tonumber(onexml.Attributes["index"]) == rank) then
                                for k, propertyxml in ipairs(onexml.ChildNodes) do
                                    if(tonumber(propertyxml.Attributes["index"]) == official) then
                                        return tostring(propertyxml.Attributes["name"]);
                                    end
                                end
                            end
                        end
                    end
                end
            end
        end
    end
	return "";
end
--获得玩家在帮会的职位
function LuaCommonMethod.getSchoolPostName(post)
--    if (post == CTemplateSchoolConfig.SCHOOL_POST_TRAINEE) then
--			return  LanguageData.gLanguageData.UI_COMMON_165
--	elseif (post==CTemplateSchoolConfig.SCHOOL_POST_OFFICIAL) then
--			return  LanguageData.gLanguageData.UI_COMMON_166
--	elseif (post==CTemplateSchoolConfig.SCHOOL_POST_HEIR) then
--			return  LanguageData.gLanguageData.UI_COMMON_167
--	elseif (post==CTemplateSchoolConfig.SCHOOL_POST_RULEESCORT) then
--			return  LanguageData.gLanguageData.UI_COMMON_168
--	elseif (post==CTemplateSchoolConfig.SCHOOL_POST_PRESBYTER) then
--			return  LanguageData.gLanguageData.UI_COMMON_169
--	elseif (post==CTemplateSchoolConfig.SCHOOL_POST_MASTER) then
--			return  LanguageData.gLanguageData.UI_COMMON_170
--	end
--	return  LanguageData.gLanguageData.UI_COMMON_171
end

function LuaCommonMethod.GetTrainNum(xmlData, nOgreID, nOgreNum)
	local nNum = 0;
    for each, ogreList in ipairs(xmlData.ChildNodes) do
        if (ogreList.Name == "OgreList") then
            local nID = ogreList.Attributes["id"];
		    local OgreTemplate = LuaDataStatic.SearchFightData(nID);
		    if (OgreTemplate ~= nil) then
                local n = 0
		        while  n < MAX_ARRAYS_POS_NUM  do
			        local nOgrePartnerID = OgreTemplate.OgrePartner[n]
			        if (nOgrePartnerID ~= 0) then
				        --伙伴怪物伙伴模板
			            local OgrePartnerTemplate = LuaDataStatic.SearchOgrePartnerTpl(nOgrePartnerID);
			            if (OgrePartnerTemplate ~= nil) then
				            if (OgrePartnerTemplate.mTempID == nOgreID) then
				                nNum = nNum + 1;
			                end
			            end
			        end
			        n = n + 1;
		        end
		    end
        end
    end
	local nTrainNum = 0;
	if (nNum > 0) then
		nTrainNum = math.ceil(nOgreNum / nNum);
	end
	return nTrainNum;
end
--玩家资源全称
function LuaCommonMethod.GetRoleImageName(nImage, mSex)
	local strMetier = "";
	if(nImage == IMAGE_SECOND) --	拳宗
	then
		strMetier = "quan";
	elseif(nImage == IMAGE_FIRST) 	--	剑宗
	then
		strMetier = "jian";
	elseif(nImage == IMAGE_THIRD)	--	指宗
	then
		strMetier = "zhi";
	end
	if(strMetier == "")
	then
		return "";
	end
			
	local strSex = "";
	if(mSex == 0)	-- 男
	then
		strSex = "nan";
	elseif(mSex == 1) -- 女
	then
		strSex = "nv";
	end
	return strMetier .. strSex;
end
function LuaCommonMethod.GetRoleBattleModuleName(nImage, nSex)
    local strMetier = "";
    if (nImage == IMAGE_SECOND) then
        -- 拳宗
        strMetier = "quan";
    elseif (nImage == IMAGE_FIRST) then
        -- 剑宗
        strMetier = "jian";
    elseif (nImage == IMAGE_THIRD) then
        -- 指宗
        strMetier = "zhi";
    end

    local strSex = "";
    if (nSex == 0) then
        -- 男
        strSex = "nan";
    elseif (nSex == 1) then
        -- 女
        strSex = "nv";
    end
    local strClothesUrl = strMetier .. strSex .. "_battle";
    return strClothesUrl;
end

--玩家头像路径 
function LuaCommonMethod.GetRoleBigHeadUrl(nImage, mSex)	-- 获得角色头像资源
	local str = LuaCommonMethod.GetRoleImageName(nImage,mSex);
	if(str == "")
	then
		return "";
	end
	return "Textures/icon/head/partner/" .. str .. ".png";
end
--得到怪物的战斗力
--战斗力 = （如果是奇宗选择内功攻击否则选择外功攻击）+ 绝技攻击+外功防御+绝技防御+内功防御+（最大HP*25%）
--        +先攻值+（暴击+防暴+命中+闪避+破防+格挡+必杀）*2
function LuaCommonMethod.GetOgrePartnerFightAbility(ograId)
    local nFightAbility = 0;
    local OgreTemp = LuaDataStatic.SearchOgrePartnerTpl(ograId);
    if(OgreTemp ~= nil) then
        local nPower = 0;
        if(OgreTemp.Metier == METIER_TYPE.emTplMetier_Breath) then
            nPower = OgreTemp.NormalAttack;
        else
            nPower = OgreTemp.MagicAttack;
        end
        nFightAbility = nPower + OgreTemp.StuntAttack + OgreTemp.NormalDefense + OgreTemp.StuntDefense + OgreTemp.MagicDefense
            + OgreTemp.HPMax * 0.25 + 0 + (OgreTemp.CriticalHit + OgreTemp.Toughness + OgreTemp.Hit + OgreTemp.Duck + OgreTemp.BreakHit
            + OgreTemp.Parry + OgreTemp.DeathHit)*2;
    end
    return math.ceil(nFightAbility);
end
--点击购买体力
function LuaCommonMethod.OnBtnAddStrength()
    local Times = 0;
	local VipLevel = 0;
	local cishu = 0;
    local PlayerYuanBao = 0;
    local costYuanBao = 0;
    local PlayerStrength = 0;--玩家当前体力
    PlayerStrength = LuaCHeroProperty.m_nStrength;
    local strengthConfig = LuaDataStatic.SearchStrengthConfig();
    --购买一次是40体力购买之后玩家体力不得超过最大体力值
    if strengthConfig ~= nil then
        if (PlayerStrength + strengthConfig.PurchaseStrength) > MAX_STRENGHT then
            LuaCUIFlyTips.ShowFlyTips(CLanguageData.GetLanguageText("UI_SPCHEAD_008"));
            return;      
        end
    end
    --检测玩家购买次数 次数不够给予提示
	Times = LuaCDailyData.GetDailyTimes(DAILY_TYPE_PURCHASE_STRENGTH);
	VipLevel = LuaCHeroProperty.mVipLevel + 1;
    local vipConfig = LuaDataStatic.SearchVipConfig();
    if (vipConfig ~= nil) 
    then
        local vipRechargeConfig = LuaDataStatic.SearchVIPConfigForViplevel(VipLevel);
        if vipRechargeConfig ~= nil then
            cishu = vipRechargeConfig.PurchaseStrengthTimes - Times;
        end
	    
	    if (cishu <= 0) 
        then
		    LuaCommonMethod.getNextVipNum(VipLevel - 1,"purchaseStrengthTimes",
            CLanguageData.GetLanguageText("UI_SPCHEAD_002"),
		    CLanguageData.GetLanguageText("UI_SPCHEAD_003"),
		    CLanguageData.GetLanguageText("UI_SPCHEAD_002"),
		    CLanguageData.GetLanguageText("UI_SPCHEAD_002"),
		    CLanguageData.GetLanguageText("UI_SPCHEAD_002"));
		    return; 
	    end

    end
    --购买次数花费相应的元宝
    local strengthConfig = LuaDataStatic.SearchStrengthConfig();
    if strengthConfig ~= nil then
        if 0 <= cishu and cishu < strengthConfig.PhaseTimes[1]  then
            costYuanBao = strengthConfig.PhaseYuanBao[1];
        elseif strengthConfig.PhaseTimes[1] <= cishu and cishu < strengthConfig.PhaseTimes[2] then 
            costYuanBao = strengthConfig.PhaseYuanBao[2]; 
        elseif strengthConfig.PhaseTimes[2] <= cishu and cishu < strengthConfig.PhaseTimes[3] then 
            costYuanBao = strengthConfig.PhaseYuanBao[3];
        elseif strengthConfig.PhaseTimes[3] <= cishu and cishu < strengthConfig.PhaseTimes[4] then
            costYuanBao = strengthConfig.PhaseYuanBao[4];  
        end
        --判断玩家元宝是否足够支付
        PlayerYuanBao =  LuaCHeroProperty.mYuanBao;
        if PlayerYuanBao < costYuanBao then
            local strContent = CLanguageData.GetLanguageText("UI_SPCHEAD_007");
            LuaCUIConfirm.Show(strContent,function() LuaCommonMethod.OnBtnAddDiamond() end, function() end);
            return;    
        end           
        --当购买之后不超过最大体力值 玩家有购买次数 元宝足够 则显示购买提示界面
        local strContent = string.format(CLanguageData.GetLanguageText("UI_SPCHEAD_009"),costYuanBao,strengthConfig.PurchaseStrength);                                                            
        LuaCUIConfirm.Show(strContent,function() LuaCProModule.SendPurchaseStrength() end, function() end);
    end
end

--获得这个心法组的总内力
function LuaCommonMethod.getNeiLi(arrHeart)
	if(arrHeart == nil)
	then
		return 0;
	end
	local total = 0;
--	local num = #arrHeart;
--    print(num)
--	for i = 1, num
--	do				
--		local obj = arrHeart[i];
--		if(obj ~= nil)
--		then
--			total = total + obj.mExp;
--		end
--	end
    for k,v in pairs(arrHeart)
    do
        if(v ~= nil)
		then
			total = total + v.mExp;
		end
    end
	return math.floor((total / 10))
end

--获得这个心法组的tips
function LuaCommonMethod.getTip(arr)
	if(arr == nil)
	then
		return "";
	end
    local arrHeart = {};
--    for i = 1, #arr
--    do
--        if(arr[i] ~= nil)
--        then
--            table.insert(arrHeart, arr[i]);
--        end
--    end
    for k,v in pairs(arr)
    do
        if(v ~= nil)
        then
            table.insert(arrHeart, v);
        end
    end
    if(#arrHeart > 1)
    then
        table.sort(arrHeart, function(A, B)
                                if(A ~= nil and B ~= nil)
                                then
                                    local aItem = LuaDataStatic.SearchItemTpl(A.mItemID);
                                    local bItem = LuaDataStatic.SearchItemTpl(B.mItemID);
                                    if(aItem ~= nil and bItem ~= nil)
                                    then
                                        if(aItem.Quality > bItem.Quality)
                                        then
                                            return true;
                                        elseif(aItem.Quality == bItem.Quality)
                                        then
                                            if(A.mLevel > B.mLevel)
                                            then
                                                return true;
                                            else
                                                return false;
                                            end
                                            return false;
                                        else
                                            return false;
                                        end
                                    end
                                end
                            end
                    );
    end
	
    local proDes = "";
    for i = 1, #arrHeart
    do
        local heart = arrHeart[i];
        if(heart ~= nil)
        then
            local pItem = LuaDataStatic.SearchItemTpl(heart.mItemID);
            if(pItem ~= nil)
            then
                local magicName=LuaCommonMethod.AddBlankString(CLanguageData.GetTplText(pItem.ItemName),5);
                proDes = proDes .. "<color="..LuaCommonMethod.GetQualityColor(pItem.Quality)..">"..magicName.."</color>".. " " .. "<color='#D8F0FFFF'>" .. LuaCommonMethod.AddBlankNumString(string.format(CLanguageData.GetLanguageText("UI_ItemTip_Level"), heart.mLevel), 9) .. "</color>" ;
                local proValue = "";
                local j = 1;
                while  j <= #pItem.PropertyInfo  
                do
					local propertyinfo = pItem.PropertyInfo[j]
					if (propertyinfo ~= nil and propertyinfo.PropertyBase ~= 0) 
                    then
						if(j == 1)
                        then
                            proValue = proValue .. LuaCommonMethod.AddBlankString(LuaCommonMethod.GetPropertyTypeNameById(propertyinfo.PropertyType),6)..LuaCommonMethod.GetPropertyValueById(propertyinfo.PropertyType,propertyinfo.PropertyBase + (heart.mLevel - 1) * propertyinfo.PropertyGrow);
                        else
                            proValue = proValue .. "" .. LuaCommonMethod.AddBlankString(LuaCommonMethod.GetPropertyTypeNameById(propertyinfo.PropertyType),6).. LuaCommonMethod.GetPropertyValueById(propertyinfo.PropertyType,propertyinfo.PropertyBase + (heart.mLevel - 1) * propertyinfo.PropertyGrow);
                        end
					end
					j = j + 1
				end

                if(i ~= #arrHeart)
                then
                    proDes = proDes .. " " .. "<color='#ffff00'>" .. proValue .. "</color>" .. "\n";
                else
                    proDes = proDes .. " " .. "<color='#ffff00'>" .. proValue .. "</color>";
                end
            end
        end
    end
    return proDes;
end
--增加一定数量的空白字符
function LuaCommonMethod.AddBlankString(str, num)
    local blankNum=0;
    if #str/3<num then
        blankNum =num-#str/3;
    end;
    for i = 1, blankNum
    do
        str=str.."　";
    end
    return str;
end
function LuaCommonMethod.AddBlankNumString(str, num)
    local blankNum=0;
    if #str<num then
        blankNum =num-#str;
    end;
    for i = 1, blankNum
    do
        str=str.."   ";
    end
    return str;
end
function LuaCommonMethod.AddAssetNameToTable(arr, strName)
    if(arr == nil) then
        return;
    end
    for i, name in ipairs(arr) do
        if(name == strName) then
            return;
        end
    end
    table.insert(arr, strName);
end
