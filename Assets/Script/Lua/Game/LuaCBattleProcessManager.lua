--region *.lua
--Date
--此文件由[BabeLua]插件自动生成
MAX_POWER = 100;        -- 气势最大值

BATTLE_INIT = 0;	    -- 战斗初始化
BATTLE_STAR_ATTACK = 1; -- 战斗开始攻击
BATTLE_ATTACK_ING = 2;	-- 战斗攻击中
BATTLE_WAIT_END_ROUND = 3;	-- 战斗等待回合结束
BATTLE_END = 4;	        -- 战斗结束

BATTLE_SPRITE_TYPE_PLAYER	    = 0;	-- 玩家
BATTLE_SPRITE_TYPE_OGRE	        = 1;	-- 怪物
BATTLE_SPRITE_TYPE_BOSS	        = 2;	-- BOSS
BATTLE_SPRITE_TYPE_WORLD_BOSS	= 3;	-- 世界BOSS


LuaCBattleProcessManager = 
{
    m_BattleProcessData = nil,      -- 战斗过程数据
    m_BattleScene = nil,            -- 战斗场景
    m_battleEffectCtl = nil,        -- 战斗中特效控制类
    m_Team1Map = { },               -- 队伍1表
    m_Team2Map = { },               -- 队伍2表
    m_arrLookLeftFreePos = {};	    -- 围观左阵营的位置
    m_arrLookRightFreePos = {};	    -- 围观右阵营的位置
    m_RideMap = { },                -- 坐骑表
    m_funcBattleEnd = nil,          -- 战斗结束回调函数
    m_nBattleState = BATTLE_END,	-- 战斗状态
 };
local this = LuaCBattleProcessManager;

local m_FBMapid = 0;
local m_FBIndex = 0;
local m_BattleMapID = 0;
local m_strMapNameUrl = "";
local m_arrOgreList = { };

-- local	m_BattleMap = CBattleMap:new(),		--战斗地图层
-- local	m_BattlingTalent = CBattlingTalent:new(),		--战斗中显示的天赋

local isReplayBattle = false;	-- 是否为回放

local m_unBattleCD = 0;			    -- 战斗冷却时间，单位：毫秒
local m_unBattleTimeTick = 0;		-- 战斗计时器
local m_arrAttacker = { };		    -- 攻击者
local m_arrTarget = { };		    -- 攻击目标
local m_arrMoving = { };            -- 移动中的
local m_arrDead = { };              -- 正在死亡的
local m_arrBuffer = { };			-- 受到buff效果角色列表
local m_arrBuffObj = { };           -- 正在显示的buff特效列表
local m_arrDamageEffect = { };      -- 场景破坏特效列表
local m_BattleStartEffect = nil;	-- 战斗开场特效

--local m_bSceneSkill = false;	    -- 是否在释放场景技能
local m_nSkillType = 0;				-- 技能类型
local m_nSceneSkillAttackRange = 0;	-- 场景技能攻击范围
local m_strNextSkillEffect = "";	-- 场景技能下一个特效

local m_nBattleProcessIndex = 1;	-- 战斗进度索引


--local m_CurBattleDamgeInfo = LuaCBattleDamage:new();	--当前的伤害信息
--local m_arrAttacker:Array;					--攻击者
--local m_arrAttackeder:Array;					--登出游戏回到选服界面0
--local m_arrBuffer:Array;						--受到buff效果角色列表
--local m_bSceneSkill=false;			        --是否正在场景技能
--local m_nSkillBottomEffectState:int;			--技能底部特效状态
--local m_bWaitAttackEnd=false;				    --是否等待攻击结束再进行新攻击
--local m_CurSkillAttacker:CBattleSprite;		--当前使用技能攻击者
--local m_nSkillType=0;					        --技能类型
--local m_nSceneSkillAttackRange:int;			--场景技能攻击范围
--local m_strNextSkillEffect:String;			--场景技能下一个特效
--local m_nPreFrameTime:int;					--上一帧时间
--local m_bShowBattleProcess= true
--local m_bPause=false


-- 开始战斗
function LuaCBattleProcessManager.StartBattle()
--    GameFrameWork.mGameState = GAME_STATE_BATTLE;
    m_nBattleProcessIndex = 1;
    m_arrAttacker = { };
    m_arrTarget = { };
    m_arrBuffer = { };
    m_arrMoving = { };
    m_arrDead = { };
    m_arrBuffObj = { };
    
    if(this.m_BattleScene ~= nil) then
        local spWhiteTsm = this.m_BattleScene.transform:FindChild("white");
        if(spWhiteTsm ~= nil) then
            local spWhite = spWhiteTsm.gameObject:GetComponent("SpriteRenderer");
            if(spWhite ~= nil and spWhite.sprite.texture ~= nil) then
                local nWidth = spWhite.sprite.textureRect.width;
                local nHeight = spWhite.sprite.textureRect.height;
                spWhiteTsm.localScale = UnityEngine.Vector3.New(UnityEngine.Screen.width / nWidth + 5, UnityEngine.Screen.height / nHeight + 0.5, 1);
            end
        end
    end
    LuaCBattleProcessManager.m_nBattleState = BATTLE_STAR_ATTACK;
    LuaGame.AddPerFrameFunc("LuaCBattleProcessManager.Update", LuaCBattleProcessManager.Update);
    return;
end

--每帧更新函数
function LuaCBattleProcessManager.Update()
	this.BattleProcess();

--	for i, ride in pairs(this.m_RideMap) do
--		if (ride ~= nil) then
--			ride.UpdateAnimation();
--		end
--	end

--	this.ShowBattleRoleInfo();
	--查看战斗中的天赋名称是否播放完毕
--	this.m_BattlingTalent.StopTalentNameEffect()
end

-- 战斗流程处理
function LuaCBattleProcessManager.BattleProcess()
    if(LuaCBattleProcessManager.m_nBattleState == BATTLE_STAR_ATTACK) then
        this.StarRound();
    elseif(LuaCBattleProcessManager.m_nBattleState == BATTLE_ATTACK_ING) then
        this.AttackIng();
    end
end

-- 回合开始
function LuaCBattleProcessManager.StarRound()
    local curTimer = UnityEngine.Time.time - m_unBattleTimeTick;
    if (curTimer < m_unBattleCD) then
        -- 超过间隔
        return;
    end

    --攻击间隔时间
    m_unBattleTimeTick = UnityEngine.Time.time;
    m_unBattleCD = 1;
    
    -- 获得当前的战斗伤害信息
    local curBattleDamgeInfo = this.m_BattleProcessData.m_arrBattleProcess[m_nBattleProcessIndex];
    m_nBattleProcessIndex = m_nBattleProcessIndex + 1;
    if (curBattleDamgeInfo == nil) then
        return;
    end

    -- 刷新回合数
    this.countRound(curBattleDamgeInfo.round);

    local SrcMap = nil;
    local DestMap = nil;
    if (curBattleDamgeInfo.m_unAttackerIndex == 0) then
        -- 左边阵营
        SrcMap = this.m_Team1Map;
        DestMap = this.m_Team2Map;
    else
        SrcMap = this.m_Team2Map;
        DestMap = this.m_Team1Map;
    end
    -- 找到准备攻击的角色，播放攻击的动作
    m_arrAttacker = { };
    local Attacker = SrcMap[curBattleDamgeInfo.m_unSourceIndex];
    if (Attacker == nil) then
        return
    end
