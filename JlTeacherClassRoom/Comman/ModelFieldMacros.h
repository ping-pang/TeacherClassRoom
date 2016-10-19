//
//  ModelFieldMacros.h
//  JinLun
//
//  Created by 蓋剣秋 on 13-8-8.
//  Copyright (c) 2013年 Hanen. All rights reserved.
//

#ifndef JinLun_ModelFieldMacros_h
#define JinLun_ModelFieldMacros_h

typedef NS_ENUM(NSInteger, BOOK_STATUS){
    BOOK_DOWNLOADING,
    BOOK_NEW,
    BOOK_READING,
    BOOK_FINISHED
};

//User model's fields...
#define UserId @"uid"
#define UserPwd @"userPassword"
#define UserAge @"userAge"
#define UserSex @"userSex"

//AppPreference model's fields...
#define AppAccessed @"appHasBeenAccessed"
#define HasRegistered @"HasRegistered"
#define MainViewAccessed @"mainViewHasBeenAccessed"
#define UserViewAccessed @"userViewHasBeenAccessed"
#define BookStoreViewAccessed @"bookStoreViewHasBeenAccessed"
#define LocalBookManagerAccessed @"localBookManagerViewHasBeenAccessed"
#define PreferenceViewAccessed @"preferenceViewHasBeenAccessed"
#define PwdRemembered @"userPwdIsRememberedByUserDefault"
#define LoginAutomatically @"loginAutomatically"
#define UserLoggedIn @"aUserIsLoggedInThisApp"
#define AVAcessed @"AdultVideoWatched"
#define NotOnlyWifi @"NotOnlyWifi"
#define FastBuy     @"FastBuy"

//downloading operations that not finished...
//#define DOWNLOADING_OPS_ARY @"downloadingOperationsArray"

#define BOOKINDEX       @"bookIndex"        // 本地书籍
#define BOOKDOWNLIST    @"bookdownlist"     // 正在下载的书籍列表
#define CODEINDEX       @"codeIndex"        // 本地码
#define CODEDOWNLIST    @"codedownlist"     // 正在下载的码的列表

#define HISTORYOPS @"historyOperations"


/*===================================Added by x_wangyang2:2014-11-4=======================================*/

//View相关
#define Point(Xpos, Ypos)                  CGPointMake(Xpos, Ypos)
#define Size(Width, Height)                CGSizeMake(Width, Height)
#define Frame(Xpos, Ypos, Width, Height)   CGRectMake(Xpos, Ypos, Width, Height)
#define Xpos                               origin.x
#define Ypos                               origin.y
#define Width                              size.width
#define Height                             size.height

//Window相关
#define Screen_Width                 [UIScreen mainScreen].bounds.size.width
#define Screen_Height                [UIScreen mainScreen].bounds.size.height

//弧度与角度的转换
#define DegreeToRadian(X)            ((X) * M_PI / 180.0)
#define RadianToDegree(Radian)       ((Radian) * 180.0 / M_PI)

//设置View圆角
#define setViewCorner(view,radius)   {view.layer.cornerRadius = radius; view.layer.masksToBounds = YES;}

//设置颜色
#define ColorRGBA(R,G,B,A)           [UIColor colorWithRed:R / 255.0 green:G / 255.0  blue:B / 255.0  alpha:A]
#define ColorRGB(R,G,B)              [UIColor colorWithRed:R / 255.0 green:G / 255.0  blue:B / 255.0  alpha:1.0]

//透明色
#define ClearColor                   [UIColor clearColor]

//从nib中加载cell
#define LoadFromNib(nibName)  [[[NSBundle mainBundle] loadNibNamed:nibName owner:self options:nil] lastObject]

//从类中加载cell
#define LoadFromClass(cellId) [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId]


//变量属性
#define Strong          @property(nonatomic, strong)
#define Weak            @property(nonatomic, weak)
#define Retain          @property(nonatomic, retain)
#define Copy            @property(nonatomic, copy)
#define Assign          @property(nonatomic, assign)

#define StrongWithIB    @property(nonatomic, strong) IBOutlet
#define WeakWithIB      @property(nonatomic, weak) IBOutlet
#define RetainWithIB    @property(nonatomic, retain) IBOutlet

//block self
#define WeakSelf        __weak typeof(self) wself = self;


//通知
#define AddNoticeObserver(NoticeKey)             [NSNotificationCenter defaultCenter] addObserverForName:NoticeKey object:nil queue:nil usingBlock:^(NSNotification *note)
#define PostNoticeObserver(NoticeKey,Object)     [[NSNotificationCenter defaultCenter] postNotificationName:NoticeKey object:Object]
#define PostNoticeObserverWithInfo(NoticeKey,Object,UserInfo)     [[NSNotificationCenter defaultCenter] postNotificationName:NoticeKey object:Object userInfo:UserInfo]
#define RemoveNoticeObserver(NoticeKey,Delegate) [[NSNotificationCenter defaultCenter] removeObserver:Delegate name:NoticeKey object:nil]


//字体
#define Font(FontSize)                     [UIFont systemFontOfSize:FontSize]
#define BoldFont(FontSize)                 [UIFont boldSystemFontOfSize:FontSize]

//检测是否retina屏
#define isRetina   ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640.0, 960.0), [[UIScreen mainScreen] currentMode].size) : NO)

//检测是否iPhone5
#define iPhone5    ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640.0, 1136.0), [[UIScreen mainScreen] currentMode].size) : NO)
//检测是否4寸屏
#define is4inch    ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640.0, 1136.0), [[UIScreen mainScreen] currentMode].size) : NO)
#define is4_7inch   ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(750.0, 1334.0), [[UIScreen mainScreen] currentMode].size) : NO)
#define is5_5inch   ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1242.0, 2208.0), [[UIScreen mainScreen] currentMode].size) : NO)

//检测是否iOS7
#define iOS7       (CurrentSystemVersion_Double >= 7.0)
//检测是否 iOS8
#define iOS8       (CurrentSystemVersion_Double >= 8.0)
//检测是否iPad
#define isiPad      (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)

//检测是否iPod或者iPhone
#define isiPhone    (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)

//当前iOS系统版本
#define CurrentSystemVersion_String        [[UIDevice currentDevice] systemVersion]
#define CurrentSystemVersion_Double        [[[UIDevice currentDevice] systemVersion] doubleValue]



//空字符串
#define NullString            @""

/*==================================Add end====================================*/

#endif
