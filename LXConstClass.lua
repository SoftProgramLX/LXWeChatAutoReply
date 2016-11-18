

require("TSLib")

timerSleepConst = 1000;
kOcrTextTime = 500;
kOpenRedPacketTime = 3000;
kClickBackBtnTime = 1000;
kClickWillPushTime = 1500;
kSendMessageTime = 500;
kWaitingTimeOfS = 5;
kUnlockDeviceTime = 1000;
kDeviceAwakenTime = 2000;

screenWidth, screenHeight = getScreenSize(); --默认720*1280
kStatusMaxHeight = 50;
kNavBarMaxHeight = 146;
kHomeCellHeight = 128;
kTabBarHeght = 108;
kHomeTabTextHeight = 44;--文字顶到屏幕低的高度
kTabBtnWidth = (screenWidth/4.0);
	
kChatRoomToolHeight = 96;
kChatBubbleStep = 20;
kChatBubbleX1 = 120;

weChatPakeName = "com.tencent.mm";
--注意这里的key与userid自己去图灵机器人官网注册后获取，再替换
kTuLingURL = "http://www.tuling123.com/openapi/api?key=***&userid=***&info=%s";
kThanksYourRedPacket = "谢谢老板，嘻嘻";




