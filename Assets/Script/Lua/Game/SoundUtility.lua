local this = LuaSoundUtility
LuaSoundUtility = { 
	FB_DEFAULT_MUSIC="sound/music/music_fuben.mp3"
}
local TYPE_CITY=0;	--切换账号按钮059
local TYPE_FIELD=1;--切换背景音乐的时候音乐过渡效果所持续的时间60
local TRANSFORM_FRAME=15;	--分包的总共字节数1
local lastBgSound
local bgSound
local frameCounter=0
local m_soundMap={}();--存音效的
local mIsSoundOn=true;	--音效是否开启
local mIsMusicOn=true;	--背景音乐是否开启
local mMusicMap:HashMap;	--地图ID对应背景音乐的Url
local mSkillSoundMap:HashMap;	--技能音效
local mCountFrame=0
--副本播放的默认音乐的url路径
static function LuaSoundUtility.init()
	local xmlData
	local obj
	local sndName
	local idStr
	local mapIdArr
	local mapId=0
	local skillId=0
	mMusicMap={}()
	mSkillSoundMap={}()
	xmlData=CFileManager.loadXMLData("config/sound.xml")
	for _obj in pairs(xmlData.sound) do
		local obj=xmlData.sound[_obj]
		idStr=(obj.@mapId).toString()
		mapIdArr=String(idStr).split(";")
		for _mapId in pairs(mapIdArr) do
			local mapId=mapIdArr[_mapId]
			sndName=obj.@soundName
			mMusicMap.put(mapId,sndName)
		end
	end
	for _obj in pairs(xmlData.skill) do
		local obj=xmlData.skill[_obj]
		skillId=parseInt(obj.@skillId)
		sndName=(obj.@soundName).toString()
		mSkillSoundMap.put(skillId,sndName)
	end
end
static function LuaSoundUtility.play(s,times,bSkill,skillId,entityId)
	if times == nil then times=1 end
	if bSkill == nil then bSkill=false end
	if skillId == nil then skillId=-1 end
	if entityId == nil then entityId=-1 end
	local disposeSnd
	local key
	local _sound
	if (not mIsSoundOn or s=="" or s==nil) then
		return 
	end
	if (m_soundMap.size()>=27) then
			--创建的音频数量最多是30个左右，超过一定数量则播放不了
	end
		disposeSnd=m_soundMap.getValueAtIndex(0)
		if (disposeSnd~=nil) then
			disposeSnd.stop()
			disposeSnd.dispose()
			disposeSnd=nil
		end
	end
	key=s
	if (bSkill) then
		key=entityId.toString()+skillId.toString()
	end
	_sound=m_soundMap.getValue(key)
	if (_sound==nil) then
		_sound=GameSound.new(s)
		m_soundMap.put(key,_sound)
	end
	if (_sound.soundOver==false) then
		return 
	else
		_sound.play(times)
	end
end
	--停止背景音乐播放
static function LuaSoundUtility.stopBgMusic()
	if (bgSound) then
		bgSound.stop()
		bgSound.dispose()
		bgSound=nil
	end
end
	--下载分包的索引0
static function LuaSoundUtility.changeBgMusic(music)
	if music == nil then music=nil end
	GameMain.instance.stopBgMusic()
	if (lastBgSound==music) then
		return 
	end
	lastBgSound=music
	if (not mIsMusicOn) then
		return 
	end
	if (lastBgSound~="" and lastBgSound~=nil) then
		if (bgSound~=nil and frameCounter==0) then
			FrameEventUtility.add(onFrame)
		else
			this.stopBgMusic()
			bgSound=GameSound.new(lastBgSound);--Global.getUrl(lastBgSound)
			bgSound.play(1000)
		end
	end
end
static function LuaSoundUtility.playMusicByMapId(mapId)
	local sndUrl
	local sndArr
	local idx=0
	sndUrl=mMusicMap.getValue(mapId)
	if (sndUrl==nil) then
			--没有配置背景音乐则随机播放音乐
	end
		sndArr=mMusicMap.values()
		if (String(sndArr).length>0) then
			idx=Math.random()*(String(sndArr).length-1)
			sndUrl=sndArr[idx]
		end
	end
	SoundUtility.changeBgMusic("sound/music/"..sndUrl)