--    Attacker.m_arrTalent = { };
--    for i, nTalentID in ipairs(curBattleDamgeInfo.m_arrTalentID) do
--        table.insert(Attacker.m_arrTalent, nTalentID);
--    end
    Attacker.m_nPower = curBattleDamgeInfo.m_unPower;

    table.insert(m_arrAttacker,
    {
        role = Attacker,
        skill = curBattleDamgeInfo.m_unSkillID,
        damagetype = curBattleDamgeInfo.m_unDamageType,
        counter = curBattleDamgeInfo.m_nCounterHP,
        direction = curBattleDamgeInfo.m_unAttackerIndex,
        arrayIndex = curBattleDamgeInfo.m_unSourceIndex,
        origin = nil;
    } )

    -- 找到被攻击玩家列表
    m_arrTarget = { };
    for i, Dest in pairs(curBattleDamgeInfo.m_arrDestInfo) do
        -- 低16位为被攻击者的位置索引
        local unDestIndex = luabit.band(Dest.m_unIndex, 0x0000ffff);
        -- 高16位，0为对方阵营，1为己方阵营
        local unCamp = luabit.rshift(Dest.m_unIndex, 16);
        local Npc = nil;
        if (unCamp == 0) then
            -- 对方阵营
            Npc = DestMap[unDestIndex];
        else
            -- 已方阵营
            Npc = SrcMap[unDestIndex];
        end
        if (Npc ~= nil) then
            Npc.m_nPower = Dest.m_nCurPower;
--            Npc.m_arrTalent = { };
--            for j, nTalentID in ipairs(Dest.m_arrTalentID) do
--                table.insert(Npc.m_arrTalent, nTalentID);
--            end
            table.insert(m_arrTarget,
            {
                role = Npc,
                damagetype = Dest.m_unDamageType,
                curhp = Dest.m_nCurHP,
                ClearBuff = Dest.m_arrBuffClear,
                camp = unCamp,
                destIndex = unDestIndex,
                attackerInfo = m_arrAttacker[1],
            } );
        end
    end
    -- 受到buff影响的玩家
    m_arrBuffer = { };
    for i, buffData in pairs(curBattleDamgeInfo.m_arrBuff) do
        -- 低16位位被攻击者的位置索引
        local unDestIndex = luabit.band(buffData.destindex, 0x0000ffff);
        -- 高16位，0为对方阵营，1为己方阵营
        local unCamp = luabit.rshift(buffData.destindex, 16);
        local Npc = nil;
        local nCurHp = buffData.destCurHP;
        if (unCamp == 0) then
            -- 对方阵营
            Npc = DestMap[unDestIndex];
            if (Npc ~= nil) then
                -- 如果buff列表中存在的目标同时也存在伤害列表中，血值以伤害列表为准
                for nAttackerIndex, objAttackeder in ipairs(m_arrTarget) do
                    local npcTemp = objAttackeder.role;
                    if (npcTemp ~= nil and npcTemp == Npc) then
                        nCurHp = m_arrTarget[nAttackerIndex].curhp;
                    end
                end
            end
        else
            -- 已方阵营
            Npc = SrcMap[unDestIndex];
        end
        if (Npc ~= nil) then
            table.insert(m_arrBuffer,
                {
                    role = Npc,
                    buff = buffData.destbufferstate,
                    curhp = nCurHp
                });
        end
    end

    -- 先清除buff特效
    for i, nBuffID in ipairs(curBattleDamgeInfo.m_arrBuffClear) do
--        Attacker.ClearBuffEffect(nBuffID);
        local arrRoleBuff = m_arrBuffObj[Attacker.m_unEntityID];
        if(arrRoleBuff ~= nil) then
            local buffEffect = arrRoleBuff[nBuffID];
            UnityEngine.GameObject.Destroy(buffEffect);
            if(buffEffect ~= nil) then
                table.remove(arrRoleBuff, nBuffID);
            end
        end
    end
    -- 开始攻击之前显示触发的天赋名称
    -- 在触发天赋的角色头顶显示天赋文字特效
    -- 找到角色的阵法上的索引，触发的天赋ID，角色所在阵营
