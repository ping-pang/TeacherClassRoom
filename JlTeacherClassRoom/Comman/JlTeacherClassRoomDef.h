//
//  JlTeacherClassRoomDef.h
//  JlTeacherClassRoom
//
//  Created by app on 15/11/30.
//  Copyright © 2015年 app. All rights reserved.
//

#ifndef JlTeacherClassRoomDef_h
#define JlTeacherClassRoomDef_h


#endif /* JlTeacherClassRoomDef_h */
#define Screen_Width                 [UIScreen mainScreen].bounds.size.width
#define Screen_Height                [UIScreen mainScreen].bounds.size.height

//128环境
#define HTTP_UTL          @"http://128.0.3.253:48080/"
#define JL_HTTP_URL       @"http://128.0.3.253:58080/ssk-platform-mobile/"
#define JL_HTTP_URL_OUT   @"http://128.0.3.253:58080/ssk-platform-mobile/mobile/exec?m=logout"
#define JL_HTTP_URL111       @"http://128.0.3.253:48080/ssk-fzkt/mobile/exec?m="

#define BaseUrl [NSString stringWithFormat:@"userId=%@&S=%@&businessSysId=%@",[[UserModel sharedUser] uid],[[UserModel sharedUser] my_cookie],@"2"]

//更新版本接口


#define JL_UPDATE_VERSION  [JL_HTTP_URL111 stringByAppendingString:@"getVersionUp&sysId=11&osVer=02&mobileType=01&userId=%@&S=%@&ver=%@"]


//提示语
#define ALERT_TITLE      @"提示"
#define ALERT_CONFIRM    @"确定"
#define ALERT_CANCLE     @"取消"
#define ALERT_MESSAGE    @"手机号码有误"

//正式环境
//#define HTTP_UTL          @"http://www.wassk.cn/"
//#define JL_HTTP_URL       @"http://www.wassk.cn/ssk-platform-mobile/"
//#define JL_HTTP_URL_OUT   @"http://www.wassk.cn/ssk-platform-mobile/mobile/exec?m=logout"
//#define JL_HTTP_URL111       @"http://www.wassk.cn/ssk-fzkt/mobile/exec?m="

#define USER_DEFAULT [NSUserDefaults standardUserDefaults]
#define UserId @"uid"
#define UserPwd @"userPassword"


#import "MBProgressController.h"
#import "RequestManage.h"
#import "AppPreFerence.h"
#import "UserModel.h"
#import "JLBaseViewController.h"


//颜色
#define RGB(r, g, b, a) [UIColor colorWithRed:(float)r/255.0f green:(float)g/255.0f blue:(float)b/255.0f alpha:a]

#define HEXCOLOR(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

#define wCurrentScreen4 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 960), [[UIScreen mainScreen] currentMode].size) : NO)
#define wCurrentScreen5 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)
#define wCurrentScreen6 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(750, 1334), [[UIScreen mainScreen] currentMode].size) : NO)
#define wCurrentScreen6p ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1242, 2208), [[UIScreen mainScreen] currentMode].size) : NO)
#define navHeight 64.0
//block self
#define WeakSelf        __weak typeof(self) wself = self;
#define Size(Width, Height)                CGSizeMake(Width, Height)
#define IOS7_OR_LATER NLSystemVersionGreaterOrEqualThan(7.0)
//检测是否iPhone5
#define iPhone5    ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640.0, 1136.0), [[UIScreen mainScreen] currentMode].size) : NO)
#define iPhone4    ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640.0, 960.0), [[UIScreen mainScreen] currentMode].size) : NO)


#define BookJsonName @"bookInfo.plist"
#define CodeJsonName @"ReadMe.plist"
// 商品的详细信息
#define JL_CODE_RES       [JL_HTTP_URL stringByAppendingString:@"getGoodsRes&goodsId=%@&mobileNum=%@&mobileType=%@&userId=%@&S=%@&mac=%@&ip=%@&resH=%@&resW=%@&resVType=%@&osVer=02"]
