LuaCUILoadingPanel = {};

local this = LuaCUILoadingPanel;
local m_gameObject = nil;
local m_arrTips = {};
local m_txtPoint = nil;
local m_nMinShowTime = 1;	--界面最少需要显示的时间(秒)
local m_nPointNum = 0;		--显示点的数量
local m_nCurShowTime = 0;	--显示的时长
local m_bLoadComplete = false;	--加载是否完成

function LuaCUILoadingPanel.Awake(gameObject)
	if(gameObject == nil) then 
		return ;
	end
	m_gameObject = gameObject ;

	local txtPoint = m_gameObject.transform:FindChild("txtPoint");
	if(txtPoint ~= nil) then
		m_txtPoint = txtPoint.gameObject:GetComponent("Text");
	end
end
function LuaCUILoadingPanel.Start()
	if(m_gameObject == nil) then 
		return ;
	end

	local txt = m_gameObject.transform:FindChild("txt");
	if(txt ~= nil) then
		local txtComponent = txt.gameObject:GetComponent("Text");
		if(txtComponent ~= nil) then
			txtComponent.text = CLanguageData.GetLanguageText("UI_Loading_Loading");
		end
	end

	-- 加载xml配置信息
	local xmlData = LoadXmlData("config/loadingInfo");
	if(xmlData ~= nil) then
		for i, xml in ipairs(xmlData.ChildNodes) do
			if(xml.Name == "tips")then
				for ii, subTipXml in ipairs(xml.ChildNodes) do
					table.insert(m_arrTips, subTipXml.Attributes["info"]);
				end
			end
		end
	end
	this.UpdatePanel();
end
function LuaCUILoadingPanel.ShowUI()
	if(m_gameObject == nil) then 
		local prefabObj = CAssetManager.GetAsset("Prefabs/UI/UILoading.prefab");
        m_gameObject = UnityEngine.GameObject.Instantiate(prefabObj);
		if(m_gameObject == nil) then 
			log("创建预设失败: Prefabs/UI/UILoading.prefab") 
			return; 
		end
		local uiCanvas = UnityEngine.GameObject.Find("topCanvas"); 
		if(uiCanvas ~= nil) then 
			m_gameObject.transform:SetParent(uiCanvas.transform, false); 
		end
	else
		this.UpdatePanel();
	end
	m_gameObject:SetActive(true);
    m_gameObject.transform:SetAsLastSibling();
    LuaGame.AddPerFrameFunc("LuaCUILoadingPanel", LuaCUILoadingPanel.OnFrame);
end

function LuaCUILoadingPanel.OnFrame()
	m_nCurShowTime = m_nCurShowTime + UnityEngine.Time.deltaTime;
	if(m_nCurShowTime >= m_nMinShowTime and m_bLoadComplete) then
		this.HideUI();
		return;
	end
	if((m_nPointNum + 0.03) >= 3) then
		m_nPointNum = 0;
	end
	m_nPointNum = m_nPointNum + 0.03;
	local num = math.ceil(m_nPointNum);
	local str = "";
	local i = num;
	while(i > 0) do
		str = str .. ".";
		i = i - 1;
	end
	if(m_txtPoint ~= nil) then
		m_txtPoint.text = str;
	end
end
-- 界面显示状态
function LuaCUILoadingPanel.GetVisible()
	if(m_gameObject == nil) then
		return false;
	else
		return m_gameObject.activeSelf;
	end
end
--加载完成
function LuaCUILoadingPanel.OnLoadComplete()
	if(m_gameObject == nil) then
		return;
	end
	if(m_gameObject.activeSelf) then
		m_bLoadComplete = true;
	end
end
function LuaCUILoadingPanel.HideUI()
	if(m_gameObject == nil) then 
		return;
	end
	m_gameObject:SetActive(false)
	LuaGame.RemovePerFrameFunc("LuaCUILoadingPanel");
	m_nPointNum = 0;
