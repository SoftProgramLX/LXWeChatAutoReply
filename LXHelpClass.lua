
local sz = require"sz"
local http = require"szocket.http"
local json = sz.json
require("LXConstClass")


function clickBackBtn()
	tap(42, kStatusMaxHeight + (kNavBarMaxHeight-kStatusMaxHeight)/2.0);
	mSleep(kClickBackBtnTime);
end

--首页tab的四个标签对应的点击的点
function homeTabBtnsRegion(index)
	return kTabBtnWidth*(index-0.5), (screenHeight - kHomeTabTextHeight);
end

--启动相应App
function runAppWithName(pakeName)
	if (deviceIsLock() ~= 0) then
		unlockDevice();
		mSleep(kUnlockDeviceTime);
		moveTo(200, screenHeight*0.75, 200, screenHeight*0.25, 30)
		mSleep(kDeviceAwakenTime);
	end
	
	--isFrontApp方法不可靠，所以在else里必须再启动(从pakeName名的app按了home键后此方法还认为这个app是在前台)
	if (appIsRunning(pakeName) == 0) then
		isRun = runApp(pakeName);
		mSleep(10*1000);
		if isRun ~= 0 then
			cdLogError(pakeName.."App启动失败");
			return false;
		end
		
	else 
		runApp(pakeName);
		mSleep(kDeviceAwakenTime);
	end
	
	return true;
end


