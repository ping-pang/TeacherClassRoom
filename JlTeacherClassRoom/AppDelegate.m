//
//  AppDelegate.m
//  JlTeacherClassRoom
//
//  Created by app on 15/11/30.
//  Copyright © 2015年 app. All rights reserved.
//

#import "AppDelegate.h"
#import "ViewController.h"
#import "LoginViewController.h"
#import "MianViewController.h"
#import "MianNavViewController.h"
#import "AppPreFerence.h"
#import "UserModel.h"
#import "TeacherReplyViewController.h"
static  NSTimeInterval  enterBackgroundTime = 0.0;//进入后台时间
static  NSTimeInterval  enterForegroundTime = 0.0;//进入前台时间
static  NSString    *versionUpdatePath = nil;
static  NSInteger   downLoadOrPayCallBack = 0;

@interface AppDelegate ()
@property (nonatomic,strong) UINavigationController *nav ;
@property (nonatomic,strong)NSString    *appCurrentVersionStr;//当前版本
@property (nonatomic,strong)NSString    *appLastVersionStr;//最新版本

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
//     Override point for customization after application launch.
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    
    [self.window makeKeyAndVisible];
    [self checkUpdateVersion];
    [[AppPreFerence sharedAppPreference] setUserLoggedin:NO];
    [[AppPreFerence sharedAppPreference] saveToLocal];
    [self login];
    
//    TeacherReplyViewController *reply = [[TeacherReplyViewController alloc]init];
//    self.window.rootViewController = reply;//[[TeacherReplyViewController alloc]init];
    
    return YES;
}
-(void)login
{
    UserModel * user=[UserModel sharedUser];
    if ([[AppPreFerence sharedAppPreference] loginAutomatically] && user.log_name.length!=0 &&user.password.length !=0)
    {
        MianViewController * vc=[[MianViewController alloc]init];
//        MianNavViewController * nav=[[MianNavViewController alloc]initWithRootViewController:vc];
//        [nav.navigationBar setShadowImage:[UIImage new]];
        UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:vc];
        self.window.rootViewController=nav;

        
    }else{
        LoginViewController * loginVC=[[LoginViewController alloc]initWithNibName:@"LoginViewController" bundle:nil];
        loginVC.blockEnterMain=^(){
            [self enterMain];
        };
        self.window.rootViewController=loginVC;
        
    }
    
}
- (void)enterMain{
    MianViewController * vc=[[MianViewController alloc]init];
    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:vc];
    self.window.rootViewController=nav;
    self.window.rootViewController=nav;

}
- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    NSDateFormatter *dateFormat =[[NSDateFormatter alloc]init];
    [dateFormat setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"zh_CH"]];
    [dateFormat setDateFormat:@"yyyy-MM-dd HH:MM:SS"];
    enterForegroundTime = [[NSDate date] timeIntervalSince1970];
    NSLog(@"重新进入时间:%.1f",enterForegroundTime);
    
    if ((enterForegroundTime - enterBackgroundTime)/60.0 >= 30.0)
    {
        //在后台停留超过30分钟.
        CLog(@"超过半小时,在后台停留时间:%lf",(enterForegroundTime - enterBackgroundTime)/60.0);
        [[AppPreFerence sharedAppPreference] setUserLoggedin:NO];
        [[AppPreFerence sharedAppPreference] saveToLocal];
        
    }
    else
    {
        //在后台停留短于30分钟.
        CLog(@"没有超过半小时,在后台停留时间:%lf",(enterForegroundTime - enterBackgroundTime)/60.0);
    }
    
}

//检测版本更新
- (void)checkUpdateVersion{
    NSDictionary    *JLPlatformInfoDic = [[NSBundle mainBundle] infoDictionary];
    _appCurrentVersionStr = [JLPlatformInfoDic objectForKey:@"CFBundleVersion"];
    NSString *url_str = [NSString stringWithFormat:JL_UPDATE_VERSION,@"",@"",_appCurrentVersionStr];
    CLog(@"the update url is %@",url_str);
    [RequestManage requestCheckUpdayeVisonWithCurrentVison:url_str complete:^(NSDictionary * resDic) {
        if ([resDic[@"success"] isEqualToString:@"true"]) {
            CLog(@"the update data is %@",resDic);
            if (resDic[@"data"] != [NSNull null] && [resDic[@"data"] count] !=0)
            {
                dispatch_async(dispatch_get_main_queue(), ^{
                    downLoadOrPayCallBack = 3;
                    NSDictionary *dataDic = resDic[@"data"][0];
                    BOOL isForceup=[dataDic[@"forceup"]boolValue];
                    _appLastVersionStr = [dataDic objectForKey:@"ver"];
                    BOOL isNew=[self version:_appCurrentVersionStr  lessthan:_appLastVersionStr];
                    if (isNew==YES) {
                        //需要更新
                        if (isForceup) {
                            //强制更新
                            downLoadOrPayCallBack=3;
                            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                                            message:@"版本需要更新，请更新"
                                                                           delegate:self
                                                                  cancelButtonTitle:@"取消"
                                                                  otherButtonTitles:@"前往",nil];
                            alert.tag=101;
                            versionUpdatePath = [dataDic objectForKey:@"path"];
                            [alert show];
                            
                        }else{
                            //非强制更新
                            
                            downLoadOrPayCallBack = 4;//非强制更新
                            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                                            message:@"有更新版本，是否更新？"
                                                                           delegate:self
                                                                  cancelButtonTitle:@"取消"
                                                                  otherButtonTitles:@"前往",nil];
                            alert.tag=102;
                            versionUpdatePath = [dataDic objectForKey:@"path"];
                            [alert show];
                            
                        }
                        
                    }else{
                        //不需要更新，当前版本号大于服务器上面放的版本
                        return ;
                    }
                    
                    //                    if ([_appCurrentVersionStr isEqualToString:_appLastVersionStr]) {
                    //                        //不需要更新
                    //
                    //                    }else{
                    //
                    //                    }
                    
                });
            }
        }
    }];
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 10000) {
        
    }if (alertView.tag==101) {
        //强制更新
        if (buttonIndex == 1)
        {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:versionUpdatePath]];
            sleep(2);
            exit(0);
        }
        else
        {
            exit(0);
        }
        
    }if (alertView.tag==102) {
        //非强制更新
        if (buttonIndex == 1)
        {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:versionUpdatePath]];
            sleep(2);
            exit(0);
        }
        
    }
}

- (BOOL)version:(NSString *)_oldver lessthan:(NSString *)_newver
{
    NSArray *a1 = [_oldver componentsSeparatedByString:@"."];
    NSArray *a2 = [_newver componentsSeparatedByString:@"."];
    
    for (int i = 0; i < [a1 count]; i++) {
        if ([a2 count] > i) {
            if ([[a1 objectAtIndex:i] floatValue] < [[a2 objectAtIndex:i] floatValue]) {
                return YES;
            }
            else if ([[a1 objectAtIndex:i] floatValue] > [[a2 objectAtIndex:i] floatValue])
            {
                return NO;
            }
        }
        else
        {
            return NO;
        }
    }
    return [a1 count] < [a2 count];
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    //杀死进程
    [[AppPreFerence sharedAppPreference] setUserLoggedin:NO];
    [[AppPreFerence sharedAppPreference] saveToLocal];
    
}

@end