--    if (#Attacker.m_arrTalent > 0) then
        -- m_BattlingTalent.ShowBattlingTalent(m_arrAttacker[0]["direction"],m_arrAttacker[0]["arrayIndex"],Attacker);
--    end
    
    if (curBattleDamgeInfo.m_unSkillID == 0 and #m_arrTarget) then
        local target = m_arrTarget[1]["role"];
        if (target == Attacker and (m_arrTarget[1]["curhp"] - Attacker.m_nCurHP < 0)) then
            this.OnStartAttack({Attacker = Attacker, curBattleDamgeInfo = curBattleDamgeInfo});
            return;
        end
    end
    --加载暴气特效
    local baoqiTsm = Attacker.transform:FindChild("baoqi");
    if(baoqiTsm ~= nil) then
        local baoQiObject = baoqiTsm.gameObject;
        local skillSprite = baoQiObject:GetComponent("CEffectSprite");
        if(skillSprite ~= nil) then
            if (curBattleDamgeInfo.m_unSkillID > 0) then
                -- 技能攻击
                skillSprite:SetKeyFrameCallBack(this.OnBaoQiKeyFrame);
            end
            skillSprite:SetPlayEndCallBack(this.OnStartAttack, {baoQiObject = baoQiObject, Attacker = Attacker, curBattleDamgeInfo = curBattleDamgeInfo});
        end
        baoQiObject:SetActive(true);
    end
end

--暴气关键帧处理
function LuaCBattleProcessManager.OnBaoQiKeyFrame(skillSprite)
    if(this.m_battleEffectCtl ~= nil) then
        this.m_battleEffectCtl:StartBlack(nil);
    end
end
--开始攻击
function LuaCBattleProcessManager.OnStartAttack(params)
    local baoQiObject = params["baoQiObject"];
    local Attacker = params["Attacker"];
    local curBattleDamgeInfo = params["curBattleDamgeInfo"];

    baoQiObject:SetActive(false);

    if (curBattleDamgeInfo == nil or Attacker == nil) then
        return;
    end
    local bDelAttacker = false;
    -- 开始攻击
    if (curBattleDamgeInfo.m_unSkillID > 0) then
        -- 技能攻击
        if(Attacker:HasAction("skillattack")) then
            Attacker:PlaySkillAttackAnimation();
        else
            Attacker:PlayAttackAnimation();
        end
        this.ProcessSkillNameEffect(Attacker, curBattleDamgeInfo.m_unSkillID);
        LuaCBattleProcessManager.m_nBattleState = BATTLE_ATTACK_ING;
    else
        -- 普通攻击
        if (#m_arrTarget > 1) then
            -- 如果伤害目标是多个，则远程攻击
            Attacker:PlayAttackAnimation();
            -- 攻击目标为空，则是群体远程攻击
            LuaCBattleProcessManager.m_nBattleState = BATTLE_ATTACK_ING;
        elseif (#m_arrTarget == 1) then
            -- 就一个攻击目标，根据技能判断是近程还是远程攻击
            local target = m_arrTarget[1]["role"];
            if (target == Attacker) then
                -- 被攻击者是这本身(例如给自己加血)
                Attacker.m_nChangeHP = m_arrTarget[1]["curhp"] - Attacker.m_nCurHP;
                Attacker.m_nCurHP = m_arrTarget[1]["curhp"];
                if (Attacker.m_nChangeHP > 0) then
                    --不播放被攻击动画
--                  Attacker.ShowHpChangeEffect(true);
                    this.ShowFlyWord("Prefabs/effect/battle/number/TextAdd", "+" .. Attacker.m_nChangeHP .. "w", Attacker);
                    Attacker.m_nCurHP = Attacker.m_nCurHP + Attacker.m_nChangeHP;
                    this.OnUpdateHp(Attacker, Attacker.m_nChangeHP);
                    m_arrTarget = {};
                else
                    -- 播放被攻击动画
                    Attacker:PlayBeatingAnimation();
                end
                bDelAttacker = true;
                LuaCBattleProcessManager.m_nBattleState = BATTLE_ATTACK_ING;
            else
                -- 根据职业判断是远程攻击，还是近程攻击
                if (Attacker.m_nMetier == METIER_BREATH or Attacker.m_nMetier == METIER_FINGER) then
                    -- 奇宗和指宗为远程攻击，站在原地直接播放攻击动作
                    Attacker:PlayAttackAnimation();
                    LuaCBattleProcessManager.m_nBattleState = BATTLE_ATTACK_ING;
                else
                    LuaCBattleProcessManager.m_nBattleState = BATTLE_ATTACK_ING;
                    -- 需要移动到目标面前播放攻击目标
                    m_arrAttacker[1].origin = {x = Attacker.transform.position.x, y = Attacker.transform.position.y};
                    local moveToX = 0;
                    if(Attacker.transform.position.x > target.transform.position.x) then
                        moveToX = target.transform.position.x + 0.75;
                    else
                        moveToX = target.transform.position.x - 0.75;
                    end
                    local moveToY = target.transform.position.y;
                    Attacker:PlayRunAnimation();
                    Attacker:MoveToPosition(UnityEngine.Vector3.New(moveToX, moveToY, 0), LuaCBattleProcessManager.OnMoveTargetAttack);
                    table.insert(m_arrMoving, Attacker);

                    local shadowGameObjTsm = Attacker.transform:FindChild("shadowGameObj");
                    local shadow = nil;
                    if(shadowGameObjTsm ~= nil) then
                        shadow = shadowGameObjTsm.gameObject:GetComponent("CShadow");
                    else
--                        local prefabObj = UnityEngine.Resources.Load("Prefabs/effect/battle/shadow");
                        local prefabObj = CAssetManager.GetAsset("Prefabs/effect/battle/shadow.prefab");
                        if (prefabObj ~= null) then
                            local shadowObj = UnityEngine.GameObject.Instantiate(prefabObj);
                            shadowObj.name = "shadowGameObj";
                            shadowObj.transform:SetParent(Attacker.gameObject.transform, false);
                            shadow = shadowObj:GetComponent("CShadow");
                            shadow:SetTargetGameObj(Attacker.gameObject);
                        end
                    end
                    if (shadow ~= null) then
                        if (this.m_battleEffectCtl ~= null) then
                            shadow:SetMaxNum(this.m_battleEffectCtl.m_nShadowMaxNum);
                            shadow:SetOffsetX(this.m_battleEffectCtl.m_fShadowOffsetX);
                        end
                        shadow:StartEffect();
                    end
--                    Attacker.transform.position = UnityEngine.Vector3.New(moveToX, moveToY, 0);
                end
            end
        end
    end

    for nAttackerIndex, objAttackeder in ipairs(m_arrTarget) do
        objAttackeder.attackerInfo = m_arrAttacker[1];
    end
    if(bDelAttacker) then
        for i, attacker in ipairs(m_arrAttacker) do
            if(attacker.role == Attacker) then
                table.remove(m_arrAttacker, i);
                break;
            end
        end
    end
end

--绝招名称特效
function LuaCBattleProcessManager.ProcessSkillNameEffect(Attacker, nSkillID)
    local prefabObj = CAssetManager.GetAsset("Prefabs/effect/battle/skillName.prefab");
    if(prefabObj == nil) then
        return;
    end
    local skillNameObj = UnityEngine.GameObject.Instantiate(prefabObj);
    if(skillNameObj == nil) then
        return;
    end
    local sprTsm = skillNameObj.transform:FindChild("img");
    if(sprTsm == nil) then
        return;
    end
    local spr = sprTsm.gameObject:GetComponent("SpriteRenderer");
    if(spr == nil) then
        return;
    end
    local sprite = CAssetManager.GetAssetSprite("Textures/skillname/" .. nSkillID .. ".png");
    if(sprite ~= nil) then
        spr.sprite = sprite;
    end
    skillNameObj.transform:SetParent(this.m_BattleScene.transform, false);
    local canvas = Attacker.transform:FindChild("Canvas");
    if(canvas ~= nil) then
        local position = canvas.transform.position;
        position.x = position.x - 0.5;
        skillNameObj.transform.position = canvas.transform.position;
    end
end

--飘字
function LuaCBattleProcessManager.ShowFlyWord(prefabUrl, content, Attacker)
    prefabUrl = prefabUrl .. ".prefab";
    local prefabObj = CAssetManager.GetAsset(prefabUrl);
--    local prefabObj = UnityEngine.Resources.Load(prefabUrl);
    if(prefabObj ~= nil) then
        local textObj = UnityEngine.GameObject.Instantiate(prefabObj);
        if(textObj ~= nil) then
            textObj.name = "FlyWord";
            local battleFlyWord = textObj:GetComponent("CBattleFlyWord");
            if(battleFlyWord ~= nil) then
                battleFlyWord:SetSortingLayer("effectLayer");
                battleFlyWord:SetText(content);

                local canvas = Attacker.transform:FindChild("Canvas");
                if(canvas ~= nil) then
                    battleFlyWord.transform:SetParent(canvas, false);
                end
            end
        end
    end
end

-- 跑动到目标点，进行攻击
function LuaCBattleProcessManager.OnMoveTargetAttack(Attacker)
    Attacker:PlayStandAnimation();
    Attacker:PlayAttackAnimation();

    --从移动列表中删除
    for i, atk in ipairs(m_arrMoving) do
        if(atk == Attacker) then
            table.remove(m_arrMoving, i);
            break;
        end
    end
end
-- 返回到原来位置
function LuaCBattleProcessManager.OnMoveBack(Attacker)
    Attacker:PlayStandAnimation();

    --气势满
    if(Attacker.m_nPower >= MAX_POWER) then
        this.AddRolePowerEffect(Attacker);
    else
        this.ClearRolePowerEffect(Attacker);
    end

    --从移动列表中删除
    for i, atk in ipairs(m_arrMoving) do
        if(atk == Attacker) then
            table.remove(m_arrMoving, i);
            break;
        end
    end

--    local shadow = Attacker.gameObject:GetComponent("CShadow");
--    if(shadow ~= nil) then
--        shadow:Stop();
--    end
    local shadowGameObjTsm = Attacker.gameObject.transform:FindChild("shadowGameObj");
    if (shadowGameObjTsm ~= null) then
        local shadow = shadowGameObjTsm.gameObject:GetComponent("CShadow");
        if (shadow ~= null) then
            shadow:Stop();
        end
        UnityEngine.GameObject.Destroy(shadowGameObjTsm.gameObject);
    end
end

-- 计算回合数
function LuaCBattleProcessManager.countRound(nRounD)
    local orgeprice
    local bosslevel = 0
    local rounD = 0
    local nextboss
    if (nRounD == 0) then
        -- 没有变化
        return;
    end

    -- if (LuaCBattleProcessManager.m_BattleProcessData.m_nBattleType==BATTLE_TYPE_JXZ) then
    -- 		if (orgeprice~=nil) then
    -- 			bosslevel=parseInt(orgeprice.@bosslevel)
    -- 			round=parseInt(orgeprice.@round)
    -- 			if (bosslevel>0) then
    -- 				nextboss=CommonMethod.getJXZNextBossStage(LuaCJXZData.fightStage)
    -- 				if (nextboss~=nil) then
    -- 					if (round-nRounD+1>0) then
    -- 						CUIBattleBossHead.gUIBattleBossHead.setQiPao("<b>"..CommonMethod.replaceOldWithNew(LanguageData.gLanguageData.UI_WEBGAME_002,"",{round-nRounD+1,"'#ff0000'"},{parseInt(nextboss.@id)+1,"'#ff0000'"}).."</b>")
    -- 					else
    -- 						CUIBattleBossHead.gUIBattleBossHead.setQiPao("<b>"..LanguageData.gLanguageData.UI_WEBGAME_003.."</b>")
    -- 					end
    -- 				else
    -- 					CUIBattleBossHead.gUIBattleBossHead.setQiPao("")
    -- 				end
    -- 			end
    -- 		end
    -- end
end

function LuaCBattleProcessManager.AttackIng()
    -- 查看释放还有人在移动
    if(#m_arrMoving > 0) then
        return;
    end
    
    -- 查看释放还有人在播放死亡动画
    if(#m_arrDead > 0) then
        return;
    end
    -- 查看释放还有攻击者在攻击
    if(#m_arrAttacker > 0) then
        return;
    end
    -- 查看是否还有被攻击者需要处理
    if(#m_arrTarget > 0) then
        return;
    end
    -- 都没有需要处理的里，则此次攻击结束，判断是否战斗结束
    if (m_nBattleProcessIndex > #this.m_BattleProcessData.m_arrBattleProcess) then
        -- 战斗结束
        this.OnBattleEnd();
        return;
    end
    -- 还有战斗则开始新的攻击
    LuaCBattleProcessManager.m_nBattleState = BATTLE_STAR_ATTACK;
end
-- 角色攻击关键帧处理
function LuaCBattleProcessManager.OnRoleAttackKeyFrame(roleSprite)
    if (roleSprite == nil) then
        return;
    end
    for i, attacker in ipairs(m_arrAttacker) do
        if(attacker.role == roleSprite) then
            local nSkillID = attacker.skill;
            local nDamageType = attacker.damagetype;
            -- 显示伤害类型特效
            -- this.ShowDamageTypeEeffct(Attacker, nDamageType);

            --右边角色释放技能，技能特效要翻转一下
            local bFlipX = false;
            if(this.m_Team2Map[roleSprite.m_unEntityID] ~= nil and this.m_Team2Map[roleSprite.m_unEntityID] == roleSprite) then
                bFlipX = true;
            end

            -- 显示技能特效
            this.ProcessSkillEffect(nSkillID, bFlipX);

            -- 显示buff特效
            this.ProcessBuffEffect();

            --不需要往回跑
            if(attacker.origin == nil) then
                --气势满
                if(roleSprite.m_nPower >= MAX_POWER) then
                    this.AddRolePowerEffect(roleSprite);
                else
                    this.ClearRolePowerEffect(roleSprite);
                end
            end

            break;
        end
    end
end
-- 处理技能特效
function LuaCBattleProcessManager.ProcessSkillEffect(nSkillID, bFlipX)
    local strSkillModule = "6500";
    m_nSceneSkillAttackRange = TmTplAttackRange.emTplAttackRange_EnemySingle;
    m_nSkillType = TmSkillDamageType.emSkillDamageType_NormalStunt;
    local bRangeAttack = false;    --范围攻击
    if (nSkillID > 0) then
        -- 判断是否是技能攻击
        local tplSkill = LuaDataStatic.SearchSkillTpl(nSkillID);
        if (tplSkill ~= nil) then
            m_nSkillType = tplSkill.SkillDamageType;
            m_nSceneSkillAttackRange = tplSkill.AttackRange;
            strSkillModule = tplSkill.SkillAction;

            --范围攻击
            if(tplSkill.AttackRange == TmTplAttackRange.emTplAttackRange_EnemyAll
                or tplSkill.AttackRange == TmTplAttackRange.emTplAttackRange_EnemyRow
                or tplSkill.AttackRange == TmTplAttackRange.emTplAttackRange_EnemyLine
                or tplSkill.AttackRange == TmTplAttackRange.emTplAttackRange_FriendAll
                or tplSkill.AttackRange == TmTplAttackRange.emTplAttackRange_FriendRow
                or tplSkill.AttackRange == TmTplAttackRange.emTplAttackRange_FriendLine) then
                bRangeAttack = true;
            end
        end
    else
        local Attacker = m_arrAttacker[1].role;
        strSkillModule = "metier" .. Attacker.m_nMetier;
    end
    local prefabUrl = "Prefabs/effect/skill/" .. strSkillModule .. ".prefab";
    local prefabObj = CAssetManager.GetAsset(prefabUrl);
    if(prefabObj == nil) then
        print("找不到技能预设:" .. prefabUrl);
        prefabObj = CAssetManager.GetAsset("Prefabs/effect/skill/6500.prefab");
    end
    if(prefabObj == nil) then
        return;
    end
    local skillGameObject = UnityEngine.GameObject.Instantiate(prefabObj);
    skillGameObject.name = strSkillModule;

    --技能翻转
    local spr = skillGameObject:GetComponent("SpriteRenderer");
    if(spr ~= nil) then
        spr.flipX = bFlipX;
    end
    local skillSprite = skillGameObject:GetComponent("CSkillSprite");
    if(skillSprite == nil) then
        return;
    end

    -- 判断是技能在什么位置释放
	if (skillSprite.m_eSkillPos == EmSkillPos.emAlign_Scene) then
		--m_strNextSkillEffect = xmlData.next_effect;
		this.ProcessSceneSkillEffect(skillGameObject);
	else
        if(skillSprite.m_eSkillPos ~= EmSkillPos.emAlign_Scene and bRangeAttack) then
            --需要复制多个技能特效
            this.ProcessRoleSkillEffect(skillGameObject, prefabObj);
        else
            this.ProcessRoleSkillEffect(skillGameObject, nil);
        end
	end
    
    if(this.m_BattleScene ~= nil) then
        local audioSource = this.m_BattleScene:GetComponent("AudioSource");
        skillSprite:SetAudioSource(audioSource);
    end
    skillSprite:SetKeyFrameCallBack(this.OnSkillKeyFrame);
    skillSprite:SetHitKeyFrameCallBack(this.OnSkillTriggerHitEffect);
end

--技能触发击中特效
function LuaCBattleProcessManager.OnSkillTriggerHitEffect(strHitEffectName)
    if(strHitEffectName == nil or strHitEffectName == "") then
        return;
    end

    for i, obj in ipairs(m_arrTarget) do
        if (obj.role ~= nil) then
            local prefabUrl = "Prefabs/effect/skill/" .. strSkillModule .. ".prefab";
            local prefabObj = CAssetManager.GetAsset(prefabUrl);
            if(prefabObj == nil) then
                print("找不到击中特效预设:" .. prefabUrl);
                return;
            end
            local effectGameObj = UnityEngine.GameObject.Instantiate(prefabObj);
            effectGameObj.name = strHitEffectName;

            local skillSprite = effectGameObj:GetComponent("CSkillSprite");
            if(skillSprite == nil) then
                return;
            end

            --头顶
            if (skillSprite.m_eSkillPos == EmSkillPos.emAlign_RoleHead) then
                local headCanvas = obj.role.transform:FindChild("Canvas");
                effectGameObj.transform.localScale = UnityEngine.Vector3.New(effectGameObj.transform.localScale.x * 100, effectGameObj.transform.localScale.y * 100, 1);
                effectGameObj.transform:SetParent(headCanvas, false);
            --胸部
            elseif(skillSprite.m_eSkillPos == EmSkillPos.emAlign_RoleChest) then
                local chestPos = obj.role.transform:FindChild("chestPos");
                effectGameObj.transform:SetParent(chestPos, false);
            else
                effectGameObj.transform:SetParent(obj.role.transform, false);
            end
        end
    end
end

--技能关键帧处理
function LuaCBattleProcessManager.OnSkillKeyFrame(skillSprite)
    --处理挨打目标
    for i, obj in ipairs(m_arrTarget) do
        if (obj.role ~= nil) then
--            this.ShowDamageTypeEeffct(obj.role, obj.damagetype);
            obj.role.m_nChangeHP = obj.curhp - obj.role.m_nCurHP;
            obj.role.m_nCurHP = obj.curhp;
--            if (m_nSkillType == TmSkillDamageType.emSkillDamageType_RecoverHP) then
--                obj.role.ShowSkillBuffEffect(strSkill, true);
--            else
--                obj.role.ShowSkillEffect(strSkill);
--            end
            
            local emShakeType = nil;
            --震屏
            if(this.m_battleEffectCtl ~= nil) then
                local attacker = obj.attackerInfo;
                local nSkillID = attacker.skill;
                --产生暴击
                if(obj.damagetype == DAMAGE_TYPE_CRITICAL_HIT) then
                    if(nSkillID > 0) then   --绝招产生暴击，震屏幅度大
                        emShakeType = EmShakeType.EmShakeType_Big;
                    else
                        emShakeType = EmShakeType.EmShakeType_Small;
                    end
                elseif(nSkillID > 0) then
                    emShakeType = EmShakeType.EmShakeType_Middle;    --绝招没暴击，震屏幅度中
                end
                if(emShakeType ~= nil) then
                    this.m_battleEffectCtl:StartShake(emShakeType);    --开始震屏
                end
            end

            if(this.m_Team1Map[obj.role.m_unEntityID] ~= nil and this.m_Team1Map[obj.role.m_unEntityID] == obj.role) then
                bTeam1 = true;
            end

            if(obj.damagetype ~= DAMAGE_TYPE_DUCK) then
                --播放被攻击动画
                obj.role:PlayBeatingAnimation();

--                if (obj.ClearBuff ~= nil) then
--                    for j, nBuffid in pairs(obj.ClearBuff) do
--                        obj.role.ClearBuffEffect(nBuffid);
--                    end
--                end
            else
--                local bTeam1 = false;
--                for i, role in pairs(this.m_Team1Map) do
--                    if (role ~= nil) then
--			            if(role == obj.role) then
--                            bTeam1 = true;
--                            break;
--                        end
--		            end
--                end
                this.ShowFlyWord("Prefabs/effect/battle/number/TextHurt", "s", obj.role);

                local moveToX = 0;
                if(bTeam1) then
                    moveToX = obj.role.transform.position.x - 0.7;
                else
                    moveToX = obj.role.transform.position.x + 0.7;
                end
                local origin = obj.role.transform.position;
                local moveToY = obj.role.transform.position.y;

                local shadowGameObjTsm = obj.role.gameObject.transform:FindChild("shadowGameObj");
                local shadow = nil;
                if(shadowGameObjTsm ~= nil) then
                    shadow = shadowGameObjTsm.gameObject:GetComponent("CShadow");
                else
                    local prefabObj = CAssetManager.GetAsset("Prefabs/effect/battle/shadow.prefab");
                    if (prefabObj ~= null) then
                        local shadowObj = UnityEngine.GameObject.Instantiate(prefabObj);
                        shadowObj.name = "shadowGameObj";
                        shadowObj.transform:SetParent(obj.role.transform, false);
                        shadow = shadowObj:GetComponent("CShadow");
                        shadow:SetTargetGameObj(obj.role.gameObject);
                    end
                end
                if (shadow ~= null) then
                    if (this.m_battleEffectCtl ~= null) then
                        shadow:SetMaxNum(this.m_battleEffectCtl.m_nShadowMaxNum);
                        shadow:SetOffsetX(this.m_battleEffectCtl.m_fShadowOffsetX);
                    end
                    shadow:StartEffect();
                end

                table.insert(m_arrMoving, obj.role);
                obj.role:MoveToPosition(UnityEngine.Vector3.New(moveToX, moveToY, 0),
                 function(Attacker)
                    obj.role:MoveToPosition(origin, this.OnDuckMoveBack);

                    for i, attacked in ipairs(m_arrTarget) do
                    if(attacked.role == obj.role) then
                        table.remove(m_arrTarget, i);
                        break;
                    end
                end
                 end);
            end

            --场景破坏特效
            this.OnShowSceneDamageEffect(skillSprite.m_strDamageEffectName, obj.role.transform.position, obj.role.m_unEntityID, bTeam1);

            --战斗结束，放慢动作，和屏幕闪白效果
            if(m_nBattleProcessIndex > #this.m_BattleProcessData.m_arrBattleProcess) then
                if(this.m_battleEffectCtl ~= nil) then
                    this.OnBattleEndSlowAction();
                end
            end
        end
    end
end

function LuaCBattleProcessManager.OnBattleEndSlowAction()
    LuaCBattleProcessManager.m_nBattleState = BATTLE_WAIT_END_ROUND;

    if(LuaCUIBattleTopInfo.GetVisible()) then
        LuaCUIBattleTopInfo.SetBottomBtnShow(false);
    end

    this.m_battleEffectCtl:StartWhite(
        function()
            this.m_battleEffectCtl:PlaySlowAction(this.OnPlaySlowActionEnd);
            this.m_battleEffectCtl:WhiteToNormal(nil);
        end);
end

--慢动作结束回调函数
function LuaCBattleProcessManager.OnPlaySlowActionEnd()
    LuaCBattleProcessManager.m_nBattleState = BATTLE_ATTACK_ING;
end

--显示场景破坏特效
function LuaCBattleProcessManager.OnShowSceneDamageEffect(strDamageEffectName, position, nEntityID, bLeft)
    if(strDamageEffectName == "" or strDamageEffectName == nil) then
        return;
    end
    local arrTargetEffect = m_arrDamageEffect[nEntityID];
    if(arrTargetEffect == nil) then
        arrTargetEffect = {};
        m_arrDamageEffect[nEntityID] = arrTargetEffect;
    end
    --已经添加过这个类型特效，不再继续添加
    if(arrTargetEffect[strDamageEffectName] ~= nil) then
        return;
    end

    local prefabUrl = "Prefabs/effect/battle/sceneEffect/" .. strDamageEffectName .. ".prefab";
    local prefabObj = CAssetManager.GetAsset(prefabUrl);
--    local prefabObj = UnityEngine.Resources.Load(prefabUrl);
    if(prefabObj == nil) then
        print("没有加载到场景破坏特效:" .. prefabUrl);
        return;
    end
    -- 创建场景破坏特效
    local effectObj = UnityEngine.GameObject.Instantiate(prefabObj);
    if (effectObj == nil) then
        return;
    end

    arrTargetEffect[strDamageEffectName] = effectObj;
    effectObj.transform.position = position;
    effectObj.transform:SetParent(this.m_BattleScene.transform, false);
end

-- 闪避返回到原来位置
function LuaCBattleProcessManager.OnDuckMoveBack(Attacker)
    --从移动列表中删除
    for i, atk in ipairs(m_arrMoving) do
        if(atk == Attacker) then
            table.remove(m_arrMoving, i);
            break;
        end
    end

    local shadowGameObjTsm = Attacker.gameObject.transform:FindChild("shadowGameObj");
    if (shadowGameObjTsm ~= null) then
        local shadow = shadowGameObjTsm.gameObject:GetComponent("CShadow");
        if (shadow ~= null) then
            shadow:Stop();
        end
        UnityEngine.GameObject.Destroy(shadowGameObjTsm.gameObject);
    end
end

-- 角色播放技能特效
function LuaCBattleProcessManager.ProcessRoleSkillEffect(skillGameObject, prefabObj)
    local skillSprite = skillGameObject:GetComponent("CSkillSprite");
    if(skillSprite == nil) then
        return;
    end
    for i, obj in ipairs(m_arrTarget) do
        if (obj.role ~= nil) then
            if(skillGameObject == nil and prefabObj ~= nil) then
                skillGameObject = UnityEngine.GameObject.Instantiate(prefabObj);
                skillSprite = skillGameObject:GetComponent("CSkillSprite");
            end
            --头顶
            if (skillSprite.m_eSkillPos == EmSkillPos.emAlign_RoleHead) then
                local headCanvas = obj.role.transform:FindChild("Canvas");
                skillGameObject.transform.localScale = UnityEngine.Vector3.New(skillGameObject.transform.localScale.x * 100, skillGameObject.transform.localScale.y * 100, 1);
                skillGameObject.transform:SetParent(headCanvas, false);
            --胸部
            elseif(skillSprite.m_eSkillPos == EmSkillPos.emAlign_RoleChest) then
                local chestPos = obj.role.transform:FindChild("chestPos");
                skillGameObject.transform:SetParent(chestPos, false);
            else
                skillGameObject.transform:SetParent(obj.role.transform, false);
            end

            if(prefabObj ~= nil) then
                skillGameObject = nil;
            end
        end
    end
end
function LuaCBattleProcessManager.ProcessSceneSkillEffect(skillGameObject)
	--计算特效位置
	--查看是否有攻击目标
	local Npc = nil
	if (#m_arrTarget > 0) then
		Npc = m_arrTarget[1].role;
	elseif (#m_arrBuffer > 0) then
		--没有攻击目标，判断是否有buff目标
		Npc = m_arrBuffer[1].role;
	end
	--目标为空，则退出
	if (Npc == nil) then
		return
	end

    local posGameObject = nil;
	if (m_nSceneSkillAttackRange == TmTplAttackRange.emTplAttackRange_EnemyAll) then
		posGameObject = this.GetRoleArrayCenter(Npc);
	elseif (m_nSceneSkillAttackRange == TmTplAttackRange.emTplAttackRange_EnemyLine) then
        posGameObject = this.GetRoleArrayLineCenter(Npc);
	elseif (m_nSceneSkillAttackRange == TmTplAttackRange.emTplAttackRange_EnemyRow) then
        posGameObject = this.GetRoleArrayRowCenter(Npc);
	end

    ---posGameObject = UnityEngine.GameObject.Find("mapsprite/rightTeamPos/battle_pos" .. strPosIndex);
    if (posGameObject ~= nil) then
        skillGameObject.transform.position = UnityEngine.Vector3.New(posGameObject.transform.position.x, posGameObject.transform.position.y, 0);
    end
end

--得到玩家所在组的中心位置
function LuaCBattleProcessManager.GetRoleArrayCenter(attacker)
    local bTeam1 = false;
    if(this.m_Team1Map[attacker.m_unEntityID] ~= nil and this.m_Team1Map[attacker.m_unEntityID] == attacker) then
        bTeam1 = true;
    end

    local posGameObject = nil;
    if(bTeam1) then
        posGameObject = UnityEngine.GameObject.Find("mapsprite/leftTeamPos/battle_pos5");
    else
        posGameObject = UnityEngine.GameObject.Find("mapsprite/rightTeamPos/battle_pos5");
    end
    return posGameObject;
end
--得到玩家所在列的中心位置
function LuaCBattleProcessManager.GetRoleArrayLineCenter(attacker)
    local bTeam1 = false;
    if(this.m_Team1Map[attacker.m_unEntityID] ~= nil and this.m_Team1Map[attacker.m_unEntityID] == attacker) then
        bTeam1 = true;
    end

    local index = 5;
    if(attacker.m_unEntityID == 0 or attacker.m_unEntityID == 3 or attacker.m_unEntityID == 6) then
        index = 4;
    elseif(attacker.m_unEntityID == 1 or attacker.m_unEntityID == 4 or attacker.m_unEntityID == 7) then
        index = 5;
    else
        index = 6;
    end

    local posGameObject = nil;
    if(bTeam1) then
        posGameObject = UnityEngine.GameObject.Find("mapsprite/leftTeamPos/battle_pos" .. index);
    else
        posGameObject = UnityEngine.GameObject.Find("mapsprite/rightTeamPos/battle_pos" .. index);
    end
    return posGameObject;
end
--得到玩家所在行的中心位置
function LuaCBattleProcessManager.GetRoleArrayRowCenter(attacker)
    local bTeam1 = false;
    if(this.m_Team1Map[attacker.m_unEntityID] ~= nil and this.m_Team1Map[attacker.m_unEntityID] == attacker) then
        bTeam1 = true;
    end

    local index = math.floor(attacker.m_unEntityID / 3) * 3 + 2;

    local posGameObject = nil;
    if(bTeam1) then
        posGameObject = UnityEngine.GameObject.Find("mapsprite/leftTeamPos/battle_pos" .. index);
    else
        posGameObject = UnityEngine.GameObject.Find("mapsprite/rightTeamPos/battle_pos" .. index);
    end
    return posGameObject;
end

function LuaCBattleProcessManager.OnSceneEffectKeyFrame()
    for i, obj in ipairs(m_arrTarget) do
		local Npc = obj.role;
		if (Npc ~= nil) then
			local ndamagetype = obj.damagetype;
--		    this.ShowDamageTypeEeffct(Npc,ndamagetype);
		    local nCurHP = obj.curhp;
		    Npc.m_nChangeHP = nCurHP - Npc.m_nCurHP;
		    Npc.m_nCurHP = nCurHP;
		    if (m_nSkillType == TmSkillDamageType.emSkillDamageType_RecoverHP) then
			    Npc.ShowSkillBuffEffect(m_strNextSkillEffect,true);
		    else
			    Npc.ShowAttackedEffect(m_strNextSkillEffect);
		    end
		    
--		    if (obj.ClearBuff ~= nil) then
--			    for j, nBuffid in ipairs(obj.ClearBuff) do
--				    Npc.ClearBuffEffect(nBuffid);
--			    end
--		    end
		end
	end
end
-- 场景特效播放结束
function LuaCBattleProcessManager.OnSceneEffectEnd()
--    m_bSceneSkill = false;
end


--处理buff特效
function LuaCBattleProcessManager.ProcessBuffEffect()
    -- buff特效
    for i, bufferData in ipairs(m_arrBuffer) do
        local Npc = bufferData.role;
        local nBuffID = bufferData.buff;
        local tplBuff = LuaDataStatic.SearchBuffTpl(bufferData.buff);
        if (tplBuff ~= nil and tplBuff.BuffEffect ~= "") then
            
            local prefabUrl = "Prefabs/effect/skill/" .. tplBuff.BuffEffect .. ".prefab";
            local prefabObj = CAssetManager.GetAsset(prefabUrl);
            if(prefabObj == nil) then
                print("找不到buff动画预设:" .. prefabUrl);
                return;
            end
            -- 创建buff特效
            local buffEffect = UnityEngine.GameObject.Instantiate(prefabObj);
            if (buffEffect == nil) then
                return;
            end

            local skillSprite = buffEffect:GetComponent("CSkillSprite");
            if(skillSprite == nil) then
                return;
            end
            if (skillSprite.m_eSkillPos == EmSkillPos.emAlign_RoleHead) then
                local headCanvas = Npc.transform:FindChild("Canvas");
                buffEffect.transform:SetParent(headCanvas, false);
            --胸部
            elseif(skillSprite.m_eSkillPos == EmSkillPos.emAlign_RoleChest) then
                local chestPos = Npc.transform:FindChild("chestPos");
                buffEffect.transform:SetParent(chestPos, false);
            else
                buffEffect.transform:SetParent(Npc.transform, false);
            end

--            local strSkillimage = "config/effect/skill/" .. BuffTemp.m_sBuffEffect .. ".xml";
--            bufferData.role.ShowBuffEffect(bufferData.buff, strSkillimage);
            
            -- 处理buff加血、吸血特效
--            Npc.m_nChangeHP = bufferData.curhp - bufferData.role.m_nCurHP;
--            Npc.m_nCurHP = bufferData.curhp;
--            if (m_nSkillType == TmSkillDamageType.emSkillDamageType_NormalStunt) then
--                bufferData.role.ShowSkillBuffEffect("");
--            end
            if(m_arrBuffObj[Npc.m_unEntityID] == nil) then
                m_arrBuffObj[Npc.m_unEntityID] = {buffEffect};
            else
                table.insert(m_arrBuffObj[Npc.m_unEntityID], buffEffect);
            end
        end
    end
end
-- 结束攻击
function LuaCBattleProcessManager.OnRoleAttackEnd(BattleRole)
    -- 找到攻击者
    for i, attacker in ipairs(m_arrAttacker) do
        if(attacker.role == BattleRole) then
            if(attacker.skill > 0) then
                if(this.m_battleEffectCtl ~= nil) then
                    this.m_battleEffectCtl:BlackToNormal(nil);
                end
            end
            -- 如果被格挡，需要留在原地等待对方反击
            if(attacker.counter > 0) then
            else
                -- 如果是移动去攻击，则需要退回原来的位置
                if(attacker.origin ~= nil) then
                    attacker.role:PlayRunAnimation();

--                    --战斗结束后就不跑回去了
--                    if(m_nBattleProcessIndex <= #this.m_BattleProcessData.m_arrBattleProcess) then
--                        attacker.role:MoveToPosition(UnityEngine.Vector3.New(attacker.origin.x, attacker.origin.y, 0), LuaCBattleProcessManager.OnMoveBack);
--                        table.insert(m_arrMoving, attacker.role);
--                    end
                    attacker.role:MoveToPosition(UnityEngine.Vector3.New(attacker.origin.x, attacker.origin.y, 0), LuaCBattleProcessManager.OnMoveBack);
                    table.insert(m_arrMoving, attacker.role);
--                    attacker.role.gameObject.transform.position = UnityEngine.Vector3.New(attacker.origin.x, attacker.origin.y, 0);
                end
            end
            -- 攻击完成从攻击列表中删除此角色
            table.remove(m_arrAttacker, i);
            break;
        end
    end
end

-- 受到攻击关键帧
function LuaCBattleProcessManager.OnRoleBeatKeyFrame(BattleRole)
    if (BattleRole == nil) then
        return;
    end
    --显示伤害飘字
    local nUpdateHP = BattleRole.m_nChangeHP;
    if (BattleRole.m_nCurHP > 10 ^ 9) then
        BattleRole.m_nCurHP = 0;
    end
    BattleRole:UpdateHp();

    local attacker = m_arrAttacker[1];
    local nAttackDmgType = 0;
    if(attacker ~= nil) then
        nAttackDmgType = attacker.damagetype;
    end

    local strFlyText = "";
    local flyWordUrl = "Prefabs/effect/battle/number/TextHurt";
    for i, obj in ipairs(m_arrTarget) do
        if (obj.role == BattleRole) then
            local nDamageType = obj.damagetype;
            if(nAttackDmgType == DAMAGE_TYPE_CRITICAL_HIT) then
                --暴击
                flyWordUrl = "Prefabs/effect/battle/number/TextBj";
                strFlyText = nUpdateHP .. "w";
            elseif(nDamageType == DAMAGE_TYPE_PARRY) then
                --格挡
                flyWordUrl = "Prefabs/effect/battle/number/TextCounter";
                strFlyText = nUpdateHP .. "w";
            elseif(nDamageType == DAMAGE_TYPE_COUNTER_ATTACK) then
                --反击
                flyWordUrl = "Prefabs/effect/battle/number/TextHurt";
                strFlyText = "f" .. nUpdateHP;
            elseif(nDamageType == DAMAGE_TYPE_DUCK) then
                --闪避
                flyWordUrl = "Prefabs/effect/battle/number/TextHurt";
                strFlyText = "s";
            else
                strFlyText = nUpdateHP;
            end
            this.ShowFlyWord(flyWordUrl, strFlyText, BattleRole);
        end
    end

    --气势满
    if(BattleRole.m_nPower >= MAX_POWER) then
        this.AddRolePowerEffect(BattleRole);
    else
        this.ClearRolePowerEffect(BattleRole);
    end

    this.OnUpdateHp(BattleRole, nUpdateHP);
    -- 开始攻击之前显示触发的天赋名称
    -- 在触发天赋的角色头顶显示天赋文字特效
    -- 找到角色的阵法上的索引，触发的天赋ID，角色所在阵营,
    -- nAddvalue在buff状态下也会调用被攻击的方法，因此添加血值判断是否是被攻击掉血触发的天赋
--    if (String(BattleRole.m_arrTalent).length > 0) then
        -- 	m_BattlingTalent.ShowBattlingTalent(nDirection,nArrayIndex,BattleRole)
--    end
end
function LuaCBattleProcessManager.OnUpdateHp(BattleRole, nUpdateHP)
--    local nArrayIndex = 0;
    local bTeam1 = false;
    if(this.m_Team1Map[BattleRole.m_unEntityID] ~= nil and this.m_Team1Map[BattleRole.m_unEntityID] == BattleRole) then
        bTeam1 = true;
    end
    if (bTeam1) then
        -- 左边阵营
        LuaCUIBattleTopInfo.CostHeroHP(nUpdateHP);
        if (BattleRole.m_nCurHP <= 0) then
            LuaCUIBattleTopInfo.SetDeadState(BattleRole.m_unEntityID, true);
        end
--        for i, beatNpc in pairs(this.m_Team1Map) do
--            if (beatNpc == BattleRole) then
--                nArrayIndex = i;
--                break;
--            end
--        end
    else
        if (LuaCUIBattleTopInfo.GetRightRoleInfoVisible()) then
            LuaCUIBattleTopInfo.CostEnermyRoleHP(nUpdateHP);--BattleRole.m_nMaxHP
            if (BattleRole.m_nCurHP <= 0) then
                LuaCUIBattleTopInfo.SetDeadState(BattleRole.m_unEntityID, false);
            end
        elseif (LuaCUIBattleTopInfo.GetBossInfoVisible()) then
            LuaCUIBattleTopInfo.CostBossHp(nUpdateHP);--BattleRole.m_nMaxHP
        end
--        for i, beatNpc in pairs(this.m_Team1Map) do
--            if (beatNpc == BattleRole) then
--                nArrayIndex = i;
--                break;
--            end
--        end
    end
end

-- 受到攻击结束
function LuaCBattleProcessManager.OnRoleBeatEnd(BattleRole)
    if (BattleRole == nil) then
        return;
    end

    local attackerInfo = m_arrTarget[1].attackerInfo;
    -- 是否已经死亡
    if (BattleRole.m_nCurHP > 0) then
        -- 有反击
        local nCounterHP = attackerInfo.counter;
        if (nCounterHP > 0) then
            -- 攻击者成为反击目标
            local Npc = attackerInfo.role;
            if (Npc == nil) then
                return;
            end
            local nCurHP = Npc.m_nCurHP - nCounterHP;
            local originPos = this.GetTargetPos(Npc);

            -- 被攻击者成为攻击者
            BattleRole:PlayAttackAnimation();
            m_arrAttacker = { };
            table.insert(m_arrAttacker,
            {
                role = BattleRole,
                skill = 0,
                damagetype = 0,
                counter = 0,
                origin = nil,
            } );

            m_arrTarget = { };
            table.insert(m_arrTarget,
            {
                role = Npc,
                damagetype = DAMAGE_TYPE_COUNTER_ATTACK,
                curhp = nCurHP,
                origin = {x = originPos.x, y = originPos.y},
                attackerInfo = m_arrAttacker[1],
            });

            -- 没有BUFF效果
            m_arrBuffer = { };

            LuaCBattleProcessManager.m_nBattleState = BATTLE_ATTACK_ING;
            return;
        end

        if(m_arrTarget[1].origin ~= nil) then
            table.insert(m_arrMoving, BattleRole);
            BattleRole:PlayRunAnimation();
            BattleRole:MoveToPosition(UnityEngine.Vector3.New(m_arrTarget[1].origin.x, m_arrTarget[1].origin.y, 0), LuaCBattleProcessManager.OnMoveBack);
        end
    else
        table.insert(m_arrDead, BattleRole);
        BattleRole:PlayDeadAnimation();
        this.ClearRolePowerEffect(BattleRole);
    end

    for i, attacked in ipairs(m_arrTarget) do
        if(attacked.role == BattleRole) then
            table.remove(m_arrTarget, i);
            break;
        end
    end
end
--获得被攻击玩家的位置
function LuaCBattleProcessManager.GetTargetPos(targetRole)
    local bTeam1 = false;
    if(this.m_Team1Map[targetRole.m_unEntityID] ~= nil and this.m_Team1Map[targetRole.m_unEntityID] == targetRole) then
        bTeam1 = true;
    end

    local posGameObject = nil;
    if(bTeam1) then
        posGameObject = UnityEngine.GameObject.Find("mapsprite/leftTeamPos/battle_pos" .. (targetRole.m_unEntityID + 1));
    else
        posGameObject = UnityEngine.GameObject.Find("mapsprite/rightTeamPos/battle_pos" .. (targetRole.m_unEntityID + 1));
    end
    return UnityEngine.Vector3.New(posGameObject.transform.position.x, posGameObject.transform.position.y, 0);
end

-- 死亡结束
function LuaCBattleProcessManager.OnRoleDeadEnd(BattleRole)
    for i, deader in ipairs(m_arrDead) do
        if(deader == BattleRole) then
            table.remove(m_arrDead, i);
            break;
        end
    end
    if (BattleRole == nil) then
        return;
    end
    BattleRole.gameObject:SetActive(false);
end

--增加气势满特效
function LuaCBattleProcessManager.AddRolePowerEffect(role)
    local powerAniTsm = role.transform:FindChild("powerAnimation");
    if(powerAniTsm ~= nil) then
        local powerAni = powerAniTsm.gameObject;
        if(powerAni ~= nil) then
            local sprShadow = powerAni.gameObject:GetComponent("SpriteRenderer");
            local spr = role.gameObject:GetComponent("SpriteRenderer");
            if(spr ~= nil and sprShadow ~= nil) then
                sprShadow.sortingOrder = spr.sortingOrder + 4;
            end
            powerAni:SetActive(true);
        end
    end
end

--清除角色身上气势满特效
function LuaCBattleProcessManager.ClearRolePowerEffect(role)
    local powerAniTsm = role.transform:FindChild("powerAnimation");
    if(powerAniTsm~= nil) then
        powerAniTsm.gameObject:SetActive(false);
    end
end

--是否战胜
function LuaCBattleProcessManager.IsBattleWin()
	local isIWin = false;
	if (this.m_BattleProcessData.m_nBattlePlayerID1 == LuaCHeroProperty.mCharID and this.m_BattleProcessData.m_nBattleWinIndex==0) then
		isIWin = true;
	elseif (this.m_BattleProcessData.m_nBattlePlayerID2 == LuaCHeroProperty.mCharID and this.m_BattleProcessData.m_nBattleWinIndex==1) then
		isIWin = true;
	end
	return isIWin;
end

--战斗结束
function LuaCBattleProcessManager.OnBattleEnd()
    LuaCBattleProcessManager.m_nBattleState = BATTLE_END;
    this.SetBattleSpeed(1);
    this.ClearRole();
    this.ClearBuffEffect();
    this.ClearPowerFullEffect();
    this.ClearSceneEffect();

    if(this.m_funcBattleEnd ~= nil) then
        this.m_funcBattleEnd();
    end
end

--跳过战斗
function LuaCBattleProcessManager.JumpBattle()
    LuaCBattleProcessManager.m_nBattleState = BATTLE_END;
    this.SetBattleSpeed(1);
    this.ClearRole();
    this.ClearBuffEffect();
    this.ClearPowerFullEffect();
    this.ClearSceneEffect();

    local nBattleType = this.m_BattleProcessData.m_nBattleType;
    local bWin = true;

    if(nBattleType ~= BATTLE_TYPE_CAMPBATTLE) then
        LuaCBattleManager.JumpBattle();
    end
end

function LuaCBattleProcessManager.ClearRole()
    this.ClearRoleArray(LuaCBattleProcessManager.m_Team1Map);
    this.ClearRoleArray(LuaCBattleProcessManager.m_Team2Map);
    LuaCBattleProcessManager.m_Team1Map = {};
    LuaCBattleProcessManager.m_Team2Map = {};

    for i, ride in pairs(this.m_RideMap) do
        if (ride ~= nil) then
			UnityEngine.GameObject.Destroy(ride.gameObject);
		end
    end
	this.m_RideMap = {};
end

function LuaCBattleProcessManager.ClearRoleArray(roleArray)
    for i, role in pairs(roleArray) do
        if (role ~= nil) then
            if(role.gameObject ~= nil) then
                local shadowGameObjTsm = role.gameObject.transform:FindChild("shadowGameObj");
                if (shadowGameObjTsm ~= nil) then
                    local shadow = shadowGameObjTsm.gameObject:GetComponent("CShadow");
                    if (shadow ~= null) then
                        shadow:Stop();
                    end
                    UnityEngine.GameObject.Destroy(shadowGameObjTsm.gameObject);
                end
            end
			UnityEngine.GameObject.Destroy(role.gameObject);
		end
    end
    roleArray = { };
end

--清除气势满特效
function LuaCBattleProcessManager.ClearPowerFullEffect()
    for i, roleSprite in pairs(LuaCBattleProcessManager.m_Team1Map) do
		--气势满特效
        this.ClearRolePowerEffect(roleSprite);
	end
    for j, roleSprite in pairs(LuaCBattleProcessManager.m_Team2Map) do
		--气势满特效
        this.ClearRolePowerEffect(roleSprite);
	end
end

--清除buff特效
function LuaCBattleProcessManager.ClearBuffEffect()
    for i, arrRoleBuff in pairs(m_arrBuffObj) do
        for j, buffEffect in pairs(arrRoleBuff) do
            if (buffEffect ~= nil) then
			    UnityEngine.GameObject.Destroy(buffEffect);
		    end
        end
    end
end
--清除场景破坏特效
function LuaCBattleProcessManager.ClearSceneEffect()
    for i, arrTargetEffect in pairs(m_arrDamageEffect) do
        for j, effectObj in pairs(arrTargetEffect) do
            if (effectObj ~= nil) then
			    UnityEngine.GameObject.Destroy(effectObj);
		    end
        end
    end
    m_arrDamageEffect = {};
end

function LuaCBattleProcessManager.CloseBattle()
    LuaGame.AddPerFrameFunc("LuaCBattleProcessManager.Update", LuaCBattleProcessManager.Update);

	LuaCBattleProcessManager.m_nBattleState = BATTLE_END;
	this.ClearRole();
    this.ClearBuffEffect();
    this.ClearPowerFullEffect();
    this.ClearSceneEffect();
	m_BattleMapID = 0;
	m_arrOgreList = {};
	m_arrAttacker = {};
	m_arrTarget = {};
	m_arrBuffer = {};

    LuaCProModule.DelFirstBattleProcess();
	if (#LuaCProModule.m_arrBattle > 0) then
		--战斗列表里还有战斗则继续播放
		this.StartBattle();
		return;
	end

    if(LuaCBattleProcessManager.m_BattleProcessData.m_nBattleType ~= BATTLE_TYPE_FACTIONWAR) then
        if(this.m_BattleScene ~= nil) then
            this.m_BattleScene:SetActive(false);
        end
    end
end
function LuaCBattleProcessManager.SetTalentInfo()
    local flag
    local battleDamgeInfo = CPreBattleTalent.gPreBattleTalent.CheckPartnerTalent(LuaCBattleProcessManager.m_Team1Map, LuaCBattleProcessManager.m_Team2Map)
    -- 判断是否触发天赋特效
    if (flag) then
        -- 显示战前战斗天赋特效，第一个参数为先出手的队伍
        battleDamgeInfo = LuaCBattleProcessManager.m_BattleProcessData.m_arrBattleProcess[LuaCBattleProcessManager.m_nBattleProcessIndex]
        if (battleDamgeInfo.m_unAttackerIndex == 0) then
            -- 左边阵营
            CPreBattleTalent.gPreBattleTalent.ShowBeforeBattleEffect(LuaCBattleProcessManager.m_Team1Map, LuaCBattleProcessManager.m_Team2Map);
        else
            CPreBattleTalent.gPreBattleTalent.ShowBeforeBattleEffect(LuaCBattleProcessManager.m_Team2Map, LuaCBattleProcessManager.m_Team1Map);
        end
    else
        this.SetStartBattleState();
    end
end
--设置为战斗开始后，等待攻击状态
function LuaCBattleProcessManager.SetStartBattleState()
	LuaCBattleProcessManager.m_nBattleState = BATTLE_ATTACK_WAIT;
	m_unBattleTimeTick = getTimer();	--记录当前时间
	m_unBattleCD = 0;
end

--切换战斗速度
function LuaCBattleProcessManager.SwitchSpeed()
    if(LuaCBattleProcessManager.m_nBattleState ~= BATTLE_WAIT_END_ROUND) then
        if(UnityEngine.Time.timeScale ~= 1) then
            UnityEngine.Time.timeScale = 1;
        else
            UnityEngine.Time.timeScale = 2;
        end
    end
end

function LuaCBattleProcessManager.SetBattleSpeed(nValue)
    UnityEngine.Time.timeScale = nValue;
end

--是否在战斗中
function LuaCBattleProcessManager.IsBattle()
    return LuaCBattleProcessManager.m_nBattleState ~= BATTLE_END;
end
--endregion
