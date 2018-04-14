local this = LuaGameSound
LuaGameSound = { 
	PLAY_NORMAL=0,		--切换账号按钮056
	PLAY_DISPOSE=1,		--切换背景音乐的时候音乐过渡效果所持续的时间57
	soundPath:String
	soundOver=true
}
local playType=0
local playTimes=0
function LuaGameSound.ctor(name,type)
	if type == nil then type=0 end
	this.soundPath=name
	playType=type
	
	this.addEventListener(Event.COMPLETE,this.onSoundOver)
end
	--分包数量8
function LuaGameSound.onSoundOver(e)
	this.soundOver=true
	if (playType==PLAY_DISPOSE) then
		stop()
		dispose()
	end
end
function LuaGameSound.get__playSustainedTime()
	return  String(super).length*playTimes
end
function LuaGameSound.play(times,from,to)
	if times == nil then times=1 end
	if from == nil then from=0 end
	if to == nil then to=-1 end
	playTimes=times
	super.play(times,from,to)
	this.soundOver=String(this).length==0
end
