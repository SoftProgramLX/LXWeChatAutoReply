
require("LXWithFriendChat")


--监听消息列表
function listenMessageList ()
	while (true) do
		readWithoutMessage();
		mSleep(timerSleepConst);
	end

end

local recordScrollerMessageList = false;

--在消息列表查找未读消息
function readWithoutMessage()
	
	local needScroller = true;
	for y = kNavBarMaxHeight+26, screenHeight-kTabBarHeght, kHomeCellHeight  do
		if (isColor( 133,  y, 0xff4848, 85)) then
			tap(133,  y);
			mSleep(kClickWillPushTime);
			withFriendChat();
		else 
			needScroller = false;
		end
	end
	
	if needScroller then--needScroller
		moveTo(200, screenHeight*0.85, 200, screenHeight*0.2, 30);
		recordScrollerMessageList = true;
	elseif recordScrollerMessageList then
		tap(homeTabBtnsRegion(1));--如果次界面没有了未读消息，判断如果滚动过消息列表，则须滚动到顶端。
		recordScrollerMessageList = false;
	end
end



