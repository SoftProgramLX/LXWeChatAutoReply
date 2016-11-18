
require("LXHelpClass")


--与好友持续交流
function withFriendChat()
	local waitingTime = 0;
	while (waitingTime < kWaitingTimeOfS) do--在聊天界面有新消息时可等待好友十秒，无消息则返回消息列表
		local flag = managerFrindNewMessages();
		if flag then
			waitingTime = 0;
		end
		
		waitingTime = waitingTime + 1;
		mSleep(1000);
	end
	clickBackBtn();
end

--获取对方发的消息的底点坐标y2
function getChatBubbleY2()
	local y = screenHeight-kChatRoomToolHeight;
	while (y > kNavBarMaxHeight) do
		if isColor( kChatBubbleX1,  y, 0xffffff, 95) then
			if judgeIsLatestNews(y) then
				return y;
			else
				return 0;
			end
		end
		
		y = y - kChatBubbleStep;
	end
	
	return 0;
end

--判断对方的这条消息下面是否有我的消息，无：则是新消息
function judgeIsLatestNews(y2)
	local y = y2
	while (y < screenHeight-kChatRoomToolHeight) do
		y = y + 78;--cell的最小高度
		if (isColor( screenWidth - kChatBubbleX1,  y, 0xebebeb, 95) == false) then
			return false;
		end
	end
	
	return true;
end

--获取对方发的消息的顶点坐标y1
function getChatBubbleY1(y2)
	local y = y2;
	while (y > kNavBarMaxHeight) do
		if (isColor( kChatBubbleX1,  y, 0xffffff, 95) == false) then
			return y + kChatBubbleStep;
		end
		y = y - kChatBubbleStep;
	end
	
	return kNavBarMaxHeight;
end

--获取对方发的消息的底点坐标x2
function getChatBubbleX2(y1)
	local x = kChatBubbleX1;
	while (x < screenWidth) do
		if (isColor( x,  y1, 0xffffff, 95) == false) then
			return x - kChatBubbleStep;
		end
		x = x + kChatBubbleStep;
	end
	
	return screenWidth;
end

--识别好友发的消息内容
function recognizeFriendMessage()
	
	local y2 = getChatBubbleY2();
	if y2 == 0 then -- 说明没有收到新消息
		return nil;
	end
	
	local y1 = getChatBubbleY1(y2);
	if (y2 - y1 < 40) then --说明这是搜索到了“微信红包”
		return nil;
	end
	
	local x2 = getChatBubbleX2(y1);

	recognize = ocrText(kChatBubbleX1, y1, x2, y2, 1);  --OCR 英文识别   311,  339   --603,  638
	mSleep(kOcrTextTime); 
	return recognize;
end

--发送meaasge
function sendMessage(message)
	tap(250, screenHeight-50);  -- 点击输入框
	switchTSInputMethod(true);  -- 切换到触动/帮你玩输入法
	inputText(message)		-- 输入
	--switchTSInputMethod(false); -- 切换到之前的输入法
	tap(screenWidth-60, screenHeight-50);--点击发送按钮
	mSleep(kSendMessageTime);
end

--判断有无最新红包消息
function judgeIsRedPacket()
	
	local y = screenHeight-kChatRoomToolHeight;
	while (y > kNavBarMaxHeight) do
		if (isColor( kChatBubbleX1, y, 0xfa9d3b, 95)) then
			if judgeIsLatestNews(y) then
				openRedPacket(y);
				sendMessage(kThanksYourRedPacket);
				mSleep(kSendMessageTime); --在睡眠的目的是刷新tabview的时间
				return true;
			else
				return false;
			end
		end
		
		y = y - 126;
	end
	
	return false;
end

--打开红包
function openRedPacket(y)
	tap(kChatBubbleX1, y);--点击红包
	mSleep(kOpenRedPacketTime);
	tap((screenWidth/2.0), (screenHeight/2.0) + 150);--点击“开”
	mSleep(kOpenRedPacketTime);
	clickBackBtn();
end

--在聊天界面，处理与好友的交流
function managerFrindNewMessages()
	
	if judgeIsRedPacket() then
		return true;
	end
	
	local receivedMessage = recognizeFriendMessage();
	if (receivedMessage == "" or receivedMessage == nil) then
		return false;
	end
	
	--数据请求
	local urlPath = string.format(kTuLingURL, receivedMessage);
	local ret = httpGet(urlPath);
	
	--这里就不解析html数据
	local startPosition,endPosition = ret:find("<html>");
	if startPosition == 1 then 
		return false;
	end
	
	local tem = json.decode(ret)
	local code = tostring(tem.code)
	if (code == "100000" or code == "40002") then 
		message = tostring(tem.text);
		sendMessage(message);
		
		toast("收到："..receivedMessage.."\n发送："..message,2);
	end
	
	return true;
end