end
static function LuaSoundUtility.playFbMusicByMapId(mapId)
	local sndUrl=mMusicMap.getValue(mapId)
	if (sndUrl==nil) then
			--没有配置背景音乐则播放默认的副本背景音乐
	end
		SoundUtility.changeBgMusic(FB_DEFAULT_MUSIC)
	else
		SoundUtility.changeBgMusic("sound/music/"..sndUrl)
	end
end
static function LuaSoundUtility.playSkillSndEffect(skillId,entityId)
	local sndUrl=mSkillSoundMap.getValue(skillId)
	if (sndUrl~=nil) then
			--没有配置背景音乐则随机播放音乐
	end
		this.play("sound/soundEffect/"..sndUrl,1,true,skillId,entityId)
	end
end
static function LuaSoundUtility.stopSkillSound(skillId,entityid)
	local key
	local sound=entityid.toString()+skillId.toString()
	sound=m_soundMap.getValue(key)
	if (sound~=nil) then
		sound.stop()
		sound.soundOver=true
	end
end
	static function LuaSoundUtility.onFrame()
	if (not mIsMusicOn) then
		frameCounter=0
		FrameEventUtility.remove(onFrame)
		return 
	end
	frameCounter=frameCounter+1
	if (frameCounter<TRANSFORM_FRAME) then
		bgSound.volume=1000*(1-frameCounter/TRANSFORM_FRAME)
	elseif (frameCounter==TRANSFORM_FRAME) then
		this.stopBgMusic()
		bgSound=GameSound.new(lastBgSound)
		bgSound.play(1000)
		bgSound.volume=0
	elseif (frameCounter<=TRANSFORM_FRAME*2) then
		bgSound.volume=1000*(frameCounter/TRANSFORM_FRAME-1)
	else
		frameCounter=0
		bgSound.volume=1000
		FrameEventUtility.remove(onFrame)
	end
end
	--关闭背景音乐
static function LuaSoundUtility.stopMusic()
	mIsMusicOn=false
	mCountFrame=0
	FrameEventUtility.add(onFrameStopMusic)
end
	static function LuaSoundUtility.onFrameStopMusic()
	mCountFrame=mCountFrame+1
	if (mCountFrame<TRANSFORM_FRAME) then
		if (bgSound~=nil) then
			bgSound.volume=1000*(1-mCountFrame/TRANSFORM_FRAME)
		end
	elseif (mCountFrame==TRANSFORM_FRAME) then
		this.stopBgMusic()
		FrameEventUtility.remove(onFrameStopMusic)
	end
end
	--开启背景音乐
static function LuaSoundUtility.openMusic()
	if (not mIsMusicOn) then
		mIsMusicOn=true
		mCountFrame=TRANSFORM_FRAME+1
		if (lastBgSound~="" and lastBgSound~=nil) then
			FrameEventUtility.add(onFrameOpenMusic)
		end
	end
end
	static function LuaSoundUtility.onFrameOpenMusic()
	mCountFrame=mCountFrame-1
	if (mCountFrame==TRANSFORM_FRAME) then
		this.stopBgMusic()
		bgSound=GameSound.new(lastBgSound)
		bgSound.play(1000)
		bgSound.volume=0
	elseif (mCountFrame<TRANSFORM_FRAME and mCountFrame>=0) then
		if (bgSound~=nil) then
			bgSound.volume=1000*(1-mCountFrame/TRANSFORM_FRAME)
		end
	else
		FrameEventUtility.remove(onFrameOpenMusic)
	end
end
	--关闭音效
static function LuaSoundUtility.stopSound()
	mIsSoundOn=false
end
	--开启音效
static function LuaSoundUtility.openSound()
	mIsSoundOn=true
end
	--音效是否开启
static function LuaSoundUtility.get__isSoundOn()
	return  mIsSoundOn
end
	--已下载的分包字节数0
static function LuaSoundUtility.get__isMusicOn()
	return  mIsMusicOn
end
static function LuaSoundUtility.clearCache()
	local sound
	local i=0
	i=0
	while  i<m_soundMap.size()  do
		sound=m_soundMap.getValueAtIndex(i)
		m_soundMap.remove(sound.soundPath)
		sound.stop()
		sound.dispose()
		sound=nil
				i=i+1
	end
end
static function LuaSoundUtility.dispose()
	lastBgSound=nil
	if (bgSound~=nil) then
		bgSound.stop()
		bgSound.dispose()
		bgSound=nil
	end
	if (mMusicMap~=nil) then
		mMusicMap.clear()
	end
	if (mSkillSoundMap~=nil) then
		mSkillSoundMap.clear()
	end
	this.clearCache()
end