end
function LuaCUILoadingPanel.UpdatePanel()
    -- 随机选择一条提示信息
	nRandom = math.random(#m_arrTips);
    if(nRandom > 0 and nRandom <= #m_arrTips) then
        local txtTip =  m_gameObject.transform:FindChild("txtTips");
        if(txtTip ~= nil) then
            local txtComponent =  txtTip.gameObject:GetComponent("Text");
            if(txtComponent ~= nil) then
                txtComponent.text = m_arrTips[nRandom];
            end
        end
    end
end

function LuaCUILoadingPanel.ShowLoginLoadRes()
--	super.ShowUI(false)
--	this.updateExpprogressBar(0,1);--添加音效开启按钮00

--	m_curProgressIndex=0
--	m_arrTaskList={}
--	m_curTaskIndex=0
--	m_strMapPath=""
--	m_bLoadSpc=false
--	m_bLoadNpc=false
--	m_arrTaskList.push({type:"template",res:"",path:""});		--加载模版
--	m_arrTaskList.push({type:"initGame",res:"",path:""});			--初始化游戏
--	m_arrTaskList.push({type:"ui_com",res:"",path:""});				--加载通用的界面资源
--	m_arrTaskList.push({type:"create_ui",res:"",path:""});			--创建界面
--	m_arrTaskList.push({type:"loginGame",res:"",path:""});		--登录游戏
--	m_arrTaskList.push({type:"map_image",res:"",path:""});			--加载地图资源
--	this.startNewTask()
end
function LuaCUILoadingPanel.loadMapRes(nMapID)
--	local flagLoadMap
--	local obj
--	if (m_strMapPath~="config/scene/"..nMapID..".xml") then
--		m_strMapPath="config/scene/"..nMapID..".xml"
--		--判断加载地图资源事件是否走完
--		flagLoadMap=true
--		for _obj in pairs(m_arrTaskList) do
--			local obj=m_arrTaskList[_obj]
--			if (obj~=nil) then
--				if (obj.type=="map_image") then
--					flagLoadMap=false
--					break
--				end
--			end
--		end
--		if (flagLoadMap==true) then
--			m_arrTaskList.push({type:"map_image",res:"",path:""});	--没有加载特效swf源文件，则需要加载0
--		end
--	end
end
--function LuaCUILoadingPanel.loadSpcRes()
--	m_bLoadSpc=true
--	this.startNewTask()
--end
--	--场景切换，显示loading条
--function LuaCUILoadingPanel.ShowReconnectSceneLoading(nMapID)
--	super.ShowUI(false)
--	this.updateExpprogressBar(0,1);--初始化进度条
--	--显示提示信息
--	--			updateProText(CommonMethod.getLanguageTxt("%55%49%5F%4C%6F%61%64%69%6E%67%5F%73%63%65%6E%65"));
--	m_arrTaskList={}
--	m_curTaskIndex=0
--	m_curProgressIndex=0
--	m_bLoadNpc=false
--	m_arrTaskList.push({type:"map_image",res:"",path:""})
--	m_arrTaskList.push({type:"npc",res:"",path:""});					--加载怪物，npc资源
--	m_strMapPath="config/scene/"..nMapID..".xml"
--	this.startNewTask()
--end
--	--显示进入战斗场景加载界面
--function LuaCUILoadingPanel.ShowBattleSceneLoading()
--	super.ShowUI(false)
--	this.updateExpprogressBar(0,1);--初始化进度条
--	m_arrTaskList={}
--	m_curTaskIndex=0
--	m_curProgressIndex=0
--	m_bLoadNpc=false
--	m_arrTaskList.push({type:"fb_ui",res:"",path:""});		--加载战斗界面资源
--	m_arrTaskList.push({type:"fb_map",res:"",path:""});	--加载战斗地图
--	m_arrTaskList.push({type:"fb_role",res:"",path:""});	--				if(!CSWFImageManager.gSWFImageManager.IsLoaded(swfUrl))0
--	m_arrTaskList.push({type:"fb_starteffect",res:"",path:""});	--加载开始战斗特效资源
--	m_arrTaskList.push({type:"fb_skillname",res:"",path:""});	--加载技能名称特效资源
--	this.startNewTask()
--end
--function LuaCUILoadingPanel.onFrame()
--end

--function LuaCUILoadingPanel.startNewTask()
--	local obj
--	if (m_curProgressIndex<25) then
--		--先做个假的加载进度
--	end
--		mCProgress.addTask(0,"")
--	else
--		obj=m_arrTaskList[m_curTaskIndex]
--		if (obj~=nil) then
--			if (obj.type=="template") then
--					mCProgress.addTask(1,"template")
--			elseif (obj.type=="initGame") then
--					mCProgress.addTask(2,"initgame")
--			elseif (obj.type=="ui_com") then
--					mCProgress.addTask(3,"com")
--			elseif (obj.type=="create_ui") then
--					mCProgress.addTask(4,"create_ui")
--			elseif (obj.type=="loginGame") then
--					mCProgress.addTask(5,"loginGame")
--			elseif (obj.type=="map_image") then
--					if (not m_bLoadSpc) then
--						return 
--					end
--	--				{0
--	--							{
--	--								return;
--	--							}
--					mCProgress.addTask(6,m_strMapPath)
--			elseif (obj.type=="fb_ui") then
--					mCProgress.addTask(7,"fb_ui")
--			elseif (obj.type=="fb_map") then
--					mCProgress.addTask(8,"fb_map")
--			elseif (obj.type=="fb_role") then
--					mCProgress.addTask(9,"fb_role")
--			elseif (obj.type=="fb_starteffect") then
--					mCProgress.addTask(10,"fb_starteffect")
--			elseif (obj.type=="fb_skillname") then
--					mCProgress.addTask(11,"fb_skillname")
--			end
--			m_arrTaskList[m_curTaskIndex]=nil
--		end
--	end
--	this.updateExpprogressBar(m_curProgressIndex,String(m_arrTaskList).length+25)
--	mCProgress.go()
--end
--	--执行完一个任务后刷新进度条
--function LuaCUILoadingPanel.ondotask(e)
--	local obj
--	local nType=0
--	local strPath
--	local strTip=e.taskObj
--	--执行任务
--	nType=obj.type
--	strPath=obj.path
--	strTip=obj.tip
--	if (nType==1) then
--			CDataStatic.gDataStatic.Initialize()
--	elseif (nType==2) then
--			GameFrameWork.instance.InitGameLogic()
--	elseif (nType==3) then
--			CTextureManager.gTextureManager.splitImage("images/ui/com.xml","images/ui/com")
--	elseif (nType==4) then
--			CUIManager.gUIManager.Init()
--	elseif (nType==5) then
--			CoreModule.gCoreModule.LoginGame()
--	elseif (nType==6) then
--			--	load map
--			CGameMap.gGameMap.LoadMap(LuaCMapModule.mCurMapID)
--			CGameMap.gGameMap..visible=true
--	elseif (nType==7) then
--			--load fb_ui
--			CBattleManager.gBattleManager.InitBattleUI()
--	elseif (nType==8) then
--			--load fb_map
--			CBattleManager.gBattleManager.LoadBattleMap()
--	elseif (nType==9) then
--			--load fb_role
--			CBattleManager.gBattleManager.CreatRole()
--	elseif (nType==10) then
--			--					LoadResource.gLoadResource.addLoadList("%73%77%66%65%66%66%65%63%74",swfUrl,null);0
--			CBattleManager.gBattleManager.LoadBattleStartEffect()
--	elseif (nType==11) then
--			--load fb_skillname
--			CBattleManager.gBattleManager.LoadSkillNameEffect()
--	else
--			break
--	end
--end
--	--完成一次加载任务
--function LuaCUILoadingPanel.onCompletetask(e)
--	if (m_curProgressIndex>=25) then
--		m_curTaskIndex=m_curTaskIndex+1
--	end
--	m_curProgressIndex=m_curProgressIndex+1
--	this.updateExpprogressBar(m_curProgressIndex,String(m_arrTaskList).length+25)
--	if (m_curTaskIndex>=String(m_arrTaskList).length) then
--		--所有加载任务完成，发送加载完成的消息
--		dispatchEvent(Event.new(EVENT_LOAD_COMPLETE))
--		return 
--	end
--	this.startNewTask()
--end
--function LuaCUILoadingPanel.isLoadNpc()
--	return  m_bLoadNpc
--end
